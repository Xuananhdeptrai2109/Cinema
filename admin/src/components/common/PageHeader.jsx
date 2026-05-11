import { Typography } from 'antd'

const { Title, Text } = Typography

export default function PageHeader({ title, subtitle, extra }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'flex-start',
      justifyContent: 'space-between', marginBottom: 24
    }}>
      <div>
        <Title level={4} style={{ color: '#e8e8f0', margin: 0, fontSize: 20 }}>
          {title}
        </Title>
        {subtitle && (
          <Text style={{ color: '#9090a8', fontSize: 13 }}>{subtitle}</Text>
        )}
      </div>
      {extra && <div>{extra}</div>}
    </div>
  )
}
