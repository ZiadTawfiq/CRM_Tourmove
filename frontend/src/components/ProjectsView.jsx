import React from 'react';
import { Building2, MapPin, Coins, Users, ArrowUpRight } from 'lucide-react';

export default function ProjectsView({ projects, leads, onFilterProject }) {
  const formatCurrency = (val) => {
    if (!val) return 'غير محدد';
    if (val >= 1000000) return `${(val / 1000000).toFixed(1)} مليون ج.م`;
    return `${val.toLocaleString()} ج.م`;
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          <h3 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--text-primary)', margin: 0 }}>
            المشاريع العقارية والمجمعات (Real Estate Projects)
          </h3>
          <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', margin: '4px 0 0' }}>
            المشاريع المسجلة في النظام ومتابعة حجم العملاء المهتمين بكل مشروع
          </p>
        </div>
      </div>

      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))',
        gap: '20px'
      }}>
        {projects.map(proj => {
          const projLeads = leads.filter(l => l.projectId === proj.id);
          const totalBudget = projLeads.reduce((acc, curr) => acc + (curr.budget || 0), 0);

          return (
            <div
              key={proj.id}
              className="glass-card"
              style={{
                padding: '24px',
                backgroundColor: 'var(--bg-surface)',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between'
              }}
            >
              <div>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '14px' }}>
                  <div style={{
                    width: '42px',
                    height: '42px',
                    borderRadius: '12px',
                    background: 'var(--primary-light)',
                    color: 'var(--primary)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center'
                  }}>
                    <Building2 size={22} />
                  </div>
                  <span style={{
                    padding: '4px 10px',
                    borderRadius: '999px',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    color: '#3b82f6',
                    fontSize: '0.75rem',
                    fontWeight: 700
                  }}>
                    {projLeads.length} عميل مهتم
                  </span>
                </div>

                <h4 style={{ fontSize: '1.05rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '8px' }}>
                  {proj.name}
                </h4>

                <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: 'var(--text-muted)', fontSize: '0.82rem', marginBottom: '16px' }}>
                  <MapPin size={14} />
                  <span>{proj.location}</span>
                </div>

                <div style={{
                  padding: '12px',
                  borderRadius: 'var(--radius-md)',
                  backgroundColor: 'var(--bg-app)',
                  display: 'flex',
                  justifyContent: 'space-between',
                  marginBottom: '16px',
                  fontSize: '0.82rem'
                }}>
                  <div>
                    <span style={{ display: 'block', color: 'var(--text-muted)' }}>يبدأ من:</span>
                    <strong style={{ color: 'var(--text-primary)' }}>{formatCurrency(proj.startingPrice)}</strong>
                  </div>
                  <div>
                    <span style={{ display: 'block', color: 'var(--text-muted)' }}>إجمالي الميزانيات:</span>
                    <strong style={{ color: 'var(--primary)' }}>{formatCurrency(totalBudget)}</strong>
                  </div>
                </div>
              </div>

              <button
                className="btn btn-secondary btn-sm"
                style={{ width: '100%', justifyContent: 'center' }}
                onClick={() => onFilterProject(proj.id)}
              >
                <span>عرض عملاء هذا المشروع</span>
                <ArrowUpRight size={14} />
              </button>
            </div>
          );
        })}
      </div>
    </div>
  );
}
