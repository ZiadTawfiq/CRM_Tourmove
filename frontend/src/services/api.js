import { STATUS, TYPE_LEAD } from '../types/crmConstants';

const STORAGE_KEY_LEADS = 'tourmove_crm_leads_v1';
const STORAGE_KEY_PROJECTS = 'tourmove_crm_projects_v1';
const STORAGE_KEY_CHANNELS = 'tourmove_crm_channels_v1';
const STORAGE_KEY_EMPLOYEES = 'tourmove_crm_employees_v1';
const STORAGE_KEY_CONFIG = 'tourmove_crm_config_v1';

const defaultProjects = [
  { id: 1, name: 'كمبوند بالم هيلز التجمع - Palm Hills New Cairo', location: 'القاهرة الجديدة', startingPrice: 6500000 },
  { id: 2, name: 'زد إيست التجمع الخامس - Zed East', location: 'التجمع الخامس', startingPrice: 8200000 },
  { id: 3, name: 'ماونتن فيو أي سيتي - Mountain View iCity', location: 'التجمع الخامس', startingPrice: 5400000 },
  { id: 4, name: 'سول تاون فيلا - Soul Town Luxury Villas', location: 'الشيخ زايد', startingPrice: 12500000 },
  { id: 5, name: 'أبراج العلمين الشاطئية - North Coast Towers', location: 'الساحل الشمالي', startingPrice: 9800000 },
];

const defaultChannels = [
  { id: 1, name: 'إعلانات فيسبوك (Facebook Ads)' },
  { id: 2, name: 'إعلانات جوجل (Google Search & Ads)' },
  { id: 3, name: 'توصية وترشيح (Referral)' },
  { id: 4, name: 'زيارة المعرض / المقر (Walk-in)' },
  { id: 5, name: 'الموقع الإلكتروني (Web Form)' },
  { id: 6, name: 'إنستجرام وريلز (Instagram)' },
];

const defaultEmployees = [
  { id: 'emp-101', name: 'أحمد ممدوح', email: 'ahmed@tourmove.com', role: 2, phone: '+201011223344', activeLeads: 8 },
  { id: 'emp-102', name: 'سارة عبد الرحمن', email: 'sara@tourmove.com', role: 2, phone: '+201022334455', activeLeads: 12 },
  { id: 'emp-103', name: 'عمر الشناوي', email: 'omar@tourmove.com', role: 3, phone: '+201033445566', activeLeads: 5 },
  { id: 'emp-104', name: 'نورهان طارق', email: 'nourhan@tourmove.com', role: 4, phone: '+201044556677', activeLeads: 0 },
  { id: 'emp-100', name: 'خالد توفيق (مدير)', email: 'khaled@tourmove.com', role: 1, phone: '+201099887766', activeLeads: 2 },
];

