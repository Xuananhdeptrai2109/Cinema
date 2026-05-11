import { Row, Col, Card, Statistic, Spin, Table, Tag, Typography } from 'antd'
import { useQuery } from '@tanstack/react-query'
import {
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, BarChart, Bar, Legend
} from 'recharts'
import {
  VideoCameraOutlined, DollarOutlined,
  ShoppingCartOutlined, UserOutlined, RiseOutlined
} from '@ant-design/icons'
import { statsApi } from '../api'
import dayjs from 'dayjs'

const { Text } = Typography

function StatCard({ title, value, prefix, suffix, icon, color, delta }) {
  return (
    <Card className="stat-card" style={{ height: '100%' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div>
          <Text style={{ color: '#9090a8', fontSize: 12, textTransform: 'uppercase', letterSpacing: '0.08em' }}>
            {title}
          </Text>
          <Statistic
            value={value} prefix={prefix} suffix={suffix}
            valueStyle={{ color: '#e8e8f0', fontSize: 28, fontWeight: 700 }}
            style={{ marginTop: 4 }}
          />
          {delta !== undefined && (
            <Text style={{ color: delta >= 0 ? '#43a047' : '#e53935', fontSize: 12 }}>
              <RiseOutlined /> {delta >= 0 ? '+' : ''}{delta}% so với tháng trước
            </Text>
          )}
        </div>
        <div style={{
          width: 48, height: 48, borderRadius: 12,
          background: `rgba(${color},0.12)`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontSize: 20, color: `rgb(${color})`
        }}>{icon}</div>
      </div>
    </Card>
  )
}

const CUSTOM_TOOLTIP_STYLE = {
  background: '#22222f', border: '1px solid #2e2e3f',
  borderRadius: 8, color: '#e8e8f0', fontSize: 13
}

const dateLabel = value => {
  if (!value) return ''
  const parsed = dayjs(value)
  return parsed.isValid() ? parsed.format('DD/MM') : value
}

export default function Dashboard() {
  const { data: overview, isLoading } = useQuery({
    queryKey: ['stats-overview'],
    queryFn: () => statsApi.overview().then(r => r.data),
    placeholderData: {
      totalRevenue: 0, totalTickets: 0, totalMovies: 0, totalUsers: 0,
      revenueDelta: 0, ticketDelta: 0, userDelta: 0,
      revenueChart: [], ticketChart: []
    }
  })

  const { data: topMovies = [] } = useQuery({
    queryKey: ['top-movies'],
    queryFn: () => statsApi.topMovies().then(r => r.data),
    placeholderData: []
  })

  if (isLoading) return (
    <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 80 }}>
      <Spin size="large" />
    </div>
  )

  const fmt = (n) => new Intl.NumberFormat('vi-VN').format(n)

  return (
    <div className="page-enter">
      <div style={{ marginBottom: 24 }}>
        <Text style={{ color: '#e8e8f0', fontSize: 20, fontWeight: 700 }}>Dashboard</Text>
        <br />
        <Text style={{ color: '#9090a8', fontSize: 13 }}>Tổng quan hệ thống rạp chiếu phim</Text>
      </div>

      {/* Stat Cards */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        <Col xs={24} sm={12} xl={6}>
          <StatCard title="Doanh thu tháng này" value={fmt(overview.totalRevenue)}
            suffix="₫" icon={<DollarOutlined />} color="229,57,53" delta={overview.revenueDelta} />
        </Col>
        <Col xs={24} sm={12} xl={6}>
          <StatCard title="Vé bán ra" value={overview.totalTickets}
            icon={<ShoppingCartOutlined />} color="30,136,229" delta={overview.ticketDelta} />
        </Col>
        <Col xs={24} sm={12} xl={6}>
          <StatCard title="Phim đang chiếu" value={overview.totalMovies}
            icon={<VideoCameraOutlined />} color="67,160,71" />
        </Col>
        <Col xs={24} sm={12} xl={6}>
          <StatCard title="Tổng người dùng" value={overview.totalUsers}
            icon={<UserOutlined />} color="251,140,0" delta={overview.userDelta} />
        </Col>
      </Row>

      {/* Charts */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        <Col xs={24} lg={14}>
          <Card title={<Text style={{ color: '#e8e8f0' }}>Doanh thu 7 ngày gần nhất</Text>}>
            <ResponsiveContainer width="100%" height={240}>
              <AreaChart data={overview.revenueChart}>
                <defs>
                  <linearGradient id="revGrad" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%"  stopColor="#E53935" stopOpacity={0.3} />
                    <stop offset="95%" stopColor="#E53935" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="#2e2e3f" />
                <XAxis dataKey="date" stroke="#9090a8" tick={{ fontSize: 12 }} tickFormatter={dateLabel} />
                <YAxis stroke="#9090a8" tick={{ fontSize: 12 }}
                  tickFormatter={v => `${(v/1e6).toFixed(0)}M`} />
                <Tooltip contentStyle={CUSTOM_TOOLTIP_STYLE}
                  formatter={v => [`${fmt(v)} ₫`, 'Doanh thu']}
                  labelFormatter={dateLabel} />
                <Area type="monotone" dataKey="revenue"
                  stroke="#E53935" strokeWidth={2} fill="url(#revGrad)" />
              </AreaChart>
            </ResponsiveContainer>
          </Card>
        </Col>
        <Col xs={24} lg={10}>
          <Card title={<Text style={{ color: '#e8e8f0' }}>Vé bán theo ngày</Text>}>
            <ResponsiveContainer width="100%" height={240}>
              <BarChart data={overview.ticketChart}>
                <CartesianGrid strokeDasharray="3 3" stroke="#2e2e3f" />
                <XAxis dataKey="date" stroke="#9090a8" tick={{ fontSize: 12 }} tickFormatter={dateLabel} />
                <YAxis stroke="#9090a8" tick={{ fontSize: 12 }} />
                <Tooltip contentStyle={CUSTOM_TOOLTIP_STYLE}
                  formatter={v => [v, 'Vé']}
                  labelFormatter={dateLabel} />
                <Bar dataKey="tickets" fill="#1e88e5" radius={[4,4,0,0]} />
              </BarChart>
            </ResponsiveContainer>
          </Card>
        </Col>
      </Row>

      {/* Top movies table */}
      <Card title={<Text style={{ color: '#e8e8f0' }}>Phim bán vé nhiều nhất</Text>}>
        <Table
          dataSource={topMovies}
          rowKey="movieId"
          pagination={false}
          size="small"
          columns={[
            { title: '#', key: 'rank', width: 48,
              render: (_, __, i) => <Text style={{ color: '#9090a8' }}>{i + 1}</Text> },
            { title: 'Phim', dataIndex: 'title',
              render: (t, r) => (
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  {r.posterLink && <img src={r.posterLink} alt={t}
                    style={{ width: 32, height: 44, objectFit: 'cover', borderRadius: 4 }} />}
                  <Text style={{ color: '#e8e8f0', fontWeight: 500 }}>{t}</Text>
                </div>
              )
            },
            { title: 'Trạng thái', dataIndex: 'status', width: 120,
              render: s => {
                const map = { 'NOW_SHOWING': ['Đang chiếu','#43a047'],
                              'COMING_SOON': ['Sắp chiếu', '#fb8c00'],
                              'ENDED':       ['Ngừng chiếu','#9090a8'] }
                const [label, color] = map[s] || [s, '#9090a8']
                return <Tag style={{ background: `${color}22`, color, border: `1px solid ${color}44` }}>{label}</Tag>
              }
            },
            { title: 'Vé bán', dataIndex: 'ticketsSold', width: 100, align: 'right',
              render: v => <Text style={{ color: '#1e88e5', fontWeight: 600 }}>{v?.toLocaleString('vi-VN')}</Text>
            },
            { title: 'Doanh thu', dataIndex: 'revenue', width: 140, align: 'right',
              render: v => <Text style={{ color: '#E53935', fontWeight: 600 }}>{fmt(v)} ₫</Text>
            },
          ]}
        />
      </Card>
    </div>
  )
}
