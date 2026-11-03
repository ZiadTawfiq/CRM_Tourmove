import React from 'react';
import { 
  Users, 
  UserPlus, 
  Clock, 
  CheckCircle2, 
  XCircle, 
  TrendingUp, 
  Coins 
} from 'lucide-react';
import { STATUS } from '../types/crmConstants';

export default function StatsCards({ leads }) {
  const totalLeads = leads.length;
  const freshLeads = leads.filter(l => l.status === STATUS.FreshLead).length;
  const inPipelineLeads = leads.filter(l => l.status === STATUS.FollowUp || l.status === STATUS.Orientation).length;
  const wonLeads = leads.filter(l => l.status === STATUS.Reservation).length;
  const cancelledLeads = leads.filter(l => l.status === STATUS.Cancellation).length;

  const totalBudget = leads.reduce((acc, curr) => acc + (curr.budget || 0), 0);
  const wonBudget = leads
    .filter(l => l.status === STATUS.Reservation)
    .reduce((acc, curr) => acc + (curr.budget || 0), 0);

  const conversionRate = totalLeads > 0 ? ((wonLeads / totalLeads) * 100).toFixed(1) : 0;

  const formatCurrency = (val) => {
    if (val >= 1000000) {
      return `${(val / 1000000).toFixed(1)} مليون ج.م`;
    }
    return `${val.toLocaleString()} ج.م`;
  };

  const cards = [
    {
      id: 'stat-total',
      title: 'إجمالي العملاء',
      value: totalLeads,
      subValue: `${conversionRate}% معدل التحويل`,
      icon: Users,
      color: '#4f46e5',
      bgGrad: 'linear-gradient(135deg, rgba(79, 70, 229, 0.15) 0%, rgba(124, 58, 237, 0.08) 100%)',
    },
    {
      id: 'stat-fresh',
      title: 'عملاء جدد (Fresh)',
      value: freshLeads,
      subValue: 'بانتظار التواصل الأول',
      icon: UserPlus,
      color: '#3b82f6',
      bgGrad: 'linear-gradient(135deg, rgba(59, 130, 246, 0.15) 0%, rgba(6, 182, 212, 0.08) 100%)',
    },
    {
      id: 'stat-pipeline',
      title: 'قيد المتابعة والمعاينة',
      value: inPipelineLeads,
      subValue: 'مفاوضات وزيارات جارية',
      icon: Clock,
      color: '#f59e0b',
      bgGrad: 'linear-gradient(135deg, rgba(245, 158, 11, 0.15) 0%, rgba(217, 119, 6, 0.08) 100%)',
    },
    {
      id: 'stat-won',
      title: 'حجوزات مؤكدة (Closed)',
      value: wonLeads,
      subValue: formatCurrency(wonBudget),
      icon: CheckCircle2,
      color: '#10b981',
      bgGrad: 'linear-gradient(135deg, rgba(16, 185, 129, 0.15) 0%, rgba(5, 150, 105, 0.08) 100%)',
    },
    {
      id: 'stat-budget',
      title: 'إجمالي قيمة المسار',
      value: formatCurrency(totalBudget),
      subValue: 'مجموع الميزانيات المسجلة',
      icon: Coins,
      color: '#8b5cf6',
      bgGrad: 'linear-gradient(135deg, rgba(139, 92, 246, 0.15) 0%, rgba(79, 70, 229, 0.08) 100%)',
    },
  ];

  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
      gap: '16px',
      marginBottom: '28px'
    }}>
      {cards.map((c) => {
        const Icon = c.icon;
        return (
          <div
            key={c.id}
            id={c.id}
            className="glass-card"
            style={{
              padding: '20px',
              background: 'var(--bg-surface)',
              position: 'relative',
              overflow: 'hidden',
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '12px' }}>
              <span style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', fontWeight: 600 }}>
                {c.title}
              </span>
              <div style={{
                width: '40px',
                height: '40px',
                borderRadius: '10px',
                background: c.bgGrad,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: c.color
              }}>
                <Icon size={20} />
              </div>
            </div>
            <div style={{ fontSize: '1.65rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '4px' }}>
              {c.value}
            </div>
            <div style={{ fontSize: '0.78rem', color: 'var(--text-muted)', fontWeight: 500, display: 'flex', alignItems: 'center', gap: '4px' }}>
              <TrendingUp size={13} style={{ color: c.color }} />
              <span>{c.subValue}</span>
            </div>
          </div>
        );
      })}
    </div>
  );
}
