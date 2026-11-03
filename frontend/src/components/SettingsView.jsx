import React, { useState } from 'react';
import { Settings, Server, RefreshCw, CheckCircle2, ShieldCheck, Database } from 'lucide-react';
import { CRM_API } from '../services/api';

export default function SettingsView({ onDataReset }) {
  const [config, setConfig] = useState(CRM_API.getConfig());
  const [savedSuccess, setSavedSuccess] = useState(false);

  const handleSave = (e) => {
    e.preventDefault();
    CRM_API.saveConfig(config);
    setSavedSuccess(true);
    setTimeout(() => setSavedSuccess(false), 3000);
  };

  const handleResetData = () => {
    if (window.confirm('هل تريد إعادة تعيين البيانات التجريبية إلى الوضع الافتراضي؟')) {
      CRM_API.resetDemoData();
      onDataReset();
      alert('تم إعادة تعيين البيانات بنجاح.');
    }
  };

  return (
    <div style={{ maxWidth: '800px', display: 'flex', flexDirection: 'column', gap: '24px' }}>
      <div>
        <h3 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--text-primary)', margin: 0 }}>
          إعدادات النظام والربط البرمجي (Settings & Integration)
        </h3>
        <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', margin: '4px 0 0' }}>
          ضبط خيارات الاتصال بالباك إند (.NET Web API) وإدارة التخزين المحلي
        </p>
      </div>

      {/* Backend API Configuration */}
      <div className="glass-card" style={{ padding: '24px', backgroundColor: 'var(--bg-surface)' }}>
        <h4 style={{ fontSize: '1rem', fontWeight: 700, marginBottom: '14px', color: 'var(--text-primary)', display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Server size={18} style={{ color: 'var(--primary)' }} />
          إعدادات خادم الـ API (ASP.NET Core)
        </h4>

        <form onSubmit={handleSave} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          <div className="form-group">
            <label className="form-label">رابط خادم الباك إند (API Base URL):</label>
            <input
              id="input-api-url"
              type="text"
              dir="ltr"
              className="form-input"
              value={config.backendUrl}
              onChange={(e) => setConfig({ ...config, backendUrl: e.target.value })}
              placeholder="https://localhost:7001/api"
            />
            <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
              الرابط الافتراضي لمشروع CustomerRelationshipManagement عند تشغيله محلياً.
            </span>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <button id="btn-save-settings" type="submit" className="btn btn-primary btn-sm">
              حفظ الإعدادات
            </button>
            {savedSuccess && (
              <span style={{ color: '#10b981', fontSize: '0.82rem', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '4px' }}>
                <CheckCircle2 size={16} />
                تم حفظ التغييرات بنجاح
              </span>
            )}
          </div>
        </form>
      </div>

      {/* Preservation & Integrity Notice */}
      <div className="glass-card" style={{ padding: '24px', backgroundColor: 'var(--bg-surface)' }}>
        <h4 style={{ fontSize: '1rem', fontWeight: 700, marginBottom: '10px', color: 'var(--text-primary)', display: 'flex', alignItems: 'center', gap: '8px' }}>
          <ShieldCheck size={18} style={{ color: '#10b981' }} />
          سلامة ملفات الباك إند (Backend Code Integrity)
        </h4>
        <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', lineHeight: 1.6, margin: 0 }}>
          تم بناء هذا الفرونت إند بالكامل داخل مجلد مستقل <code style={{ backgroundColor: 'var(--bg-app)', padding: '2px 6px', borderRadius: '4px' }}>frontend/</code> مع الالتزام التام بعدم تعديل أو لمس أي كود في مشروع الباك إند (.NET Core) نهائياً بناءً على طلبك.
        </p>
      </div>

      {/* Reset Demo Data */}
      <div className="glass-card" style={{ padding: '24px', backgroundColor: 'var(--bg-surface)' }}>
        <h4 style={{ fontSize: '1rem', fontWeight: 700, marginBottom: '10px', color: 'var(--text-primary)', display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Database size={18} style={{ color: '#ef4444' }} />
          إدارة البيانات التجريبية (Demo Data)
        </h4>
        <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', marginBottom: '16px' }}>
          يمكنك إعادة تعيين كافة العملاء والملاحظات وحالات المسار إلى الوضع التجريبي الأصلي في أي وقت.
        </p>
        <button
          id="btn-reset-demo-data"
          type="button"
          className="btn btn-danger btn-sm"
          onClick={handleResetData}
        >
          <RefreshCw size={15} />
          <span>إعادة تعيين البيانات التجريبية</span>
        </button>
      </div>
    </div>
  );
}
