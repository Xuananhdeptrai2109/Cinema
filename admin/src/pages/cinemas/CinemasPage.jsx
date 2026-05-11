import { useState } from 'react'
import { Table, Button, Tag, Modal, Form, Input, Select,
         message, Popconfirm, Space, Typography, Avatar } from 'antd'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { PlusOutlined, EditOutlined, DeleteOutlined, SearchOutlined, BankOutlined } from '@ant-design/icons'
import { cinemaApi, cityApi } from '../../api'
import PageHeader from '../../components/common/PageHeader'

const { Text } = Typography

const STATUS_MAP = {
  active:      { label: 'Hoạt động', color: '#43a047' },
  maintenance: { label: 'Bảo trì',   color: '#fb8c00' },
  closed:      { label: 'Đóng cửa',  color: '#9090a8' },
}

export default function CinemasPage() {
  const [open, setOpen]       = useState(false)
  const [editing, setEditing] = useState(null)
  const [search, setSearch]   = useState('')
  const [form]                = Form.useForm()
  const qc                    = useQueryClient()

  const { data: cinemas = [], isLoading } = useQuery({
    queryKey: ['cinemas'],
    queryFn: () => cinemaApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const { data: cities = [] } = useQuery({
    queryKey: ['cities'],
    queryFn: () => cityApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const invalidate = () => qc.invalidateQueries({ queryKey: ['cinemas'] })

  const createMut = useMutation({
    mutationFn: cinemaApi.create,
    onSuccess: () => { message.success('Thêm rạp thành công'); invalidate(); close() },
    onError: () => message.error('Thêm rạp thất bại'),
  })
  const updateMut = useMutation({
    mutationFn: ({ id, data }) => cinemaApi.update(id, data),
    onSuccess: () => { message.success('Cập nhật thành công'); invalidate(); close() },
    onError: () => message.error('Cập nhật thất bại'),
  })
  const deleteMut = useMutation({
    mutationFn: cinemaApi.delete,
    onSuccess: () => { message.success('Đã xóa rạp'); invalidate() },
    onError: () => message.error('Xóa thất bại'),
  })

  const close = () => { setOpen(false); setEditing(null); form.resetFields() }
  const openCreate = () => { setEditing(null); form.resetFields(); setOpen(true) }
  const openEdit = (rec) => {
    setEditing(rec)
    form.setFieldsValue({ ...rec, provinceId: rec.province?.provinceId })
    setOpen(true)
  }

  const filtered = cinemas.filter(c =>
    c.cinemaName?.toLowerCase().includes(search.toLowerCase()) ||
    c.address?.toLowerCase().includes(search.toLowerCase())
  )

  const columns = [
    {
      title: 'Rạp', dataIndex: 'cinemaName',
      render: (name, rec) => (
        <div style={{ display:'flex', alignItems:'center', gap:12 }}>
          <Avatar
            src={rec.imageUrl} icon={<BankOutlined />} size={40}
            style={{ background:'#22222f', flexShrink:0 }}
          />
          <div>
            <Text style={{ color:'#e8e8f0', fontWeight:600, display:'block' }}>{name}</Text>
            <Text style={{ color:'#9090a8', fontSize:12 }}>{rec.address}</Text>
          </div>
        </div>
      )
    },
    { title: 'Tỉnh/TP', dataIndex: ['province','provinceName'], width: 140,
      render: v => <Text style={{ color:'#9090a8' }}>{v}</Text>
    },
    { title: 'Hotline', dataIndex: 'hotline', width: 130,
      render: v => <Text style={{ color:'#9090a8' }}>{v}</Text>
    },
    { title: 'Trạng thái', dataIndex: 'status', width: 120,
      render: s => {
        const m = STATUS_MAP[s] || STATUS_MAP.active
        return <Tag style={{ background:`${m.color}22`, color:m.color, border:`1px solid ${m.color}44` }}>{m.label}</Tag>
      }
    },
    { title: 'Hành động', width: 100, align:'center',
      render: (_, rec) => (
        <Space>
          <Button type="text" icon={<EditOutlined />} style={{ color:'#1e88e5' }} onClick={() => openEdit(rec)} />
          <Popconfirm title="Xóa rạp này?" okText="Xóa" cancelText="Hủy"
            okButtonProps={{ danger: true }}
            onConfirm={() => deleteMut.mutate(rec.cinemasId)}>
            <Button type="text" icon={<DeleteOutlined />} style={{ color:'#E53935' }} />
          </Popconfirm>
        </Space>
      )
    },
  ]

  return (
    <div className="page-enter">
      <PageHeader
        title="Quản lý rạp chiếu phim"
        subtitle={`${cinemas.length} rạp trong hệ thống`}
        extra={
          <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}
            style={{ background:'#E53935', border:'none', fontWeight:600 }}>
            Thêm rạp
          </Button>
        }
      />

      <div style={{ marginBottom:16 }}>
        <Input
          placeholder="Tìm kiếm rạp, địa chỉ..."
          prefix={<SearchOutlined style={{ color:'#9090a8' }} />}
          value={search} onChange={e => setSearch(e.target.value)}
          style={{ width:320 }}
        />
      </div>

      <Table
        dataSource={filtered} columns={columns}
        rowKey="cinemasId" loading={isLoading}
        pagination={{ pageSize:10, showTotal: t => `${t} rạp` }}
      />

      <Modal
        title={editing ? 'Chỉnh sửa rạp' : 'Thêm rạp mới'}
        open={open} onCancel={close} footer={null} width={560} destroyOnClose
      >
        <Form form={form} layout="vertical" onFinish={vals => {
          if (editing) updateMut.mutate({ id: editing.cinemasId, data: vals })
          else createMut.mutate(vals)
        }} style={{ marginTop:16 }}>
          <Form.Item name="cinemaName" label="Tên rạp" rules={[{ required:true }]}>
            <Input placeholder="VD: CGV Vincom Center" />
          </Form.Item>
          <Form.Item name="address" label="Địa chỉ" rules={[{ required:true }]}>
            <Input placeholder="Địa chỉ đầy đủ" />
          </Form.Item>
          <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:12 }}>
            <Form.Item name="provinceId" label="Tỉnh/TP">
              <Select placeholder="Chọn tỉnh/TP">
                {cities.map(c => <Select.Option key={c.provinceId} value={c.provinceId}>{c.provinceName}</Select.Option>)}
              </Select>
            </Form.Item>
            <Form.Item name="status" label="Trạng thái">
              <Select placeholder="Trạng thái" defaultValue="active">
                {Object.entries(STATUS_MAP).map(([k,v]) =>
                  <Select.Option key={k} value={k}>{v.label}</Select.Option>)}
              </Select>
            </Form.Item>
            <Form.Item name="hotline" label="Hotline">
              <Input placeholder="1900 xxxx" />
            </Form.Item>
            <Form.Item name="fax" label="Fax">
              <Input placeholder="Fax" />
            </Form.Item>
          </div>
          <Form.Item name="imageUrl" label="Hình ảnh rạp (URL)">
            <Input placeholder="https://..." />
          </Form.Item>
          <Form.Item name="mapUrl" label="Link Google Maps">
            <Input placeholder="https://maps.google.com/..." />
          </Form.Item>
          <div style={{ display:'flex', justifyContent:'flex-end', gap:8, marginTop:8 }}>
            <Button onClick={close}>Hủy</Button>
            <Button type="primary" htmlType="submit"
              loading={createMut.isPending || updateMut.isPending}
              style={{ background:'#E53935', border:'none' }}>
              {editing ? 'Cập nhật' : 'Thêm rạp'}
            </Button>
          </div>
        </Form>
      </Modal>
    </div>
  )
}
