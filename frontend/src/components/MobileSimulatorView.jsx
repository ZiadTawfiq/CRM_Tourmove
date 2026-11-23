import React, { useState } from 'react';
import { 
  Smartphone, 
  Kanban, 
  Users, 
  ShieldAlert, 
  Building2, 
  BarChart3, 
  Phone, 
  MessageCircle, 
  Plus, 
  Search, 
  ArrowRight, 
  CheckCircle2, 
  RotateCcw,
  Sparkles,
  Settings,
  ChevronLeft
} from 'lucide-react';
import { STATUS, TYPE_LEAD, CANCELLATION_REASONS } from '../types/crmConstants';

export default function MobileSimulatorView({
  leads,
  projects,
  channels,
  employees,
  onCreateLead,
  onUpdateStatus,
  onAssignEmployee,
  onAddComment,
  duplicateCount,
}) {
  const [activeTab, setActiveTab] = useState('pipeline'); // 'pipeline', 'leads', 'duplicates', 'projects', 'analytics'
  const [selectedStage, setSelectedStage] = useState(STATUS.FreshLead);
  const [selectedLead, setSelectedLead] = useState(null);
  const [isAddLeadOpen, setIsAddLeadOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [commentInput, setCommentInput] = useState('');

  // Add lead form state
  const [formName, setFormName] = useState('');
  const [formPhone, setFormPhone] = useState('');
  const [formProject, setFormProject] = useState(projects[0]?.id || 1);
  const [formChannel, setFormChannel] = useState(channels[0]?.id || 1);
  const [formBudget, setFormBudget] = useState('');
  const [formEmployee, setFormEmployee] = useState(employees[0]?.id || '');
  const [formNote, setFormNote] = useState('');

  // Check duplicate phone in form
  const duplicateMatch = formPhone.trim().length >= 8
    ? leads.find(l => l.phoneNumber.replace(/\s+/g, '') === formPhone.trim().replace(/\s+/g, ''))
    : null;

  const handleFormSubmit = (e) => {
    e.preventDefault();
    if (!formName.trim() || !formPhone.trim()) return;

    const proj = projects.find(p => p.id === Number(formProject));
    const chan = channels.find(c => c.id === Number(formChannel));
    const emp = employees.find(e => e.id === formEmployee);

    onCreateLead({
      name: formName.trim(),
      phoneNumber: formPhone.trim(),
      projectId: Number(formProject),
      projectName: proj?.name || '',
      channelId: Number(formChannel),
      channelName: chan?.name || '',
      employeeId: emp?.id || null,
      employeeName: emp?.name || 'غير مسند',
      budget: Number(formBudget) || 0,
      typeLead: TYPE_LEAD.Sale,
      note: formNote.trim() || undefined,
    });

    setFormName('');
    setFormPhone('');
    setFormBudget('');
    setFormNote('');
    setIsAddLeadOpen(false);
  };

  const stagesList = [
    { id: STATUS.FreshLead, name: 'عميل جديد', color: '#3B82F6' },
    { id: STATUS.FollowUp, name: 'متابعة', color: '#F59E0B' },
    { id: STATUS.Orientation, name: 'معاينة', color: '#8B5CF6' },
    { id: STATUS.Reservation, name: 'حجز مؤكد', color: '#10B981' },
    { id: STATUS.Cancellation, name: 'ملغي', color: '#EF4444' },
  ];

  const formatEGP = (val) => {
    if (!val) return '0 ج.م';
    if (val >= 1000000) return `${(val / 1000000).toFixed(1)} م ج.م`;
    return `${(val / 1000).toFixed(0)} ألف ج.م`;
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '24px', minHeight: '85vh' }}>
      {/* Simulation Header */}
      <div style={{ textAlign: 'center', marginBottom: '20px' }}>
        <div style={{ display: 'inline-flex', alignItems: 'center', gap: '8px', padding: '6px 14px', background: 'rgba(79, 70, 229, 0.1)', color: '#4F46E5', borderRadius: '20px', fontWeight: 'bold', fontSize: '13px', marginBottom: '8px' }}>
          <Smartphone size={16} />
          <span>نسخة العرض التفاعلية لتطبيق الجوال (Flutter Mobile App Interactive Demo)</span>
        </div>
        <p style={{ color: 'var(--text-muted)', fontSize: '14px', margin: 0 }}>
          يمكنك تجربة واجهات وسيرفسز تطبيق فلاتر (Pipeline, Duplicate Strategy, WhatsApp, Lead Management) مباشرة هنا!
        </p>
      </div>

      {/* Phone Mockup Frame */}
      <div style={{
        width: '390px',
        height: '780px',
        background: '#0F172A',
        borderRadius: '48px',
        padding: '12px',
        boxShadow: '0 25px 60px -15px rgba(0, 0, 0, 0.45), 0 0 0 1px rgba(255, 255, 255, 0.15)',
        position: 'relative',
        display: 'flex',
        flexDirection: 'column'
      }}>
        {/* Dynamic Island / Speaker Notch */}
        <div style={{
          width: '120px',
          height: '24px',
          background: '#000',
          borderRadius: '20px',
          margin: '0 auto 8px auto',
          position: 'relative',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 30
        }}>
          <div style={{ width: '10px', height: '10px', borderRadius: '50%', background: '#1e293b', marginRight: '6px' }} />
          <div style={{ width: '40px', height: '4px', borderRadius: '2px', background: '#334155' }} />
        </div>

        {/* Screen Area */}
        <div style={{
          flex: 1,
          background: '#f8fafc',
          borderRadius: '38px',
          overflow: 'hidden',
          display: 'flex',
          flexDirection: 'column',
          position: 'relative',
          color: '#1e293b',
          fontFamily: 'Cairo, sans-serif'
        }}>
          {/* Top Status & App Bar */}
          <div style={{ background: '#ffffff', padding: '12px 16px 8px 16px', borderBottom: '1px solid #e2e8f0' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <div style={{ width: '32px', height: '32px', borderRadius: '50%', background: '#4F46E5', color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 'bold', fontSize: '13px' }}>
                  خ
                </div>
                <div>
                  <div style={{ fontSize: '13px', fontWeight: 'bold' }}>خالد توفيق (مدير)</div>
                  <div style={{ fontSize: '10px', color: '#64748b' }}>Tourmove CRM Mobile</div>
                </div>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span style={{ fontSize: '10px', background: '#FEF3C7', color: '#B45309', padding: '2px 8px', borderRadius: '12px', fontWeight: 'bold' }}>
                  ⚡ Demo Mode
                </span>
              </div>
            </div>
          </div>

          {/* Screen Content Body */}
          <div style={{ flex: 1, overflowY: 'auto', padding: '12px' }}>
            {/* 1. PIPELINE TAB */}
            {activeTab === 'pipeline' && (
              <div>
                {/* Horizontal Stages Pills */}
                <div style={{ display: 'flex', gap: '6px', overflowX: 'auto', paddingBottom: '8px', marginBottom: '8px' }}>
                  {stagesList.map(st => {
                    const count = leads.filter(l => l.status === st.id).length;
                    const isSelected = selectedStage === st.id;
                    return (
                      <button
                        key={st.id}
                        onClick={() => setSelectedStage(st.id)}
                        style={{
                          padding: '6px 12px',
                          borderRadius: '16px',
                          border: isSelected ? `2px solid ${st.color}` : '1px solid #cbd5e1',
                          background: isSelected ? `${st.color}15` : '#fff',
                          color: isSelected ? st.color : '#475569',
                          fontWeight: 'bold',
                          fontSize: '11px',
                          whiteSpace: 'nowrap',
                          cursor: 'pointer',
                          display: 'flex',
                          alignItems: 'center',
                          gap: '6px'
                        }}
                      >
                        <span>{st.name}</span>
                        <span style={{ background: st.color, color: '#fff', borderRadius: '10px', padding: '1px 6px', fontSize: '10px' }}>
                          {count}
                        </span>
                      </button>
                    );
                  })}
                </div>

                {/* Stage Summary */}
                {(() => {
                  const stageLeads = leads.filter(l => l.status === selectedStage);
                  const sumBudget = stageLeads.reduce((acc, l) => acc + (l.budget || 0), 0);
                  return (
                    <div style={{ background: '#f1f5f9', padding: '8px 12px', borderRadius: '10px', display: 'flex', justifyContent: 'space-between', fontSize: '11px', fontWeight: 'bold', marginBottom: '10px' }}>
                      <span>عدد الطلبات: {stageLeads.length}</span>
                      <span style={{ color: '#4F46E5' }}>الإجمالي: {formatEGP(sumBudget)}</span>
                    </div>
                  );
                })()}

                {/* Leads in Current Stage */}
                {leads.filter(l => l.status === selectedStage).length === 0 ? (
                  <div style={{ textAlign: 'center', padding: '40px 10px', color: '#94a3b8' }}>
                    <p style={{ fontSize: '13px' }}>لا توجد طلبات في هذه المرحلة</p>
                  </div>
                ) : (
                  leads.filter(l => l.status === selectedStage).map(lead => (
                    <div
                      key={lead.id}
                      onClick={() => setSelectedLead(lead)}
                      style={{
                        background: '#fff',
                        borderRadius: '12px',
                        padding: '12px',
                        marginBottom: '8px',
                        boxShadow: '0 2px 5px rgba(0,0,0,0.04)',
                        border: lead.isDuplicated ? '1.5px solid #ef4444' : '1px solid #e2e8f0',
                        cursor: 'pointer'
                      }}
                    >
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
                        <span style={{ fontWeight: 'bold', fontSize: '13px' }}>{lead.name}</span>
                        {lead.isDuplicated && (
                          <span style={{ background: '#FEE2E2', color: '#DC2626', fontSize: '10px', padding: '2px 6px', borderRadius: '4px', fontWeight: 'bold' }}>
                            ⚠️ مكرر
                          </span>
                        )}
                      </div>
                      <div style={{ fontSize: '11px', color: '#64748b', marginBottom: '4px' }}>
                        📞 {lead.phoneNumber}
                      </div>
                      <div style={{ fontSize: '11px', color: '#475569', marginBottom: '6px' }}>
                        🏢 {lead.projectName || 'بدون مشروع'}
                      </div>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderTop: '1px solid #f1f5f9', paddingTop: '6px', fontSize: '11px' }}>
                        <span style={{ color: '#10B981', fontWeight: 'bold' }}>{formatEGP(lead.budget)}</span>
                        <span style={{ color: '#64748b' }}>👤 {lead.employeeName?.split(' ')[0] || 'غير مسند'}</span>
                      </div>
                    </div>
                  ))
                )}
              </div>
            )}

            {/* 2. LEADS DIRECTORY TAB */}
            {activeTab === 'leads' && (
              <div>
                <div style={{ display: 'flex', alignItems: 'center', background: '#fff', padding: '8px 12px', borderRadius: '10px', border: '1px solid #cbd5e1', marginBottom: '10px' }}>
                  <Search size={16} color="#94a3b8" />
                  <input
                    type="text"
                    placeholder="بحث برقم الهاتف أو اسم العميل..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    style={{ border: 'none', outline: 'none', marginLeft: '8px', fontSize: '12px', width: '100%', fontFamily: 'inherit' }}
                  />
                </div>

                {leads
                  .filter(l => !searchQuery.trim() || l.name.includes(searchQuery) || l.phoneNumber.includes(searchQuery))
                  .map(lead => (
                    <div
                      key={lead.id}
                      onClick={() => setSelectedLead(lead)}
                      style={{
                        background: '#fff',
                        borderRadius: '12px',
                        padding: '12px',
                        marginBottom: '8px',
                        border: '1px solid #e2e8f0',
                        cursor: 'pointer'
                      }}
                    >
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <span style={{ fontWeight: 'bold', fontSize: '13px' }}>{lead.name}</span>
                        <span style={{ fontSize: '10px', padding: '2px 8px', borderRadius: '10px', background: '#e0e7ff', color: '#4338ca', fontWeight: 'bold' }}>
                          {stagesList.find(s => s.id === lead.status)?.name || 'جديد'}
                        </span>
                      </div>
                      <div style={{ fontSize: '11px', color: '#64748b', marginTop: '4px' }}>
                        {lead.phoneNumber} • {lead.projectName}
                      </div>
                    </div>
                  ))}
              </div>
            )}

            {/* 3. DUPLICATES STRATEGY TAB */}
            {activeTab === 'duplicates' && (
              <div>
                <div style={{ background: '#EFF6FF', padding: '10px', borderRadius: '10px', border: '1px solid #BFDBFE', marginBottom: '12px' }}>
                  <div style={{ fontWeight: 'bold', fontSize: '12px', color: '#1E40AF' }}>🛡️ نظام حماية التكرار (Duplicate Strategy)</div>
                  <div style={{ fontSize: '11px', color: '#3B82F6' }}>
                    تطبيق استراتيجية Strategy Pattern: Reassign vs Create New Lead
                  </div>
                </div>

                {leads.filter(l => l.isDuplicated).length === 0 ? (
                  <div style={{ textAlign: 'center', padding: '40px 10px', color: '#10B981' }}>
                    <CheckCircle2 size={36} style={{ margin: '0 auto 8px auto' }} />
                    <p style={{ fontSize: '13px', fontWeight: 'bold' }}>لا توجد أرقام مكررة مسجلة حالياً</p>
                  </div>
                ) : (
                  leads.filter(l => l.isDuplicated).map(lead => (
                    <div key={lead.id} style={{ background: '#fff', borderRadius: '12px', padding: '12px', border: '1.5px solid #F87171', marginBottom: '10px' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <span style={{ fontWeight: 'bold', fontSize: '13px', color: '#B91C1C' }}>⚠️ تنبيه تكرار رقم هاتف</span>
                        <span style={{ fontSize: '10px', color: '#991B1B' }}>ID: {lead.id}</span>
                      </div>
                      <div style={{ fontSize: '12px', fontWeight: 'bold', marginTop: '6px' }}>{lead.name}</div>
                      <div style={{ fontSize: '11px', color: '#64748b' }}>الهاتف: {lead.phoneNumber}</div>
                      <div style={{ fontSize: '11px', color: '#64748b' }}>المسؤول الحالي: {lead.employeeName}</div>

                      <div style={{ display: 'flex', gap: '6px', marginTop: '10px' }}>
                        <button
                          onClick={() => {
                            onAssignEmployee(lead.id, 'emp-102');
                            alert('تم تنفيذ ReassignLeadHandler وإسناد العميل إلى سارة عبد الرحمن!');
                          }}
                          style={{
                            flex: 1,
                            padding: '6px',
                            background: '#3B82F6',
                            color: '#fff',
                            border: 'none',
                            borderRadius: '8px',
                            fontSize: '10px',
                            fontWeight: 'bold',
                            cursor: 'pointer'
                          }}
                        >
                          🔄 إعادة إسناد (Reassign)
                        </button>
                        <button
                          onClick={() => {
                            onCreateLead({
                              ...lead,
                              name: `${lead.name} (طلب منفصل)`,
                              isDuplicated: false,
                            });
                            alert('تم تنفيذ CreateNewleadHandelr وإنشاء عميل مستقل!');
                          }}
                          style={{
                            flex: 1,
                            padding: '6px',
                            background: '#10B981',
                            color: '#fff',
                            border: 'none',
                            borderRadius: '8px',
                            fontSize: '10px',
                            fontWeight: 'bold',
                            cursor: 'pointer'
                          }}
                        >
                          ➕ إنشاء جديد (Create)
                        </button>
                      </div>
                    </div>
                  ))
                )}
              </div>
            )}

            {/* 4. PROJECTS TAB */}
            {activeTab === 'projects' && (
              <div>
                <div style={{ fontWeight: 'bold', fontSize: '13px', marginBottom: '10px' }}>المشاريع والكمبوندات العقارية</div>
                {projects.map(proj => {
                  const pCount = leads.filter(l => l.projectId === proj.id).length;
                  return (
                    <div key={proj.id} style={{ background: '#fff', borderRadius: '12px', padding: '12px', border: '1px solid #e2e8f0', marginBottom: '8px' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <span style={{ fontWeight: 'bold', fontSize: '13px' }}>{proj.name}</span>
                        <span style={{ fontSize: '10px', background: '#DBEAFE', color: '#1E40AF', padding: '2px 6px', borderRadius: '4px', fontWeight: 'bold' }}>
                          {pCount} عميل
                        </span>
                      </div>
                      <div style={{ fontSize: '11px', color: '#64748b', marginTop: '4px' }}>📍 {proj.location}</div>
                      <div style={{ fontSize: '11px', color: '#10B981', fontWeight: 'bold', marginTop: '4px' }}>
                        يبدأ من: {formatEGP(proj.startingPrice)}
                      </div>
                    </div>
                  );
                })}
              </div>
            )}

            {/* 5. ANALYTICS TAB */}
            {activeTab === 'analytics' && (
              <div>
                <div style={{ background: 'linear-gradient(135deg, #4F46E5, #7C3AED)', color: '#fff', padding: '14px', borderRadius: '14px', marginBottom: '12px' }}>
                  <div style={{ fontSize: '11px', opacity: 0.8 }}>إجمالي ميزانية المسار</div>
                  <div style={{ fontSize: '20px', fontWeight: 'bold', margin: '4px 0 8px 0' }}>
                    {formatEGP(leads.reduce((a, b) => a + (b.budget || 0), 0))}
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '11px', borderTop: '1px solid rgba(255,255,255,0.2)', paddingTop: '8px' }}>
                    <span>إجمالي العملاء: {leads.length}</span>
                    <span>الحجوزات: {leads.filter(l => l.status === STATUS.Reservation).length}</span>
                  </div>
                </div>

                <div style={{ fontWeight: 'bold', fontSize: '13px', marginBottom: '8px' }}>توزيع مراحل المسار</div>
                {stagesList.map(st => {
                  const cnt = leads.filter(l => l.status === st.id).length;
                  const pct = leads.length > 0 ? ((cnt / leads.length) * 100).toFixed(0) : 0;
                  return (
                    <div key={st.id} style={{ background: '#fff', padding: '8px 12px', borderRadius: '10px', marginBottom: '6px', border: '1px solid #f1f5f9' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '11px', marginBottom: '4px' }}>
                        <span>{st.name} ({cnt})</span>
                        <span style={{ fontWeight: 'bold', color: st.color }}>{pct}%</span>
                      </div>
                      <div style={{ height: '6px', background: '#e2e8f0', borderRadius: '3px', overflow: 'hidden' }}>
                        <div style={{ height: '100%', width: `${pct}%`, background: st.color }} />
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>

          {/* Floating Action Button (New Lead) */}
          <button
            onClick={() => setIsAddLeadOpen(true)}
            style={{
              position: 'absolute',
              bottom: '64px',
              left: '16px',
              width: '44px',
              height: '44px',
              borderRadius: '50%',
              background: '#4F46E5',
              color: '#fff',
              border: 'none',
              boxShadow: '0 4px 12px rgba(79, 70, 229, 0.4)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              cursor: 'pointer',
              zIndex: 20
            }}
          >
            <Plus size={22} />
          </button>

          {/* Bottom Mobile Navigation Bar */}
          <div style={{
            background: '#ffffff',
            borderTop: '1px solid #e2e8f0',
            display: 'flex',
            justifyContent: 'space-around',
            padding: '8px 4px 12px 4px',
            zIndex: 10
          }}>
            {[
              { id: 'pipeline', label: 'المسار', icon: Kanban },
              { id: 'leads', label: 'العملاء', icon: Users },
              { id: 'duplicates', label: 'التكرار', icon: ShieldAlert, badge: duplicateCount },
              { id: 'projects', label: 'المشاريع', icon: Building2 },
              { id: 'analytics', label: 'التحليلات', icon: BarChart3 },
            ].map(tab => {
              const Icon = tab.icon;
              const isActive = activeTab === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  style={{
                    background: 'none',
                    border: 'none',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    gap: '2px',
                    color: isActive ? '#4F46E5' : '#94a3b8',
                    cursor: 'pointer',
                    position: 'relative',
                    fontFamily: 'inherit',
                    padding: '2px 8px'
                  }}
                >
                  <Icon size={18} />
                  <span style={{ fontSize: '10px', fontWeight: isActive ? 'bold' : 'normal' }}>{tab.label}</span>
                  {tab.badge > 0 && (
                    <span style={{
                      position: 'absolute',
                      top: '-2px',
                      right: '6px',
                      background: '#ef4444',
                      color: '#fff',
                      fontSize: '9px',
                      padding: '1px 5px',
                      borderRadius: '10px',
                      fontWeight: 'bold'
                    }}>
                      {tab.badge}
                    </span>
                  )}
                </button>
              );
            })}
          </div>

          {/* MODAL 1: ADD NEW LEAD (Inside Phone) */}
          {isAddLeadOpen && (
            <div style={{
              position: 'absolute',
              inset: 0,
              background: '#fff',
              zIndex: 50,
              display: 'flex',
              flexDirection: 'column',
              padding: '16px'
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '14px', borderBottom: '1px solid #e2e8f0', paddingBottom: '8px' }}>
                <span style={{ fontWeight: 'bold', fontSize: '14px' }}>إضافة عميل جديد (Create Lead)</span>
                <button onClick={() => setIsAddLeadOpen(false)} style={{ border: 'none', background: 'none', fontSize: '13px', color: '#64748b', cursor: 'pointer' }}>
                  إلغاء
                </button>
              </div>

              <form onSubmit={handleFormSubmit} style={{ flex: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '10px' }}>
                {duplicateMatch && (
                  <div style={{ background: '#FEE2E2', border: '1px solid #F87171', padding: '8px', borderRadius: '8px', fontSize: '11px', color: '#B91C1C', fontWeight: 'bold' }}>
                    ⚠️ تنبيه تكرار: هذا الرقم مسجل بالفعل للعميل ({duplicateMatch.name})!
                  </div>
                )}

                <div>
                  <label style={{ fontSize: '11px', fontWeight: 'bold', display: 'block', marginBottom: '4px' }}>اسم العميل *</label>
                  <input
                    type="text"
                    required
                    value={formName}
                    onChange={(e) => setFormName(e.target.value)}
                    placeholder="م. أحمد الشربيني"
                    style={{ width: '100%', padding: '8px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '12px', fontFamily: 'inherit' }}
                  />
                </div>

                <div>
                  <label style={{ fontSize: '11px', fontWeight: 'bold', display: 'block', marginBottom: '4px' }}>رقم الهاتف *</label>
                  <input
                    type="tel"
                    required
                    value={formPhone}
                    onChange={(e) => setFormPhone(e.target.value)}
                    placeholder="01001234567"
                    style={{ width: '100%', padding: '8px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '12px', fontFamily: 'inherit' }}
                  />
                </div>

                <div>
                  <label style={{ fontSize: '11px', fontWeight: 'bold', display: 'block', marginBottom: '4px' }}>المشروع العقاري *</label>
                  <select
                    value={formProject}
                    onChange={(e) => setFormProject(e.target.value)}
                    style={{ width: '100%', padding: '8px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '12px', fontFamily: 'inherit' }}
                  >
                    {projects.map(p => <option key={p.id} value={p.id}>{p.name}</option>)}
                  </select>
                </div>

                <div>
                  <label style={{ fontSize: '11px', fontWeight: 'bold', display: 'block', marginBottom: '4px' }}>قناة التسويق *</label>
                  <select
                    value={formChannel}
                    onChange={(e) => setFormChannel(e.target.value)}
                    style={{ width: '100%', padding: '8px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '12px', fontFamily: 'inherit' }}
                  >
                    {channels.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
                  </select>
                </div>

                <div>
                  <label style={{ fontSize: '11px', fontWeight: 'bold', display: 'block', marginBottom: '4px' }}>الميزانية المقترحة (ج.م)</label>
                  <input
                    type="number"
                    value={formBudget}
                    onChange={(e) => setFormBudget(e.target.value)}
                    placeholder="7500000"
                    style={{ width: '100%', padding: '8px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '12px', fontFamily: 'inherit' }}
                  />
                </div>

                <button
                  type="submit"
                  style={{
                    marginTop: 'auto',
                    padding: '10px',
                    background: '#4F46E5',
                    color: '#fff',
                    border: 'none',
                    borderRadius: '10px',
                    fontWeight: 'bold',
                    fontSize: '13px',
                    cursor: 'pointer'
                  }}
                >
                  حفظ وتسجيل في النظام
                </button>
              </form>
            </div>
          )}

          {/* MODAL 2: LEAD DETAILS (Inside Phone) */}
          {selectedLead && (
            <div style={{
              position: 'absolute',
              inset: 0,
              background: '#fff',
              zIndex: 50,
              display: 'flex',
              flexDirection: 'column',
              padding: '16px'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', borderBottom: '1px solid #e2e8f0', paddingBottom: '8px', marginBottom: '12px' }}>
                <button onClick={() => setSelectedLead(null)} style={{ border: 'none', background: 'none', display: 'flex', alignItems: 'center', gap: '4px', color: '#4F46E5', fontSize: '12px', fontWeight: 'bold', cursor: 'pointer' }}>
                  <ChevronLeft size={16} /> رجوع
                </button>
                <span style={{ fontSize: '13px', fontWeight: 'bold' }}>تفاصيل العميل</span>
              </div>

              <div style={{ flex: 1, overflowY: 'auto' }}>
                <div style={{ fontWeight: 'bold', fontSize: '16px', marginBottom: '4px' }}>{selectedLead.name}</div>
                <div style={{ fontSize: '12px', color: '#64748b', marginBottom: '12px' }}>{selectedLead.phoneNumber}</div>

                {/* 1-Tap Quick Actions */}
                <div style={{ display: 'flex', gap: '8px', marginBottom: '14px' }}>
                  <a
                    href={`tel:${selectedLead.phoneNumber}`}
                    style={{
                      flex: 1,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '6px',
                      background: '#3B82F6',
                      color: '#fff',
                      padding: '8px',
                      borderRadius: '8px',
                      textDecoration: 'none',
                      fontSize: '12px',
                      fontWeight: 'bold'
                    }}
                  >
                    <Phone size={14} /> اتصال هاتفي
                  </a>
                  <a
                    href={`https://wa.me/2${selectedLead.phoneNumber.replace(/\s+/g, '')}?text=${encodeURIComponent(`مرحباً ${selectedLead.name}`)}`}
                    target="_blank"
                    rel="noreferrer"
                    style={{
                      flex: 1,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '6px',
                      background: '#10B981',
                      color: '#fff',
                      padding: '8px',
                      borderRadius: '8px',
                      textDecoration: 'none',
                      fontSize: '12px',
                      fontWeight: 'bold'
                    }}
                  >
                    <MessageCircle size={14} /> واتساب
                  </a>
                </div>

                {/* Change Stage */}
                <div style={{ background: '#f8fafc', padding: '10px', borderRadius: '10px', border: '1px solid #e2e8f0', marginBottom: '12px' }}>
                  <div style={{ fontSize: '11px', fontWeight: 'bold', marginBottom: '6px' }}>تحديث المرحلة في المسار:</div>
                  <div style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
                    {stagesList.map(st => (
                      <button
                        key={st.id}
                        onClick={() => {
                          onUpdateStatus(selectedLead.id, st.id);
                          setSelectedLead(prev => ({ ...prev, status: st.id }));
                        }}
                        style={{
                          padding: '4px 8px',
                          borderRadius: '6px',
                          border: selectedLead.status === st.id ? `2px solid ${st.color}` : '1px solid #cbd5e1',
                          background: selectedLead.status === st.id ? st.color : '#fff',
                          color: selectedLead.status === st.id ? '#fff' : '#475569',
                          fontSize: '10px',
                          fontWeight: 'bold',
                          cursor: 'pointer'
                        }}
                      >
                        {st.name}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Timeline Comments */}
                <div style={{ fontSize: '12px', fontWeight: 'bold', marginBottom: '6px' }}>سجل الملاحظات والنشاط (Timeline):</div>
                <div style={{ display: 'flex', gap: '6px', marginBottom: '10px' }}>
                  <input
                    type="text"
                    value={commentInput}
                    onChange={(e) => setCommentInput(e.target.value)}
                    placeholder="أضف ملاحظة أو تقرير اتصال..."
                    style={{ flex: 1, padding: '6px 8px', borderRadius: '6px', border: '1px solid #cbd5e1', fontSize: '11px', fontFamily: 'inherit' }}
                  />
                  <button
                    onClick={() => {
                      if (!commentInput.trim()) return;
                      onAddComment(selectedLead.id, commentInput.trim(), 'خالد توفيق');
                      setSelectedLead(prev => ({
                        ...prev,
                        comments: [{ id: Date.now(), comment: commentInput.trim(), author: 'خالد توفيق', createdAt: new Date().toISOString() }, ...(prev.comments || [])]
                      }));
                      setCommentInput('');
                    }}
                    style={{ padding: '6px 12px', background: '#4F46E5', color: '#fff', border: 'none', borderRadius: '6px', fontSize: '11px', cursor: 'pointer', fontWeight: 'bold' }}
                  >
                    إضافة
                  </button>
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                  {(selectedLead.comments || []).map((cm, idx) => (
                    <div key={idx} style={{ background: '#f8fafc', padding: '8px', borderRadius: '8px', border: '1px solid #e2e8f0', fontSize: '11px' }}>
                      <div style={{ fontWeight: 'bold', color: '#475569', marginBottom: '2px' }}>{cm.author || 'المستخدم'}</div>
                      <div style={{ color: '#1e293b' }}>{cm.comment}</div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

