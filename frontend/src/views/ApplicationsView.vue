<template>
  <div class="app-container">
    <!-- Floating Orbs Background -->
    <div class="bg-orbs">
      <div class="orb orb-1"></div>
      <div class="orb orb-2"></div>
      <div class="orb orb-3"></div>
    </div>

    <!-- Header -->
    <header class="app-header glass-card">
      <div class="header-left">
        <div class="logo">
          <svg viewBox="0 0 48 48" class="logo-icon">
            <defs>
              <linearGradient id="headerLogoGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" style="stop-color:#7c3aed"/>
                <stop offset="100%" style="stop-color:#a78bfa"/>
              </linearGradient>
            </defs>
            <circle cx="24" cy="24" r="20" fill="url(#headerLogoGrad)"/>
            <circle cx="24" cy="24" r="7" fill="rgba(255,255,255,0.9)"/>
            <circle cx="24" cy="24" r="3" fill="url(#headerLogoGrad)"/>
          </svg>
          <span class="logo-text text-gradient">Resource Manager</span>
        </div>
      </div>
      <div class="header-right">
        <!-- Theme Toggle -->
        <button class="theme-btn" @click="themeStore.toggle()">
          <svg v-if="themeStore.isDark" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 3a9 9 0 109 9c0-.46-.04-.92-.1-1.36a5.389 5.389 0 01-4.4 2.26 5.403 5.403 0 01-3.14-9.8c-.44-.06-.9-.1-1.36-.1z"/>
          </svg>
          <svg v-else viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1z"/>
          </svg>
        </button>
        <!-- Home -->
        <el-button class="header-btn" @click="goToHome">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
          </svg>
          <span>Сотрудники</span>
        </el-button>
        <!-- Admin Settings -->
        <el-button v-if="authStore.isAdmin" class="header-btn" @click="goToAdmin">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M19.14 12.94c.04-.31.06-.63.06-.94 0-.31-.02-.63-.06-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.04.31-.06.63-.06.94s.02.63.06.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
          </svg>
          <span>Настройка</span>
        </el-button>
        <div class="user-badge glass-card">
          <svg viewBox="0 0 24 24" fill="currentColor" class="user-icon">
            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
          <span>{{ authStore.user?.username }}</span>
        </div>
        <el-button class="logout-btn" @click="handleLogout">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/>
          </svg>
          <span>Выйти</span>
        </el-button>
      </div>
    </header>

    <!-- Main Content -->
    <main class="app-main">
      <div class="page-header">
        <div class="page-title">
          <h1>Заявки</h1>
          <p class="subtitle">Заявки на развитие и ротацию сотрудников</p>
        </div>
        <el-button type="primary" class="btn-create" @click="showCreateDialog">
          <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
            <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
          </svg>
          <span>Создать заявку</span>
        </el-button>
      </div>

      <!-- Фильтры и переключение списков -->
      <div class="filters-section glass-card">
        <el-radio-group v-model="activeList" @change="loadApplications" class="list-tabs">
          <el-radio-button value="all">Все заявки</el-radio-button>
          <el-radio-button value="my">Мои заявки</el-radio-button>
          <el-radio-button value="assigned">Назначенные мне</el-radio-button>
          <el-radio-button value="pending">Требуют согласования</el-radio-button>
        </el-radio-group>

        <el-select
          v-model="statusFilter"
          placeholder="Фильтр по статусу"
          clearable
          class="status-filter"
          @change="loadApplications"
        >
          <el-option
            v-for="status in availableStatuses"
            :key="status.value"
            :label="status.label"
            :value="status.value"
          />
        </el-select>
      </div>

      <!-- Статистика -->
      <div v-if="stats" class="stats-section">
        <div class="stat-card glass-card">
          <span class="stat-value">{{ stats.total || 0 }}</span>
          <span class="stat-label">Всего</span>
        </div>
        <div class="stat-card glass-card">
          <span class="stat-value stat-progress">{{ stats.inProgress || 0 }}</span>
          <span class="stat-label">В работе</span>
        </div>
        <div class="stat-card glass-card">
          <span class="stat-value stat-pending">{{ stats.pendingApproval || 0 }}</span>
          <span class="stat-label">На согласовании</span>
        </div>
        <div class="stat-card glass-card">
          <span class="stat-value stat-completed">{{ stats.completed || 0 }}</span>
          <span class="stat-label">Завершено</span>
        </div>
      </div>

      <!-- Таблица заявок -->
      <div class="table-card glass-card-strong">
        <el-table
          :data="applicationsStore.applications"
          :loading="applicationsStore.loading"
          class="data-table"
          @row-click="handleRowClick"
        >
          <el-table-column prop="id" label="ID" width="70" />

          <el-table-column label="Сотрудник" min-width="280">
            <template #default="{ row }">
              {{ getEmployeeName(row) }}
            </template>
          </el-table-column>

          <el-table-column label="Тип" width="130">
            <template #default="{ row }">
              <el-tag :type="row.applicationType === 'DEVELOPMENT' ? 'success' : 'warning'" size="small">
                {{ row.applicationType === 'DEVELOPMENT' ? 'Развитие' : 'Ротация' }}
              </el-tag>
            </template>
          </el-table-column>

          <el-table-column prop="targetPosition" label="Целевая должность" min-width="220" show-overflow-tooltip />

          <el-table-column label="ЗП" min-width="200">
            <template #default="{ row }">
              <div v-if="row.currentSalary && row.targetSalary" class="salary-cell">
                <div class="salary-change">
                  {{ formatSalary(row.currentSalary) }} → {{ formatSalary(row.targetSalary) }}
                </div>
                <el-tag :type="getSalaryChangeType(row)" size="small" class="salary-percent">
                  {{ getSalaryChangePercent(row) }}%
                </el-tag>
              </div>
              <span v-else>-</span>
            </template>
          </el-table-column>

          <el-table-column label="Статус" min-width="220">
            <template #default="{ row }">
              <ApplicationStatusBadge :status="row.status" />
            </template>
          </el-table-column>

          <el-table-column label="Создано" width="130">
            <template #default="{ row }">
              {{ formatDate(row.createdAt) }}
            </template>
          </el-table-column>
        </el-table>

        <div class="pagination-wrapper">
          <el-pagination
            v-model:current-page="pagination.page"
            v-model:page-size="pagination.pageSize"
            :page-sizes="[6, 12, 24]"
            :total="pagination.total"
            layout="total, sizes, prev, pager, next"
            @size-change="handleSizeChange"
            @current-change="handlePageChange"
          />
        </div>
      </div>
    </main>

    <!-- Диалог создания заявки -->
    <el-dialog
      v-model="createDialogVisible"
      title="Создать заявку"
      width="700px"
      class="create-dialog"
    >
      <ApplicationForm
        :loading="formLoading"
        @submit="handleCreateApplication"
        @cancel="createDialogVisible = false"
      />
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useApplicationsStore } from '@/stores/applications'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'
import { ElMessage } from 'element-plus'
import ApplicationStatusBadge from '@/components/applications/ApplicationStatusBadge.vue'
import ApplicationForm from '@/components/applications/ApplicationForm.vue'

