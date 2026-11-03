import React from 'react';
import { 
  Building, 
  Phone, 
  User, 
  ArrowLeft, 
  ArrowRight, 
  ShieldAlert, 
  Coins, 
  Calendar,
  Sparkles,
  ChevronLeft,
  ChevronRight
} from 'lucide-react';
import { STATUS, STATUS_META, TYPE_LEAD_META } from '../types/crmConstants';

export default function PipelineKanban({ 
  leads, 
  onSelectLead, 
  onUpdateStatus, 
  onRequestCancellation 
}) {
  const columns = [
    { id: STATUS.FreshLead, meta: STATUS_META[STATUS.FreshLead] },
    { id: STATUS.FollowUp, meta: STATUS_META[STATUS.FollowUp] },
    { id: STATUS.Orientation, meta: STATUS_META[STATUS.Orientation] },
    { id: STATUS.Reservation, meta: STATUS_META[STATUS.Reservation] },
    { id: STATUS.Cancellation, meta: STATUS_META[STATUS.Cancellation] },
  ];

  const formatCurrency = (val) => {
    if (!val) return 'غير محدد';
    if (val >= 1000000) return `${(val / 1000000).toFixed(1)} م ج.م`;
    return `${(val / 1000).toFixed(0)} ألف ج.م`;
  };

  // Status progression flow order
  const flowOrder = [STATUS.FreshLead, STATUS.FollowUp, STATUS.Orientation, STATUS.Reservation];

  const getNextStatus = (curr) => {
    const idx = flowOrder.indexOf(curr);
    if (idx !== -1 && idx < flowOrder.length - 1) return flowOrder[idx + 1];
    return null;
  };

  const getPrevStatus = (curr) => {
    const idx = flowOrder.indexOf(curr);
    if (idx > 0) return flowOrder[idx - 1];
    return null;
  };

  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: 'repeat(5, minmax(280px, 1fr))',
      gap: '16px',
      overflowX: 'auto',
      paddingBottom: '20px',
      alignItems: 'start'
    }}>
      {columns.map((col) => {
        const colLeads = leads.filter((l) => l.status === col.id);
        const colTotalBudget = colLeads.reduce((acc, curr) => acc + (curr.budget || 0), 0);

        return (
          <div
            key={col.id}
            id={`kanban-col-${col.id}`}
            style={{
              background: 'var(--bg-surface)',
              border: '1px solid var(--border-color)',
              borderRadius: 'var(--radius-lg)',
              display: 'flex',
              flexDirection: 'column',
              maxHeight: 'calc(100vh - 230px)',
              minHeight: '480px',
              boxShadow: 'var(--shadow-sm)'
            }}
          >
            {/* Column Header */}
            <div style={{
              padding: '16px 18px',
              borderBottom: '1px solid var(--border-color)',
              borderTop: `4px solid ${col.meta.color}`,
              borderRadius: 'var(--radius-lg) var(--radius-lg) 0 0',
              display: 'flex',
              flexDirection: 'column',
              gap: '6px'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <span style={{ fontWeight: 800, fontSize: '0.92rem', color: 'var(--text-primary)' }}>
                  {col.meta.labelAr}
                </span>
                <span style={{
                  padding: '2px 8px',
                  borderRadius: '999px',
                  fontSize: '0.75rem',
                  fontWeight: 700,
                  backgroundColor: col.meta.bgColor,
                  color: col.meta.color
                }}>
                  {colLeads.length}
                </span>
              </div>
              <div style={{ fontSize: '0.73rem', color: 'var(--text-muted)', display: 'flex', alignItems: 'center', gap: '4px' }}>
                <Coins size={12} />
                <span>إجمالي: {formatCurrency(colTotalBudget)}</span>
              </div>
            </div>

            {/* Column Cards List */}
            <div style={{
              flex: 1,
              overflowY: 'auto',
              padding: '12px',
              display: 'flex',
              flexDirection: 'column',
              gap: '12px'
            }}>
              {colLeads.length === 0 ? (
                <div style={{
                  padding: '40px 10px',
                  textAlign: 'center',
                  color: 'var(--text-muted)',
                  fontSize: '0.8rem',
                  border: '1px dashed var(--border-color)',
                  borderRadius: 'var(--radius-md)'
                }}>
                  لا توجد طلبات في هذه المرحلة
                </div>
              ) : (
                colLeads.map((lead) => {
                  const typeInfo = TYPE_LEAD_META[lead.typeLead] || TYPE_LEAD_META[2];
                  const nextStatus = getNextStatus(lead.status);
                  const prevStatus = getPrevStatus(lead.status);

                  return (
                    <div
                      key={lead.id}
                      id={`lead-card-${lead.id}`}
                      className="glass-card"
                      style={{
                        padding: '14px',
                        cursor: 'pointer',
                        position: 'relative',
                        borderRight: lead.isDuplicated ? '4px solid #ef4444' : '1px solid var(--border-color)',
                        backgroundColor: 'var(--bg-card)'
                      }}
                      onClick={() => onSelectLead(lead)}
                    >
                      {/* Duplicate Alert Pill */}
                      {lead.isDuplicated && (
                        <div style={{
                          marginBottom: '8px',
                          display: 'inline-flex',
                          alignItems: 'center',
                          gap: '4px',
                          padding: '2px 8px',
                          borderRadius: '4px',
                          backgroundColor: 'rgba(239, 68, 68, 0.1)',
                          color: '#dc2626',
                          fontSize: '0.7rem',
                          fontWeight: 700
                        }}>
                          <ShieldAlert size={12} />
                          <span>رقم هاتف مكرر مسجل</span>
                        </div>
                      )}

                      {/* Name & Type */}
                      <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: '8px', marginBottom: '8px' }}>
                        <h4 style={{ fontSize: '0.92rem', fontWeight: 700, color: 'var(--text-primary)', margin: 0, lineHeight: 1.3 }}>
                          {lead.name}
                        </h4>
                        <span className={`badge ${typeInfo.badgeClass}`} style={{ fontSize: '0.68rem', padding: '2px 6px' }}>
                          {typeInfo.labelAr}
                        </span>
                      </div>

                      {/* Phone */}
                      <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: 'var(--text-secondary)', fontSize: '0.78rem', marginBottom: '8px' }}>
                        <Phone size={13} style={{ color: 'var(--primary)' }} />
                        <span dir="ltr">{lead.phoneNumber}</span>
                      </div>

                      {/* Project */}
                      <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: 'var(--text-muted)', fontSize: '0.75rem', marginBottom: '8px' }}>
                        <Building size={13} />
                        <span style={{ whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                          {lead.projectName || 'مشروع عام'}
                        </span>
                      </div>

                      {/* Budget */}
                      <div style={{
                        padding: '6px 10px',
                        borderRadius: '6px',
                        backgroundColor: 'var(--bg-app)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        fontSize: '0.78rem',
                        fontWeight: 700,
                        color: 'var(--text-primary)',
                        marginBottom: '10px'
                      }}>
                        <span style={{ color: 'var(--text-secondary)', fontWeight: 500 }}>الميزانية:</span>
                        <span style={{ color: 'var(--primary)' }}>{formatCurrency(lead.budget)}</span>
                      </div>

                      {/* Sales Rep & Quick Next/Prev */}
                      <div style={{
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        paddingTop: '8px',
                        borderTop: '1px solid var(--border-light)',
                        fontSize: '0.75rem'
                      }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '5px', color: 'var(--text-secondary)' }}>
                          <div style={{
                            width: '20px',
                            height: '20px',
                            borderRadius: '50%',
                            background: 'var(--primary-light)',
                            color: 'var(--primary)',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            fontWeight: 700,
                            fontSize: '0.65rem'
                          }}>
                            {lead.employeeName ? lead.employeeName[0] : '؟'}
                          </div>
                          <span style={{ maxWidth: '85px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                            {lead.employeeName || 'غير مسند'}
                          </span>
                        </div>

                        {/* Quick Progress Buttons (RTL adjusted) */}
                        <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }} onClick={(e) => e.stopPropagation()}>
                          {prevStatus && (
                            <button
                              title="الرجوع للمرحلة السابقة"
                              className="btn-icon"
                              style={{ width: '26px', height: '26px', padding: 0 }}
                              onClick={() => onUpdateStatus(lead.id, prevStatus)}
                            >
                              <ChevronRight size={14} />
                            </button>
                          )}
                          {nextStatus && (
                            <button
                              title="التقدم للمرحلة التالية"
                              className="btn-icon"
                              style={{ width: '26px', height: '26px', padding: 0, color: 'var(--primary)' }}
                              onClick={() => onUpdateStatus(lead.id, nextStatus)}
                            >
                              <ChevronLeft size={14} />
                            </button>
                          )}
                          {lead.status !== STATUS.Cancellation && (
                            <button
                              title="إلغاء الطلب"
                              className="btn-icon"
                              style={{ width: '26px', height: '26px', padding: 0, color: '#ef4444' }}
                              onClick={() => onRequestCancellation(lead)}
                            >
                              ×
                            </button>
                          )}
                        </div>
                      </div>
                    </div>
                  );
                })
              )}
            </div>
          </div>
        );
      })}
    </div>
  );
}
