import { useState } from 'react'
import { Table, Button, Tag, Modal, Form, Input, Select, InputNumber,
         message, Popconfirm, Space, Typography, Tabs, Tooltip } from 'antd'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { PlusOutlined, EditOutlined, DeleteOutlined, SearchOutlined,
         AppstoreOutlined, EyeOutlined } from '@ant-design/icons'
import { roomApi, cinemaApi } from '../../api'
import PageHeader from '../../components/common/PageHeader'

const { Text } = Typography

const ROOM_TYPE_MAP = {
  '2D':     { color: '#1e88e5' },
  '3D':     { color: '#8e24aa' },
  'IMAX':   { color: '#E53935' },
  '4DX':    { color: '#fb8c00' },
  'GOLD CLASS': { color: '#43a047' },
  'BED-CINEMA': { color: '#00acc1' },
  'SWEETBOX': { color: '#d81b60' },
  'KIDS': { color: '#fdd835' },
}

const STATUS_MAP = {
  active:      { label: 'Hoạt động', color: '#43a047' },
  maintenance: { label: 'Bảo trì',   color: '#fb8c00' },
  closed:      { label: 'Đóng cửa',  color: '#9090a8' },
}

// ── Seat Map Preview ────────────────────────────────────────────────────────
function SeatMapModal({ room, open, onClose }) {
  if (!room) return null

  let seatLayout = []
  try {
    seatLayout = typeof room.seatLayout === 'string'
      ? JSON.parse(room.seatLayout)
      : (room.seatLayout || [])
  } catch {
    seatLayout = []
  }

  const rows = [...new Set(seatLayout.map(s => s.row))].sort()
  const cols = [...new Set(seatLayout.map(s => s.col))].sort((a, b) => a - b)

  const getStatus = (row, col) => {
    const s = seatLayout.find(s => s.row === row && s.col === col)
    return s ? s.type : null
  }

  const seatColors = {
    regular: '#1e88e5',
    vip:     '#E53935',
    couple:  '#8e24aa',
    empty:   'transparent',
  }

  return (
    <Modal
      title={`Sơ đồ ghế — ${room.roomName}`}
      open={open} onCancel={onClose} footer={null} width={700}
    >
      {/* Screen */}
      <div style={{
        textAlign: 'center', marginBottom: 24
      }}>
        <div style={{
          display: 'inline-block', width: '70%', height: 8,
          background: 'linear-gradient(90deg,transparent,#E53935,transparent)',
          borderRadius: 4, marginBottom: 4
        }} />
        <Text style={{ color: '#9090a8', fontSize: 11, display: 'block' }}>MÀN HÌNH</Text>
      </div>

      {seatLayout.length === 0 ? (
        <div style={{ textAlign: 'center', padding: 40, color: '#9090a8' }}>
          Chưa có dữ liệu sơ đồ ghế
        </div>
      ) : (
        <div style={{ overflowX: 'auto' }}>
          {rows.map(row => (
            <div key={row} style={{ display: 'flex', gap: 4, marginBottom: 4, justifyContent: 'center' }}>
              <Text style={{ color: '#9090a8', width: 24, textAlign: 'right', fontSize: 11, lineHeight: '24px' }}>
                {row}
              </Text>
              {cols.map(col => {
                const type = getStatus(row, col)
                return (
                  <Tooltip key={col} title={type ? `${row}${col} — ${type}` : ''}>
                    <div style={{
                      width: 24, height: 24, borderRadius: 4,
                      background: type ? seatColors[type] || '#2e2e3f' : 'transparent',
                      border: type ? 'none' : '1px dashed #2e2e3f',
                      opacity: type ? 1 : 0.3,
                      cursor: type ? 'pointer' : 'default',
                      fontSize: 9, color: '#fff',
                      display: 'flex', alignItems: 'center', justifyContent: 'center'
                    }}>
                      {type ? col : ''}
                    </div>
                  </Tooltip>
                )
              })}
            </div>
          ))}
        </div>
      )}

      {/* Legend */}
      <div style={{ display: 'flex', gap: 16, justifyContent: 'center', marginTop: 16 }}>
        {Object.entries(seatColors).filter(([k]) => k !== 'empty').map(([type, color]) => (
          <div key={type} style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <div style={{ width: 14, height: 14, borderRadius: 3, background: color }} />
            <Text style={{ color: '#9090a8', fontSize: 11, textTransform: 'capitalize' }}>{type}</Text>
          </div>
        ))}
      </div>
    </Modal>
  )
}

