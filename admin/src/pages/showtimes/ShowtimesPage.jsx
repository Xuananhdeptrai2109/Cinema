import { useState } from 'react'
import { Table, Button, Tag, Modal, Form, Select, DatePicker,
         TimePicker, message, Popconfirm, Space, Typography, Alert, Badge } from 'antd'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { PlusOutlined, EditOutlined, DeleteOutlined, CalendarOutlined,
         ClockCircleOutlined, WarningOutlined } from '@ant-design/icons'
import { showtimeApi, movieApi, roomApi, cinemaApi } from '../../api'
import PageHeader from '../../components/common/PageHeader'
import dayjs from 'dayjs'

const { Text } = Typography

const STATUS_MAP = {
  NOW_SHOWING: { label: 'Đang chiếu', color: '#43a047' },
  COMING_SOON: { label: 'Sắp chiếu',  color: '#fb8c00' },
  ENDED:       { label: 'Kết thúc',   color: '#9090a8' },
}

export default function ShowtimesPage() {
  const [open, setOpen]           = useState(false)
  const [editing, setEditing]     = useState(null)
  const [cinemaFilter, setCinema] = useState(null)
  const [dateFilter, setDate]     = useState(null)
  const [conflict, setConflict]   = useState(null)
  const [form]                    = Form.useForm()
  const qc                        = useQueryClient()

  const { data: showtimes = [], isLoading } = useQuery({
    queryKey: ['showtimes'],
    queryFn: () => showtimeApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const { data: movies = [] } = useQuery({
    queryKey: ['movies'],
    queryFn: () => movieApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const { data: rooms = [] } = useQuery({
    queryKey: ['rooms'],
    queryFn: () => roomApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const { data: cinemas = [] } = useQuery({
    queryKey: ['cinemas'],
    queryFn: () => cinemaApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const refreshShowtimes = async () => {
    await qc.invalidateQueries({ queryKey: ['showtimes'] })
    await qc.refetchQueries({ queryKey: ['showtimes'], type: 'active' })
  }
  const invalidate = refreshShowtimes

  const createMut = useMutation({
    mutationFn: showtimeApi.create,
    onSuccess: () => { message.success('Thêm lịch chiếu thành công'); invalidate(); close() },
    onError:   (err) => {
      const msg = err.response?.data?.message || ''
      if (msg.toLowerCase().includes('conflict') || msg.toLowerCase().includes('xung đột')) {
        setConflict(msg)
      } else {
        message.error('Thêm lịch chiếu thất bại')
      }
    },
  })
  const updateMut = useMutation({
    mutationFn: ({ id, data }) => showtimeApi.update(id, data),
    onSuccess: () => { message.success('Cập nhật thành công'); invalidate(); close() },
    onError:   () => message.error('Cập nhật thất bại'),
  })
  const deleteMut = useMutation({
    mutationFn: showtimeApi.delete,
    onSuccess: () => { message.success('Đã xóa lịch chiếu'); invalidate() },
    onError:   () => message.error('Xóa thất bại'),
  })

  const close = () => { setOpen(false); setEditing(null); setConflict(null); form.resetFields() }

  const openCreate = () => { setEditing(null); setSelectedCinema(null); form.resetFields(); setConflict(null); setOpen(true) }
  const openEdit = (rec) => {
    setEditing(rec)
    form.setFieldsValue({
      movieId:    rec.movie?.id,
      roomId:     rec.room?.roomId,
      date:       rec.showDate ? dayjs(rec.showDate) : null,
      startTime:  rec.startTime ? dayjs(rec.startTime, 'HH:mm') : null,
      endTime:    rec.endTime ? dayjs(rec.endTime, 'HH:mm') : null,
      basePrice:  rec.basePrice,
    })
    setConflict(null)
    setOpen(true)
  }

  // Auto-calculate end time based on movie duration
  const handleMovieChange = (movieId) => {
    const movie = movies.find(m => m.id === movieId)
    if (!movie) return
    const startTime = form.getFieldValue('startTime')
    if (startTime) {
      const end = startTime.add(movie.duration || 0, 'minute')
      form.setFieldsValue({ endTime: end })
    }
  }

  const handleStartTimeChange = (time) => {
    const movieId = form.getFieldValue('movieId')
    const movie = movies.find(m => m.id === movieId)
    if (movie && time) {
      const end = time.add(movie.duration || 0, 'minute')
      form.setFieldsValue({ endTime: end })
    }
  }

  // Filter rooms by selected cinema
  const [selectedCinema, setSelectedCinema] = useState(null)
  const filteredRooms = selectedCinema
    ? rooms.filter(r => r.cinema?.cinemasId === selectedCinema)
    : rooms

  const filtered = showtimes.filter(s => {
    const matchCinema = !cinemaFilter || s.room?.cinema?.cinemasId === cinemaFilter
    const matchDate   = !dateFilter   || dayjs(s.showDate).isSame(dateFilter, 'day')
    return matchCinema && matchDate
  })

  const columns = [
    {
      title: 'Phim', dataIndex: ['movie', 'title'],
      render: (title, rec) => (
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          {rec.movie?.posterLink && (
            <img src={rec.movie.posterLink} alt={title}
              style={{ width: 32, height: 44, objectFit: 'cover', borderRadius: 4 }} />
          )}
          <div>
            <Text style={{ color: '#e8e8f0', fontWeight: 600, display: 'block' }}>{title}</Text>
            <Text style={{ color: '#9090a8', fontSize: 12 }}>
              <ClockCircleOutlined style={{ marginRight: 4 }} />
              {rec.movie?.duration} phút
            </Text>
          </div>
        </div>
      )
    },
    {
      title: 'Phòng / Rạp', width: 200,
      render: (_, rec) => (
        <div>
          <Text style={{ color: '#e8e8f0', fontWeight: 500, display: 'block' }}>
            {rec.room?.roomName || '—'}
          </Text>
          <Text style={{ color: '#9090a8', fontSize: 12 }}>
            {rec.room?.cinema?.cinemaName || '—'}
          </Text>
        </div>
      )
    },
    {
      title: 'Ngày chiếu', dataIndex: 'showDate', width: 130,
      render: v => (
        <Text style={{ color: '#9090a8' }}>
          <CalendarOutlined style={{ marginRight: 6, color: '#1e88e5' }} />
          {v ? dayjs(v).format('DD/MM/YYYY') : '—'}
        </Text>
      )
    },
    {
      title: 'Giờ chiếu', width: 160,
      render: (_, rec) => (
        <div>
          <Text style={{ color: '#e8e8f0', fontWeight: 600 }}>
            {rec.startTime || '—'}
          </Text>
          {rec.endTime && (
            <Text style={{ color: '#9090a8', fontSize: 12 }}>
              {' → '}{rec.endTime}
            </Text>
          )}
        </div>
      )
    },
    {
      title: 'Giá vé', dataIndex: 'basePrice', width: 120, align: 'right',
      render: v => (
        <Text style={{ color: '#43a047', fontWeight: 600 }}>
          {v ? new Intl.NumberFormat('vi-VN').format(v) + ' ₫' : '—'}
        </Text>
      )
    },
    {
      title: 'Trạng thái', dataIndex: 'status', width: 120,
      render: s => {
        const m = STATUS_MAP[s] || { label: s, color: '#9090a8' }
        return <Tag style={{ background: `${m.color}22`, color: m.color, border: `1px solid ${m.color}44` }}>{m.label}</Tag>
      }
    },
    {
      title: 'Hành động', width: 100, align: 'center',
      render: (_, rec) => (
        <Space>
          <Button type="text" icon={<EditOutlined />}
            style={{ color: '#1e88e5' }} onClick={() => openEdit(rec)} />
          <Popconfirm title="Xóa lịch chiếu này?" okText="Xóa" cancelText="Hủy"
            okButtonProps={{ danger: true }}
            onConfirm={() => deleteMut.mutate(rec.showtimeId)}>
            <Button type="text" icon={<DeleteOutlined />} style={{ color: '#E53935' }} />
          </Popconfirm>
        </Space>
      )
    },
  ]

  return (
    <div className="page-enter">
      <PageHeader
        title="Quản lý lịch chiếu"
        subtitle={`${showtimes.length} suất chiếu`}
        extra={
          <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}
            style={{ background: '#E53935', border: 'none', fontWeight: 600 }}>
            Thêm lịch chiếu
          </Button>
        }
      />

      {/* Filters */}
      <div style={{ display: 'flex', gap: 12, marginBottom: 16, flexWrap: 'wrap' }}>
        <Select
          placeholder="Lọc theo rạp" allowClear style={{ width: 220 }}
          value={cinemaFilter} onChange={v => setCinema(v)}
        >
          {cinemas.map(c => (
            <Select.Option key={c.cinemasId} value={c.cinemasId}>{c.cinemaName}</Select.Option>
          ))}
        </Select>
        <DatePicker
          placeholder="Lọc theo ngày" format="DD/MM/YYYY"
          value={dateFilter} onChange={setDate} style={{ width: 180 }}
        />
        {(cinemaFilter || dateFilter) && (
          <Button type="text" style={{ color: '#9090a8' }}
            onClick={() => { setCinema(null); setDate(null) }}>
            Xóa bộ lọc
          </Button>
        )}
      </div>

      <Table
        dataSource={filtered} columns={columns}
        rowKey="showtimeId" loading={isLoading}
        pagination={{ pageSize: 12, showTotal: t => `${t} suất chiếu` }}
        scroll={{ x: 900 }}
      />

      {/* Add/Edit Modal */}
      <Modal
        title={editing ? 'Chỉnh sửa lịch chiếu' : 'Thêm lịch chiếu mới'}
        open={open} onCancel={close} footer={null} width={560} destroyOnClose
      >
        {conflict && (
          <Alert
            type="error" showIcon icon={<WarningOutlined />}
            message="Xung đột lịch chiếu"
            description={conflict}
            style={{ marginBottom: 16 }}
            closable onClose={() => setConflict(null)}
          />
        )}
        <Form form={form} layout="vertical"
          onFinish={vals => {
            const payload = {
              movieId:   vals.movieId,
              roomId:    vals.roomId,
              showDate:  vals.date?.format('YYYY-MM-DD'),
              startTime: vals.startTime?.format('HH:mm'),
              endTime:   vals.endTime?.format('HH:mm'),
              basePrice: vals.basePrice,
            }
            if (editing) updateMut.mutate({ id: editing.showtimeId, data: payload })
            else createMut.mutate(payload)
          }}
          style={{ marginTop: 16 }}
        >
          <Form.Item name="movieId" label="Phim" rules={[{ required: true }]}>
            <Select
              showSearch placeholder="Chọn phim"
              optionFilterProp="children"
              onChange={handleMovieChange}
            >
              {movies.map(m => (
                <Select.Option key={m.id} value={m.id}>
                  {m.title} ({m.duration} phút)
                </Select.Option>
              ))}
            </Select>
          </Form.Item>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            <Form.Item name="cinemaSelect" label="Rạp chiếu">
              <Select placeholder="Chọn rạp" allowClear
                onChange={v => { setSelectedCinema(v); form.setFieldsValue({ roomId: undefined }) }}>
                {cinemas.map(c => (
                  <Select.Option key={c.cinemasId} value={c.cinemasId}>{c.cinemaName}</Select.Option>
                ))}
              </Select>
            </Form.Item>
            <Form.Item name="roomId" label="Phòng chiếu" rules={[{ required: true }]}>
              <Select placeholder="Chọn phòng">
                {filteredRooms.map(r => (
                  <Select.Option key={r.roomId} value={r.roomId}>
                    {r.roomName} ({r.roomType})
                  </Select.Option>
                ))}
              </Select>
            </Form.Item>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            <Form.Item name="date" label="Ngày chiếu" rules={[{ required: true }]}>
              <DatePicker format="DD/MM/YYYY" style={{ width: '100%' }}
                disabledDate={d => d && d < dayjs().startOf('day')} />
            </Form.Item>
            <Form.Item name="startTime" label="Giờ bắt đầu" rules={[{ required: true }]}>
              <TimePicker format="HH:mm" style={{ width: '100%' }} minuteStep={5}
                onChange={handleStartTimeChange} />
            </Form.Item>
          </div>

          <Form.Item name="endTime" label="Giờ kết thúc (tự động)">
            <TimePicker format="HH:mm" style={{ width: '100%' }} disabled
              placeholder="Tự tính theo thời lượng phim" />
          </Form.Item>

          <Form.Item name="basePrice" label="Giá vé cơ bản (₫)" rules={[{ required: true }]}>
            <Select placeholder="Chọn mức giá">
              {[45000, 55000, 65000, 75000, 85000, 95000, 120000, 150000].map(p => (
                <Select.Option key={p} value={p}>
                  {new Intl.NumberFormat('vi-VN').format(p)} ₫
                </Select.Option>
              ))}
            </Select>
          </Form.Item>

          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 8, marginTop: 8 }}>
            <Button onClick={close}>Hủy</Button>
            <Button type="primary" htmlType="submit"
              loading={createMut.isPending || updateMut.isPending}
              style={{ background: '#E53935', border: 'none' }}>
              {editing ? 'Cập nhật' : 'Thêm lịch chiếu'}
            </Button>
          </div>
        </Form>
      </Modal>
    </div>
  )
}
