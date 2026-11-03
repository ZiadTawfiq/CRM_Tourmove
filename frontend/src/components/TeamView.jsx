import React from 'react';
import { UserCheck, Mail, Phone, Shield, Award } from 'lucide-react';
import { ROLE_LABELS, ROLES } from '../types/crmConstants';

export default function TeamView({ employees, leads }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
      <div>
        <h3 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--text-primary)', margin: 0 }}>
          فريق العمل ومسؤولو المبيعات (Sales Team & Employees)
        </h3>
        <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', margin: '4px 0 0' }}>
          هيكل الصلاحيات والأدوار (Admin, SalesRep, TeamLeader, Marketer) ومتابعة توزيع العملاء
        </p>
      </div>

      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fill, minmax(290px, 1fr))',
        gap: '20px'
      }}>
        {employees.map(emp => {
          const empLeads = leads.filter(l => l.employeeId === emp.id);

          return (
            <div
              key={emp.id}
              className="glass-card"
              style={{
                padding: '24px',
                backgroundColor: 'var(--bg-surface)',
                display: 'flex',
                flexDirection: 'column',
                gap: '14px'
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                <div style={{
                  width: '46px',
                  height: '46px',
                  borderRadius: '14px',
                  background: 'var(--primary-gradient)',
                  color: '#fff',
                  fontWeight: 800,
                  fontSize: '1.1rem',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  boxShadow: '0 4px 10px rgba(79, 70, 229, 0.3)'
                }}>
                  {emp.name[0]}
                </div>
                <div>
                  <h4 style={{ fontSize: '1rem', fontWeight: 800, color: 'var(--text-primary)', margin: 0 }}>
                    {emp.name}
                  </h4>
                  <span style={{ fontSize: '0.75rem', color: 'var(--primary)', fontWeight: 600 }}>
                    {ROLE_LABELS[emp.role] || 'عضو فريق'}
                  </span>
                </div>
              </div>

              <div style={{
                padding: '12px',
                borderRadius: 'var(--radius-md)',
                backgroundColor: 'var(--bg-app)',
                display: 'flex',
                flexDirection: 'column',
                gap: '8px',
                fontSize: '0.82rem'
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: 'var(--text-secondary)' }}>
                  <Mail size={14} />
                  <span>{emp.email}</span>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: 'var(--text-secondary)' }}>
                  <Phone size={14} />
                  <span dir="ltr">{emp.phone}</span>
                </div>
              </div>

              <div style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                paddingTop: '8px',
                borderTop: '1px solid var(--border-light)',
                fontSize: '0.8rem'
              }}>
                <span style={{ color: 'var(--text-muted)' }}>العملاء المسندين:</span>
                <span style={{
                  fontWeight: 800,
                  color: 'var(--primary)',
                  backgroundColor: 'var(--primary-light)',
                  padding: '2px 8px',
                  borderRadius: '999px'
                }}>
                  {empLeads.length} عميل
                </span>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
