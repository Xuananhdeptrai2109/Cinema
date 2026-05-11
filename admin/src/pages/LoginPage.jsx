import { Form, Input, Button, message, Typography } from 'antd'
import { UserOutlined, LockOutlined } from '@ant-design/icons'
import { useNavigate } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
import { useAuth } from '../context/AuthContext'
import { authApi } from '../api'

const { Title, Text } = Typography

export default function LoginPage() {
  const navigate = useNavigate()
  const { login } = useAuth()

  const { mutate, isPending } = useMutation({
    mutationFn: authApi.login,
    onSuccess: (res) => {
      const { token, username, role } = res.data
      if (role !== 'admin' && role !== 'ROLE_admin') {
        message.error('Tài khoản không có quyền admin')
        return
      }
      login(token, { username, role })
      message.success('Đăng nhập thành công')
      navigate('/dashboard')
    },
    onError: () => message.error('Sai email hoặc mật khẩu'),
  })

  return (
    <div style={{
      minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center',
      background: '#0f0f14',
      backgroundImage: 'radial-gradient(ellipse 80% 60% at 50% -10%, rgba(229,57,53,0.15) 0%, transparent 70%)'
    }}>
      <div style={{
        width: 400, padding: 40,
        background: '#1a1a24', borderRadius: 16,
        border: '1px solid #2e2e3f',
        boxShadow: '0 24px 80px rgba(0,0,0,0.6)'
      }}>
        {/* Logo */}
        <div style={{ textAlign: 'center', marginBottom: 32 }}>
          <div style={{
            width: 52, height: 52, borderRadius: 12,
            background: 'linear-gradient(135deg,#E53935,#b71c1c)',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
            fontSize: 24, color: '#fff', fontFamily: "'Space Mono',monospace", fontWeight: 700,
            marginBottom: 16
          }}>C</div>
          <Title level={3} style={{ color: '#e8e8f0', margin: 0 }}>Cinema Admin</Title>
          <Text style={{ color: '#9090a8', fontSize: 13 }}>Hệ thống quản trị rạp chiếu phim</Text>
        </div>

        <Form layout="vertical" onFinish={mutate} requiredMark={false}>
          <Form.Item
            name="email"
            label={<span style={{ color: '#9090a8' }}>Email</span>}
            rules={[{ required: true, message: 'Nhập email' }]}
          >
            <Input
              prefix={<UserOutlined style={{ color: '#9090a8' }} />}
              placeholder="admin@example.com"
              size="large"
            />
          </Form.Item>


          <Form.Item name="password" label={<span style={{ color: '#9090a8' }}>Mật khẩu</span>}
            rules={[{ required: true, message: 'Nhập mật khẩu' }]}>
            <Input.Password prefix={<LockOutlined style={{ color: '#9090a8' }} />}
              placeholder="••••••••" size="large" />
          </Form.Item>

          <Button type="primary" htmlType="submit" block size="large"
            loading={isPending}
            style={{ marginTop: 8, height: 44, fontWeight: 600, background: '#E53935', border: 'none' }}>
            Đăng nhập
          </Button>
        </Form>
      </div>
    </div>
  )
}
