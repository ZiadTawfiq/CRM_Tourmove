import React, { useState, useEffect } from 'react';
import Sidebar from './components/Sidebar';
import Navbar from './components/Navbar';
import StatsCards from './components/StatsCards';
import PipelineKanban from './components/PipelineKanban';
import LeadsTable from './components/LeadsTable';
import LeadDetailsModal from './components/LeadDetailsModal';
import CreateLeadModal from './components/CreateLeadModal';
import AnalyticsView from './components/AnalyticsView';
import ProjectsView from './components/ProjectsView';
import TeamView from './components/TeamView';
import SettingsView from './components/SettingsView';
import { CRM_API } from './services/api';
import { STATUS } from './types/crmConstants';

export default function App() {
  const [currentView, setCurrentView] = useState('kanban'); // 'kanban', 'leads', 'dashboard', 'analytics', 'projects', 'team', 'settings'
  const [theme, setTheme] = useState(() => localStorage.getItem('tourmove_theme') || 'light');
  const [leads, setLeads] = useState([]);
  const [projects, setProjects] = useState([]);
  const [channels, setChannels] = useState([]);
  const [employees, setEmployees] = useState([]);
  
  // Search & Modals
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedLead, setSelectedLead] = useState(null);
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [filterDuplicatesOnly, setFilterDuplicatesOnly] = useState(false);

  // Apply theme to document
  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('tourmove_theme', theme);
  }, [theme]);

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  // Load Initial Data
  const loadData = async () => {
    const [l, p, c, e] = await Promise.all([
      CRM_API.getLeads(),
      CRM_API.getProjects(),
      CRM_API.getChannels(),
      CRM_API.getEmployees(),
    ]);
    setLeads(l);
    setProjects(p);
    setChannels(c);
    setEmployees(e);
  };

  useEffect(() => {
    loadData();
  }, []);

  // Duplicate leads count
  const duplicateCount = leads.filter(l => l.isDuplicated).length;

  // Filter leads by search query if any
  const displayedLeads = leads.filter(lead => {
    if (!searchQuery.trim()) return true;
    const q = searchQuery.toLowerCase().trim();
    const matchName = lead.name?.toLowerCase().includes(q);
    const matchPhone = lead.phoneNumber?.includes(q);
    const matchProject = lead.projectName?.toLowerCase().includes(q);
    return matchName || matchPhone || matchProject;
  });

  // Handlers
  const handleCreateLead = async (leadData) => {
    const created = await CRM_API.createLead(leadData);
    await loadData();
    setSelectedLead(created); // open details for the newly created lead
  };

  const handleUpdateStatus = async (leadId, newStatus, reasonId = null, reasonText = '') => {
    await CRM_API.updateLeadStatus(leadId, newStatus, reasonId, reasonText);
    await loadData();
    if (selectedLead && selectedLead.id === leadId) {
      const updated = await CRM_API.getLeadById(leadId);
      setSelectedLead(updated);
    }
  };

  const handleAssignEmployee = async (leadId, employeeId) => {
    await CRM_API.assignLead(leadId, employeeId);
    await loadData();
    if (selectedLead && selectedLead.id === leadId) {
      const updated = await CRM_API.getLeadById(leadId);
      setSelectedLead(updated);
    }
  };

  const handleAddComment = async (leadId, comment, author) => {
    await CRM_API.addComment(leadId, comment, author);
    await loadData();
    if (selectedLead && selectedLead.id === leadId) {
      const updated = await CRM_API.getLeadById(leadId);
      setSelectedLead(updated);
    }
  };

  const handleUpdateLead = async (leadId, updateData) => {
    await CRM_API.updateLead(leadId, updateData);
    await loadData();
    if (selectedLead && selectedLead.id === leadId) {
      const updated = await CRM_API.getLeadById(leadId);
      setSelectedLead(updated);
    }
  };

  const handleDeleteLead = async (leadId) => {
    await CRM_API.deleteLead(leadId);
    await loadData();
    if (selectedLead && selectedLead.id === leadId) {
      setSelectedLead(null);
    }
  };

  const handleRequestCancellation = (lead) => {
    setSelectedLead(lead);
  };

  const handleFilterProject = (projectId) => {
    setCurrentView('leads');
  };

  return (
    <div className="app-container">
      {/* Sidebar Navigation */}
      <Sidebar 
        currentView={currentView} 
        setCurrentView={setCurrentView} 
        duplicateCount={duplicateCount} 
      />

      {/* Main Content Area */}
      <main className="main-content">
        {/* Top Navbar */}
        <Navbar 
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          onOpenCreateModal={() => setIsCreateModalOpen(true)}
          theme={theme}
          toggleTheme={toggleTheme}
          duplicateCount={duplicateCount}
        />

        {/* Dynamic Content Body */}
        <div className="content-body">
          {/* Header Title & Breadcrumb */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '22px' }}>
            <div>
              <h1 style={{ fontSize: '1.5rem', fontWeight: 800, color: 'var(--text-primary)', margin: 0 }}>
                {currentView === 'dashboard' && 'لوحة القيادة والمؤشرات العامة'}
                {currentView === 'kanban' && 'مسار المبيعات التفاعلي (Sales Pipeline)'}
                {currentView === 'leads' && 'قائمة إدارة العملاء والطلبات'}
                {currentView === 'analytics' && 'تقارير الأداء ومعدلات التحويل'}
                {currentView === 'projects' && 'المشاريع العقارية والمجمعات'}
                {currentView === 'team' && 'فريق المبيعات والصلاحيات'}
                {currentView === 'settings' && 'إعدادات النظام والربط'}
              </h1>
              <p style={{ fontSize: '0.82rem', color: 'var(--text-secondary)', margin: '4px 0 0' }}>
                نظام Tourmove CRM المتكامل لإدارة العملاء المحتملين وتتبع الصفقات العقارية
              </p>
            </div>

            {/* Quick Switch View Buttons for Pipeline / Table */}
            {(currentView === 'kanban' || currentView === 'leads' || currentView === 'dashboard') && (
              <div style={{
                display: 'flex',
                backgroundColor: 'var(--bg-surface)',
                padding: '4px',
                borderRadius: 'var(--radius-md)',
                border: '1px solid var(--border-color)',
                gap: '4px'
              }}>
                <button
                  className={`btn btn-sm ${currentView === 'kanban' ? 'btn-primary' : 'btn-ghost'}`}
                  onClick={() => setCurrentView('kanban')}
                >
                  لوحة كانبان
                </button>
                <button
                  className={`btn btn-sm ${currentView === 'leads' ? 'btn-primary' : 'btn-ghost'}`}
                  onClick={() => setCurrentView('leads')}
                >
                  جدول العملاء
                </button>
              </div>
            )}
          </div>

          {/* KPI Summary Cards */}
          {(currentView === 'dashboard' || currentView === 'kanban' || currentView === 'leads') && (
            <StatsCards leads={displayedLeads} />
          )}

          {/* View Components */}
          {currentView === 'kanban' && (
            <PipelineKanban
              leads={displayedLeads}
              onSelectLead={setSelectedLead}
              onUpdateStatus={handleUpdateStatus}
              onRequestCancellation={handleRequestCancellation}
            />
          )}

          {currentView === 'leads' && (
            <LeadsTable
              leads={displayedLeads}
              projects={projects}
              channels={channels}
              employees={employees}
              onSelectLead={setSelectedLead}
              onDeleteLead={handleDeleteLead}
              filterDuplicatesOnly={filterDuplicatesOnly}
              setFilterDuplicatesOnly={setFilterDuplicatesOnly}
            />
          )}

          {currentView === 'dashboard' && (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '28px' }}>
              <PipelineKanban
                leads={displayedLeads}
                onSelectLead={setSelectedLead}
                onUpdateStatus={handleUpdateStatus}
                onRequestCancellation={handleRequestCancellation}
              />
              <LeadsTable
                leads={displayedLeads}
                projects={projects}
                channels={channels}
                employees={employees}
                onSelectLead={setSelectedLead}
                onDeleteLead={handleDeleteLead}
                filterDuplicatesOnly={filterDuplicatesOnly}
                setFilterDuplicatesOnly={setFilterDuplicatesOnly}
              />
            </div>
          )}

          {currentView === 'analytics' && (
            <AnalyticsView
              leads={leads}
              projects={projects}
              channels={channels}
              employees={employees}
            />
          )}

          {currentView === 'projects' && (
            <ProjectsView
              projects={projects}
              leads={leads}
              onFilterProject={handleFilterProject}
            />
          )}

          {currentView === 'team' && (
            <TeamView
              employees={employees}
              leads={leads}
            />
          )}

          {currentView === 'settings' && (
            <SettingsView
              onDataReset={loadData}
            />
          )}
        </div>
      </main>

      {/* Create Lead Modal */}
      {isCreateModalOpen && (
        <CreateLeadModal
          projects={projects}
          channels={channels}
          employees={employees}
          existingLeads={leads}
          onClose={() => setIsCreateModalOpen(false)}
          onCreate={handleCreateLead}
        />
      )}

      {/* Lead Details Modal */}
      {selectedLead && (
        <LeadDetailsModal
          lead={selectedLead}
          projects={projects}
          channels={channels}
          employees={employees}
          onClose={() => setSelectedLead(null)}
          onUpdateStatus={handleUpdateStatus}
          onAssignEmployee={handleAssignEmployee}
          onAddComment={handleAddComment}
          onUpdateLead={handleUpdateLead}
        />
      )}
    </div>
  );
}
