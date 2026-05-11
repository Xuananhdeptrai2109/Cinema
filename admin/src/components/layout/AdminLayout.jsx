import { useState } from 'react'
import { Layout, Menu, Avatar, Dropdown, Badge, Typography } from 'antd'
import { Outlet, useNavigate, useLocation } from 'react-router-dom'
import {
  DashboardOutlined, VideoCameraOutlined, BankOutlined,
  AppstoreOutlined, CalendarOutlined, GiftOutlined,
  ShoppingOutlined, BarChartOutlined, LogoutOutlined,
  UserOutlined, MenuFoldOutlined, MenuUnfoldOutlined,
  BellOutlined
} from '@ant-design/icons'
import { useAuth } from '../../context/AuthContext'

const { Sider, Header, Content } = Layout
const { Text } = Typography

const NAV_ITEMS = [
  { key: '/dashboard',  icon: <DashboardOutlined />,   label: 'Dashboard' },
  { key: '/movies',     icon: <VideoCameraOutlined />,  label: 'Phim' },
  { key: '/cinemas',    icon: <BankOutlined />,         label: 'Rạp chiếu' },
  { key: '/rooms',      icon: <AppstoreOutlined />,     label: 'Phòng chiếu' },
  { key: '/showtimes',  icon: <CalendarOutlined />,     label: 'Lịch chiếu' },
  { key: '/products',   icon: <ShoppingOutlined />,     label: 'Sản phẩm' },
  { key: '/discounts',  icon: <GiftOutlined />,         label: 'Khuyến mãi' },
  { key: '/statistics', icon: <BarChartOutlined />,     label: 'Thống kê' },
]

export default function AdminLayout() {
  const [collapsed, setCollapsed] = useState(false)
  const navigate  = useNavigate()
  const location  = useLocation()
  const { user, logout } = useAuth()

  const userMenu = {
    items: [
      { key: 'logout', icon: <LogoutOutlined />, label: 'Đăng xuất', danger: true }
    ],
    onClick: ({ key }) => { if (key === 'logout') { logout(); navigate('/login') } }
  }

  return (
    <Layout style={{ minHeight: '100vh' }}>
      {/* ── SIDEBAR ── */}
      <Sider
        collapsible collapsed={collapsed}
        onCollapse={setCollapsed}
        trigger={null}
        width={220}
        style={{ position: 'fixed', height: '100vh', left: 0, top: 0, zIndex: 100 }}
      >
        {/* Logo */}
        <div style={{
          height: 64, display: 'flex', alignItems: 'center', justifyContent: 'center',
          borderBottom: '1px solid #2e2e3f', gap: 10
        }}>
          <div style={{
            width: 32, height: 32, borderRadius: 8,
            background: 'linear-gradient(135deg,#E53935,#b71c1c)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: 16, color: '#fff', fontFamily: "'Space Mono', monospace", fontWeight: 700
          }}>C</div>
          {!collapsed && (
            <Text style={{ color: '#e8e8f0', fontWeight: 700, fontSize: 15, letterSpacing: '-0.02em' }}>
              Cinema <span style={{ color: '#E53935' }}>Admin</span>
            </Text>
          )}
        </div>

        {/* Nav */}
        <Menu
          theme="dark" mode="inline"
          selectedKeys={[location.pathname]}
          onClick={({ key }) => navigate(key)}
          style={{ border: 'none', marginTop: 8 }}
          items={NAV_ITEMS.map(item => ({
            key: item.key,
            icon: item.icon,
            label: item.label,
          }))}
        />
      </Sider>

      {/* ── MAIN ── */}
      <Layout style={{ marginLeft: collapsed ? 80 : 220, transition: 'margin 0.2s' }}>
        {/* Header */}
        <Header style={{
          position: 'sticky', top: 0, zIndex: 99,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          padding: '0 24px', height: 64
        }}>
          <button
            onClick={() => setCollapsed(!collapsed)}
            style={{ background: 'none', border: 'none', color: '#9090a8', cursor: 'pointer', fontSize: 18 }}
          >
            {collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
          </button>

          <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
            <Badge count={3} size="small">
              <BellOutlined style={{ color: '#9090a8', fontSize: 18, cursor: 'pointer' }} />
            </Badge>
            <Dropdown menu={userMenu} placement="bottomRight" trigger={['click']}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, cursor: 'pointer' }}>
                <Avatar
                  size={34}
                  style={{ background: 'linear-gradient(135deg,#E53935,#b71c1c)' }}
                  icon={<UserOutlined />}
                />
                {user?.username && (
                  <Text style={{ color: '#e8e8f0', fontSize: 13 }}>{user.username}</Text>
                )}
              </div>
            </Dropdown>
          </div>
        </Header>

        {/* Content */}
        <Content style={{ padding: '24px', minHeight: 'calc(100vh - 64px)' }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  )
}
