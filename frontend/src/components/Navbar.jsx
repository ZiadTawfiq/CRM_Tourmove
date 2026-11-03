import React from 'react';
import { 
  Search, 
  Plus, 
  Sun, 
  Moon, 
  Bell, 
  User, 
  Sparkles,
  PhoneCall
} from 'lucide-react';

export default function Navbar({ 
  searchQuery, 
  setSearchQuery, 
  onOpenCreateModal, 
  theme, 
  toggleTheme,
  duplicateCount 
}) {
  return (
    <header style={{
      height: '70px',
      backgroundColor: 'var(--bg-surface)',
      borderBottom: '1px solid var(--border-color)',
      padding: '0 32px',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      position: 'sticky',
      top: 0,
      zIndex: 50,
      boxShadow: 'var(--shadow-sm)'
    }}>
      {/* Search Input */}
      <div style={{ position: 'relative', width: '380px', maxWidth: '100%' }}>
        <Search 
          size={18} 
          style={{ 
            position: 'absolute', 
            right: '14px', 
            top: '50%', 
            transform: 'translateY(-50%)', 
            color: 'var(--text-muted)' 
          }} 
        />
        <input
          id="global-search-input"
          type="text"
          placeholder="بحث سريع برقم الهاتف أو اسم العميل..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          style={{
            width: '100%',
            padding: '10px 42px 10px 14px',
            borderRadius: 'var(--radius-full)',
            border: '1px solid var(--border-color)',
            backgroundColor: 'var(--bg-app)',
            color: 'var(--text-primary)',
            fontFamily: 'inherit',
            fontSize: '0.88rem',
            outline: 'none',
            transition: 'var(--transition)'
          }}
          onFocus={(e) => {
            e.target.style.borderColor = 'var(--primary)';
            e.target.style.boxShadow = '0 0 0 3px var(--primary-light)';
          }}
          onBlur={(e) => {
            e.target.style.borderColor = 'var(--border-color)';
            e.target.style.boxShadow = 'none';
          }}
        />
      </div>

      {/* Right Controls */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
        {/* Create Lead Button */}
        <button
          id="btn-add-new-lead"
          className="btn btn-primary"
          onClick={onOpenCreateModal}
          style={{ padding: '9px 18px', borderRadius: 'var(--radius-full)' }}
        >
          <Plus size={18} />
          <span>إضافة عميل جديد</span>
        </button>

        {/* Theme Switcher */}
        <button
          id="btn-toggle-theme"
          className="btn-icon"
          onClick={toggleTheme}
          title={theme === 'dark' ? 'الوضع النهاري' : 'الوضع الليلي'}
          style={{ borderRadius: '50%', width: '38px', height: '38px' }}
        >
          {theme === 'dark' ? <Sun size={18} color="#f59e0b" /> : <Moon size={18} />}
        </button>

        {/* Notification Bell with Badge */}
        <div style={{ position: 'relative' }}>
          <button
            id="btn-notifications"
            className="btn-icon"
            style={{ borderRadius: '50%', width: '38px', height: '38px' }}
            title="الإشعارات"
          >
            <Bell size={18} />
          </button>
          {duplicateCount > 0 && (
            <span style={{
              position: 'absolute',
              top: '-4px',
              left: '-4px',
              backgroundColor: '#ef4444',
              color: '#fff',
              fontSize: '0.65rem',
              fontWeight: 800,
              width: '18px',
              height: '18px',
              borderRadius: '50%',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              border: '2px solid var(--bg-surface)'
            }}>
              {duplicateCount}
            </span>
          )}
        </div>

        {/* Divider */}
        <div style={{ height: '24px', width: '1px', backgroundColor: 'var(--border-color)' }}></div>

        {/* Current User Pill */}
        <div style={{
          display: 'flex',
          alignItems: 'center',
          gap: '10px',
          padding: '4px 10px 4px 6px',
          borderRadius: 'var(--radius-full)',
          backgroundColor: 'var(--bg-app)',
          border: '1px solid var(--border-color)'
        }}>
          <div style={{
            width: '32px',
            height: '32px',
            borderRadius: '50%',
            background: 'var(--accent-gradient)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: '#fff',
            fontWeight: 700,
            fontSize: '0.85rem'
          }}>
            خ
          </div>
          <div style={{ textAlign: 'right', lineHeight: 1.2 }}>
            <div style={{ fontSize: '0.82rem', fontWeight: 700, color: 'var(--text-primary)' }}>
              خالد توفيق
            </div>
            <div style={{ fontSize: '0.7rem', color: 'var(--primary)', fontWeight: 600 }}>
              مدير النظام (Admin)
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
