import React from 'react';
import { 
  BarChart, 
  PieChart, 
  TrendingUp, 
  Target, 
  Share2, 
  Building2, 
  DollarSign,
  Award
} from 'lucide-react';
import { STATUS, STATUS_META, TYPE_LEAD, TYPE_LEAD_META } from '../types/crmConstants';

export default function AnalyticsView({ leads, projects, channels, employees }) {
  const total = leads.length || 1;

  // Status breakdown
  const statusCounts = Object.values(STATUS_META).map(s => {
    const count = leads.filter(l => l.status === s.id).length;
    const percentage = ((count / total) * 100).toFixed(1);
    return { ...s, count, percentage };
  });

  // Channel breakdown
  const channelData = channels.map(c => {
    const channelLeads = leads.filter(l => l.channelId === c.id);
    const count = channelLeads.length;
    const wonCount = channelLeads.filter(l => l.status === STATUS.Reservation).length;
    const totalBudget = channelLeads.reduce((acc, curr) => acc + (curr.budget || 0), 0);
    return {
      name: c.name,
      count,
      wonCount,
      totalBudget,
      percentage: ((count / total) * 100).toFixed(1)
    };
  }).sort((a, b) => b.count - a.count);

  // Sales rep performance
  const repPerformance = employees
    .filter(e => e.role === 2 || e.role === 3) // SalesRep & TeamLeader
    .map(emp => {
      const repLeads = leads.filter(l => l.employeeId === emp.id);
      const won = repLeads.filter(l => l.status === STATUS.Reservation).length;
      const pipelineValue = repLeads.reduce((acc, curr) => acc + (curr.budget || 0), 0);
      return {
        name: emp.name,
        totalLeads: repLeads.length,
        won,
        pipelineValue,
        conversion: repLeads.length > 0 ? ((won / repLeads.length) * 100).toFixed(1) : 0
      };
    }).sort((a, b) => b.totalLeads - a.totalLeads);

  // Rent vs Sale
  const saleCount = leads.filter(l => l.typeLead === TYPE_LEAD.Sale).length;
  const rentCount = leads.filter(l => l.typeLead === TYPE_LEAD.Rent).length;

  const formatCurrency = (val) => {
    if (!val) return '0 ج.م';
    if (val >= 1000000) return `${(val / 1000000).toFixed(1)} مليون ج.م`;
    return `${val.toLocaleString()} ج.م`;
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '24px' }}>
      {/* Top Banner KPI */}
      <div className="glass-card" style={{
        padding: '24px',
        background: 'linear-gradient(135deg, rgba(79, 70, 229, 0.08) 0%, rgba(6, 182, 212, 0.08) 100%)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        flexWrap: 'wrap',
        gap: '20px'
      }}>
        <div>
          <h3 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--text-primary)', margin: 0, marginBottom: '6px' }}>
            تحليلات أداء المبيعات ومسار التحويل
          </h3>
          <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', margin: 0 }}>
            رؤى وإحصائيات دقيقة حول تدفق العملاء، قنوات الاستقطاب، وكفاءة فريق المبيعات
          </p>
        </div>

        <div style={{ display: 'flex', gap: '16px' }}>
          <div style={{
            padding: '12px 20px',
            backgroundColor: 'var(--bg-surface)',
            borderRadius: 'var(--radius-md)',
            border: '1px solid var(--border-color)',
            textAlign: 'center'
          }}>
            <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>نسبة الشراء (Sale)</div>
            <div style={{ fontSize: '1.3rem', fontWeight: 800, color: '#4f46e5' }}>
              {((saleCount / total) * 100).toFixed(0)}%
            </div>
          </div>
          <div style={{
            padding: '12px 20px',
            backgroundColor: 'var(--bg-surface)',
            borderRadius: 'var(--radius-md)',
            border: '1px solid var(--border-color)',
            textAlign: 'center'
          }}>
            <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>نسبة الإيجار (Rent)</div>
            <div style={{ fontSize: '1.3rem', fontWeight: 800, color: '#06b6d4' }}>
              {((rentCount / total) * 100).toFixed(0)}%
            </div>
          </div>
        </div>
      </div>

      <div className="grid-cols-2">
        {/* Pipeline Distribution */}
        <div className="glass-card" style={{ padding: '24px', backgroundColor: 'var(--bg-surface)' }}>
          <h4 style={{ fontSize: '1rem', fontWeight: 700, marginBottom: '16px', color: 'var(--text-primary)', display: 'flex', alignItems: 'center', gap: '8px' }}>
            <Target size={18} style={{ color: 'var(--primary)' }} />
            توزيع العملاء حسب مراحل المسار
          </h4>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
            {statusCounts.map(s => (
              <div key={s.id}>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.85rem', marginBottom: '6px' }}>
                  <span style={{ fontWeight: 600, color: 'var(--text-primary)' }}>{s.labelAr}</span>
                  <span style={{ fontWeight: 700, color: s.color }}>{s.count} ({s.percentage}%)</span>
                </div>
                <div style={{
                  height: '10px',
                  backgroundColor: 'var(--bg-app)',
                  borderRadius: '999px',
                  overflow: 'hidden',
                  border: '1px solid var(--border-light)'
                }}>
                  <div style={{
                    width: `${s.percentage}%`,
                    height: '100%',
                    backgroundColor: s.color,
                    borderRadius: '999px',
                    transition: 'width 0.5s ease'
                  }}></div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Channels Performance */}
        <div className="glass-card" style={{ padding: '24px', backgroundColor: 'var(--bg-surface)' }}>
          <h4 style={{ fontSize: '1rem', fontWeight: 700, marginBottom: '16px', color: 'var(--text-primary)', display: 'flex', alignItems: 'center', gap: '8px' }}>
            <Share2 size={18} style={{ color: 'var(--primary)' }} />
            أداء قنوات الاستقطاب (Marketing Channels)
          </h4>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
            {channelData.map(c => (
              <div 
                key={c.name}
                style={{
                  padding: '12px 14px',
                  borderRadius: 'var(--radius-md)',
                  backgroundColor: 'var(--bg-app)',
                  border: '1px solid var(--border-color)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between'
                }}
              >
                <div>
                  <div style={{ fontSize: '0.88rem', fontWeight: 700, color: 'var(--text-primary)' }}>
                    {c.name}
                  </div>
                  <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: '2px' }}>
                    حجوزات ناجحة: {c.wonCount} • إجمالي الميزانية: {formatCurrency(c.totalBudget)}
                  </div>
                </div>
                <span style={{
                  padding: '4px 10px',
                  borderRadius: '999px',
                  fontSize: '0.8rem',
                  fontWeight: 700,
                  backgroundColor: 'var(--primary-light)',
                  color: 'var(--primary)'
                }}>
                  {c.count} عميل
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Sales Rep Workload & Conversion */}
      <div className="glass-card" style={{ padding: '24px', backgroundColor: 'var(--bg-surface)' }}>
        <h4 style={{ fontSize: '1rem', fontWeight: 700, marginBottom: '16px', color: 'var(--text-primary)', display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Award size={18} style={{ color: '#f59e0b' }} />
          كفاءة ومعدل إغلاق مسؤولي المبيعات
        </h4>

        <div style={{ overflowX: 'auto' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'right', fontSize: '0.88rem' }}>
            <thead>
              <tr style={{ backgroundColor: 'var(--bg-app)', borderBottom: '1px solid var(--border-color)', color: 'var(--text-secondary)' }}>
                <th style={{ padding: '12px 16px' }}>مسؤول المبيعات</th>
                <th style={{ padding: '12px 16px' }}>العملاء المسندين</th>
                <th style={{ padding: '12px 16px' }}>الحجوزات المكتملة</th>
                <th style={{ padding: '12px 16px' }}>قيمة الصفقات</th>
                <th style={{ padding: '12px 16px' }}>معدل التحويل</th>
              </tr>
            </thead>
            <tbody>
              {repPerformance.map((rep, idx) => (
                <tr key={rep.name} style={{ borderBottom: '1px solid var(--border-color)' }}>
                  <td style={{ padding: '12px 16px', fontWeight: 700, color: 'var(--text-primary)' }}>
                    {idx === 0 && '🥇 '}{rep.name}
                  </td>
                  <td style={{ padding: '12px 16px' }}>{rep.totalLeads}</td>
                  <td style={{ padding: '12px 16px', color: '#10b981', fontWeight: 700 }}>{rep.won}</td>
                  <td style={{ padding: '12px 16px', fontWeight: 700, color: 'var(--primary)' }}>
                    {formatCurrency(rep.pipelineValue)}
                  </td>
                  <td style={{ padding: '12px 16px' }}>
                    <span className="badge badge-reservation">
                      {rep.conversion}%
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