const defaultLeads = [
  {
    id: 1001,
    name: 'م. طارق كمال المنشاوي',
    phoneNumber: '01001234567',
    projectId: 1,
    projectName: 'كمبوند بالم هيلز التجمع - Palm Hills New Cairo',
    employeeId: 'emp-101',
    employeeName: 'أحمد ممدوح',
    channelId: 1,
    channelName: 'إعلانات فيسبوك (Facebook Ads)',
    budget: 7500000,
    status: STATUS.FreshLead,
    typeLead: TYPE_LEAD.Sale,
    isDuplicated: false,
    created: new Date(Date.now() - 3600000 * 2).toISOString(),
    updated: new Date(Date.now() - 3600000 * 2).toISOString(),
    assigned: new Date(Date.now() - 3600000 * 1).toISOString(),
    comments: [
      { id: 1, comment: 'سجل اهتمامه عبر نموذج الفيسبوك يطلب وحدة 3 غرف نوم.', createdAt: new Date(Date.now() - 3600000 * 2).toISOString(), author: 'System' }
    ]
  },
  {
    id: 1002,
    name: 'د. منى عبد العزيز العوضي',
    phoneNumber: '01123456789',
    projectId: 2,
    projectName: 'زد إيست التجمع الخامس - Zed East',
    employeeId: 'emp-102',
    employeeName: 'سارة عبد الرحمن',
    channelId: 2,
    channelName: 'إعلانات جوجل (Google Search & Ads)',
    budget: 9500000,
    status: STATUS.FollowUp,
    typeLead: TYPE_LEAD.Sale,
    isDuplicated: false,
    created: new Date(Date.now() - 3600000 * 24).toISOString(),
    updated: new Date(Date.now() - 3600000 * 4).toISOString(),
    assigned: new Date(Date.now() - 3600000 * 20).toISOString(),
    comments: [
      { id: 1, comment: 'تم الاتصال بالعميلة، مهتمة جداً بزد إيست وتريد خطة سداد على 8 سنوات.', createdAt: new Date(Date.now() - 3600000 * 18).toISOString(), author: 'سارة عبد الرحمن' },
      { id: 2, comment: 'تم إرسال البروشور وعروض الأسعار على الواتساب، وبانتظار ردها لموعد المعاينة.', createdAt: new Date(Date.now() - 3600000 * 4).toISOString(), author: 'سارة عبد الرحمن' }
    ]
  },
  {
    id: 1003,
    name: 'أ/ شريف حسام الدين',
    phoneNumber: '01234567890',
    projectId: 3,
    projectName: 'ماونتن فيو أي سيتي - Mountain View iCity',
    employeeId: 'emp-101',
    employeeName: 'أحمد ممدوح',
    channelId: 3,
    channelName: 'توصية وترشيح (Referral)',
    budget: 6200000,
    status: STATUS.Orientation,
    typeLead: TYPE_LEAD.Sale,
    isDuplicated: false,
    created: new Date(Date.now() - 3600000 * 48).toISOString(),
    updated: new Date(Date.now() - 3600000 * 8).toISOString(),
    assigned: new Date(Date.now() - 3600000 * 40).toISOString(),
    orientationDate: new Date(Date.now() + 3600000 * 28).toISOString(),
    comments: [
      { id: 1, comment: 'توصية من عميل سابق، تم التنسيق مع العميل لزيارة مشروع ماونتن فيو يوم الخميس القادم.', createdAt: new Date(Date.now() - 3600000 * 8).toISOString(), author: 'أحمد ممدوح' }
    ]
  },
  {
    id: 1004,
    name: 'م/ ياسمين فاروق المهدي',
    phoneNumber: '01509876543',
    projectId: 4,
    projectName: 'سول تاون فيلا - Soul Town Luxury Villas',
    employeeId: 'emp-102',
    employeeName: 'سارة عبد الرحمن',
    channelId: 5,
    channelName: 'الموقع الإلكتروني (Web Form)',
    budget: 14000000,
    status: STATUS.Reservation,
    typeLead: TYPE_LEAD.Sale,
    isDuplicated: false,
    created: new Date(Date.now() - 3600000 * 120).toISOString(),
    updated: new Date(Date.now() - 3600000 * 12).toISOString(),
    assigned: new Date(Date.now() - 3600000 * 110).toISOString(),
    reservationDate: new Date(Date.now() - 3600000 * 12).toISOString(),
    comments: [
      { id: 1, comment: 'تم توقيع استمارة الحجز المبدئي وإيداع شيك الدفعة الأولى لدى الإدارة المالية.', createdAt: new Date(Date.now() - 3600000 * 12).toISOString(), author: 'سارة عبد الرحمن' }
    ]
  },
  {
    id: 1005,
    name: 'أ/ كريم بدر السعيد',
    phoneNumber: '01011122233',
    projectId: 1,
    projectName: 'كمبوند بالم هيلز التجمع - Palm Hills New Cairo',
    employeeId: 'emp-101',
    employeeName: 'أحمد ممدوح',
    channelId: 6,
    channelName: 'إنستجرام وريلز (Instagram)',
    budget: 450000,
    status: STATUS.FollowUp,
    typeLead: TYPE_LEAD.Rent,
    isDuplicated: false,
    created: new Date(Date.now() - 3600000 * 30).toISOString(),
    updated: new Date(Date.now() - 3600000 * 14).toISOString(),
    assigned: new Date(Date.now() - 3600000 * 28).toISOString(),
    comments: [
      { id: 1, comment: 'يبحث عن إيجار سنوي لوحدة مفروشة بالكامل.', createdAt: new Date(Date.now() - 3600000 * 14).toISOString(), author: 'أحمد ممدوح' }
    ]
  },
  {
    id: 1006,
    name: 'حازم الدسوقي',
    phoneNumber: '01001234567', // Duplicate phone for demo!
    projectId: 5,
    projectName: 'أبراج العلمين الشاطئية - North Coast Towers',
    employeeId: 'emp-103',
    employeeName: 'عمر الشناوي',
    channelId: 4,
    channelName: 'زيارة المعرض / المقر (Walk-in)',
    budget: 10500000,
    status: STATUS.FreshLead,
    typeLead: TYPE_LEAD.Sale,
    isDuplicated: true, // Marked duplicate!
    created: new Date(Date.now() - 3600000 * 6).toISOString(),
    updated: new Date(Date.now() - 3600000 * 6).toISOString(),
    assigned: new Date(Date.now() - 3600000 * 5).toISOString(),
    comments: [
      { id: 1, comment: 'تنبيه: تم رصد رقم هاتف مكرر مسجل مسبقاً لدى العميل م. طارق كمال المنشاوي.', createdAt: new Date(Date.now() - 3600000 * 6).toISOString(), author: 'نظام الحماية من التكرار' }
    ]
  },
  {
    id: 1007,
    name: 'أ/ ماجد حسني ناصف',
    phoneNumber: '01287654321',
    projectId: 3,
    projectName: 'ماونتن فيو أي سيتي - Mountain View iCity',
    employeeId: 'emp-101',
    employeeName: 'أحمد ممدوح',
    channelId: 1,
    channelName: 'إعلانات فيسبوك (Facebook Ads)',
    budget: 5000000,
    status: STATUS.Cancellation,
    cancellationReasonId: 1,
    cancellationReason: 'الميزانية غير ملائمة (Budget Out of Range)',
    cancellationDate: new Date(Date.now() - 3600000 * 18).toISOString(),
    typeLead: TYPE_LEAD.Sale,
    isDuplicated: false,
    created: new Date(Date.now() - 3600000 * 70).toISOString(),
    updated: new Date(Date.now() - 3600000 * 18).toISOString(),
    assigned: new Date(Date.now() - 3600000 * 65).toISOString(),
    comments: [
      { id: 1, comment: 'العميل أفاد بأن الأسعار الحالية تتجاوز ميزانيته، تم تحويله للإلغاء مع إمكانية إعادة التواصل عند توفر مشاريع بديلة.', createdAt: new Date(Date.now() - 3600000 * 18).toISOString(), author: 'أحمد ممدوح' }
    ]
  }
];

