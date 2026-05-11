import { useState } from 'react'
import { Table, Button, Tag, Modal, Form, Input, Select, InputNumber,
         message, Popconfirm, Space, Typography, Switch, Image } from 'antd'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { PlusOutlined, EditOutlined, DeleteOutlined, SearchOutlined } from '@ant-design/icons'
import { productApi } from '../../api'
import PageHeader from '../../components/common/PageHeader'

const { Text } = Typography
const { TextArea } = Input

const TYPE_COLORS = {
  'Bỏng ngô':  ['#fb8c00', '#fb8c0022'],
  'Đồ uống':   ['#1e88e5', '#1e88e522'],
  'Combo':      ['#E53935', '#E5393522'],
}

export default function ProductsPage() {
  const [open, setOpen]       = useState(false)
  const [editing, setEditing] = useState(null)
  const [search, setSearch]   = useState('')
  const [form]                = Form.useForm()
  const qc                    = useQueryClient()

  const { data: products = [], isLoading } = useQuery({
    queryKey: ['products'],
    queryFn: () => productApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const invalidate = () => qc.invalidateQueries({ queryKey: ['products'] })

  const createMut = useMutation({
    mutationFn: productApi.create,
    onSuccess: () => { message.success('Thêm sản phẩm thành công'); invalidate(); close() },
    onError: () => message.error('Thêm sản phẩm thất bại'),
  })
  const updateMut = useMutation({
    mutationFn: ({ id, data }) => productApi.update(id, data),
    onSuccess: () => { message.success('Cập nhật thành công'); invalidate(); close() },
    onError: () => message.error('Cập nhật thất bại'),
  })
  const deleteMut = useMutation({
    mutationFn: productApi.delete,
    onSuccess: () => { message.success('Đã xóa sản phẩm'); invalidate() },
    onError: () => message.error('Xóa thất bại'),
  })

  const close = () => { setOpen(false); setEditing(null); form.resetFields() }
  const openCreate = () => { setEditing(null); form.setFieldsValue({ isAvailable: true }); setOpen(true) }
  const openEdit = (rec) => {
    setEditing(rec)
    form.setFieldsValue({
      productName: rec.productName,
      description: rec.description,
      price: rec.price,
      quantity: rec.quantity,
      imageUrl: rec.imageUrl,
      productTypeId: rec.productType?.productTypeId,
      isAvailable: rec.isAvailable,
    })
    setOpen(true)
  }

  const filtered = products.filter(p =>
    p.productName?.toLowerCase().includes(search.toLowerCase())
  )

  const fmt = v => new Intl.NumberFormat('vi-VN').format(v)

  const columns = [
    {
      title: 'Sản phẩm', dataIndex: 'productName',
      render: (name, rec) => (
        <div style={{ display:'flex', alignItems:'center', gap:12 }}>
          {rec.imageUrl
            ? <Image src={rec.imageUrl} width={44} height={44}
                style={{ objectFit:'cover', borderRadius:8 }}
                fallback="https://placehold.co/44/1a1a24/9090a8?text=?" />
            : <div style={{ width:44,height:44,background:'#22222f',borderRadius:8,
                display:'flex',alignItems:'center',justifyContent:'center',fontSize:20 }}>🍿</div>
          }
          <div>
            <Text style={{ color:'#e8e8f0', fontWeight:600, display:'block' }}>{name}</Text>
            <Text style={{ color:'#9090a8', fontSize:12 }} ellipsis={{ tooltip: rec.description }}>
              {rec.description?.substring(0, 40)}{rec.description?.length > 40 ? '...' : ''}
            </Text>
          </div>
        </div>
      )
    },
    { title: 'Loại', dataIndex: ['productType','typeName'], width: 110,
      render: v => {
        const [color, bg] = TYPE_COLORS[v] || ['#9090a8', '#9090a822']
        return <Tag style={{ background:bg, color, border:`1px solid ${color}44` }}>{v}</Tag>
      }
    },
    { title: 'Giá', dataIndex: 'price', width: 120, align:'right',
      render: v => <Text style={{ color:'#43a047', fontWeight:600 }}>{fmt(v)} ₫</Text>
    },
    { title: 'Tồn kho', dataIndex: 'quantity', width: 90, align:'center',
      render: v => (
        <Tag style={{
          background: v > 10 ? '#43a04722' : v > 0 ? '#fb8c0022' : '#E5393522',
          color:       v > 10 ? '#43a047'   : v > 0 ? '#fb8c00'   : '#E53935',
          border: 'none'
        }}>{v}</Tag>
      )
    },
    { title: 'Trạng thái', dataIndex: 'isAvailable', width: 110, align:'center',
      render: v => (
        <Tag style={{
          background: v ? '#43a04722' : '#9090a822',
          color:       v ? '#43a047'   : '#9090a8',
          border: 'none'
        }}>{v ? 'Còn bán' : 'Ngừng bán'}</Tag>
      )
    },
    { title: 'Hành động', width: 100, align:'center',
      render: (_, rec) => (
        <Space>
          <Button type="text" icon={<EditOutlined />} style={{ color:'#1e88e5' }} onClick={() => openEdit(rec)} />
          <Popconfirm title="Xóa sản phẩm này?" okText="Xóa" cancelText="Hủy"
            okButtonProps={{ danger:true }}
            onConfirm={() => deleteMut.mutate(rec.productId)}>
            <Button type="text" icon={<DeleteOutlined />} style={{ color:'#E53935' }} />
          </Popconfirm>
        </Space>
      )
    },
  ]

  return (
    <div className="page-enter">
      <PageHeader
        title="Quản lý sản phẩm"
        subtitle={`${products.length} sản phẩm (bỏng, nước, combo)`}
        extra={
          <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}
            style={{ background:'#E53935', border:'none', fontWeight:600 }}>
            Thêm sản phẩm
          </Button>
        }
      />

      <div style={{ marginBottom:16 }}>
        <Input
          placeholder="Tìm kiếm sản phẩm..."
          prefix={<SearchOutlined style={{ color:'#9090a8' }} />}
          value={search} onChange={e => setSearch(e.target.value)}
          style={{ width:280 }}
        />
      </div>

      <Table
        dataSource={filtered} columns={columns}
        rowKey="productId" loading={isLoading}
        pagination={{ pageSize:10, showTotal: t => `${t} sản phẩm` }}
      />

      <Modal
        title={editing ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm'}
        open={open} onCancel={close} footer={null} destroyOnClose
      >
        <Form form={form} layout="vertical" onFinish={vals => {
          if (editing) updateMut.mutate({ id: editing.productId, data: vals })
          else createMut.mutate(vals)
        }} style={{ marginTop:16 }}>
          <Form.Item name="productName" label="Tên sản phẩm" rules={[{ required:true }]}>
            <Input placeholder="VD: Bỏng ngô vừa" />
          </Form.Item>
          <Form.Item name="description" label="Mô tả">
            <TextArea rows={2} placeholder="Mô tả sản phẩm" />
          </Form.Item>
          <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:12 }}>
            <Form.Item name="price" label="Giá (₫)" rules={[{ required:true }]}>
              <InputNumber min={0} style={{ width:'100%' }}
                formatter={v => `${v}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                parser={v => v.replace(/,/g, '')} />
            </Form.Item>
            <Form.Item name="quantity" label="Số lượng tồn kho">
              <InputNumber min={0} style={{ width:'100%' }} />
            </Form.Item>
            <Form.Item name="productTypeId" label="Loại sản phẩm" rules={[{ required:true }]}>
              <Select placeholder="Chọn loại">
                <Select.Option value={1}>Bỏng ngô</Select.Option>
                <Select.Option value={2}>Đồ uống</Select.Option>
                <Select.Option value={3}>Combo</Select.Option>
              </Select>
            </Form.Item>
            <Form.Item name="isAvailable" label="Còn bán" valuePropName="checked">
              <Switch checkedChildren="Có" unCheckedChildren="Không" />
            </Form.Item>
          </div>
          <Form.Item name="imageUrl" label="Hình ảnh (URL)">
            <Input placeholder="https://..." />
          </Form.Item>
          <div style={{ display:'flex', justifyContent:'flex-end', gap:8, marginTop:8 }}>
            <Button onClick={close}>Hủy</Button>
            <Button type="primary" htmlType="submit"
              loading={createMut.isPending || updateMut.isPending}
              style={{ background:'#E53935', border:'none' }}>
              {editing ? 'Cập nhật' : 'Thêm'}
            </Button>
          </div>
        </Form>
      </Modal>
    </div>
  )
}
