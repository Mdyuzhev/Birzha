<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'
import { useColumnsStore } from '@/stores/columns'
import { employeesApi } from '@/api/employees'
import { ElMessage, ElMessageBox } from 'element-plus'
import EmployeeDialog from '@/components/EmployeeDialog.vue'

const router = useRouter()
const authStore = useAuthStore()
const themeStore = useThemeStore()
const columnsStore = useColumnsStore()

const employees = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const editingEmployee = ref(null)
const selectedEmployee = ref(null)

// Пагинация - 4 строки на странице
const pagination = ref({
  page: 0,
  size: 4,
  total: 0
})

// Фиксированные колонки + динамические
const tableColumns = computed(() => {
  const fixed = [
    { prop: 'fullName', label: 'ФИО', width: 220, fixed: true },
    { prop: 'email', label: 'Email', width: 200 }
  ]

  const dynamic = columnsStore.columns.map(col => ({
    prop: `customFields.${col.name}`,
    label: col.displayName,
    width: col.fieldType === 'TEXT' ? 150 : 130,
    fieldType: col.fieldType,
    dictionaryId: col.dictionaryId
  }))

  return [...fixed, ...dynamic]
})

async function fetchEmployees() {
  loading.value = true
  try {
    const response = await employeesApi.getAll({
      page: pagination.value.page,
      size: pagination.value.size
    })
    employees.value = response.data.content || response.data
    pagination.value.total = response.data.totalElements || employees.value.length
  } catch (error) {
    ElMessage.error('Ошибка загрузки данных')
  } finally {
    loading.value = false
  }
}

function getNestedValue(obj, path) {
  return path.split('.').reduce((acc, part) => acc?.[part], obj)
}

function getStatusClass(prop, value) {
  if (prop !== 'customFields.status' || !value) return ''
  const statusMap = {
    'На проекте': 'status-badge status-active',
    'На бенче': 'status-badge status-bench',
    'В отпуске': 'status-badge status-vacation',
    'Болеет': 'status-badge status-sick'
  }
  return statusMap[value] || 'status-badge'
}

function openCreateDialog() {
  editingEmployee.value = null
  dialogVisible.value = true
}

function openEditDialog() {
  if (!selectedEmployee.value) return
  editingEmployee.value = { ...selectedEmployee.value }
  dialogVisible.value = true
}

async function handleDelete() {
  if (!selectedEmployee.value) return
  try {
    await ElMessageBox.confirm(
      `Удалить сотрудника "${selectedEmployee.value.fullName}"?`,
      'Подтверждение',
      { type: 'warning' }
    )
    await employeesApi.delete(selectedEmployee.value.id)
    ElMessage.success('Сотрудник удалён')
    selectedEmployee.value = null
    fetchEmployees()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('Ошибка удаления')
    }
  }
}

function handleSelect(row) {
  selectedEmployee.value = selectedEmployee.value?.id === row.id ? null : row
}

function handleDialogClose(saved) {
  dialogVisible.value = false
  if (saved) {
    fetchEmployees()
  }
}

function handlePageChange(page) {
  pagination.value.page = page - 1
  fetchEmployees()
}

function handleSizeChange(size) {
  pagination.value.size = size
  pagination.value.page = 0
  fetchEmployees()
}

function handleLogout() {
  authStore.logout()
  router.push('/login')
}

function goToAdmin() {
  router.push('/admin')
}

onMounted(async () => {
  await columnsStore.fetchColumns()
  await fetchEmployees()
})
</script>

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
        <!-- Admin Settings -->
        <el-button v-if="authStore.isAdmin" class="settings-btn" @click="goToAdmin">
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
          <h1>Управление сотрудниками</h1>
          <p class="subtitle">Отслеживание доступности и аллокации на проекты</p>
        </div>
        <div class="page-stats glass-card">
          <div class="stat">
            <span class="stat-value">{{ pagination.total }}</span>
            <span class="stat-label">Сотрудников</span>
          </div>
        </div>
      </div>

      <!-- Toolbar -->
      <div class="toolbar">
        <el-button type="primary" class="btn-add" @click="openCreateDialog">
          <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
            <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
          </svg>
          <span>Добавить</span>
        </el-button>
        <el-button
          class="btn-edit"
          :disabled="!selectedEmployee"
          @click="openEditDialog"
        >
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
          </svg>
          <span>Изменить</span>
        </el-button>
        <el-button
          class="btn-delete"
          :disabled="!selectedEmployee"
          @click="handleDelete"
        >
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
          </svg>
          <span>Удалить</span>
        </el-button>
        <el-button class="btn-refresh" @click="fetchEmployees" :loading="loading">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/>
          </svg>
          <span>Обновить</span>
        </el-button>
      </div>

      <!-- Table Card -->
      <div class="table-card glass-card-strong">
        <el-table
          :data="employees"
          v-loading="loading"
          stripe
          class="data-table"
          highlight-current-row
          @row-click="handleSelect"
        >
          <!-- Selection Column -->
          <el-table-column width="50" fixed="left" align="center">
            <template #default="{ row }">
              <div class="radio-cell" @click.stop="handleSelect(row)">
                <span
                  class="custom-radio"
                  :class="{ 'is-checked': selectedEmployee?.id === row.id }"
                >
                  <span class="radio-inner"></span>
                </span>
              </div>
            </template>
          </el-table-column>

          <el-table-column
            v-for="col in tableColumns"
            :key="col.prop"
            :prop="col.prop"
            :label="col.label"
            :width="col.width"
            :fixed="col.fixed ? 'left' : false"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <span :class="getStatusClass(col.prop, getNestedValue(row, col.prop))">
                {{ getNestedValue(row, col.prop) || '—' }}
              </span>
            </template>
          </el-table-column>
        </el-table>

        <!-- Pagination -->
        <div class="pagination-wrapper">
          <el-pagination
            v-model:current-page="pagination.page"
            :page-size="pagination.size"
            :page-sizes="[4, 8, 12, 20]"
            :total="pagination.total"
            layout="total, sizes, prev, pager, next"
            @current-change="handlePageChange"
            @size-change="handleSizeChange"
          />
        </div>
      </div>
    </main>

    <!-- Dialog -->
    <EmployeeDialog
      v-model:visible="dialogVisible"
      :employee="editingEmployee"
      @close="handleDialogClose"
    />
  </div>
