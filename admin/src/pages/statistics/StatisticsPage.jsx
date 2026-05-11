import { useState } from 'react'
import { Card, Col, DatePicker, Row, Select, Segmented, Spin, Statistic, Table, Tabs, Typography } from 'antd'
import { useQuery } from '@tanstack/react-query'
import {
  Area,
  AreaChart,
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import { DollarOutlined, ShoppingCartOutlined, UserOutlined } from '@ant-design/icons'
import { cinemaApi, statsApi } from '../../api'
import PageHeader from '../../components/common/PageHeader'
import dayjs from 'dayjs'

const { RangePicker } = DatePicker
const { Text } = Typography

const tooltipStyle = {
  background: '#22222f',
  border: '1px solid #2e2e3f',
  borderRadius: 8,
  color: '#e8e8f0',
  fontSize: 13,
}

const fmt = value => new Intl.NumberFormat('vi-VN').format(value ?? 0)
const money = value => `${fmt(value)} đ`
const dateLabel = value => {
  if (!value) return ''
  const parsed = dayjs(value)
  return parsed.isValid() ? parsed.format('DD/MM/YYYY') : value
}

function EmptyHint({ children }) {
  return (
    <div style={{ padding: 32, textAlign: 'center', color: '#9090a8' }}>
      {children || 'Chưa có dữ liệu để hiển thị'}
    </div>
  )
}

function RevenueTab({ cinemaId }) {
  const [period, setPeriod] = useState('month')
  const [range, setRange] = useState([dayjs().subtract(30, 'day'), dayjs()])

  const { data = {}, isLoading } = useQuery({
    queryKey: ['stats-revenue', period, range?.[0]?.format('YYYY-MM-DD'), range?.[1]?.format('YYYY-MM-DD'), cinemaId],
    queryFn: () => statsApi.revenue({
      period,
      from: range?.[0]?.format('YYYY-MM-DD'),
      to: range?.[1]?.format('YYYY-MM-DD'),
      cinemaId,
    }).then(r => r.data),
    placeholderData: { chart: [], total: 0, avgPerDay: 0, maxDay: null },
  })

  return (
    <div>
      <div style={{ display: 'flex', gap: 12, marginBottom: 20, flexWrap: 'wrap' }}>
        <Segmented
          options={[
            { label: 'Theo ngày', value: 'day' },
            { label: 'Theo tuần', value: 'week' },
            { label: 'Theo tháng', value: 'month' },
          ]}
          value={period}
          onChange={setPeriod}
        />
        <RangePicker format="DD/MM/YYYY" value={range} onChange={setRange} style={{ width: 280 }} />
      </div>

      <Row gutter={[16, 16]} style={{ marginBottom: 20 }}>
        <Col xs={24} sm={8}>
          <Card>
            <Statistic title="Tổng doanh thu" value={fmt(data.total)} suffix="đ" prefix={<DollarOutlined />} valueStyle={{ color: '#E53935', fontWeight: 700 }} />
          </Card>
        </Col>
        <Col xs={24} sm={8}>
          <Card>
            <Statistic title="Trung bình / ngày" value={fmt(data.avgPerDay)} suffix="đ" valueStyle={{ color: '#1e88e5', fontWeight: 700 }} />
          </Card>
        </Col>
        <Col xs={24} sm={8}>
          <Card>
            <Statistic title="Ngày cao nhất" value={fmt(data.maxDay?.revenue)} suffix="đ" valueStyle={{ color: '#43a047', fontWeight: 700 }} />
            {data.maxDay?.date && <Text style={{ color: '#9090a8' }}>{dayjs(data.maxDay.date).format('DD/MM/YYYY')}</Text>}
          </Card>
        </Col>
      </Row>

      <Card title={<Text style={{ color: '#e8e8f0' }}>Biểu đồ doanh thu</Text>}>
        {isLoading ? <Spin style={{ display: 'block', margin: '40px auto' }} /> : data.chart?.length ? (
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={data.chart}>
              <CartesianGrid strokeDasharray="3 3" stroke="#2e2e3f" />
              <XAxis dataKey="label" stroke="#9090a8" tick={{ fontSize: 11 }} tickFormatter={dateLabel} />
              <YAxis stroke="#9090a8" tick={{ fontSize: 11 }} tickFormatter={v => `${(v / 1000000).toFixed(0)}M`} />
              <Tooltip contentStyle={tooltipStyle} formatter={v => [money(v), 'Doanh thu']} labelFormatter={dateLabel} />
              <Area type="monotone" dataKey="revenue" stroke="#E53935" strokeWidth={2} fill="#E5393533" />
            </AreaChart>
          </ResponsiveContainer>
        ) : <EmptyHint />}
      </Card>
    </div>
  )
}

function CinemaRevenueTab() {
  const { data = [], isLoading } = useQuery({
    queryKey: ['stats-revenue-by-cinema'],
    queryFn: () => statsApi.byCinema().then(r => r.data),
    placeholderData: [],
  })

  const rows = data.filter(row => Number(row.totalRevenue) > 0 || Number(row.totalTicketsSold) > 0)
  const displayRows = rows.length ? rows : data

  const columns = [
    { title: 'Rạp', dataIndex: 'cinemaName', render: v => <Text style={{ color: '#e8e8f0', fontWeight: 600 }}>{v}</Text> },
    { title: 'Tỉnh/TP', dataIndex: 'provinceName', render: v => <Text style={{ color: '#9090a8' }}>{v || '-'}</Text> },
    { title: 'Hóa đơn', dataIndex: 'totalInvoices', width: 110, align: 'right', render: fmt },
    { title: 'Vé bán', dataIndex: 'totalTicketsSold', width: 110, align: 'right', render: fmt },
    { title: 'Doanh thu', dataIndex: 'totalRevenue', width: 150, align: 'right', render: v => <Text style={{ color: '#E53935', fontWeight: 700 }}>{money(v)}</Text> },
  ]

  return (
    <div>
      <Card title={<Text style={{ color: '#e8e8f0' }}>Doanh thu theo rạp</Text>} style={{ marginBottom: 16 }}>
        {isLoading ? <Spin style={{ display: 'block', margin: '40px auto' }} /> : rows.length ? (
          <ResponsiveContainer width="100%" height={320}>
            <BarChart data={rows.slice(0, 12)}>
              <CartesianGrid strokeDasharray="3 3" stroke="#2e2e3f" />
              <XAxis dataKey="cinemaName" stroke="#9090a8" tick={{ fontSize: 10 }} tickFormatter={v => v?.length > 14 ? `${v.slice(0, 14)}...` : v} />
              <YAxis stroke="#9090a8" tick={{ fontSize: 11 }} tickFormatter={v => `${(v / 1000000).toFixed(0)}M`} />
              <Tooltip contentStyle={tooltipStyle} formatter={v => [money(v), 'Doanh thu']} />
              <Bar dataKey="totalRevenue" fill="#43a047" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        ) : <EmptyHint>Chưa có hóa đơn đã thanh toán nên doanh thu theo rạp đang bằng 0.</EmptyHint>}
      </Card>
      <Table dataSource={displayRows} rowKey="cinemaId" columns={columns} loading={isLoading} pagination={{ pageSize: 10 }} size="small" />
    </div>
  )
}

function DailyRevenueTab() {
  const [range, setRange] = useState([dayjs().subtract(30, 'day'), dayjs()])
  const params = {
    from: range?.[0]?.format('YYYY-MM-DD'),
    to: range?.[1]?.format('YYYY-MM-DD'),
  }

  const { data = [], isLoading } = useQuery({
    queryKey: ['stats-revenue-by-date', params.from, params.to],
    queryFn: () => statsApi.byDate(params).then(r => r.data),
    placeholderData: [],
  })

  const columns = [
    { title: 'Ngày', dataIndex: 'reportDate', width: 130, render: v => v ? dayjs(v).format('DD/MM/YYYY') : '-' },
    { title: 'Hóa đơn', dataIndex: 'totalInvoices', width: 110, align: 'right', render: fmt },
    { title: 'Vé bán', dataIndex: 'totalTicketsSold', width: 110, align: 'right', render: fmt },
    { title: 'Doanh thu', dataIndex: 'totalRevenue', width: 150, align: 'right', render: v => <Text style={{ color: '#E53935', fontWeight: 700 }}>{money(v)}</Text> },
    { title: 'Tiền mặt', dataIndex: 'revenueCash', width: 130, align: 'right', render: money },
    { title: 'VNPay', dataIndex: 'revenueVnpay', width: 130, align: 'right', render: money },
  ]

  return (
    <div>
      <RangePicker format="DD/MM/YYYY" value={range} onChange={setRange} style={{ width: 280, marginBottom: 16 }} />
      <Card title={<Text style={{ color: '#e8e8f0' }}>Doanh thu theo ngày</Text>} style={{ marginBottom: 16 }}>
        {isLoading ? <Spin style={{ display: 'block', margin: '40px auto' }} /> : data.length ? (
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={[...data].reverse()}>
              <CartesianGrid strokeDasharray="3 3" stroke="#2e2e3f" />
              <XAxis dataKey="reportDate" stroke="#9090a8" tick={{ fontSize: 11 }} tickFormatter={v => dayjs(v).format('DD/MM')} />
              <YAxis stroke="#9090a8" tick={{ fontSize: 11 }} tickFormatter={v => `${(v / 1000000).toFixed(0)}M`} />
              <Tooltip contentStyle={tooltipStyle} formatter={v => [money(v), 'Doanh thu']} labelFormatter={v => dayjs(v).format('DD/MM/YYYY')} />
              <Area type="monotone" dataKey="totalRevenue" stroke="#1e88e5" strokeWidth={2} fill="#1e88e533" />
            </AreaChart>
          </ResponsiveContainer>
        ) : <EmptyHint>Chưa có hóa đơn đã thanh toán trong khoảng ngày này.</EmptyHint>}
      </Card>
      <Table dataSource={data} rowKey="reportDate" columns={columns} loading={isLoading} pagination={{ pageSize: 10 }} size="small" scroll={{ x: 850 }} />
    </div>
  )
}

function TicketsTab({ cinemaId }) {
  const [period, setPeriod] = useState('day')
  const { data = {}, isLoading } = useQuery({
    queryKey: ['stats-tickets', period, cinemaId],
    queryFn: () => statsApi.tickets({ period, cinemaId }).then(r => r.data),
    placeholderData: { chart: [], total: 0, byShowtime: [] },
  })

  const columns = [
    { title: 'Suất chiếu', dataIndex: 'showtimeLabel', render: v => <Text style={{ color: '#e8e8f0' }}>{v}</Text> },
    { title: 'Phim', dataIndex: 'movieTitle', render: v => <Text style={{ color: '#9090a8' }}>{v}</Text> },
    { title: 'Ngày', dataIndex: 'date', width: 120, render: v => v ? dayjs(v).format('DD/MM') : '-' },
    { title: 'Vé bán', dataIndex: 'ticketsSold', width: 100, align: 'right', render: fmt },
    { title: 'Lấp đầy', dataIndex: 'fillRate', width: 90, align: 'right', render: v => `${fmt(v)}%` },
  ]

  return (
    <div>
      <Segmented
        options={[
          { label: 'Theo ngày', value: 'day' },
          { label: 'Theo tuần', value: 'week' },
          { label: 'Theo tháng', value: 'month' },
        ]}
        value={period}
        onChange={setPeriod}
        style={{ marginBottom: 20 }}
      />
      <Row gutter={[16, 16]} style={{ marginBottom: 20 }}>
        <Col xs={24} sm={8}>
          <Card><Statistic title="Tổng vé bán ra" value={data.total ?? 0} prefix={<ShoppingCartOutlined />} valueStyle={{ color: '#1e88e5', fontWeight: 700 }} /></Card>
        </Col>
        <Col xs={24} sm={8}>
          <Card><Statistic title="Tỷ lệ lấp đầy TB" value={data.avgFillRate ?? 0} suffix="%" valueStyle={{ color: '#43a047', fontWeight: 700 }} /></Card>
        </Col>
        <Col xs={24} sm={8}>
          <Card><Statistic title="Suất chiếu đầy" value={data.fullShowtimes ?? 0} valueStyle={{ color: '#fb8c00', fontWeight: 700 }} /></Card>
        </Col>
      </Row>
      <Card title={<Text style={{ color: '#e8e8f0' }}>Vé bán theo thời gian</Text>} style={{ marginBottom: 16 }}>
        {isLoading ? <Spin style={{ display: 'block', margin: '40px auto' }} /> : data.chart?.length ? (
          <ResponsiveContainer width="100%" height={260}>
            <BarChart data={data.chart}>
              <CartesianGrid strokeDasharray="3 3" stroke="#2e2e3f" />
              <XAxis dataKey="label" stroke="#9090a8" tick={{ fontSize: 11 }} tickFormatter={dateLabel} />
              <YAxis stroke="#9090a8" tick={{ fontSize: 11 }} />
              <Tooltip contentStyle={tooltipStyle} formatter={v => [v, 'Vé']} labelFormatter={dateLabel} />
              <Bar dataKey="tickets" fill="#1e88e5" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        ) : <EmptyHint>Chưa có vé đã thanh toán.</EmptyHint>}
      </Card>
      <Table dataSource={data.byShowtime} rowKey="showtimeId" columns={columns} loading={isLoading} pagination={{ pageSize: 8 }} size="small" />
    </div>
  )
}

function MoviesTab() {
  const { data = [], isLoading } = useQuery({
    queryKey: ['stats-movies-revenue'],
    queryFn: () => statsApi.byMovie({ limit: 20 }).then(r => r.data),
    placeholderData: [],
  })

  const rows = data.filter(row => Number(row.totalRevenue) > 0 || Number(row.totalTicketsSold) > 0)
  const displayRows = rows.length ? rows : data

  const columns = [
    { title: 'Phim', dataIndex: 'title', render: v => <Text style={{ color: '#e8e8f0', fontWeight: 600 }}>{v}</Text> },
    { title: 'Đạo diễn', dataIndex: 'directorName', render: v => <Text style={{ color: '#9090a8' }}>{v || '-'}</Text> },
    { title: 'Suất chiếu', dataIndex: 'totalShowtimes', width: 110, align: 'right', render: fmt },
    { title: 'Vé bán', dataIndex: 'totalTicketsSold', width: 110, align: 'right', render: fmt },
    { title: 'Doanh thu', dataIndex: 'totalRevenue', width: 150, align: 'right', render: v => <Text style={{ color: '#E53935', fontWeight: 700 }}>{money(v)}</Text> },
  ]

  return (
    <div>
      <Card title={<Text style={{ color: '#e8e8f0' }}>Doanh thu và lượt xem theo phim</Text>} style={{ marginBottom: 16 }}>
        {isLoading ? <Spin style={{ display: 'block', margin: '40px auto' }} /> : rows.length ? (
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={rows.slice(0, 10)} layout="vertical">
              <CartesianGrid strokeDasharray="3 3" stroke="#2e2e3f" horizontal={false} />
              <XAxis type="number" stroke="#9090a8" tick={{ fontSize: 10 }} tickFormatter={v => `${(v / 1000000).toFixed(0)}M`} />
              <YAxis type="category" dataKey="title" width={140} stroke="#9090a8" tick={{ fontSize: 11 }} tickFormatter={v => v?.length > 16 ? `${v.slice(0, 16)}...` : v} />
              <Tooltip contentStyle={tooltipStyle} formatter={v => [money(v), 'Doanh thu']} />
              <Bar dataKey="totalRevenue" fill="#E53935" radius={[0, 4, 4, 0]} />
            </BarChart>
          </ResponsiveContainer>
        ) : <EmptyHint>Đã có phim và suất chiếu, nhưng chưa có vé đã thanh toán nên doanh thu/lượt xem đang bằng 0.</EmptyHint>}
      </Card>
      <Table dataSource={displayRows} rowKey="movieId" columns={columns} loading={isLoading} pagination={{ pageSize: 10 }} size="small" />
    </div>
  )
}

function CustomersTab() {
  const { data = {}, isLoading } = useQuery({
    queryKey: ['stats-customers'],
    queryFn: () => statsApi.customers().then(r => r.data),
    placeholderData: { totalUsers: 0, newUsersMonth: 0, returningRate: 0, activityByHour: [] },
  })

  return (
    <div>
      <Row gutter={[16, 16]}>
        <Col xs={24} sm={8}>
          <Card><Statistic title="Tổng khách hàng" value={data.totalUsers ?? 0} prefix={<UserOutlined />} valueStyle={{ color: '#e8e8f0', fontWeight: 700 }} /></Card>
        </Col>
        <Col xs={24} sm={8}>
          <Card><Statistic title="Mới tháng này" value={data.newUsersMonth ?? 0} valueStyle={{ color: '#43a047', fontWeight: 700 }} /></Card>
        </Col>
        <Col xs={24} sm={8}>
          <Card><Statistic title="Tỷ lệ quay lại" value={data.returningRate ?? 0} suffix="%" valueStyle={{ color: '#1e88e5', fontWeight: 700 }} /></Card>
        </Col>
      </Row>
    </div>
  )
}

export default function StatisticsPage() {
  const [cinemaId, setCinemaId] = useState(null)
  const { data: cinemas = [] } = useQuery({
    queryKey: ['cinemas'],
    queryFn: () => cinemaApi.getAll().then(r => r.data),
    placeholderData: [],
  })

  const tabs = [
    { key: 'revenue', label: 'Doanh thu', children: <RevenueTab cinemaId={cinemaId} /> },
    { key: 'cinemas', label: 'Doanh thu rạp', children: <CinemaRevenueTab /> },
    { key: 'daily', label: 'Doanh thu ngày', children: <DailyRevenueTab /> },
    { key: 'tickets', label: 'Vé bán ra', children: <TicketsTab cinemaId={cinemaId} /> },
    { key: 'movies', label: 'Theo phim', children: <MoviesTab /> },
    { key: 'customers', label: 'Khách hàng', children: <CustomersTab /> },
  ]

  return (
    <div className="page-enter">
      <PageHeader
        title="Báo cáo & Thống kê"
        subtitle="Phân tích doanh thu, vé bán và hành vi người dùng"
        extra={
          <Select placeholder="Tất cả rạp" allowClear style={{ width: 220 }} value={cinemaId} onChange={setCinemaId}>
            {cinemas.map(c => <Select.Option key={c.cinemasId} value={c.cinemasId}>{c.cinemaName}</Select.Option>)}
          </Select>
        }
      />
      <Tabs items={tabs} defaultActiveKey="revenue" size="large" style={{ marginTop: -8 }} />
    </div>
  )
}