// Local storage init
function initStorage() {
  if (!localStorage.getItem(STORAGE_KEY_LEADS)) {
    localStorage.setItem(STORAGE_KEY_LEADS, JSON.stringify(defaultLeads));
  }
  if (!localStorage.getItem(STORAGE_KEY_PROJECTS)) {
    localStorage.setItem(STORAGE_KEY_PROJECTS, JSON.stringify(defaultProjects));
  }
  if (!localStorage.getItem(STORAGE_KEY_CHANNELS)) {
    localStorage.setItem(STORAGE_KEY_CHANNELS, JSON.stringify(defaultChannels));
  }
  if (!localStorage.getItem(STORAGE_KEY_EMPLOYEES)) {
    localStorage.setItem(STORAGE_KEY_EMPLOYEES, JSON.stringify(defaultEmployees));
  }
}

initStorage();

export const CRM_API = {
  // Config
  getConfig() {
    const defaultConf = {
      backendUrl: 'https://localhost:7001/api',
      mode: 'mock', // 'mock' or 'live'
    };
    try {
      const stored = localStorage.getItem(STORAGE_KEY_CONFIG);
      return stored ? JSON.parse(stored) : defaultConf;
    } catch {
      return defaultConf;
    }
  },

  saveConfig(conf) {
    localStorage.setItem(STORAGE_KEY_CONFIG, JSON.stringify(conf));
  },

  // Leads
  async getLeads() {
    const data = localStorage.getItem(STORAGE_KEY_LEADS);
    return data ? JSON.parse(data) : [];
  },

  async getLeadById(id) {
    const leads = await this.getLeads();
    return leads.find(l => l.id === Number(id)) || null;
  },

  async createLead(newLeadData) {
    const leads = await this.getLeads();
    const projects = await this.getProjects();
    const channels = await this.getChannels();
    const employees = await this.getEmployees();

    // Check duplicate phone
    const cleanPhone = (newLeadData.phoneNumber || '').trim().replace(/\s+/g, '');
    const isDup = leads.some(l => (l.phoneNumber || '').trim().replace(/\s+/g, '') === cleanPhone);

    const project = projects.find(p => p.id === Number(newLeadData.projectId));
    const channel = channels.find(c => c.id === Number(newLeadData.channelId));
    const employee = employees.find(e => e.id === newLeadData.employeeId);

    const newLead = {
      id: Date.now(),
      name: newLeadData.name,
      phoneNumber: cleanPhone,
      projectId: Number(newLeadData.projectId),
      projectName: project ? project.name : '',
      channelId: newLeadData.channelId ? Number(newLeadData.channelId) : null,
      channelName: channel ? channel.name : 'مباشر',
      employeeId: newLeadData.employeeId || null,
      employeeName: employee ? employee.name : 'غير مسند',
      budget: Number(newLeadData.budget) || null,
      status: Number(newLeadData.status) || STATUS.FreshLead,
      typeLead: Number(newLeadData.typeLead) || TYPE_LEAD.Sale,
      isDuplicated: isDup,
      created: new Date().toISOString(),
      updated: new Date().toISOString(),
      assigned: newLeadData.employeeId ? new Date().toISOString() : null,
      comments: [
        {
          id: Date.now(),
          comment: isDup ? 'تم إنشاء العميل مع رصد تنبيه بوجود رقم هاتف مكرر سابقاً.' : 'تم تسجيل العميل بنجاح في النظام.',
          createdAt: new Date().toISOString(),
          author: 'System'
        }
      ]
    };

    const updatedList = [newLead, ...leads];
    localStorage.setItem(STORAGE_KEY_LEADS, JSON.stringify(updatedList));
    return newLead;
  },

  async updateLead(id, updateData) {
    const leads = await this.getLeads();
    const index = leads.findIndex(l => l.id === Number(id));
    if (index === -1) return null;

    const projects = await this.getProjects();
    const channels = await this.getChannels();
    const employees = await this.getEmployees();

    const existing = leads[index];
    const project = updateData.projectId ? projects.find(p => p.id === Number(updateData.projectId)) : null;
    const channel = updateData.channelId ? channels.find(c => c.id === Number(updateData.channelId)) : null;
    const employee = updateData.employeeId ? employees.find(e => e.id === updateData.employeeId) : null;

    const updated = {
      ...existing,
      ...updateData,
      projectName: project ? project.name : existing.projectName,
      channelName: channel ? channel.name : existing.channelName,
      employeeName: employee ? employee.name : existing.employeeName,
      updated: new Date().toISOString(),
    };

    leads[index] = updated;
    localStorage.setItem(STORAGE_KEY_LEADS, JSON.stringify(leads));
    return updated;
  },

  async updateLeadStatus(id, newStatus, cancellationReasonId = null, reasonText = '') {
    const leads = await this.getLeads();
    const index = leads.findIndex(l => l.id === Number(id));
    if (index === -1) return null;

    const lead = leads[index];
    lead.status = Number(newStatus);
    lead.updated = new Date().toISOString();

    if (newStatus === STATUS.Cancellation) {
      lead.cancellationReasonId = cancellationReasonId;
      lead.cancellationReason = reasonText || 'تم الإلغاء';
      lead.cancellationDate = new Date().toISOString();
    } else if (newStatus === STATUS.Reservation) {
      lead.reservationDate = new Date().toISOString();
    } else if (newStatus === STATUS.Orientation) {
      lead.orientationDate = new Date().toISOString();
    }

    lead.comments.unshift({
      id: Date.now(),
      comment: `تم تحديث حالة العميل إلى: ${reasonText || 'حالة جديدة'}`,
      createdAt: new Date().toISOString(),
      author: 'مدير النظام / المستخدم'
    });

    leads[index] = lead;
    localStorage.setItem(STORAGE_KEY_LEADS, JSON.stringify(leads));
    return lead;
  },

  async addComment(leadId, commentText, author = 'المستخدم') {
    const leads = await this.getLeads();
    const index = leads.findIndex(l => l.id === Number(leadId));
    if (index === -1) return null;

    const newComment = {
      id: Date.now(),
      comment: commentText,
      createdAt: new Date().toISOString(),
      author
    };

    leads[index].comments = [newComment, ...(leads[index].comments || [])];
    leads[index].updated = new Date().toISOString();
    localStorage.setItem(STORAGE_KEY_LEADS, JSON.stringify(leads));
    return newComment;
  },

  async assignLead(leadId, employeeId) {
    const employees = await this.getEmployees();
    const employee = employees.find(e => e.id === employeeId);
    return this.updateLead(leadId, {
      employeeId,
      employeeName: employee ? employee.name : 'غير محدد',
      assigned: new Date().toISOString()
    });
  },

  async deleteLead(id) {
    const leads = await this.getLeads();
    const filtered = leads.filter(l => l.id !== Number(id));
    localStorage.setItem(STORAGE_KEY_LEADS, JSON.stringify(filtered));
    return true;
  },

  // Lookup data
  async getProjects() {
    const data = localStorage.getItem(STORAGE_KEY_PROJECTS);
    return data ? JSON.parse(data) : [];
  },

  async getChannels() {
    const data = localStorage.getItem(STORAGE_KEY_CHANNELS);
    return data ? JSON.parse(data) : [];
  },

  async getEmployees() {
    const data = localStorage.getItem(STORAGE_KEY_EMPLOYEES);
    return data ? JSON.parse(data) : [];
  },

  resetDemoData() {
    localStorage.removeItem(STORAGE_KEY_LEADS);
    localStorage.removeItem(STORAGE_KEY_PROJECTS);
    localStorage.removeItem(STORAGE_KEY_CHANNELS);
    localStorage.removeItem(STORAGE_KEY_EMPLOYEES);
    initStorage();
    return true;
  }
};