</template>


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

/* Header */
.app-header {
  position: sticky;
  top: 16px;
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
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-glass) !important;
  color: var(--text-primary) !important;
}

.logout-btn:hover {
  background: rgba(239, 68, 68, 0.1) !important;
  border-color: var(--danger) !important;
  color: var(--danger) !important;
}

.settings-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--bg-glass) !important;
  border: 1px solid var(--accent) !important;
  color: var(--accent) !important;
}

.settings-btn:hover {
  background: var(--accent) !important;
  color: white !important;
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
  align-items: flex-start;
  margin-bottom: 28px;
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

.page-stats {
  padding: 16px 24px;
}

.stat {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stat-value {
  font-size: 28px;
  font-weight: 800;
  color: var(--accent);
}

.stat-label {
  font-size: 12px;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Toolbar */
.toolbar {
  margin-bottom: 20px;
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.btn-add {
  display: flex;
  align-items: center;
  gap: 8px;
  height: 44px;
  padding: 0 20px;
  font-weight: 600;
}

.btn-edit {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 44px;
  background: var(--bg-glass) !important;
  border: 1px solid var(--accent) !important;
  color: var(--accent) !important;
}

.btn-edit:hover:not(:disabled) {
  background: var(--accent) !important;
  color: white !important;
}

.btn-edit:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-delete {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 44px;
  background: var(--bg-glass) !important;
  border: 1px solid var(--danger) !important;
  color: var(--danger) !important;
}

.btn-delete:hover:not(:disabled) {
  background: var(--danger) !important;
  color: white !important;
}

.btn-delete:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-refresh {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 44px;
}

/* Table Card */
.table-card {
  overflow: hidden;
}

.data-table {
  border-radius: var(--radius-lg);
}

/* Custom Radio */
.radio-cell {
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
}

.custom-radio {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 2px solid var(--border-glass-strong);
  background: var(--bg-glass);
  transition: var(--transition);
}

.custom-radio:hover {
  border-color: var(--accent);
}

.custom-radio.is-checked {
  border-color: var(--accent);
  background: var(--accent);
}

.radio-inner {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: transparent;
  transition: var(--transition);
}

.custom-radio.is-checked .radio-inner {
  background: white;
}

/* Selected row highlight */
:deep(.el-table__body tr.current-row > td) {
  background: var(--bg-glass-strong) !important;
}

/* Fixed columns background - solid to prevent text bleeding */
:deep(.el-table__fixed),
:deep(.el-table__fixed-left),
:deep(.el-table__fixed-right) {
  background: var(--bg-solid) !important;
}

:deep(.el-table-fixed-column--left) {
  background: var(--bg-solid) !important;
}

:deep(.el-table__header .el-table-fixed-column--left) {
  background: var(--bg-solid) !important;
}

:deep(.el-table--striped .el-table__body tr.el-table__row--striped .el-table-fixed-column--left) {
  background: var(--bg-solid) !important;
  opacity: 0.95;
}

:deep(.el-table__body tr:hover .el-table-fixed-column--left) {
  background: var(--bg-solid) !important;
}

/* Status Badges */
.status-badge {
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  display: inline-block;
}

.status-active {
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.2) 0%, rgba(16, 185, 129, 0.1) 100%);
  color: #10b981;
  border: 1px solid rgba(16, 185, 129, 0.3);
}

.status-bench {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.2) 0%, rgba(245, 158, 11, 0.1) 100%);
  color: #f59e0b;
  border: 1px solid rgba(245, 158, 11, 0.3);
}

.status-vacation {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.2) 0%, rgba(59, 130, 246, 0.1) 100%);
  color: #3b82f6;
  border: 1px solid rgba(59, 130, 246, 0.3);
}

.status-sick {
  background: linear-gradient(135deg, rgba(236, 72, 153, 0.2) 0%, rgba(236, 72, 153, 0.1) 100%);
  color: #ec4899;
  border: 1px solid rgba(236, 72, 153, 0.3);
}

/* Pagination */
.pagination-wrapper {
  padding: 20px 24px;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid var(--border-glass);
}

/* Responsive */
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
  }

  .page-title h1 {
    font-size: 24px;
  }

  .toolbar {
    flex-wrap: wrap;
  }
}
</style>
