import React from 'react'
import ReactDOM from 'react-dom/client'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ConfigProvider } from 'antd'
import viVN from 'antd/locale/vi_VN'
import App from './App'
import './index.css'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      staleTime: 30_000,
    }
  }
})

const theme = {
  token: {
    colorPrimary: '#E53935',
    colorBgLayout: '#0f0f14',
    colorBgContainer: '#1a1a24',
    colorBgElevated: '#22222f',
    colorText: '#e8e8f0',
    colorTextSecondary: '#9090a8',
    colorBorder: '#2e2e3f',
    borderRadius: 8,
    fontFamily: "'Plus Jakarta Sans', sans-serif",
  },
  components: {
    Menu: {
      darkItemBg: '#0f0f14',
      darkSubMenuItemBg: '#13131c',
      darkItemSelectedBg: 'rgba(229,57,53,0.15)',
      darkItemSelectedColor: '#E53935',
    },
    Table: {
      headerBg: '#22222f',
      rowHoverBg: '#2a2a38',
    },
    Card: {
      colorBgContainer: '#1a1a24',
    }
  }
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <ConfigProvider theme={theme} locale={viVN}>
        <App />
      </ConfigProvider>
    </QueryClientProvider>
  </React.StrictMode>
)
