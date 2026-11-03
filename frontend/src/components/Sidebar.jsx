import React from 'react';
import { 
  LayoutDashboard, 
  Kanban, 
  Users, 
  BarChart3, 
  Building2, 
  UserCheck, 
  Settings,
  Sparkles,
  ShieldAlert
} from 'lucide-react';

export default function Sidebar({ currentView, setCurrentView, duplicateCount }) {
  const menuItems = [
    { id: 'dashboard', label: 'لوحة المؤشرات', icon: LayoutDashboard },
    { id: 'kanban', label: 'مسار المبيعات (كانبان)', icon: Kanban },
    { id: 'leads', label: 'إدارة العملاء (Leads)', icon: Users, badge: duplicateCount > 0 ? `${duplicateCount} مكرر` : null, badgeColor: 'bg-red-500' },
    { id: 'analytics', label: 'التحليلات والتقارير', icon: BarChart3 },
    { id: 'projects', label: 'المشاريع العقارية', icon: Building2 },
    { id: 'team', label: 'فريق العمل والمبيعات', icon: UserCheck },
    { id: 'settings', label: 'إعدادات النظام والـ API', icon: Settings },
  ];

  return (
    <aside className="crm-sidebar" style={{
      width: '270px',
      backgroundColor: 'var(--bg-sidebar)',
      color: 'var(--sidebar-text)',
      display: 'flex',
      flexDirection: 'column',
      flexShrink: 0,
      borderLeft: '1px solid var(--border-color)',
      transition: 'var(--transition)'
    }}>
      {/* Brand Header */}
      <div style={{
        padding: '24px 20px',
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
        borderBottom: '1px solid rgba(255, 255, 255, 0.08)'
      }}>
        <div style={{
          width: '42px',
          height: '42px',
          borderRadius: '12px',
          background: 'var(--primary-gradient)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          color: '#fff',
          boxShadow: '0 4px 14px rgba(79, 70, 229, 0.45)',
          flexShrink: 0
        }}>
          <Sparkles size={22} />
        </div>
        <div>
          <h2 style={{ fontSize: '1.15rem', fontWeight: 800, color: '#fff', letterSpacing: '-0.3px', margin: 0 }}>
            Tourmove CRM
          </h2>
          <span style={{ fontSize: '0.75rem', color: '#64748b', fontWeight: 500 }}>
            Real Estate Lead System
          </span>
        </div>
      </div>

      {/* Navigation List */}
      <nav style={{ flex: 1, padding: '18px 12px', display: 'flex', flexDirection: 'column', gap: '6px', overflowY: 'auto' }}>
        <div style={{ fontSize: '0.7rem', fontWeight: 700, color: '#475569', padding: '0 12px 6px', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
          القائمة الرئيسية
        </div>
        {menuItems.map(item => {
          const Icon = item.icon;
          const isActive = currentView === item.id;
          return (
            <button
              key={item.id}
              id={`nav-${item.id}`}
              onClick={() => setCurrentView(item.id)}
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                width: '100%',
                padding: '12px 14px',
                borderRadius: '10px',
                border: 'none',
                background: isActive ? 'var(--primary-gradient)' : 'transparent',
                color: isActive ? '#ffffff' : 'var(--sidebar-text)',
                cursor: 'pointer',
                fontFamily: 'inherit',
                fontSize: '0.9rem',
                fontWeight: isActive ? 700 : 500,
                textAlign: 'right',
                transition: 'var(--transition)',
                boxShadow: isActive ? '0 4px 14px rgba(79, 70, 229, 0.35)' : 'none'
              }}
              onMouseEnter={(e) => {
                if (!isActive) e.currentTarget.style.backgroundColor = 'rgba(255, 255, 255, 0.05)';
              }}
              onMouseLeave={(e) => {
                if (!isActive) e.currentTarget.style.backgroundColor = 'transparent';
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                <Icon size={19} style={{ color: isActive ? '#fff' : '#818cf8' }} />
                <span>{item.label}</span>
              </div>
              {item.badge && (
                <span style={{
                  backgroundColor: '#ef4444',
                  color: '#fff',
                  fontSize: '0.7rem',
                  padding: '2px 8px',
                  borderRadius: '999px',
                  fontWeight: 700,
                  display: 'flex',
                  alignItems: 'center',
                  gap: '4px'
                }}>
                  <ShieldAlert size={12} />
                  {item.badge}
                </span>
              )}
            </button>
          );
        })}
      </nav>

      {/* System Status Footer */}
      <div style={{
        padding: '16px',
        margin: '12px',
        borderRadius: '12px',
        backgroundColor: 'rgba(255, 255, 255, 0.03)',
        border: '1px solid rgba(255, 255, 255, 0.06)'
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '4px' }}>
          <span style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#10b981', display: 'inline-block' }}></span>
          <span style={{ fontSize: '0.8rem', color: '#cbd5e1', fontWeight: 600 }}>الفرونت إند نشط ومترابط</span>
        </div>
        <p style={{ fontSize: '0.72rem', color: '#64748b', margin: 0, lineHeight: 1.4 }}>
          متوافق 100% مع نماذج الباك إند (.NET CRM Core)
        </p>
      </div>
    </aside>
  );
}