// ── Main Page ───────────────────────────────────────────────────────────────
export default function RoomsPage() {
  const [open, setOpen]           = useState(false)
  const [editing, setEditing]     = useState(null)
  const [seatPreview, setSeat]    = useState(null)
  const [search, setSearch]       = useState('')
  const [cinemaFilter, setCinema] = useState(null)
  const [form]                    = Form.useForm()
  const qc                        = useQueryClient()

  const { data: rooms = [], isLoading } = useQuery({
    queryKey: ['rooms'],
    queryFn: () => roomApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const { data: cinemas = [] } = useQuery({
    queryKey: ['cinemas'],
    queryFn: () => cinemaApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const invalidate = () => qc.invalidateQueries({ queryKey: ['rooms'] })

  const createMut = useMutation({
    mutationFn: roomApi.create,
    onSuccess: async () => {
      message.success('Thêm phòng chiếu thành công')
      setSearch('')
      setCinema(null)
      await invalidate()
      close()
    },
    onError:   () => message.error('Thêm phòng chiếu thất bại'),
  })
  const updateMut = useMutation({
    mutationFn: ({ id, data }) => roomApi.update(id, data),
    onSuccess: () => { message.success('Cập nhật thành công'); invalidate(); close() },
    onError:   () => message.error('Cập nhật thất bại'),
  })
  const deleteMut = useMutation({
    mutationFn: roomApi.delete,
    onSuccess: () => { message.success('Đã xóa phòng chiếu'); invalidate() },
    onError:   () => message.error('Xóa thất bại'),
  })

  const close = () => { setOpen(false); setEditing(null); form.resetFields() }

  const openCreate = () => { setEditing(null); form.resetFields(); setOpen(true) }
  const openEdit = (rec) => {
    setEditing(rec)
    form.setFieldsValue({
      roomName: rec.roomName,
      roomType: rec.roomType || rec.screeningFormat?.type,
      capacity: rec.capacity,
      status: rec.status,
      cinemasId: rec.cinema?.cinemasId,
    })
    setOpen(true)
  }

  const sortedRooms = [...rooms].sort((a, b) => (b.roomId || 0) - (a.roomId || 0))

  const filtered = sortedRooms.filter(r => {
    const matchSearch  = r.roomName?.toLowerCase().includes(search.toLowerCase())
    const matchCinema  = !cinemaFilter || r.cinema?.cinemasId === cinemaFilter
    return matchSearch && matchCinema
  })

  const columns = [
    {
      title: 'Phòng chiếu', dataIndex: 'roomName',
      render: (name, rec) => (
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{
            width: 36, height: 36, borderRadius: 8,
            background: '#22222f', display: 'flex', alignItems: 'center', justifyContent: 'center',
            color: '#9090a8', fontSize: 16
          }}>
            <AppstoreOutlined />
          </div>
          <div>
            <Text style={{ color: '#e8e8f0', fontWeight: 600, display: 'block' }}>{name}</Text>
            <Text style={{ color: '#9090a8', fontSize: 12 }}>{rec.cinema?.cinemaName || '—'}</Text>
          </div>
        </div>
      )
    },
    {
      title: 'Loại phòng', width: 100,
      render: (_, rec) => {
        const v = rec.roomType || rec.screeningFormat?.type
        const cfg = ROOM_TYPE_MAP[v] || { color: '#9090a8' }
        return <Tag style={{ background: `${cfg.color}22`, color: cfg.color, border: `1px solid ${cfg.color}44`, fontWeight: 700 }}>{v}</Tag>
      }
    },
    {
      title: 'Sức chứa', dataIndex: 'capacity', width: 100, align: 'center',
      render: v => <Text style={{ color: '#e8e8f0', fontWeight: 600 }}>{v} <Text style={{ color: '#9090a8', fontSize: 12 }}>ghế</Text></Text>
    },
    {
      title: 'Trạng thái', dataIndex: 'status', width: 120,
      render: s => {
        const m = STATUS_MAP[s] || STATUS_MAP.active
        return <Tag style={{ background: `${m.color}22`, color: m.color, border: `1px solid ${m.color}44` }}>{m.label}</Tag>
      }
    },
    {
      title: 'Hành động', width: 120, align: 'center',
      render: (_, rec) => (
        <Space>
          <Tooltip title="Xem sơ đồ ghế">
            <Button type="text" icon={<EyeOutlined />}
              style={{ color: '#43a047' }} onClick={() => setSeat(rec)} />
          </Tooltip>
          <Button type="text" icon={<EditOutlined />}
            style={{ color: '#1e88e5' }} onClick={() => openEdit(rec)} />
          <Popconfirm title="Xóa phòng chiếu này?" okText="Xóa" cancelText="Hủy"
            okButtonProps={{ danger: true }}
            onConfirm={() => deleteMut.mutate(rec.roomId)}>
            <Button type="text" icon={<DeleteOutlined />} style={{ color: '#E53935' }} />
          </Popconfirm>
        </Space>
      )
    },
  ]

  return (
    <div className="page-enter">
      <PageHeader
        title="Quản lý phòng chiếu"
        subtitle={`${rooms.length} phòng trong hệ thống`}
        extra={
          <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}
            style={{ background: '#E53935', border: 'none', fontWeight: 600 }}>
            Thêm phòng
          </Button>
        }
      />

      {/* Filters */}
      <div style={{ display: 'flex', gap: 12, marginBottom: 16, flexWrap: 'wrap' }}>
        <Input
          placeholder="Tìm kiếm phòng chiếu..."
          prefix={<SearchOutlined style={{ color: '#9090a8' }} />}
          value={search} onChange={e => setSearch(e.target.value)}
          style={{ width: 280 }}
        />
        <Select
          placeholder="Lọc theo rạp" allowClear style={{ width: 220 }}
          value={cinemaFilter} onChange={v => setCinema(v)}
        >
          {cinemas.map(c => (
            <Select.Option key={c.cinemasId} value={c.cinemasId}>{c.cinemaName}</Select.Option>
          ))}
        </Select>
      </div>

      <Table
        dataSource={filtered} columns={columns}
        rowKey="roomId" loading={isLoading}
        pagination={{ pageSize: 10, showTotal: t => `${t} phòng` }}
      />

      {/* Add/Edit Modal */}
      <Modal
        title={editing ? 'Chỉnh sửa phòng chiếu' : 'Thêm phòng chiếu'}
        open={open} onCancel={close} footer={null} destroyOnClose
      >
        <Form form={form} layout="vertical" onFinish={vals => {
          if (editing) updateMut.mutate({ id: editing.roomId, data: vals })
          else createMut.mutate(vals)
        }} style={{ marginTop: 16 }}>
          <Form.Item name="roomName" label="Tên phòng" rules={[{ required: true }]}>
            <Input placeholder="VD: Phòng 1, Hall A, ..." />
          </Form.Item>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            <Form.Item name="cinemasId" label="Rạp chiếu phim" rules={[{ required: true }]}>
              <Select placeholder="Chọn rạp">
                {cinemas.map(c => (
                  <Select.Option key={c.cinemasId} value={c.cinemasId}>{c.cinemaName}</Select.Option>
                ))}
              </Select>
            </Form.Item>
            <Form.Item name="roomType" label="Loại phòng" rules={[{ required: true }]}>
              <Select placeholder="Chọn loại phòng">
                {Object.keys(ROOM_TYPE_MAP).map(t => (
                  <Select.Option key={t} value={t}>{t}</Select.Option>
                ))}
              </Select>
            </Form.Item>
            <Form.Item name="capacity" label="Sức chứa (ghế)" rules={[{ required: true }]}>
              <InputNumber min={1} max={1000} style={{ width: '100%' }} />
            </Form.Item>
            <Form.Item name="status" label="Trạng thái" initialValue="active">
              <Select>
                {Object.entries(STATUS_MAP).map(([k, v]) => (
                  <Select.Option key={k} value={k}>{v.label}</Select.Option>
                ))}
              </Select>
            </Form.Item>
          </div>
          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 8, marginTop: 8 }}>
            <Button onClick={close}>Hủy</Button>
            <Button type="primary" htmlType="submit"
              loading={createMut.isPending || updateMut.isPending}
              style={{ background: '#E53935', border: 'none' }}>
              {editing ? 'Cập nhật' : 'Thêm phòng'}
            </Button>
          </div>
        </Form>
      </Modal>

      {/* Seat Map Preview */}
      <SeatMapModal room={seatPreview} open={!!seatPreview} onClose={() => setSeat(null)} />
    </div>
  )
}
