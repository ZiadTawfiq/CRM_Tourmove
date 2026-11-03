import React, { useState } from 'react';
import { 
  Search, 
  Filter, 
  Download, 
  Eye, 
  Trash2, 
  Phone, 
  MessageCircle, 
  ShieldAlert, 
  Building,
  CheckCircle,
  Clock,
  ArrowUpDown
} from 'lucide-react';
import { STATUS_META, TYPE_LEAD_META, STATUS, TYPE_LEAD } from '../types/crmConstants';

export default function LeadsTable({ 
  leads, 
  projects, 
  channels, 
  employees, 
  onSelectLead, 
  onDeleteLead,
  filterDuplicatesOnly,
  setFilterDuplicatesOnly
}) {
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [projectFilter, setProjectFilter] = useState('ALL');
  const [typeFilter, setTypeFilter] = useState('ALL');
  const [channelFilter, setChannelFilter] = useState('ALL');
  const [sortField, setSortField] = useState('created');
  const [sortAsc, setSortAsc] = useState(false);

  // Filtering
  const filteredLeads = leads.filter(lead => {
    if (statusFilter !== 'ALL' && lead.status !== Number(statusFilter)) return false;
    if (projectFilter !== 'ALL' && lead.projectId !== Number(projectFilter)) return false;
    if (typeFilter !== 'ALL' && lead.typeLead !== Number(typeFilter)) return false;
    if (channelFilter !== 'ALL' && lead.channelId !== Number(channelFilter)) return false;
    if (filterDuplicatesOnly && !lead.isDuplicated) return false;
    return true;
  });

  // Sorting
  const sortedLeads = [...filteredLeads].sort((a, b) => {
    let aVal = a[sortField];
    let bVal = b[sortField];
    if (sortField === 'budget') {
      aVal = a.budget || 0;
      bVal = b.budget || 0;
    }
    if (aVal < bVal) return sortAsc ? -1 : 1;
    if (aVal > bVal) return sortAsc ? 1 : -1;
    return 0;
  });

  const toggleSort = (field) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  const exportCSV = () => {
    const headers = ['المعرف', 'الاسم', 'رقم الهاتف', 'الحالة', 'النوع', 'المشروع', 'المبيعات', 'الميزانية', 'القناة', 'تاريخ التسجيل'];
    const rows = sortedLeads.map(l => [
      l.id,
      `"${l.name}"`,
      `"${l.phoneNumber}"`,
      STATUS_META[l.status]?.labelAr || l.status,
      TYPE_LEAD_META[l.typeLead]?.labelAr || l.typeLead,
      `"${l.projectName || ''}"`,
      `"${l.employeeName || ''}"`,
      l.budget || 0,
      `"${l.channelName || ''}"`,
      new Date(l.created).toLocaleDateString('ar-EG')
    ]);

    const csvContent = '\uFEFF' + [headers.join(','), ...rows.map(e => e.join(','))].join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.setAttribute('href', url);
    link.setAttribute('download', `Tourmove_CRM_Leads_${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const formatCurrency = (val) => {
    if (!val) return 'غير محدد';
    return `${val.toLocaleString()} ج.م`;
  };

  return (
    <div className="glass-card" style={{ padding: '24px', backgroundColor: 'var(--bg-surface)' }}>
      {/* Filters Bar */}
      <div style={{
        display: 'flex',
        flexWrap: 'wrap',
        gap: '12px',
        alignItems: 'center',
        justifyContent: 'space-between',
        marginBottom: '20px'
      }}>
        {/* Dropdowns */}
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '10px', alignItems: 'center' }}>
          {/* Status filter */}
          <select
            id="filter-status-select"
            className="form-select"
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            style={{ width: 'auto', minWidth: '150px' }}
          >
            <option value="ALL">جميع المراحل (All Statuses)</option>
            {Object.values(STATUS_META).map(s => (
              <option key={s.id} value={s.id}>{s.labelAr}</option>
            ))}
          </select>

          {/* Project filter */}
          <select
            id="filter-project-select"
            className="form-select"
            value={projectFilter}
            onChange={(e) => setProjectFilter(e.target.value)}
            style={{ width: 'auto', minWidth: '160px' }}
          >
            <option value="ALL">جميع المشاريع (All Projects)</option>
            {projects.map(p => (
              <option key={p.id} value={p.id}>{p.name}</option>
            ))}
          </select>

          {/* Type filter */}
          <select
            id="filter-type-select"
            className="form-select"
            value={typeFilter}
            onChange={(e) => setTypeFilter(e.target.value)}
            style={{ width: 'auto', minWidth: '130px' }}
          >
            <option value="ALL">نوع الطلب (All)</option>
            <option value={TYPE_LEAD.Sale}>شراء (Sale)</option>
            <option value={TYPE_LEAD.Rent}>إيجار (Rent)</option>
          </select>

          {/* Channel filter */}
          <select
            id="filter-channel-select"
            className="form-select"
            value={channelFilter}
            onChange={(e) => setChannelFilter(e.target.value)}
            style={{ width: 'auto', minWidth: '140px' }}
          >
            <option value="ALL">قناة الجلب (Channels)</option>
            {channels.map(c => (
              <option key={c.id} value={c.id}>{c.name}</option>
            ))}
          </select>

          {/* Duplicate toggle */}
          <button
            id="btn-filter-duplicates"
            className={`btn btn-sm ${filterDuplicatesOnly ? 'btn-danger' : 'btn-secondary'}`}
            onClick={() => setFilterDuplicatesOnly(!filterDuplicatesOnly)}
            style={{ gap: '6px' }}
          >
            <ShieldAlert size={14} />
            <span>{filterDuplicatesOnly ? 'عرض كل العملاء' : 'المكررين فقط'}</span>
          </button>
        </div>

        {/* Export Action */}
        <button
          id="btn-export-csv"
          className="btn btn-secondary btn-sm"
          onClick={exportCSV}
          title="تصدير بيانات الجدول إلى ملف Excel/CSV"
        >
          <Download size={15} />
          <span>تصدير CSV</span>
        </button>
      </div>

      {/* Table Container */}
      <div style={{ overflowX: 'auto', borderRadius: 'var(--radius-md)', border: '1px solid var(--border-color)' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'right', fontSize: '0.88rem' }}>
          <thead>
            <tr style={{ backgroundColor: 'var(--bg-app)', borderBottom: '1px solid var(--border-color)', color: 'var(--text-secondary)' }}>
              <th style={{ padding: '14px 16px', fontWeight: 700 }}>العميل</th>
              <th style={{ padding: '14px 16px', fontWeight: 700 }}>الهاتف</th>
              <th style={{ padding: '14px 16px', fontWeight: 700 }}>المرحلة</th>
              <th style={{ padding: '14px 16px', fontWeight: 700 }}>النوع</th>
              <th style={{ padding: '14px 16px', fontWeight: 700 }}>المشروع</th>
              <th style={{ padding: '14px 16px', fontWeight: 700 }}>المبيعات</th>
              <th 
                style={{ padding: '14px 16px', fontWeight: 700, cursor: 'pointer' }}
                onClick={() => toggleSort('budget')}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                  <span>الميزانية</span>
                  <ArrowUpDown size={13} />
                </div>
              </th>
              <th style={{ padding: '14px 16px', fontWeight: 700 }}>القناة</th>
              <th 
                style={{ padding: '14px 16px', fontWeight: 700, cursor: 'pointer' }}
                onClick={() => toggleSort('created')}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                  <span>التاريخ</span>
                  <ArrowUpDown size={13} />
                </div>
              </th>
              <th style={{ padding: '14px 16px', fontWeight: 700, textAlign: 'center' }}>إجراءات</th>
            </tr>
          </thead>
          <tbody>
            {sortedLeads.length === 0 ? (
              <tr>
                <td colSpan="10" style={{ padding: '40px', textAlign: 'center', color: 'var(--text-muted)' }}>
                  لا توجد نتائج تطابق معايير البحث والفلترة المحددة
                </td>
              </tr>
            ) : (
              sortedLeads.map((lead) => {
                const statusInfo = STATUS_META[lead.status] || STATUS_META[STATUS.FreshLead];
                const typeInfo = TYPE_LEAD_META[lead.typeLead] || TYPE_LEAD_META[2];

                return (
                  <tr
                    key={lead.id}
                    id={`table-row-${lead.id}`}
                    style={{
                      borderBottom: '1px solid var(--border-color)',
                      transition: 'var(--transition)',
                      backgroundColor: lead.isDuplicated ? 'rgba(239, 68, 68, 0.03)' : 'transparent'
                    }}
                    onMouseEnter={(e) => e.currentTarget.style.backgroundColor = 'var(--bg-surface-hover)'}
                    onMouseLeave={(e) => e.currentTarget.style.backgroundColor = lead.isDuplicated ? 'rgba(239, 68, 68, 0.03)' : 'transparent'}
                  >
                    {/* Name & Duplicate indicator */}
                    <td style={{ padding: '14px 16px' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <span style={{ fontWeight: 700, color: 'var(--text-primary)' }}>{lead.name}</span>
                        {lead.isDuplicated && (
                          <span title="رقم هاتف مكرر" style={{ color: '#ef4444', display: 'flex', alignItems: 'center' }}>
                            <ShieldAlert size={15} />
                          </span>
                        )}
                      </div>
                    </td>

                    {/* Phone */}
                    <td style={{ padding: '14px 16px' }}>
                      <span dir="ltr" style={{ color: 'var(--text-secondary)', fontFamily: 'monospace', fontSize: '0.85rem' }}>
                        {lead.phoneNumber}
                      </span>
                    </td>

                    {/* Status Badge */}
                    <td style={{ padding: '14px 16px' }}>
                      <span className={`badge ${statusInfo.badgeClass}`}>
                        {statusInfo.labelAr}
                      </span>
                    </td>

                    {/* Type Badge */}
                    <td style={{ padding: '14px 16px' }}>
                      <span className={`badge ${typeInfo.badgeClass}`}>
                        {typeInfo.labelAr}
                      </span>
                    </td>

                    {/* Project */}
                    <td style={{ padding: '14px 16px', maxWidth: '170px' }}>
                      <span style={{ display: 'block', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', color: 'var(--text-primary)' }}>
                        {lead.projectName || '—'}
                      </span>
                    </td>

                    {/* Employee */}
                    <td style={{ padding: '14px 16px' }}>
                      <span style={{ color: 'var(--text-secondary)' }}>
                        {lead.employeeName || 'غير مسند'}
                      </span>
                    </td>

                    {/* Budget */}
                    <td style={{ padding: '14px 16px', fontWeight: 700, color: 'var(--primary)' }}>
                      {formatCurrency(lead.budget)}
                    </td>

                    {/* Channel */}
                    <td style={{ padding: '14px 16px', color: 'var(--text-muted)', fontSize: '0.8rem' }}>
                      {lead.channelName || 'مباشر'}
                    </td>

                    {/* Date */}
                    <td style={{ padding: '14px 16px', color: 'var(--text-muted)', fontSize: '0.8rem' }}>
                      {new Date(lead.created).toLocaleDateString('ar-EG')}
                    </td>

                    {/* Actions */}
                    <td style={{ padding: '14px 16px', textAlign: 'center' }}>
                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '6px' }}>
                        {/* WhatsApp */}
                        <a
                          href={`https://wa.me/${lead.phoneNumber.replace(/^0/, '+20')}?text=مرحباً%20${encodeURIComponent(lead.name)}`}
                          target="_blank"
                          rel="noreferrer"
                          className="btn-icon"
                          title="محادثة واتساب"
                          style={{ width: '32px', height: '32px', color: '#10b981' }}
                        >
                          <MessageCircle size={15} />
                        </a>

                        {/* Call */}
                        <a
                          href={`tel:${lead.phoneNumber}`}
                          className="btn-icon"
                          title="اتصال هاتفي"
                          style={{ width: '32px', height: '32px', color: '#3b82f6' }}
                        >
                          <Phone size={15} />
                        </a>

                        {/* View / Edit */}
                        <button
                          className="btn-icon"
                          title="عرض التفاصيل وسجل الملاحظات"
                          style={{ width: '32px', height: '32px', color: 'var(--primary)' }}
                          onClick={() => onSelectLead(lead)}
                        >
                          <Eye size={15} />
                        </button>

                        {/* Delete */}
                        <button
                          className="btn-icon"
                          title="حذف العميل"
                          style={{ width: '32px', height: '32px', color: '#ef4444' }}
                          onClick={() => {
                            if (window.confirm(`هل أنت متأكد من حذف العميل "${lead.name}"؟`)) {
                              onDeleteLead(lead.id);
                            }
                          }}
                        >
                          <Trash2 size={15} />
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>

      {/* Footer Info */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginTop: '16px', fontSize: '0.8rem', color: 'var(--text-muted)' }}>
        <span>إجمالي النتائج المعروضة: <strong>{sortedLeads.length}</strong> عميل</span>
        <span>البيانات محدثة ومحفوظة تلقائياً</span>
      </div>
    </div>
  );
}