const router = useRouter()
const applicationsStore = useApplicationsStore()
const authStore = useAuthStore()
const themeStore = useThemeStore()

const activeList = ref('all')
const statusFilter = ref(null)
const stats = ref(null)
const createDialogVisible = ref(false)
const formLoading = ref(false)

const pagination = ref({
  page: 1,
  pageSize: 6,
  total: 0
})

const availableStatuses = [
  { value: 'DRAFT', label: 'Черновик' },
  { value: 'AVAILABLE_FOR_REVIEW', label: 'Доступна для просмотра' },
  { value: 'IN_PROGRESS', label: 'В работе' },
  { value: 'INTERVIEW', label: 'Собеседование' },
  { value: 'PENDING_HR_BP', label: 'На согласовании HR BP' },
  { value: 'APPROVED_HR_BP', label: 'Согласовано HR BP' },
  { value: 'REJECTED_HR_BP', label: 'Отклонено HR BP' },
  { value: 'PENDING_BORUP', label: 'На согласовании БОРУП' },
  { value: 'APPROVED_BORUP', label: 'Согласовано БОРУП' },
  { value: 'REJECTED_BORUP', label: 'Отклонено БОРУП' },
  { value: 'PREPARING_TRANSFER', label: 'Подготовка к переводу' },
  { value: 'TRANSFERRED', label: 'Переведен' },
  { value: 'DISMISSED', label: 'Уволен' },
  { value: 'CANCELLED', label: 'Отменена' }
]

async function loadApplications() {
  try {
    const params = {
      page: pagination.value.page - 1,
      size: pagination.value.pageSize
    }

    if (statusFilter.value) {
      params.status = statusFilter.value
    }

    let response
    switch (activeList.value) {
      case 'my':
        response = await applicationsStore.fetchMy(params)
        break
      case 'assigned':
        response = await applicationsStore.fetchAssigned(params)
        break
      case 'pending':
        response = await applicationsStore.fetchPendingApproval(params)
        break
      default:
        response = await applicationsStore.fetchAll(params)
    }

    if (response?.totalElements !== undefined) {
      pagination.value.total = response.totalElements
    }
  } catch (error) {
    ElMessage.error('Ошибка загрузки заявок')
  }
}

async function loadStats() {
  try {
    stats.value = await applicationsStore.fetchStats()
  } catch (error) {
    // Игнорируем ошибки загрузки статистики
  }
}

