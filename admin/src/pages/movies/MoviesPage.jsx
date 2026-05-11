import { useState } from 'react'
import { Table, Button, Tag, Modal, Form, Input, Select, InputNumber,
         DatePicker, message, Popconfirm, Space, Image, Typography } from 'antd'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { PlusOutlined, EditOutlined, DeleteOutlined, SearchOutlined } from '@ant-design/icons'
import { movieApi, genreApi } from '../../api'
import PageHeader from '../../components/common/PageHeader'
import dayjs from 'dayjs'

const { Text } = Typography
const { TextArea } = Input

const STATUS_MAP = {
  NOW_SHOWING: { label: 'Đang chiếu', color: '#43a047' },
  COMING_SOON: { label: 'Sắp chiếu',  color: '#fb8c00' },
  ENDED:       { label: 'Ngừng chiếu',color: '#9090a8' },
}

export default function MoviesPage() {
  const [open, setOpen]         = useState(false)
  const [editing, setEditing]   = useState(null)
  const [search, setSearch]     = useState('')
  const [form]                  = Form.useForm()
  const qc                      = useQueryClient()

  const { data: movies = [], isLoading } = useQuery({
    queryKey: ['movies'],
    queryFn: () => movieApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const { data: genres = [] } = useQuery({
    queryKey: ['genres'],
    queryFn: () => genreApi.getAll().then(r => r.data),
    placeholderData: []
  })

  const invalidate = () => qc.invalidateQueries({ queryKey: ['movies'] })

  const createMut = useMutation({
    mutationFn: movieApi.create,
    onSuccess: () => { message.success('Thêm phim thành công'); invalidate(); closeModal() },
    onError: () => message.error('Thêm phim thất bại'),
  })
  const updateMut = useMutation({
    mutationFn: ({ id, data }) => movieApi.update(id, data),
    onSuccess: () => { message.success('Cập nhật thành công'); invalidate(); closeModal() },
    onError: () => message.error('Cập nhật thất bại'),
  })
  const deleteMut = useMutation({
    mutationFn: movieApi.delete,
    onSuccess: () => { message.success('Đã xóa phim'); invalidate() },
    onError: () => message.error('Xóa thất bại'),
  })

  const openCreate = () => { setEditing(null); form.resetFields(); setOpen(true) }
  const openEdit   = (rec) => {
    setEditing(rec)
    form.setFieldsValue({
      ...rec,
      releaseDate: rec.releaseDate ? dayjs(rec.releaseDate) : null,
      genreNames: rec.genreNames || [],
      director: rec.director || '',
      performerNames: rec.performerNames || [],
    })
    setOpen(true)
  }
  const closeModal = () => { setOpen(false); setEditing(null); form.resetFields() }

  const onFinish = (vals) => {
    const payload = {
      ...vals,
      releaseDate: vals.releaseDate?.format('YYYY-MM-DD'),
    }
    if (editing) updateMut.mutate({ id: editing.id, data: payload })
    else createMut.mutate(payload)
  }

  const filtered = movies.filter(m =>
    m.title?.toLowerCase().includes(search.toLowerCase())
  )

  const columns = [
    {
      title: 'Poster', dataIndex: 'posterLink', width: 70,
      render: url => url
        ? <Image src={url} width={44} height={60} style={{ objectFit:'cover', borderRadius:4 }}
            fallback="https://placehold.co/44x60/1a1a24/9090a8?text=N/A" />
        : <div style={{ width:44,height:60,background:'#22222f',borderRadius:4 }} />
    },
    { title: 'Tên phim', dataIndex: 'title', ellipsis: true,
      render: t => <Text style={{ color:'#e8e8f0', fontWeight:500 }}>{t}</Text>
    },
    { title: 'Thể loại', dataIndex: 'genreNames', width: 180,
      render: gs => gs?.map(name =>
        <Tag key={name} style={{ background:'#22222f', color:'#9090a8', border:'1px solid #2e2e3f', marginBottom:2, fontSize:11 }}>
          {name}
        </Tag>
      )
    },
    { title: 'TL (phút)', dataIndex: 'duration', width: 90, align: 'center',
      render: v => <Text style={{ color:'#9090a8' }}>{v}</Text>
    },
    { title: 'Ngôn ngữ', dataIndex: 'language', width: 90,
      render: v => <Text style={{ color:'#9090a8' }}>{v}</Text>
    },
    { title: 'Tuổi', dataIndex: 'ageRating', width: 70, align: 'center',
      render: v => <Tag style={{ background:'#fb8c0022', color:'#fb8c00', border:'1px solid #fb8c0044' }}>{v}</Tag>
    },
    { title: 'Trạng thái', dataIndex: 'status', width: 120,
      render: s => {
        const m = STATUS_MAP[s] || { label: s, color: '#9090a8' }
        return <Tag style={{ background: `${m.color}22`, color: m.color, border: `1px solid ${m.color}44` }}>
          {m.label}
        </Tag>
      }
    },
    { title: 'Hành động', width: 100, align: 'center',
      render: (_, rec) => (
        <Space>
          <Button type="text" icon={<EditOutlined />}
            style={{ color: '#1e88e5' }} onClick={() => openEdit(rec)} />
          <Popconfirm title="Xóa phim này?" okText="Xóa" cancelText="Hủy"
            okButtonProps={{ danger: true }}
            onConfirm={() => deleteMut.mutate(rec.id)}>
            <Button type="text" icon={<DeleteOutlined />} style={{ color: '#E53935' }} />
          </Popconfirm>
        </Space>
      )
    },
  ]

  return (
    <div className="page-enter">
      <PageHeader
        title="Quản lý phim"
        subtitle={`${movies.length} phim trong hệ thống`}
        extra={
          <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}
            style={{ background:'#E53935', border:'none', fontWeight:600 }}>
            Thêm phim
          </Button>
        }
      />

      {/* Search */}
      <div style={{ marginBottom: 16 }}>
        <Input
          placeholder="Tìm kiếm phim..." prefix={<SearchOutlined style={{ color:'#9090a8' }} />}
          value={search} onChange={e => setSearch(e.target.value)}
          style={{ width: 320 }}
        />
      </div>

      <Table
        dataSource={filtered} columns={columns}
        rowKey="id" loading={isLoading}
        pagination={{ pageSize: 10, showSizeChanger: true, showTotal: (t) => `${t} phim` }}
        scroll={{ x: 900 }}
      />

      {/* Modal */}
      <Modal
        title={editing ? 'Chỉnh sửa phim' : 'Thêm phim mới'}
        open={open} onCancel={closeModal} footer={null} width={640}
        destroyOnClose
      >
        <Form form={form} layout="vertical" onFinish={onFinish} style={{ marginTop: 16 }}>
          <Form.Item name="title" label="Tên phim" rules={[{ required: true }]}>
            <Input placeholder="Tên phim" />
          </Form.Item>
          <Form.Item name="description" label="Mô tả">
            <TextArea rows={3} placeholder="Mô tả nội dung phim" />
          </Form.Item>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            <Form.Item name="duration" label="Thời lượng (phút)" rules={[{ required: true }]}>
              <InputNumber min={1} max={600} style={{ width: '100%' }} />
            </Form.Item>
            <Form.Item name="releaseDate" label="Ngày phát hành">
              <DatePicker format="DD/MM/YYYY" style={{ width: '100%' }} />
            </Form.Item>
            <Form.Item name="language" label="Ngôn ngữ" rules={[{ required: true }]}>
              <Input placeholder="VD: Tiếng Việt" />
            </Form.Item>
            <Form.Item name="ageRating" label="Phân loại tuổi" rules={[{ required: true }]}>
              <Select placeholder="Chọn phân loại">
                {['P','C13','C16','C18'].map(r => <Select.Option key={r} value={r}>{r}</Select.Option>)}
              </Select>
            </Form.Item>
            <Form.Item name="status" label="Trạng thái" rules={[{ required: true }]}>
              <Select placeholder="Chọn trạng thái">
                {Object.entries(STATUS_MAP).map(([k, v]) =>
                  <Select.Option key={k} value={k}>{v.label}</Select.Option>)}
              </Select>
            </Form.Item>
            <Form.Item name="genreNames" label="Thể loại">
              <Select mode="multiple" placeholder="Chọn thể loại">
                {genres.map(g => <Select.Option key={g.genreId} value={g.genreName}>{g.genreName}</Select.Option>)}
              </Select>
            </Form.Item>
          </div>
          <Form.Item name="posterLink" label="Link poster">
            <Input placeholder="https://..." />
          </Form.Item>
          <Form.Item name="trailerLink" label="Link trailer">
            <Input placeholder="https://youtube.com/..." />
          </Form.Item>
          <Form.Item name="director" label="Đạo diễn">
            <Input placeholder="Tên đạo diễn" />
          </Form.Item>
          <Form.Item name="performerNames" label="Diễn viên chính">
            <Select mode="tags" placeholder="Diễn viên 1, diễn viên 2, ..." />
          </Form.Item>
          <div style={{ display:'flex', justifyContent:'flex-end', gap:8, marginTop:8 }}>
            <Button onClick={closeModal}>Hủy</Button>
            <Button type="primary" htmlType="submit"
              loading={createMut.isPending || updateMut.isPending}
              style={{ background:'#E53935', border:'none' }}>
              {editing ? 'Cập nhật' : 'Thêm phim'}
            </Button>
          </div>
        </Form>
      </Modal>
    </div>
  )
}
