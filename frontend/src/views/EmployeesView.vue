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
const filterDialogVisible = ref(false)
const activeFilters = ref({})
const dateConditions = ref({})
const exportLoading = ref(false)
const exportDialogVisible = ref(false)

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

// Вычисление активных полей для фильтрации
const filterableColumns = computed(() => {
  const fixed = [
    { name: 'fullName', displayName: 'ФИО', fieldType: 'TEXT' },
    { name: 'email', displayName: 'Email', fieldType: 'TEXT' }
  ]
  return [...fixed, ...columnsStore.columns]
})

// Количество активных фильтров
const activeFilterCount = computed(() => {
  return Object.values(activeFilters.value).filter(v => v && v.length > 0).length
})

// Общее количество страниц
const totalPages = computed(() => {
  return Math.ceil(pagination.value.total / pagination.value.size)
})

async function fetchEmployees() {
  loading.value = true
  try {
    const params = {
      page: pagination.value.page,
      size: pagination.value.size
    }

    // Добавляем фильтры
    const customFields = {}
    const dateFilters = {}

    for (const [key, value] of Object.entries(activeFilters.value)) {
      if (!value || (Array.isArray(value) && value.length === 0)) continue

      const col = filterableColumns.value.find(c => c.name === key)
      if (!col) continue

      if (key === 'fullName' || key === 'email') {
        params[key] = Array.isArray(value) ? value.join(',') : value
      } else if (col.fieldType === 'DATE') {
        const condition = dateConditions.value[key] || 'equals'
        dateFilters[key] = `${condition}:${value}`
      } else {
        customFields[key] = Array.isArray(value) ? value.join(',') : value
      }
    }

    if (Object.keys(customFields).length > 0) {
      for (const [k, v] of Object.entries(customFields)) {
        params[`customFields[${k}]`] = v
      }
    }
    if (Object.keys(dateFilters).length > 0) {
      for (const [k, v] of Object.entries(dateFilters)) {
        params[`dateFilters[${k}]`] = v
      }
    }

    const response = await employeesApi.getAll(params)
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

function openFilterDialog() {
  filterDialogVisible.value = true
}

function applyFilters() {
  filterDialogVisible.value = false
  pagination.value.page = 0
  fetchEmployees()
}

function clearFilters() {
  activeFilters.value = {}
  dateConditions.value = {}
  filterDialogVisible.value = false
  pagination.value.page = 0
  fetchEmployees()
}

function openExportDialog() {
  exportDialogVisible.value = true
}

async function handleExport(exportAll) {
  exportLoading.value = true
  exportDialogVisible.value = false
  try {
    const params = { all: exportAll }

    if (!exportAll) {
      // Применяем текущие фильтры
      for (const [key, value] of Object.entries(activeFilters.value)) {
        if (!value || (Array.isArray(value) && value.length === 0)) continue

        const col = filterableColumns.value.find(c => c.name === key)
        if (!col) continue

        if (key === 'fullName' || key === 'email') {
          params[key] = Array.isArray(value) ? value.join(',') : value
        } else if (col.fieldType === 'DATE') {
          const condition = dateConditions.value[key] || 'equals'
          params[`dateFilters[${key}]`] = `${condition}:${value}`
        } else {
          params[`customFields[${key}]`] = Array.isArray(value) ? value.join(',') : value
        }
      }
    }

    const response = await employeesApi.export(params)

    // Скачиваем файл
    const blob = new Blob([response.data], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url

    // Извлекаем имя файла из заголовка или генерируем
    const contentDisposition = response.headers['content-disposition']
    let filename = 'employees.xlsx'
    if (contentDisposition) {
      const match = contentDisposition.match(/filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/)
      if (match) filename = match[1].replace(/['"]/g, '')
    }
    link.download = filename

    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)

    ElMessage.success('Файл успешно выгружен')
  } catch (error) {
    ElMessage.error('Ошибка экспорта')
  } finally {
    exportLoading.value = false
  }
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
        <el-button class="btn-filter" :class="{ 'has-filters': activeFilterCount > 0 }" @click="openFilterDialog">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/>
          </svg>
          <span>Фильтр</span>
          <span v-if="activeFilterCount > 0" class="filter-badge">{{ activeFilterCount }}</span>
        </el-button>
        <el-button class="btn-export" :loading="exportLoading" @click="openExportDialog">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
          </svg>
          <span>Экспорт</span>
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

        <!-- Custom Pagination -->
        <div class="pagination-wrapper">
          <div class="custom-pagination">
            <span class="pagination-total">Всего {{ pagination.total }}</span>

            <el-select
              v-model="pagination.size"
              class="pagination-size"
              popper-class="pagination-size-dropdown"
              @change="handleSizeChange"
            >
              <el-option :value="4" label="4 на стр." />
              <el-option :value="8" label="8 на стр." />
              <el-option :value="12" label="12 на стр." />
              <el-option :value="20" label="20 на стр." />
            </el-select>

            <div class="pagination-pages">
              <button
                class="page-btn"
                :disabled="pagination.page === 0"
                @click="handlePageChange(pagination.page)"
              >
                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                  <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/>
                </svg>
              </button>

              <button
                class="page-btn"
                :class="{ active: pagination.page === 0 }"
                @click="handlePageChange(1)"
              >1</button>

              <button
                v-if="totalPages > 1"
                class="page-btn"
                :class="{ active: pagination.page === 1 }"
                @click="handlePageChange(2)"
              >2</button>

              <span v-if="totalPages > 4" class="page-dots">...</span>

              <button
                v-if="totalPages > 3"
                class="page-btn"
                :class="{ active: pagination.page === totalPages - 2 }"
                @click="handlePageChange(totalPages - 1)"
              >{{ totalPages - 1 }}</button>

              <button
                v-if="totalPages > 2"
                class="page-btn"
                :class="{ active: pagination.page === totalPages - 1 }"
                @click="handlePageChange(totalPages)"
              >{{ totalPages }}</button>

              <button
                class="page-btn"
                :disabled="pagination.page >= totalPages - 1"
                @click="handlePageChange(pagination.page + 2)"
              >
                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                  <path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"/>
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Dialog -->
    <EmployeeDialog
      v-model:visible="dialogVisible"
      :employee="editingEmployee"
      @close="handleDialogClose"
    />

    <!-- Filter Dialog -->
    <el-dialog
      v-model="filterDialogVisible"
      title="Фильтры"
      width="500px"
      class="filter-dialog"
    >
      <div class="filter-form">
        <div v-for="col in filterableColumns" :key="col.name" class="filter-field">
          <label class="filter-label">{{ col.displayName }}</label>

          <!-- TEXT и NUMBER поля -->
          <el-input
            v-if="col.fieldType === 'TEXT' || col.fieldType === 'NUMBER'"
            v-model="activeFilters[col.name]"
            :placeholder="`Введите ${col.displayName.toLowerCase()}`"
            clearable
          />

          <!-- SELECT поля с выбором из справочника -->
          <el-select
            v-else-if="col.fieldType === 'SELECT'"
            v-model="activeFilters[col.name]"
            :placeholder="`Выберите ${col.displayName.toLowerCase()}`"
            clearable
            multiple
            collapse-tags
            collapse-tags-tooltip
          >
            <el-option
              v-for="opt in columnsStore.getDictionaryValues(col.dictionaryId)"
              :key="opt"
              :label="opt"
              :value="opt"
            />
          </el-select>

          <!-- DATE поля с условием -->
          <div v-else-if="col.fieldType === 'DATE'" class="date-filter-group">
            <el-select
              v-model="dateConditions[col.name]"
              placeholder="Условие"
              class="date-condition"
            >
              <el-option label="Равно" value="equals" />
              <el-option label="Ранее" value="before" />
              <el-option label="Позже" value="after" />
            </el-select>
            <el-date-picker
              v-model="activeFilters[col.name]"
              type="date"
              placeholder="Выберите дату"
              format="DD.MM.YYYY"
              value-format="YYYY-MM-DD"
              class="date-picker"
            />
          </div>
        </div>
      </div>

      <template #footer>
        <div class="filter-actions">
          <el-button @click="clearFilters">Сбросить</el-button>
          <el-button type="primary" @click="applyFilters">Применить</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- Export Dialog -->
    <el-dialog
      v-model="exportDialogVisible"
      title="Экспорт в Excel"
      width="400px"
      class="export-dialog"
    >
      <div class="export-options">
        <p class="export-description">Выберите, какие данные выгрузить:</p>
        <div class="export-buttons">
          <el-button
            type="primary"
            size="large"
            @click="handleExport(false)"
            :disabled="activeFilterCount === 0"
          >
            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
              <path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/>
            </svg>
            <span>По фильтру ({{ pagination.total }})</span>
          </el-button>
          <el-button
            size="large"
            @click="handleExport(true)"
          >
            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
              <path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9h-4v4h-2v-4H9V9h4V5h2v4h4v2z"/>
            </svg>
            <span>Все записи</span>
          </el-button>
        </div>
        <p v-if="activeFilterCount === 0" class="export-hint">
          Для экспорта по фильтру сначала установите фильтры
        </p>
      </div>
    </el-dialog>
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

/* Filter Button */
.btn-filter {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 44px;
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-glass-strong) !important;
  color: var(--text-primary) !important;
  position: relative;
}

.btn-filter:hover {
  border-color: var(--accent) !important;
  color: var(--accent) !important;
}

.btn-filter.has-filters {
  border-color: var(--accent) !important;
  background: rgba(124, 58, 237, 0.1) !important;
}

.filter-badge {
  position: absolute;
  top: -6px;
  right: -6px;
  min-width: 20px;
  height: 20px;
  padding: 0 6px;
  border-radius: 10px;
  background: var(--accent);
  color: white;
  font-size: 11px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Filter Dialog */
.filter-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.filter-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.filter-label {
  font-size: 13px;
  font-weight: 500;
  color: var(--text-secondary);
}

.date-filter-group {
  display: flex;
  gap: 8px;
}

.date-condition {
  width: 120px;
  flex-shrink: 0;
}

.date-picker {
  flex: 1;
}

.filter-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* Export Button */
.btn-export {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 44px;
  background: var(--bg-glass) !important;
  border: 1px solid #10b981 !important;
  color: #10b981 !important;
}

.btn-export:hover {
  background: #10b981 !important;
  color: white !important;
}

/* Export Dialog */
.export-options {
  text-align: center;
}

.export-description {
  margin-bottom: 20px;
  color: var(--text-secondary);
}

.export-buttons {
  display: flex;
  flex-direction: row;
  gap: 12px;
  justify-content: center;
}

.export-buttons .el-button {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.export-hint {
  margin-top: 16px;
  font-size: 13px;
  color: var(--text-muted);
}

/* Custom Pagination */
.custom-pagination {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 16px;
}

.pagination-total {
  color: var(--text-primary);
  font-size: 14px;
}

.pagination-size {
  width: 120px;
}

.pagination-size :deep(.el-input__wrapper) {
  background: rgba(40, 40, 60, 0.95) !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
  box-shadow: none !important;
}

.pagination-size :deep(.el-input__wrapper *) {
  color: #ffffff !important;
  -webkit-text-fill-color: #ffffff !important;
}

.pagination-size :deep(.el-input__inner) {
  color: #ffffff !important;
  font-weight: 600 !important;
  -webkit-text-fill-color: #ffffff !important;
  opacity: 1 !important;
}

.pagination-size :deep(.el-select__selected-item) {
  color: #ffffff !important;
  -webkit-text-fill-color: #ffffff !important;
}

.pagination-size :deep(.el-select__placeholder) {
  color: #ffffff !important;
  -webkit-text-fill-color: #ffffff !important;
}

.pagination-size :deep(span) {
  color: #ffffff !important;
  -webkit-text-fill-color: #ffffff !important;
}

.pagination-size :deep(.el-select__suffix) {
  color: #ffffff !important;
}

.pagination-size :deep(.el-select__caret) {
  color: #ffffff !important;
}

.pagination-size :deep(.el-input__suffix-inner) {
  color: #ffffff !important;
}

.pagination-size:hover :deep(.el-input__wrapper) {
  border-color: var(--accent) !important;
  background: rgba(60, 60, 80, 0.95) !important;
}

.pagination-pages {
  display: flex;
  align-items: center;
  gap: 4px;
}

.page-btn {
  min-width: 36px;
  height: 36px;
  padding: 0 8px;
  border: 1px solid var(--border-glass);
  border-radius: 8px;
  background: var(--bg-glass);
  color: var(--text-primary);
  font-size: 14px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.page-btn:hover:not(:disabled) {
  border-color: var(--accent);
  color: var(--accent);
}

.page-btn.active {
  background: var(--accent);
  border-color: var(--accent);
  color: white;
}

.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.page-dots {
  color: var(--text-muted);
  padding: 0 4px;
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

<style>
/* Global styles for pagination dropdown (outside component tree) */
.pagination-size-dropdown {
  background: rgba(30, 30, 50, 0.98) !important;
  border: none !important;
  border-radius: 8px !important;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4) !important;
}

.pagination-size-dropdown .el-select-dropdown__wrap {
  border: none !important;
}

.pagination-size-dropdown .el-select-dropdown__list {
  padding: 6px !important;
}

.pagination-size-dropdown .el-select-dropdown__item {
  color: white !important;
  border-radius: 4px;
}

.pagination-size-dropdown .el-select-dropdown__item:hover,
.pagination-size-dropdown .el-select-dropdown__item.hover {
  background: rgba(124, 58, 237, 0.3) !important;
}

.pagination-size-dropdown .el-select-dropdown__item.selected {
  color: #a78bfa !important;
  font-weight: 600;
  background: rgba(124, 58, 237, 0.2) !important;
}

.pagination-size-dropdown .el-popper__arrow {
  display: none !important;
}
</style>
