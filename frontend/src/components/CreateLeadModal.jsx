import React, { useState } from 'react';
import { 
  X, 
  UserPlus, 
  ShieldAlert, 
  Building, 
  Phone, 
  User, 
  Coins, 
  Layers 
} from 'lucide-react';
import { STATUS, TYPE_LEAD } from '../types/crmConstants';

export default function CreateLeadModal({ 
  projects, 
  channels, 
  employees, 
  existingLeads,
  onClose, 
  onCreate 
}) {
  const [formData, setFormData] = useState({
    name: '',
    phoneNumber: '',
    projectId: projects[0]?.id || '',
    channelId: channels[0]?.id || '',
    employeeId: '',
    budget: '',
    status: STATUS.FreshLead,
    typeLead: TYPE_LEAD.Sale,
    initialNote: ''
  });

  const [error, setError] = useState('');

  // Live duplicate detection
  const cleanPhone = (formData.phoneNumber || '').trim().replace(/\s+/g, '');
  const duplicateMatch = cleanPhone.length >= 7 
    ? existingLeads.find(l => (l.phoneNumber || '').trim().replace(/\s+/g, '') === cleanPhone)
    : null;

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!formData.name.trim()) {
      setError('يرجى إدخال اسم العميل');
      return;
    }
    if (!formData.phoneNumber.trim()) {
      setError('يرجى إدخال رقم الهاتف');
      return;
    }
    if (!formData.projectId) {
      setError('يرجى اختيار المشروع');
      return;
    }

    onCreate(formData);
    onClose();
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div 
        className="modal-content" 
        style={{ maxWidth: '580px' }} 
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
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <div style={{
              width: '36px',
              height: '36px',
              borderRadius: '10px',
              background: 'var(--primary-gradient)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: '#fff'
            }}>
              <UserPlus size={18} />
            </div>
            <div>
              <h3 style={{ fontSize: '1.15rem', fontWeight: 800, margin: 0, color: 'var(--text-primary)' }}>
                إضافة عميل جديد (Create Lead)
              </h3>
              <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                تسجيل العميل في مسار المبيعات وتعيين مسؤول
              </span>
            </div>
          </div>
          <button className="btn-icon" onClick={onClose} style={{ borderRadius: '50%' }}>
            <X size={18} />
          </button>
        </div>

        {/* Live Duplicate Warning */}
        {duplicateMatch && (
          <div style={{
            margin: '16px 24px 0',
            padding: '12px 16px',
            backgroundColor: 'rgba(239, 68, 68, 0.1)',
            border: '1px dashed #ef4444',
            borderRadius: 'var(--radius-md)',
            color: '#dc2626',
            fontSize: '0.82rem',
            display: 'flex',
            alignItems: 'flex-start',
            gap: '8px'
          }}>
            <ShieldAlert size={18} style={{ flexShrink: 0, marginTop: '2px' }} />
            <div>
              <strong>تنبيه تكرار:</strong> هذا الرقم مسجل بالفعل للعميل (<strong>{duplicateMatch.name}</strong>) في مشروع ({duplicateMatch.projectName}). سيتم وسم العميل كـ "مكرر" في النظام.
            </div>
          </div>
        )}

        {/* Form Body */}
        <form onSubmit={handleSubmit} style={{ padding: '20px 24px' }}>
          {error && (
            <div style={{
              padding: '10px',
              backgroundColor: 'rgba(239, 68, 68, 0.1)',
              color: '#ef4444',
              borderRadius: 'var(--radius-md)',
              fontSize: '0.85rem',
              marginBottom: '16px',
              fontWeight: 600
            }}>
              {error}
            </div>
          )}

          <div className="grid-cols-2">
            {/* Customer Name */}
            <div className="form-group">
              <label className="form-label">اسم العميل *</label>
              <input
                id="input-create-lead-name"
                type="text"
                required
                className="form-input"
                placeholder="مثال: أحمد عبد الله"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              />
            </div>

            {/* Phone */}
            <div className="form-group">
              <label className="form-label">رقم الهاتف *</label>
              <input
                id="input-create-lead-phone"
                type="tel"
                required
                dir="ltr"
                className="form-input"
                placeholder="01012345678"
                value={formData.phoneNumber}
                onChange={(e) => setFormData({ ...formData, phoneNumber: e.target.value })}
              />
            </div>
          </div>

          <div className="grid-cols-2">
            {/* Project */}
            <div className="form-group">
              <label className="form-label">المشروع العقاري *</label>
              <select
                id="select-create-lead-project"
                className="form-select"
                value={formData.projectId}
                onChange={(e) => setFormData({ ...formData, projectId: e.target.value })}
              >
                {projects.map(p => (
                  <option key={p.id} value={p.id}>{p.name}</option>
                ))}
              </select>
            </div>

            {/* Acquisition Channel */}
            <div className="form-group">
              <label className="form-label">قناة الجلب (Source)</label>
              <select
                id="select-create-lead-channel"
                className="form-select"
                value={formData.channelId}
                onChange={(e) => setFormData({ ...formData, channelId: e.target.value })}
              >
                {channels.map(c => (
                  <option key={c.id} value={c.id}>{c.name}</option>
                ))}
              </select>
            </div>
          </div>

          <div className="grid-cols-2">
            {/* Lead Type */}
            <div className="form-group">
              <label className="form-label">نوع الطلب</label>
              <select
                id="select-create-lead-type"
                className="form-select"
                value={formData.typeLead}
                onChange={(e) => setFormData({ ...formData, typeLead: Number(e.target.value) })}
              >
                <option value={TYPE_LEAD.Sale}>شراء (Sale)</option>
                <option value={TYPE_LEAD.Rent}>إيجار (Rent)</option>
              </select>
            </div>

            {/* Budget */}
            <div className="form-group">
              <label className="form-label">الميزانية المقترحة (ج.م)</label>
              <input
                id="input-create-lead-budget"
                type="number"
                className="form-input"
                placeholder="مثال: 4500000"
                value={formData.budget}
                onChange={(e) => setFormData({ ...formData, budget: e.target.value })}
              />
            </div>
          </div>

          {/* Assigned Sales Rep */}
          <div className="form-group">
            <label className="form-label">إسناد لمسؤول مبيعات (Sales Rep)</label>
            <select
              id="select-create-lead-employee"
              className="form-select"
              value={formData.employeeId}
              onChange={(e) => setFormData({ ...formData, employeeId: e.target.value })}
            >
              <option value="">بدون إسناد حالياً (غير مسند)</option>
              {employees.map(emp => (
                <option key={emp.id} value={emp.id}>{emp.name} ({emp.phone})</option>
              ))}
            </select>
          </div>

          {/* Initial Note */}
          <div className="form-group">
            <label className="form-label">ملاحظة أولية عن العميل (اختياري)</label>
            <textarea
              id="input-create-lead-note"
              rows={2}
              className="form-textarea"
              placeholder="مثال: يبحث عن فيلا تاون هاوس تسليم فوري..."
              value={formData.initialNote}
              onChange={(e) => setFormData({ ...formData, initialNote: e.target.value })}
            />
          </div>

          {/* Actions */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: '12px', marginTop: '20px' }}>
            <button type="button" className="btn btn-secondary" onClick={onClose}>
              إلغاء
            </button>
            <button id="btn-submit-create-lead" type="submit" className="btn btn-primary">
              <UserPlus size={16} />
              <span>إضافة العميل للمسار</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