function showCreateDialog() {
  createDialogVisible.value = true
}

async function handleCreateApplication(data) {
  try {
    formLoading.value = true
    await applicationsStore.create(data)
    ElMessage.success('Заявка создана')
    createDialogVisible.value = false
    await loadApplications()
  } catch (error) {
    // Показываем понятное сообщение от сервера
    const message = error.response?.data?.message || error.message || 'Ошибка создания заявки'
    ElMessage.error({
      message: message,
      duration: 5000,
      showClose: true
    })
  } finally {
    formLoading.value = false
  }
}

function handleRowClick(row) {
  viewApplication(row.id)
}

function viewApplication(id) {
  router.push(`/applications/${id}`)
}

function getEmployeeName(application) {
  // Backend возвращает employeeName напрямую в DTO
  if (application.employeeName) {
    return application.employeeName
  }
  // Fallback
  if (application.employee?.fullName) {
    return application.employee.fullName
  }
  return `ID: ${application.employeeId}`
}

function formatSalary(value) {
  return new Intl.NumberFormat('ru-RU').format(value)
}

function getSalaryChangePercent(application) {
  if (!application.currentSalary || !application.targetSalary) return 0
  const change = ((application.targetSalary - application.currentSalary) / application.currentSalary) * 100
  return change.toFixed(1)
}

function getSalaryChangeType(application) {
  const percent = parseFloat(getSalaryChangePercent(application))
  if (percent > 30) return 'danger'
  if (percent > 15) return 'warning'
  if (percent > 0) return 'success'
  return 'info'
}

function formatDate(dateString) {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('ru-RU')
}

function goToHome() {
  router.push('/')
}

function goToAdmin() {
  router.push('/admin')
}

async function handleLogout() {
  await authStore.logout()
  router.push('/login')
}

function handlePageChange(page) {
  pagination.value.page = page
  loadApplications()
}

function handleSizeChange(size) {
  pagination.value.pageSize = size
  pagination.value.page = 1
  loadApplications()
}

onMounted(async () => {
  await loadApplications()
  await loadStats()
})
</script>

<style scoped>
.app-container {
  min-height: 100vh;
  position: relative;
}

/* Background Orbs */
.bg-orbs {
  position: fixed;
  inset: 0;
  overflow: hidden;
  pointer-events: none;
  z-index: 0;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.4;
  animation: float 12s ease-in-out infinite;
}

.orb-1 {
  width: 500px;
  height: 500px;
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
  top: -150px;
  right: -100px;
}

.orb-2 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #06b6d4 0%, #22d3ee 100%);
  bottom: -100px;
  left: -100px;
  animation-delay: -4s;
}

.orb-3 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #ec4899 0%, #f472b6 100%);
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  animation-delay: -8s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-30px) rotate(5deg); }
}

/* Header */
.app-header {
  position: sticky;
  top: 2px;
  margin: 16px 24px 0;
  padding: 16px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  z-index: 100;
}

.header-left {
  display: flex;
  align-items: center;
}

.logo {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  width: 42px;
  height: 42px;
  filter: drop-shadow(0 4px 12px rgba(124, 58, 237, 0.3));
}

.logo-text {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: -0.5px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.theme-btn {
  width: 42px;
  height: 42px;
  border-radius: var(--radius-md);
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-primary);
  transition: var(--transition);
}

.theme-btn:hover {
  background: var(--bg-glass-strong);
  border-color: var(--accent);
  transform: scale(1.05);
}

.theme-btn svg {
  width: 20px;
  height: 20px;
}

.header-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 40px;
  padding: 0 16px;
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-glass) !important;
  color: var(--text-primary) !important;
  border-radius: 20px;
  font-weight: 500;
  transition: all 0.2s ease;
}

.header-btn:hover {
  background: var(--accent) !important;
  border-color: var(--accent) !important;
  color: white !important;
}

.user-badge {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  color: var(--text-primary);
  font-size: 14px;
  font-weight: 500;
}

.user-icon {
  width: 20px;
  height: 20px;
  color: var(--accent);
}

.logout-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 40px;
  padding: 0 16px;
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-glass) !important;
  color: var(--text-primary) !important;
  border-radius: 20px;
  font-weight: 500;
}

.logout-btn:hover {
  background: rgba(239, 68, 68, 0.1) !important;
  border-color: var(--danger) !important;
  color: var(--danger) !important;
}

/* Main */
.app-main {
  padding: 32px 24px;
  max-width: 1600px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.page-title h1 {
  margin: 0 0 6px 0;
  font-size: 32px;
  font-weight: 800;
  color: var(--text-primary);
  letter-spacing: -0.5px;
}

.subtitle {
  margin: 0;
  color: var(--text-secondary);
  font-size: 15px;
}

.btn-create {
  display: flex;
  align-items: center;
  gap: 8px;
  height: 44px;
  padding: 0 24px;
  font-weight: 600;
  font-size: 15px;
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%) !important;
  border: none !important;
  box-shadow: 0 4px 12px rgba(124, 58, 237, 0.3);
  transition: all 0.3s ease;
}

