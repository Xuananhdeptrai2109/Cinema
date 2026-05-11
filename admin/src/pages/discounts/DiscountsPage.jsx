import { useState } from 'react'
import { Table, Button, Tag, Modal, Form, Input, Select, InputNumber,
         DatePicker, message, Popconfirm, Space, Typography, Progress } from 'antd'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { PlusOutlined, EditOutlined, DeleteOutlined, SearchOutlined, GiftOutlined } from '@ant-design/icons'
import { discountApi } from '../../api'
import PageHeader from '../../components/common/PageHeader'
import dayjs from 'dayjs'

const { Text } = Typography
const { TextArea } = Input
const { RangePicker } = DatePicker

export default function DiscountsPage() {
  const [open, setOpen]       = useState(false)
  const [editing, setEditing] = useState(null)
  const [search, setSearch]   = useState('')
  const [form]                = Form.useForm()
  const qc                    = useQueryClient()

  const { data: discounts = [], isLoading } = useQuery({
    queryKey: ['discounts'],
    queryFn: () => discountApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const invalidate = () => qc.invalidateQueries({ queryKey: ['discounts'] })

  const createMut = useMutation({
    mutationFn: discountApi.create,
    onSuccess: () => { message.success('Thêm mã giảm giá thành công'); invalidate(); close() },
    onError: () => message.error('Thêm thất bại'),
  })
  const updateMut = useMutation({
    mutationFn: ({ id, data }) => discountApi.update(id, data),
    onSuccess: () => { message.success('Cập nhật thành công'); invalidate(); close() },
    onError: () => message.error('Cập nhật thất bại'),
  })
  const deleteMut = useMutation({
    mutationFn: discountApi.delete,
    onSuccess: () => { message.success('Đã xóa mã giảm giá'); invalidate() },
    onError: () => message.error('Xóa thất bại'),
  })

  const close = () => { setOpen(false); setEditing(null); form.resetFields() }
  const openCreate = () => { setEditing(null); form.resetFields(); setOpen(true) }
  const openEdit = (rec) => {
    setEditing(rec)
    form.setFieldsValue({
      discountTitle: rec.discountTitle,
      discountDescription: rec.discountDescription,
      discountCode: rec.discountCode,
      discountType: rec.discountType,
      discountValue: rec.discountValue,
      maxUsage: rec.maxUsage,
      dateRange: [dayjs(rec.startDate), dayjs(rec.endDate)],
    })
    setOpen(true)
  }

  const filtered = discounts.filter(d =>
    d.discountTitle?.toLowerCase().includes(search.toLowerCase()) ||
    d.discountCode?.toLowerCase().includes(search.toLowerCase())
  )

  const isExpired = (d) => d.endDate && dayjs(d.endDate).isBefore(dayjs(), 'day')
  const isActive  = (d) => !isExpired(d) && d.currentUsage < (d.maxUsage || Infinity)

  const columns = [
    {
      title: 'Mã giảm giá', dataIndex: 'discountCode',
      render: (code, rec) => (
        <div>
          <div style={{ display:'flex', alignItems:'center', gap:8 }}>
            <GiftOutlined style={{ color:'#E53935' }} />
            <Text style={{ color:'#e8e8f0', fontWeight:700, fontFamily:"'Space Mono',monospace", letterSpacing:'0.05em' }}>
              {code}
            </Text>
          </div>
          <Text style={{ color:'#9090a8', fontSize:12 }}>{rec.discountTitle}</Text>
        </div>
      )
    },
    { title: 'Giảm', width: 120,
      render: (_, rec) => (
        <Tag style={{
          background: rec.discountType === 'percent' ? '#1e88e522' : '#43a04722',
          color:       rec.discountType === 'percent' ? '#1e88e5'   : '#43a047',
          border:'none', fontWeight:700, fontSize:14, padding:'4px 10px'
        }}>
          {rec.discountType === 'percent'
            ? `${rec.discountValue}%`
            : `${new Intl.NumberFormat('vi-VN').format(rec.discountValue)}₫`}
        </Tag>
      )
    },
    { title: 'Hiệu lực', width: 180,
      render: (_, rec) => (
        <div>
          <Text style={{ color:'#9090a8', fontSize:12 }}>
            {rec.startDate ? dayjs(rec.startDate).format('DD/MM/YYYY') : '—'}
            {' → '}
            {rec.endDate ? dayjs(rec.endDate).format('DD/MM/YYYY') : '—'}
          </Text>
        </div>
      )
    },
    { title: 'Đã dùng / Tối đa', width: 160,
      render: (_, rec) => {
        const pct = rec.maxUsage ? Math.round((rec.currentUsage / rec.maxUsage) * 100) : 0
        return (
          <div>
            <Text style={{ color:'#9090a8', fontSize:12 }}>
              {rec.currentUsage} / {rec.maxUsage || '∞'}
            </Text>
            {rec.maxUsage && (
              <Progress percent={pct} size="small" showInfo={false}
                strokeColor={pct > 80 ? '#E53935' : '#1e88e5'}
                trailColor="#2e2e3f" style={{ margin:0 }} />
            )}
          </div>
        )
      }
    },
    { title: 'Trạng thái', width: 110,
      render: (_, rec) => {
        if (isExpired(rec))
          return <Tag style={{ background:'#9090a822', color:'#9090a8', border:'none' }}>Hết hạn</Tag>
        if (!isActive(rec))
          return <Tag style={{ background:'#E5393522', color:'#E53935', border:'none' }}>Hết lượt</Tag>
        return <Tag style={{ background:'#43a04722', color:'#43a047', border:'none' }}>Đang dùng</Tag>
      }
    },
    { title: 'Hành động', width: 100, align:'center',
      render: (_, rec) => (
        <Space>
          <Button type="text" icon={<EditOutlined />} style={{ color:'#1e88e5' }} onClick={() => openEdit(rec)} />
          <Popconfirm title="Xóa mã giảm giá?" okText="Xóa" cancelText="Hủy"
            okButtonProps={{ danger:true }}
            onConfirm={() => deleteMut.mutate(rec.discountId)}>
            <Button type="text" icon={<DeleteOutlined />} style={{ color:'#E53935' }} />
          </Popconfirm>
        </Space>
      )
    },
  ]

  return (
    <div className="page-enter">
      <PageHeader
        title="Quản lý khuyến mãi"
        subtitle={`${discounts.length} mã giảm giá`}
        extra={
          <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}
            style={{ background:'#E53935', border:'none', fontWeight:600 }}>
            Thêm mã giảm giá
          </Button>
        }
      />

      <div style={{ marginBottom:16 }}>
        <Input
          placeholder="Tìm mã giảm giá..."
          prefix={<SearchOutlined style={{ color:'#9090a8' }} />}
          value={search} onChange={e => setSearch(e.target.value)}
          style={{ width:280 }}
        />
      </div>

      <Table
        dataSource={filtered} columns={columns}
        rowKey="discountId" loading={isLoading}
        pagination={{ pageSize:10 }}
      />

      <Modal
        title={editing ? 'Chỉnh sửa mã giảm giá' : 'Tạo mã giảm giá mới'}
        open={open} onCancel={close} footer={null} destroyOnClose
      >
        <Form form={form} layout="vertical"
          onFinish={vals => {
            const [start, end] = vals.dateRange || []
            const payload = {
              ...vals,
              startDate: start?.format('YYYY-MM-DD'),
              endDate:   end?.format('YYYY-MM-DD'),
            }
            delete payload.dateRange
            if (editing) updateMut.mutate({ id: editing.discountId, data: payload })
            else createMut.mutate(payload)
          }}
          style={{ marginTop:16 }}
        >
          <Form.Item name="discountTitle" label="Tên chương trình" rules={[{ required:true }]}>
            <Input placeholder="VD: Mừng Quốc khánh" />
          </Form.Item>
          <Form.Item name="discountDescription" label="Mô tả">
            <TextArea rows={2} placeholder="Mô tả điều kiện, áp dụng..." />
          </Form.Item>
          <Form.Item name="discountCode" label="Mã giảm giá" rules={[{ required:true }]}>
            <Input placeholder="VD: SUMMER2025" style={{ fontFamily:"'Space Mono',monospace", textTransform:'uppercase' }} />
          </Form.Item>
          <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:12 }}>
            <Form.Item name="discountType" label="Kiểu giảm" rules={[{ required:true }]}>
              <Select placeholder="Chọn kiểu">
                <Select.Option value="percent">Phần trăm (%)</Select.Option>
                <Select.Option value="fixed">Số tiền cố định (₫)</Select.Option>
              </Select>
            </Form.Item>
            <Form.Item name="discountValue" label="Giá trị giảm" rules={[{ required:true }]}>
              <InputNumber min={0} style={{ width:'100%' }}
                formatter={v => `${v}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                parser={v => v.replace(/,/g, '')} />
            </Form.Item>
          </div>
          <Form.Item name="maxUsage" label="Số lượng mã tối đa">
            <InputNumber min={1} style={{ width:'100%' }} placeholder="Để trống = không giới hạn" />
          </Form.Item>
          <Form.Item name="dateRange" label="Thời gian áp dụng">
            <RangePicker format="DD/MM/YYYY" style={{ width:'100%' }} />
          </Form.Item>
          <div style={{ display:'flex', justifyContent:'flex-end', gap:8, marginTop:8 }}>
            <Button onClick={close}>Hủy</Button>
            <Button type="primary" htmlType="submit"
              loading={createMut.isPending || updateMut.isPending}
              style={{ background:'#E53935', border:'none' }}>
              {editing ? 'Cập nhật' : 'Tạo mã'}
            </Button>
          </div>
        </Form>
      </Modal>
    </div>
  )
}
