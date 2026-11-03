import React, { useState } from 'react';
import { 
  X, 
  Phone, 
  MessageCircle, 
  User, 
  Building, 
  Coins, 
  Calendar, 
  ShieldAlert, 
  Send, 
  Clock, 
  CheckCircle,
  FileText,
  AlertTriangle
} from 'lucide-react';
import { 
  STATUS, 
  STATUS_META, 
  TYPE_LEAD, 
  TYPE_LEAD_META, 
  CANCELLATION_REASONS 
} from '../types/crmConstants';

export default function LeadDetailsModal({ 
  lead, 
  projects, 
  channels, 
  employees, 
  onClose, 
  onUpdateStatus, 
  onAssignEmployee, 
  onAddComment, 
  onUpdateLead 
}) {
  const [commentText, setCommentText] = useState('');
  const [selectedStatus, setSelectedStatus] = useState(lead.status);
  const [selectedReasonId, setSelectedReasonId] = useState(lead.cancellationReasonId || 1);
  const [customReason, setCustomReason] = useState(lead.cancellationReason || '');
  const [showCancelPrompt, setShowCancelPrompt] = useState(false);
  const [selectedEmployee, setSelectedEmployee] = useState(lead.employeeId || '');
  const [selectedProject, setSelectedProject] = useState(lead.projectId || '');
  const [leadBudget, setLeadBudget] = useState(lead.budget || '');

  const handleStatusChange = (newStatusVal) => {
    const val = Number(newStatusVal);
    if (val === STATUS.Cancellation) {
      setSelectedStatus(val);
      setShowCancelPrompt(true);
    } else {
      setSelectedStatus(val);
      setShowCancelPrompt(false);
      onUpdateStatus(lead.id, val);
    }
  };

  const handleConfirmCancellation = () => {
    const reasonObj = CANCELLATION_REASONS.find(r => r.id === Number(selectedReasonId));
    const reasonText = reasonObj ? reasonObj.reason : customReason;
    onUpdateStatus(lead.id, STATUS.Cancellation, selectedReasonId, reasonText);
    setShowCancelPrompt(false);
  };

  const handleAssignChange = (empId) => {
    setSelectedEmployee(empId);
    onAssignEmployee(lead.id, empId);
  };

  const handleSaveAttributes = () => {
    onUpdateLead(lead.id, {
      projectId: selectedProject,
      budget: Number(leadBudget) || null,
    });
    alert('تم حفظ تعديلات العميل بنجاح');
  };

  const handleCommentSubmit = (e) => {
    e.preventDefault();
    if (!commentText.trim()) return;
    onAddComment(lead.id, commentText.trim(), 'خالد توفيق (المستخدم)');
    setCommentText('');
  };

  const statusInfo = STATUS_META[lead.status] || STATUS_META[STATUS.FreshLead];
  const typeInfo = TYPE_LEAD_META[lead.typeLead] || TYPE_LEAD_META[2];

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div 
        className="modal-content" 
        style={{ maxWidth: '840px', padding: 0 }} 
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div style={{
          padding: '20px 24px',
          borderBottom: '1px solid var(--border-color)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          background: 'var(--bg-app)',
          borderRadius: 'var(--radius-xl) var(--radius-xl) 0 0'
        }}>
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
              <h3 style={{ fontSize: '1.25rem', fontWeight: 800, margin: 0, color: 'var(--text-primary)' }}>
                {lead.name}
              </h3>
              <span className={`badge ${statusInfo.badgeClass}`}>
                {statusInfo.labelAr}
              </span>
              <span className={`badge ${typeInfo.badgeClass}`}>
                {typeInfo.labelAr}
              </span>
            </div>
            <div style={{ fontSize: '0.8rem', color: 'var(--text-muted)', marginTop: '4px' }}>
              معرف العميل #{lead.id} • أضيف بتاريخ {new Date(lead.created).toLocaleString('ar-EG')}
            </div>
          </div>

          <button className="btn-icon" onClick={onClose} style={{ borderRadius: '50%' }}>
            <X size={20} />
          </button>
        </div>

        {/* Duplicate Banner */}
        {lead.isDuplicated && (
          <div style={{
            padding: '12px 24px',
            backgroundColor: 'rgba(239, 68, 68, 0.1)',
            borderBottom: '1px solid rgba(239, 68, 68, 0.2)',
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            color: '#dc2626',
            fontSize: '0.85rem',
            fontWeight: 700
          }}>
            <ShieldAlert size={18} />
            <span>تنبيه: تم رصد رقم هاتف مكرر في النظام لهذا العميل!</span>
          </div>
        )}

        {/* Body Grid */}
        <div style={{ padding: '24px', display: 'grid', gridTemplateColumns: '1.2fr 1fr', gap: '24px' }}>
          {/* Right Column: Lead Properties */}
          <div>
            <h4 style={{ fontSize: '0.95rem', fontWeight: 700, marginBottom: '16px', color: 'var(--text-primary)', display: 'flex', alignItems: 'center', gap: '8px' }}>
              <FileText size={18} style={{ color: 'var(--primary)' }} />
              بيانات ومسار العميل
            </h4>

            {/* Quick Contact Bar */}
            <div style={{
              display: 'flex',
              gap: '10px',
              padding: '12px',
              borderRadius: 'var(--radius-md)',
              backgroundColor: 'var(--bg-app)',
              marginBottom: '20px'
            }}>
              <a
                href={`tel:${lead.phoneNumber}`}
                className="btn btn-primary btn-sm"
                style={{ flex: 1 }}
              >
                <Phone size={14} />
                <span>اتصال ({lead.phoneNumber})</span>
              </a>
              <a
                href={`https://wa.me/${lead.phoneNumber.replace(/^0/, '+20')}?text=مرحباً%20${encodeURIComponent(lead.name)}`}
                target="_blank"
                rel="noreferrer"
                className="btn btn-secondary btn-sm"
                style={{ flex: 1, color: '#10b981', borderColor: 'rgba(16, 185, 129, 0.3)' }}
              >
                <MessageCircle size={14} />
                <span>واتساب</span>
              </a>
            </div>

            {/* Change Status */}
            <div className="form-group">
              <label className="form-label">مرحلة العميل (Status Pipeline):</label>
              <select
                id="modal-select-status"
                className="form-select"
                value={selectedStatus}
                onChange={(e) => handleStatusChange(e.target.value)}
              >
                {Object.values(STATUS_META).map(s => (
                  <option key={s.id} value={s.id}>{s.labelAr}</option>
                ))}
              </select>
            </div>

            {/* Cancellation Reason Dialog Box */}
            {showCancelPrompt && (
              <div style={{
                padding: '14px',
                borderRadius: 'var(--radius-md)',
                backgroundColor: 'rgba(239, 68, 68, 0.08)',
                border: '1px solid rgba(239, 68, 68, 0.25)',
                marginBottom: '16px'
              }}>
                <div style={{ fontSize: '0.85rem', fontWeight: 700, color: '#dc2626', marginBottom: '8px', display: 'flex', alignItems: 'center', gap: '6px' }}>
                  <AlertTriangle size={15} />
                  <span>تحديد سبب الإلغاء (إلزامي):</span>
                </div>
                <select
                  className="form-select"
                  value={selectedReasonId}
                  onChange={(e) => setSelectedReasonId(e.target.value)}
                  style={{ marginBottom: '10px' }}
                >
                  {CANCELLATION_REASONS.map(r => (
                    <option key={r.id} value={r.id}>{r.reason}</option>
                  ))}
                </select>
                <button
                  className="btn btn-sm btn-danger"
                  style={{ width: '100%' }}
                  onClick={handleConfirmCancellation}
                >
                  تأكيد الإلغاء
                </button>
              </div>
            )}

            {lead.status === STATUS.Cancellation && lead.cancellationReason && (
              <div style={{
                padding: '10px',
                borderRadius: 'var(--radius-md)',
                backgroundColor: 'rgba(239, 68, 68, 0.08)',
                fontSize: '0.82rem',
                color: '#dc2626',
                marginBottom: '16px'
              }}>
                <strong>سبب الإلغاء المسجل:</strong> {lead.cancellationReason}
              </div>
            )}

            {/* Assign Sales Rep */}
            <div className="form-group">
              <label className="form-label">مسؤول المبيعات (Sales Rep):</label>
              <select
                id="modal-select-employee"
                className="form-select"
                value={selectedEmployee}
                onChange={(e) => handleAssignChange(e.target.value)}
              >
                <option value="">غير مسند</option>
                {employees.map(emp => (
                  <option key={emp.id} value={emp.id}>{emp.name} ({emp.email})</option>
                ))}
              </select>
            </div>

            {/* Project Selection */}
            <div className="form-group">
              <label className="form-label">المشروع العقاري:</label>
              <select
                id="modal-select-project"
                className="form-select"
                value={selectedProject}
                onChange={(e) => setSelectedProject(e.target.value)}
              >
                {projects.map(p => (
                  <option key={p.id} value={p.id}>{p.name}</option>
                ))}
              </select>
            </div>

            {/* Budget */}
            <div className="form-group">
              <label className="form-label">الميزانية المقدرة (ج.م):</label>
              <input
                id="modal-input-budget"
                type="number"
                className="form-input"
                value={leadBudget}
                onChange={(e) => setLeadBudget(e.target.value)}
                placeholder="مثال: 5000000"
              />
            </div>

            <button
              className="btn btn-secondary btn-sm"
              style={{ width: '100%', marginTop: '6px' }}
              onClick={handleSaveAttributes}
            >
              حفظ التعديلات الأساسية
            </button>
          </div>

          {/* Left Column: Timeline & Comments */}
          <div style={{ borderRight: '1px solid var(--border-color)', paddingRight: '20px', display: 'flex', flexDirection: 'column' }}>
            <h4 style={{ fontSize: '0.95rem', fontWeight: 700, marginBottom: '16px', color: 'var(--text-primary)', display: 'flex', alignItems: 'center', gap: '8px' }}>
              <Clock size={18} style={{ color: 'var(--primary)' }} />
              سجل المتابعات والملاحظات
            </h4>

            {/* Add Comment Box */}
            <form onSubmit={handleCommentSubmit} style={{ marginBottom: '16px' }}>
              <div style={{ position: 'relative' }}>
                <textarea
                  id="comment-input-area"
                  rows={3}
                  className="form-textarea"
                  placeholder="أضف ملخص مكالمة، موعد معاينة، أو تفاصيل عرض..."
                  value={commentText}
                  onChange={(e) => setCommentText(e.target.value)}
                  style={{ resize: 'none', paddingBottom: '36px' }}
                />
                <button
                  type="submit"
                  disabled={!commentText.trim()}
                  className="btn btn-primary btn-sm"
                  style={{
                    position: 'absolute',
                    bottom: '8px',
                    left: '8px',
                    padding: '4px 10px',
                    opacity: commentText.trim() ? 1 : 0.6
                  }}
                >
                  <Send size={13} />
                  <span>إرسال</span>
                </button>
              </div>
            </form>

            {/* Timeline Comments List */}
            <div style={{ flex: 1, overflowY: 'auto', maxHeight: '350px', display: 'flex', flexDirection: 'column', gap: '12px' }}>
              {(!lead.comments || lead.comments.length === 0) ? (
                <div style={{ padding: '30px 10px', textAlign: 'center', color: 'var(--text-muted)', fontSize: '0.8rem' }}>
                  لا توجد ملاحظات مسجلة بعد لهذا العميل
                </div>
              ) : (
                lead.comments.map((c) => (
                  <div
                    key={c.id}
                    style={{
                      padding: '12px',
                      borderRadius: 'var(--radius-md)',
                      backgroundColor: 'var(--bg-app)',
                      border: '1px solid var(--border-color)',
                      fontSize: '0.82rem'
                    }}
                  >
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '6px' }}>
                      <span style={{ fontWeight: 700, color: 'var(--primary)' }}>{c.author || 'المسؤول'}</span>
                      <span style={{ fontSize: '0.7rem', color: 'var(--text-muted)' }}>
                        {new Date(c.createdAt).toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })} • {new Date(c.createdAt).toLocaleDateString('ar-EG')}
                      </span>
                    </div>
                    <div style={{ color: 'var(--text-primary)', lineHeight: 1.4, whiteSpace: 'pre-wrap' }}>
                      {c.comment}
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