.btn-create:hover {
  background: linear-gradient(135deg, #6d28d9 0%, #8b5cf6 100%) !important;
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(124, 58, 237, 0.4);
}

/* Filters */
.filters-section {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  margin-bottom: 20px;
}

.list-tabs {
  display: flex;
  gap: 8px;
}

:deep(.list-tabs .el-radio-button__inner) {
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  color: var(--text-primary);
  padding: 8px 20px;
  font-weight: 500;
  transition: all 0.3s ease;
}

:deep(.list-tabs .el-radio-button__original-radio:checked + .el-radio-button__inner) {
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
  border-color: #7c3aed;
  color: white;
  box-shadow: 0 4px 12px rgba(124, 58, 237, 0.3);
}

:deep(.list-tabs .el-radio-button__inner:hover) {
  border-color: #7c3aed;
  transform: translateY(-1px);
}

.status-filter {
  width: 250px;
}

/* Stats */
.stats-section {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

.stat-card {
  padding: 20px;
  text-align: center;
}

.stat-value {
  display: block;
  font-size: 32px;
  font-weight: 800;
  color: var(--accent);
  margin-bottom: 4px;
}

.stat-progress {
  color: #3b82f6;
}

.stat-pending {
  color: #f59e0b;
}

.stat-completed {
  color: #10b981;
}

.stat-label {
  font-size: 13px;
  color: var(--text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Table */
.table-card {
  overflow: hidden;
  padding: 0;
}

.data-table {
  width: 100%;
}

:deep(.el-table__row) {
  cursor: pointer;
}

:deep(.el-table__row:hover) {
  background-color: var(--bg-glass-strong);
}

.salary-cell {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 4px;
}

.salary-change {
  font-size: 13px;
  color: var(--text-primary);
  white-space: nowrap;
}

.salary-percent {
  font-size: 11px;
}

/* Create Dialog */
.create-dialog :deep(.el-dialog) {
  background: rgba(20, 20, 35, 0.98) !important;
  border: 1px solid rgba(124, 58, 237, 0.3) !important;
  border-radius: 16px !important;
  backdrop-filter: blur(20px);
}

.create-dialog :deep(.el-dialog__header) {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 20px 24px !important;
}

.create-dialog :deep(.el-dialog__title) {
  color: #fff !important;
  font-size: 20px !important;
  font-weight: 700 !important;
}

.create-dialog :deep(.el-dialog__body) {
  padding: 24px !important;
}

.create-dialog :deep(.el-dialog__headerbtn .el-dialog__close) {
  color: rgba(255, 255, 255, 0.6) !important;
}

.create-dialog :deep(.el-dialog__headerbtn:hover .el-dialog__close) {
  color: #fff !important;
}

/* Responsive */
@media (max-width: 1024px) {
  .stats-section {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .app-header {
    margin: 12px 16px 0;
    padding: 12px 16px;
    flex-wrap: wrap;
    gap: 12px;
  }

  .app-main {
    padding: 24px 16px;
  }

  .page-header {
    flex-direction: column;
    gap: 16px;
    align-items: flex-start;
  }

  .filters-section {
    flex-direction: column;
    gap: 16px;
    align-items: flex-start;
  }

  .status-filter {
    width: 100%;
  }

  .stats-section {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* Стили кнопок в таблице */
:deep(.el-table .el-button--primary) {
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
  border: none;
  font-weight: 500;
}

:deep(.el-table .el-button--primary:hover) {
  background: linear-gradient(135deg, #6d28d9 0%, #8b5cf6 100%);
  transform: translateY(-1px);
}

/* Пагинация */
.pagination-wrapper {
  padding: 16px 20px;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid var(--border-glass);
}

:deep(.el-pagination) {
  --el-pagination-bg-color: transparent;
  --el-pagination-button-bg-color: var(--bg-glass);
  --el-pagination-hover-color: var(--accent);
}

:deep(.el-pagination .el-pager li) {
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  border-radius: 6px;
  margin: 0 2px;
}

:deep(.el-pagination .el-pager li.is-active) {
  background: var(--accent);
  border-color: var(--accent);
}

:deep(.el-pagination button) {
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-glass);
  border-radius: 6px;
}

:deep(.el-pagination .el-select .el-input__wrapper) {
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  box-shadow: none;
}

:deep(.el-table__row) {
  cursor: pointer;
  transition: background-color 0.2s ease;
}

:deep(.el-table__row:hover) {
  background-color: rgba(124, 58, 237, 0.1) !important;
}
</style>
