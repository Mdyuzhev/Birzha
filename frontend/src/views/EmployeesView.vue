<script setup>
import { ref, onMounted, onUnmounted, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'
import { useColumnsStore } from '@/stores/columns'
import { useNotificationsStore } from '@/stores/notifications'
import { employeesApi } from '@/api/employees'
import { columnPresetsApi } from '@/api/columnPresets'
import { savedFiltersApi } from '@/api/savedFilters'
import { resumesApi } from '@/api/resumes'
import { ElMessage, ElMessageBox } from 'element-plus'
import EmployeeDialog from '@/components/EmployeeDialog.vue'
import draggable from 'vuedraggable'

const router = useRouter()
const authStore = useAuthStore()
const themeStore = useThemeStore()
const columnsStore = useColumnsStore()
const notificationsStore = useNotificationsStore()

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
const columnsSettingsVisible = ref(false)
const columnSettings = ref([])
const historyDialogVisible = ref(false)
const historyLoading = ref(false)
const historyItems = ref([])

// Резюме сотрудников (Map: employeeId -> resume)
const employeeResumes = ref(new Map())
const resumeViewVisible = ref(false)
const viewingResume = ref(null)

// Борды (пресеты колонок)
const presets = ref([])
const selectedPresetId = ref(null)
const newPresetName = ref('')
const presetsLoading = ref(false)

// Сохранённые фильтры
const savedFilters = ref([])
const selectedFilterId = ref(null)
const newFilterName = ref('')
const filtersLoading = ref(false)

// Пагинация - 4 строки на странице
const pagination = ref({
  page: 0,
  size: 4,
  total: 0
})

// Все доступные колонки
const allColumns = computed(() => {
  const fixed = [
    { prop: 'fullName', label: 'ФИО', width: 220, fixed: true, isFixed: true },
    { prop: 'email', label: 'Email', width: 200, isFixed: false }
  ]

  const dynamic = columnsStore.columns.map(col => ({
    prop: `customFields.${col.name}`,
    label: col.displayName,
    width: col.fieldType === 'TEXT' ? 150 : 130,
    fieldType: col.fieldType,
    dictionaryId: col.dictionaryId,
    isFixed: false
  }))

  return [...fixed, ...dynamic]
})

// Колонки с учётом настроек видимости и порядка
const tableColumns = computed(() => {
  if (columnSettings.value.length === 0) {
    return allColumns.value
  }

  // Возвращаем только видимые колонки в заданном порядке
  return columnSettings.value
    .filter(s => s.visible)
    .map(s => allColumns.value.find(c => c.prop === s.prop))
    .filter(Boolean)
})

// Инициализация настроек колонок
function initColumnSettings() {
  const saved = localStorage.getItem('employeeColumnSettings')
  if (saved) {
    try {
      const parsed = JSON.parse(saved)
      // Проверяем актуальность сохранённых настроек
      const allProps = allColumns.value.map(c => c.prop)
      const validSettings = parsed.filter(s => allProps.includes(s.prop))
      // Добавляем новые колонки, которых нет в сохранённых
      const savedProps = validSettings.map(s => s.prop)
      const newColumns = allColumns.value
        .filter(c => !savedProps.includes(c.prop))
        .map(c => ({ prop: c.prop, visible: true }))
      columnSettings.value = [...validSettings, ...newColumns]
    } catch {
      resetColumnSettings()
    }
  } else {
    resetColumnSettings()
  }
}

function resetColumnSettings() {
  columnSettings.value = allColumns.value.map(c => ({
    prop: c.prop,
    visible: true
  }))
}

function saveColumnSettings() {
  localStorage.setItem('employeeColumnSettings', JSON.stringify(columnSettings.value))
  columnsSettingsVisible.value = false
  ElMessage.success('Настройки сохранены')
}

function openColumnsSettings() {
  // Синхронизируем с текущими колонками перед открытием
  initColumnSettings()
  fetchPresets()
  columnsSettingsVisible.value = true
}

function getColumnLabel(prop) {
  const col = allColumns.value.find(c => c.prop === prop)
  return col?.label || prop
}

// Функции для работы с бордами
async function fetchPresets() {
  presetsLoading.value = true
  try {
    const response = await columnPresetsApi.getAll()
    presets.value = response.data
  } catch (error) {
    console.error('Error fetching presets:', error)
  } finally {
    presetsLoading.value = false
  }
}

async function loadPreset(preset) {
  selectedPresetId.value = preset.id
  columnSettings.value = preset.columnConfig.map(c => ({
    prop: c.prop,
    visible: c.visible
  }))
  // Добавляем новые колонки, которых нет в пресете
  const savedProps = columnSettings.value.map(s => s.prop)
  const newColumns = allColumns.value
    .filter(c => !savedProps.includes(c.prop))
    .map(c => ({ prop: c.prop, visible: true }))
  columnSettings.value = [...columnSettings.value, ...newColumns]
  ElMessage.success(`Борд "${preset.name}" загружен`)
}

async function saveAsPreset() {
  if (!newPresetName.value.trim()) {
    ElMessage.warning('Введите название борда')
    return
  }

  try {
    const data = {
      name: newPresetName.value.trim(),
      columnConfig: columnSettings.value.map(c => ({
        prop: c.prop,
        visible: c.visible
      })),
      isDefault: false
    }

    await columnPresetsApi.create(data)
    ElMessage.success(`Борд "${newPresetName.value}" сохранён`)
    newPresetName.value = ''
    await fetchPresets()
  } catch (error) {
    const message = error.response?.data?.message || 'Ошибка сохранения'
    ElMessage.error(message)
  }
}

async function updatePreset(preset) {
  try {
    const data = {
      name: preset.name,
      columnConfig: columnSettings.value.map(c => ({
        prop: c.prop,
        visible: c.visible
      })),
      isDefault: preset.isDefault
    }

    await columnPresetsApi.update(preset.id, data)
    ElMessage.success(`Борд "${preset.name}" обновлён`)
    await fetchPresets()
  } catch (error) {
    const message = error.response?.data?.message || 'Ошибка обновления'
    ElMessage.error(message)
  }
}

async function deletePreset(preset) {
  try {
    await ElMessageBox.confirm(
      `Удалить борд "${preset.name}"?`,
      'Подтверждение',
      { type: 'warning' }
    )
    await columnPresetsApi.delete(preset.id)
    ElMessage.success('Борд удалён')
    if (selectedPresetId.value === preset.id) {
      selectedPresetId.value = null
    }
    await fetchPresets()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('Ошибка удаления')
    }
  }
}

async function setDefaultPreset(preset) {
  try {
    await columnPresetsApi.setDefault(preset.id)
    ElMessage.success(`Борд "${preset.name}" установлен по умолчанию`)
    await fetchPresets()
  } catch (error) {
    ElMessage.error('Ошибка установки по умолчанию')
  }
}

async function togglePresetGlobal(preset) {
  if (!preset.isOwner) {
    ElMessage.warning('Только владелец может изменять глобальность борда')
    return
  }
  try {
    await columnPresetsApi.toggleGlobal(preset.id)
    ElMessage.success(preset.isGlobal ? 'Борд теперь личный' : 'Борд теперь глобальный')
    await fetchPresets()
  } catch (error) {
    ElMessage.error('Ошибка изменения глобальности')
  }
}

// Функции для работы с сохранёнными фильтрами
async function fetchSavedFilters() {
  filtersLoading.value = true
  try {
    const response = await savedFiltersApi.getAll()
    savedFilters.value = response.data
  } catch (error) {
    console.error('Error fetching saved filters:', error)
  } finally {
    filtersLoading.value = false
  }
}

async function loadSavedFilter(filter) {
  selectedFilterId.value = filter.id
  activeFilters.value = { ...filter.filterConfig.activeFilters } || {}
  dateConditions.value = { ...filter.filterConfig.dateConditions } || {}
  filterDialogVisible.value = false
  pagination.value.page = 0
  await fetchEmployees()
  ElMessage.success(`Фильтр "${filter.name}" загружен`)
}

async function saveAsFilter() {
  if (!newFilterName.value.trim()) {
    ElMessage.warning('Введите название фильтра')
    return
  }

  try {
    const data = {
      name: newFilterName.value.trim(),
      filterConfig: {
        activeFilters: { ...activeFilters.value },
        dateConditions: { ...dateConditions.value }
      },
      isDefault: false,
      isGlobal: false
    }

    await savedFiltersApi.create(data)
    ElMessage.success(`Фильтр "${newFilterName.value}" сохранён`)
    newFilterName.value = ''
    await fetchSavedFilters()
  } catch (error) {
    const message = error.response?.data?.message || 'Ошибка сохранения'
    ElMessage.error(message)
  }
}

async function deleteSavedFilter(filter) {
  if (!filter.isOwner) {
    ElMessage.warning('Только владелец может удалить фильтр')
    return
  }
  try {
    await ElMessageBox.confirm(
      `Удалить фильтр "${filter.name}"?`,
      'Подтверждение',
      { type: 'warning' }
    )
    await savedFiltersApi.delete(filter.id)
    ElMessage.success('Фильтр удалён')
    if (selectedFilterId.value === filter.id) {
      selectedFilterId.value = null
    }
    await fetchSavedFilters()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('Ошибка удаления')
    }
  }
}

async function toggleFilterGlobal(filter) {
  if (!filter.isOwner) {
    ElMessage.warning('Только владелец может изменять глобальность фильтра')
    return
  }
  try {
    await savedFiltersApi.toggleGlobal(filter.id)
    ElMessage.success(filter.isGlobal ? 'Фильтр теперь личный' : 'Фильтр теперь глобальный')
    await fetchSavedFilters()
  } catch (error) {
    ElMessage.error('Ошибка изменения глобальности')
  }
}

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

async function handleLogout() {
  await authStore.logout()
  router.push('/login')
}

function goToAdmin() {
  router.push('/admin')
}

function goToAnalytics() {
  router.push('/analytics')
}

function goToApplications() {
  router.push('/applications')
}

function goToNineBox() {
  router.push('/nine-box')
}

function goToResumes() {
  router.push('/resumes')
}

async function openHistoryDialog() {
  historyDialogVisible.value = true
  historyLoading.value = true
  notificationsStore.markAsSeen()
  try {
    const response = await employeesApi.getRecentHistory(15)
    historyItems.value = response.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки журнала')
  } finally {
    historyLoading.value = false
  }
}

function formatDate(dateStr) {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleString('ru-RU', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const fieldNameMap = {
  fullName: 'ФИО',
  email: 'Email',
  status: 'Статус',
  department: 'Отдел',
  position: 'Должность',
  grade: 'Грейд',
  location: 'Локация',
  hire_date: 'Дата найма',
  project: 'Проект',
  skills: 'Навыки',
  mentor: 'Ментор',
  salary: 'Зарплата'
}

function getFieldDisplayName(fieldName) {
  return fieldNameMap[fieldName] || fieldName
}

function openFilterDialog() {
  fetchSavedFilters()
  filterDialogVisible.value = true
}

function applyFilters() {
  selectedFilterId.value = null
  filterDialogVisible.value = false
  pagination.value.page = 0
  fetchEmployees()
}

function clearFilters() {
  activeFilters.value = {}
  dateConditions.value = {}
  selectedFilterId.value = null
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

async function fetchResumes() {
  try {
    const response = await resumesApi.getAll()
    const resumesMap = new Map()
    for (const resume of response.data) {
      resumesMap.set(resume.employeeId, resume)
    }
    employeeResumes.value = resumesMap
  } catch (error) {
    console.error('Error fetching resumes:', error)
  }
}

function hasResume(employeeId) {
  return employeeResumes.value.has(employeeId)
}

function getResumeId(employeeId) {
  return employeeResumes.value.get(employeeId)?.id
}

function openResumeView(employeeId) {
  const resume = employeeResumes.value.get(employeeId)
  if (resume) {
    viewingResume.value = resume
    resumeViewVisible.value = true
  }
}

async function exportResumePdf(resume) {
  try {
    const response = await resumesApi.exportPdf(resume.id)
    const blob = new Blob([response.data], { type: 'application/pdf' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `${resume.employeeName || 'resume'}.pdf`
    link.click()
    window.URL.revokeObjectURL(url)
  } catch (error) {
    ElMessage.error('Ошибка экспорта PDF')
  }
}

function isResumeColumn(col) {
  return col.label === 'Резюме' || col.prop === 'customFields.resume'
}

onMounted(async () => {
  await columnsStore.fetchColumns()
  initColumnSettings()
  await Promise.all([fetchEmployees(), fetchResumes()])
  notificationsStore.startPolling()
})

onUnmounted(() => {
  notificationsStore.stopPolling()
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
        <!-- History Bell -->
        <button class="bell-btn" @click="openHistoryDialog">
          <svg viewBox="0 0 24 24" fill="currentColor" width="22" height="22">
            <path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/>
          </svg>
          <span v-if="notificationsStore.newCount > 0" class="bell-badge">{{ notificationsStore.newCount }}</span>
        </button>
        <!-- Analytics -->
        <el-button class="header-btn" @click="goToAnalytics">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
          </svg>
          <span>Аналитика</span>
        </el-button>
        <!-- Applications -->
        <el-button class="header-btn" @click="goToApplications">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/>
          </svg>
          <span>Заявки</span>
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
        <el-button class="btn-columns" @click="openColumnsSettings">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M3 5h18v2H3V5zm0 6h18v2H3v-2zm0 6h18v2H3v-2z"/>
          </svg>
          <span>Данные</span>
        </el-button>
        <el-button class="btn-nine-box" @click="goToNineBox">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <rect x="2" y="2" width="5" height="5" rx="1"/>
            <rect x="9" y="2" width="5" height="5" rx="1"/>
            <rect x="16" y="2" width="5" height="5" rx="1"/>
            <rect x="2" y="9" width="5" height="5" rx="1"/>
            <rect x="9" y="9" width="5" height="5" rx="1"/>
            <rect x="16" y="9" width="5" height="5" rx="1"/>
            <rect x="2" y="16" width="5" height="5" rx="1"/>
            <rect x="9" y="16" width="5" height="5" rx="1"/>
            <rect x="16" y="16" width="5" height="5" rx="1"/>
          </svg>
          <span>9 Boxes</span>
        </el-button>
        <el-button class="btn-resumes" @click="goToResumes">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M14 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/>
          </svg>
          <span>Резюме</span>
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
            :show-overflow-tooltip="!isResumeColumn(col)"
          >
            <template #default="{ row }">
              <!-- Колонка Резюме - специальный рендер -->
              <template v-if="isResumeColumn(col)">
                <button
                  v-if="hasResume(row.id)"
                  class="resume-btn"
                  @click.stop="openResumeView(row.id)"
                >
                  Резюме
                </button>
                <span v-else class="resume-missing">ОТСУТСТВУЕТ</span>
              </template>
              <!-- Остальные колонки -->
              <span v-else :class="getStatusClass(col.prop, getNestedValue(row, col.prop))">
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

    <!-- Resume View Dialog -->
    <el-dialog
      v-model="resumeViewVisible"
      :title="viewingResume?.employeeName || 'Просмотр резюме'"
      width="800px"
      class="resume-view-dialog"
      destroy-on-close
    >
      <div v-if="viewingResume" class="resume-view">
        <div class="view-header">
          <div class="view-avatar">
            {{ viewingResume.employeeName?.charAt(0) || '?' }}
          </div>
          <div class="view-info">
            <h2>{{ viewingResume.employeeName }}</h2>
            <p class="view-position">{{ viewingResume.position || 'Должность не указана' }}</p>
            <p class="view-email">{{ viewingResume.employeeEmail }}</p>
          </div>
        </div>

        <div v-if="viewingResume.summary" class="view-section">
          <h3>О себе</h3>
          <p>{{ viewingResume.summary }}</p>
        </div>

        <div v-if="viewingResume.skills?.length" class="view-section">
          <h3>Ключевые навыки</h3>
          <div class="view-skills">
            <div v-for="(skill, idx) in viewingResume.skills" :key="idx" class="view-skill">
              <span class="skill-name">{{ skill.name }}</span>
              <span class="skill-level">{{ skill.level }}</span>
              <span v-if="skill.years" class="skill-years">{{ skill.years }} лет</span>
            </div>
          </div>
        </div>

        <div v-if="viewingResume.experience?.length" class="view-section">
          <h3>Опыт работы</h3>
          <div v-for="(exp, idx) in viewingResume.experience" :key="idx" class="view-experience">
            <div class="exp-company">{{ exp.company }}</div>
            <div class="exp-position-date">
              <span>{{ exp.position }}</span>
              <span class="exp-period">{{ exp.startDate }} - {{ exp.endDate || 'по настоящее время' }}</span>
            </div>
            <p v-if="exp.description" class="exp-description">{{ exp.description }}</p>
          </div>
        </div>

        <div v-if="viewingResume.education?.length" class="view-section">
          <h3>Образование</h3>
          <div v-for="(edu, idx) in viewingResume.education" :key="idx" class="view-education">
            <div class="edu-institution">{{ edu.institution }} <span v-if="edu.year">({{ edu.year }})</span></div>
            <div class="edu-degree">{{ edu.degree }}<span v-if="edu.field">, {{ edu.field }}</span></div>
          </div>
        </div>

        <div v-if="viewingResume.languages?.length" class="view-section">
          <h3>Языки</h3>
          <div class="view-languages">
            <div v-for="(lang, idx) in viewingResume.languages" :key="idx" class="view-lang">
              <span class="lang-name">{{ lang.language }}</span>
              <span class="lang-level">{{ lang.level }}</span>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <el-button @click="resumeViewVisible = false">Закрыть</el-button>
        <el-button type="primary" @click="exportResumePdf(viewingResume)">
          Скачать PDF
        </el-button>
      </template>
    </el-dialog>

    <!-- Filter Dialog -->
    <el-dialog
      v-model="filterDialogVisible"
      title="Фильтры"
      width="550px"
      class="filter-dialog"
    >
      <!-- Сохранённые фильтры -->
      <div class="saved-filters-section">
        <div class="saved-filters-header">
          <span class="saved-filters-title">Сохранённые фильтры</span>
          <el-button size="small" text :loading="filtersLoading" @click="fetchSavedFilters">
            <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
              <path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/>
            </svg>
          </el-button>
        </div>

        <div v-if="savedFilters.length > 0" class="saved-filters-list">
          <div
            v-for="filter in savedFilters"
            :key="filter.id"
            class="saved-filter-item"
            :class="{ 'filter-active': selectedFilterId === filter.id }"
          >
            <div class="saved-filter-info" @click="loadSavedFilter(filter)">
              <span class="saved-filter-name">{{ filter.name }}</span>
              <span v-if="filter.isGlobal" class="global-badge">Global</span>
              <span v-if="!filter.isOwner" class="owner-badge">{{ filter.ownerName }}</span>
            </div>
            <div class="saved-filter-actions" v-if="filter.isOwner">
              <el-button
                size="small"
                text
                :title="filter.isGlobal ? 'Сделать личным' : 'Сделать глобальным'"
                @click.stop="toggleFilterGlobal(filter)"
              >
                <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/>
                </svg>
              </el-button>
              <el-button
                size="small"
                text
                type="danger"
                title="Удалить"
                @click.stop="deleteSavedFilter(filter)"
              >
                <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
                  <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                </svg>
              </el-button>
            </div>
          </div>
        </div>
        <div v-else class="saved-filters-empty">
          Нет сохранённых фильтров
        </div>

        <!-- Сохранить как фильтр -->
        <div v-if="activeFilterCount > 0" class="save-filter-form">
          <el-input
            v-model="newFilterName"
            placeholder="Название фильтра"
            size="small"
            @keyup.enter="saveAsFilter"
          />
          <el-button type="primary" size="small" @click="saveAsFilter" :disabled="!newFilterName.trim()">
            Сохранить
          </el-button>
        </div>
      </div>

      <el-divider />

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

    <!-- Column Settings Dialog -->
    <el-dialog
      v-model="columnsSettingsVisible"
      title="Настройка колонок"
      width="550px"
      class="columns-settings-dialog"
    >
      <!-- Борды (пресеты) -->
      <div class="presets-section">
        <div class="presets-header">
          <span class="presets-title">Сохранённые борды</span>
          <el-button size="small" text :loading="presetsLoading" @click="fetchPresets">
            <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
              <path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/>
            </svg>
          </el-button>
        </div>

        <div v-if="presets.length > 0" class="presets-list">
          <div
            v-for="preset in presets"
            :key="preset.id"
            class="preset-item"
            :class="{ 'preset-active': selectedPresetId === preset.id }"
          >
            <div class="preset-info" @click="loadPreset(preset)">
              <span class="preset-name">{{ preset.name }}</span>
              <span v-if="preset.isDefault" class="preset-default-badge">По умолчанию</span>
              <span v-if="preset.isGlobal" class="global-badge">Global</span>
              <span v-if="!preset.isOwner" class="owner-badge">{{ preset.ownerName }}</span>
            </div>
            <div class="preset-actions" v-if="preset.isOwner">
              <el-button
                size="small"
                text
                title="Обновить текущими настройками"
                @click.stop="updatePreset(preset)"
              >
                <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
                  <path d="M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/>
                </svg>
              </el-button>
              <el-button
                size="small"
                text
                :title="preset.isGlobal ? 'Сделать личным' : 'Сделать глобальным'"
                @click.stop="togglePresetGlobal(preset)"
              >
                <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/>
                </svg>
              </el-button>
              <el-button
                v-if="!preset.isDefault"
                size="small"
                text
                title="Сделать по умолчанию"
                @click.stop="setDefaultPreset(preset)"
              >
                <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
                  <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                </svg>
              </el-button>
              <el-button
                size="small"
                text
                type="danger"
                title="Удалить"
                @click.stop="deletePreset(preset)"
              >
                <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
                  <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                </svg>
              </el-button>
            </div>
          </div>
        </div>
        <div v-else class="presets-empty">
          Нет сохранённых бордов
        </div>

        <!-- Сохранить новый борд -->
        <div class="save-preset-form">
          <el-input
            v-model="newPresetName"
            placeholder="Название нового борда"
            size="small"
            @keyup.enter="saveAsPreset"
          />
          <el-button type="primary" size="small" @click="saveAsPreset" :disabled="!newPresetName.trim()">
            Сохранить как борд
          </el-button>
        </div>
      </div>

      <el-divider />

      <p class="columns-hint">Перетащите для изменения порядка. Чем выше — тем левее в таблице.</p>
      <draggable
        v-model="columnSettings"
        item-key="prop"
        handle=".drag-handle"
        ghost-class="column-ghost"
        class="columns-list"
      >
        <template #item="{ element }">
          <div class="column-item">
            <span class="drag-handle">
              <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
                <path d="M11 18c0 1.1-.9 2-2 2s-2-.9-2-2 .9-2 2-2 2 .9 2 2zm-2-8c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0-6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm6 4c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>
              </svg>
            </span>
            <el-checkbox v-model="element.visible" class="column-checkbox">
              {{ getColumnLabel(element.prop) }}
            </el-checkbox>
          </div>
        </template>
      </draggable>
      <template #footer>
        <div class="columns-actions">
          <el-button @click="resetColumnSettings">Сбросить</el-button>
          <el-button type="primary" @click="saveColumnSettings">Сохранить</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- History Dialog -->
    <el-dialog
      v-model="historyDialogVisible"
      title="Журнал изменений"
      width="700px"
      class="history-dialog"
    >
      <div v-loading="historyLoading" class="history-content">
        <div v-if="historyItems.length === 0 && !historyLoading" class="history-empty">
          Нет записей об изменениях
        </div>
        <div v-else class="history-list">
          <div
            v-for="item in historyItems"
            :key="item.id"
            class="history-item"
          >
            <div class="history-header">
              <span class="history-author">{{ item.changedBy }}</span>
              <span class="history-date">{{ formatDate(item.changedAt) }}</span>
            </div>
            <div class="history-employee">
              <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
              </svg>
              <span>{{ item.employeeFullName }}</span>
            </div>
            <div class="history-change">
              <span class="history-field">{{ getFieldDisplayName(item.fieldName) }}:</span>
              <span class="history-old">{{ item.oldValue || '—' }}</span>
              <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16" class="history-arrow">
                <path d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z"/>
              </svg>
              <span class="history-new">{{ item.newValue || '—' }}</span>
            </div>
          </div>
        </div>
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

/* Bell Button */
.bell-btn {
  position: relative;
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  color: var(--text-primary);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.bell-btn:hover {
  background: var(--bg-glass-strong);
  border-color: var(--accent);
  color: var(--accent);
  transform: scale(1.05);
}

.bell-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 20px;
  height: 20px;
  padding: 0 6px;
  border-radius: 10px;
  background: linear-gradient(135deg, #ef4444, #f87171);
  color: white;
  font-size: 11px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(239, 68, 68, 0.4);
  animation: bellPulse 2s ease-in-out infinite;
}

@keyframes bellPulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
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
  margin-bottom: 12px;
  padding: 16px 20px;
  background: var(--bg-glass);
  backdrop-filter: blur(20px);
  border-radius: 16px;
  border: 1px solid var(--border-color);
  position: sticky;
  top: 80px;
  z-index: 90;
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
  padding: 12px 16px;
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  background: var(--bg-glass);
  backdrop-filter: blur(20px);
  border-radius: 16px;
  border: 1px solid var(--border-color);
  position: sticky;
  top: 196px;
  z-index: 80;
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

/* History Dialog */
.history-content {
  min-height: 200px;
  max-height: 500px;
  overflow-y: auto;
}

.history-empty {
  text-align: center;
  color: var(--text-muted);
  padding: 40px;
}

.history-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.history-item {
  background: rgba(30, 30, 50, 0.9);
  border: 1px solid rgba(124, 58, 237, 0.2);
  border-radius: 12px;
  padding: 14px 16px;
}

.history-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.history-author {
  font-weight: 600;
  color: var(--accent);
}

.history-date {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}

.history-employee {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #fff;
  margin-bottom: 8px;
}

.history-employee svg {
  color: rgba(255, 255, 255, 0.5);
}

.history-change {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
  font-size: 13px;
}

.history-field {
  color: rgba(255, 255, 255, 0.7);
  font-weight: 500;
}

.history-old {
  color: var(--danger);
  background: rgba(239, 68, 68, 0.1);
  padding: 2px 8px;
  border-radius: 4px;
}

.history-arrow {
  color: rgba(255, 255, 255, 0.5);
}

.history-new {
  color: var(--success);
  background: rgba(16, 185, 129, 0.1);
  padding: 2px 8px;
  border-radius: 4px;
}

/* Column Settings Button */
.btn-columns {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 44px;
  background: var(--bg-glass) !important;
  border: 1px solid #8b5cf6 !important;
  color: #8b5cf6 !important;
}

.btn-columns:hover {
  background: #8b5cf6 !important;
  color: white !important;
}

/* 9-Box Button */
.btn-nine-box {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 44px;
  background: var(--bg-glass) !important;
  border: 1px solid #f59e0b !important;
  color: #f59e0b !important;
}

.btn-nine-box:hover {
  background: #f59e0b !important;
  color: white !important;
}

/* Resumes Button */
.btn-resumes {
  display: flex;
  align-items: center;
  gap: 6px;
  height: 44px;
  background: var(--bg-glass) !important;
  border: 1px solid #10b981 !important;
  color: #10b981 !important;
}

.btn-resumes:hover {
  background: #10b981 !important;
  color: white !important;
}

/* Column Settings Modal */
.columns-hint {
  color: var(--text-secondary);
  font-size: 13px;
  margin-bottom: 16px;
}

.columns-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 400px;
  overflow-y: auto;
}

.column-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: rgba(30, 30, 50, 0.8);
  border: 1px solid rgba(124, 58, 237, 0.2);
  border-radius: 10px;
  transition: all 0.2s ease;
}

.column-item:hover {
  border-color: rgba(124, 58, 237, 0.4);
  background: rgba(40, 40, 60, 0.9);
}

.drag-handle {
  cursor: grab;
  color: var(--text-muted);
  display: flex;
  align-items: center;
  padding: 4px;
  border-radius: 4px;
  transition: all 0.2s;
}

.drag-handle:hover {
  color: var(--accent);
  background: rgba(124, 58, 237, 0.1);
}

.drag-handle:active {
  cursor: grabbing;
}

.column-checkbox {
  flex: 1;
}

.column-checkbox :deep(.el-checkbox__label) {
  color: var(--text-primary);
  font-size: 14px;
}

.column-ghost {
  opacity: 0.5;
  background: rgba(124, 58, 237, 0.2) !important;
  border-color: var(--accent) !important;
}

.columns-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* Presets Section */
.presets-section {
  margin-bottom: 8px;
}

.presets-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.presets-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}

.presets-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 180px;
  overflow-y: auto;
  margin-bottom: 12px;
}

.preset-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 14px;
  background: rgba(30, 30, 50, 0.6);
  border: 1px solid rgba(124, 58, 237, 0.15);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.preset-item:hover {
  border-color: rgba(124, 58, 237, 0.4);
  background: rgba(40, 40, 60, 0.8);
}

.preset-item.preset-active {
  border-color: var(--accent);
  background: rgba(124, 58, 237, 0.15);
}

.preset-info {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 1;
}

.preset-name {
  font-size: 14px;
  color: var(--text-primary);
}

.preset-default-badge {
  font-size: 10px;
  padding: 2px 8px;
  border-radius: 10px;
  background: linear-gradient(135deg, #10b981, #34d399);
  color: white;
  font-weight: 600;
}

.global-badge {
  font-size: 10px;
  padding: 2px 8px;
  border-radius: 10px;
  background: linear-gradient(135deg, #3b82f6, #60a5fa);
  color: white;
  font-weight: 600;
}

.owner-badge {
  font-size: 10px;
  padding: 2px 8px;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.1);
  color: var(--text-muted);
  font-weight: 500;
}

.preset-actions {
  display: flex;
  gap: 4px;
}

.preset-actions .el-button {
  padding: 4px 6px !important;
  color: var(--text-muted) !important;
}

.preset-actions .el-button:hover {
  color: var(--accent) !important;
}

.preset-actions .el-button--danger:hover {
  color: var(--danger) !important;
}

.presets-empty {
  text-align: center;
  color: var(--text-muted);
  font-size: 13px;
  padding: 16px;
  background: rgba(30, 30, 50, 0.4);
  border-radius: 8px;
  margin-bottom: 12px;
}

.save-preset-form {
  display: flex;
  gap: 10px;
}

.save-preset-form .el-input {
  flex: 1;
}

/* Saved Filters Section */
.saved-filters-section {
  margin-bottom: 8px;
}

.saved-filters-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.saved-filters-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}

.saved-filters-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 150px;
  overflow-y: auto;
  margin-bottom: 12px;
}

.saved-filter-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 14px;
  background: rgba(30, 30, 50, 0.6);
  border: 1px solid rgba(124, 58, 237, 0.15);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.saved-filter-item:hover {
  border-color: rgba(124, 58, 237, 0.4);
  background: rgba(40, 40, 60, 0.8);
}

.saved-filter-item.filter-active {
  border-color: var(--accent);
  background: rgba(124, 58, 237, 0.15);
}

.saved-filter-info {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 1;
}

.saved-filter-name {
  font-size: 14px;
  color: var(--text-primary);
}

.saved-filter-actions {
  display: flex;
  gap: 4px;
}

.saved-filter-actions .el-button {
  padding: 4px 6px !important;
  color: var(--text-muted) !important;
}

.saved-filter-actions .el-button:hover {
  color: var(--accent) !important;
}

.saved-filter-actions .el-button--danger:hover {
  color: var(--danger) !important;
}

.saved-filters-empty {
  text-align: center;
  color: var(--text-muted);
  font-size: 13px;
  padding: 16px;
  background: rgba(30, 30, 50, 0.4);
  border-radius: 8px;
  margin-bottom: 12px;
}

.save-filter-form {
  display: flex;
  gap: 10px;
}

.save-filter-form .el-input {
  flex: 1;
}

/* Resume column styles */
.resume-btn {
  display: inline-block;
  padding: 6px 16px;
  background: rgba(16, 185, 129, 0.15);
  color: #10b981;
  font-size: 13px;
  font-weight: 500;
  border-radius: 20px;
  border: 1px solid rgba(16, 185, 129, 0.4);
  cursor: pointer;
  transition: all 0.2s ease;
}

.resume-btn:hover {
  background: rgba(16, 185, 129, 0.3);
  border-color: #10b981;
}

.resume-missing {
  display: inline-block;
  padding: 4px 10px;
  background: rgba(239, 68, 68, 0.2);
  color: #ef4444;
  font-size: 11px;
  font-weight: 600;
  border-radius: 12px;
  letter-spacing: 0.5px;
}

/* Resume View Dialog */
.resume-view {
  color: #fff;
}

.view-header {
  display: flex;
  gap: 20px;
  margin-bottom: 24px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.view-avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32px;
  font-weight: bold;
  color: #fff;
  flex-shrink: 0;
}

.view-info h2 {
  margin: 0 0 8px 0;
  font-size: 24px;
}

.view-info .view-position {
  color: #60a5fa;
  margin: 0 0 4px 0;
  font-size: 16px;
}

.view-info .view-email {
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
  font-size: 14px;
}

.view-section {
  margin-bottom: 24px;
}

.view-section h3 {
  color: #60a5fa;
  margin: 0 0 12px 0;
  font-size: 16px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.view-section > p {
  color: rgba(255, 255, 255, 0.85);
  line-height: 1.6;
  margin: 0;
}

.view-skills {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.view-skill {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(59, 130, 246, 0.15);
  padding: 8px 16px;
  border-radius: 8px;
  border: 1px solid rgba(59, 130, 246, 0.3);
}

.view-skill .skill-name {
  font-weight: 500;
  color: #fff;
}

.view-skill .skill-level {
  color: #60a5fa;
  font-size: 13px;
}

.view-skill .skill-years {
  color: rgba(255, 255, 255, 0.5);
  font-size: 12px;
}

.view-experience {
  background: rgba(255, 255, 255, 0.05);
  padding: 16px;
  border-radius: 12px;
  margin-bottom: 12px;
  border-left: 3px solid #60a5fa;
}

.view-experience .exp-company {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 4px;
}

.view-experience .exp-position-date {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.view-experience .exp-position-date span:first-child {
  color: #60a5fa;
}

.view-experience .exp-period {
  color: rgba(255, 255, 255, 0.5);
  font-size: 13px;
}

.view-experience .exp-description {
  color: rgba(255, 255, 255, 0.75);
  margin: 8px 0 0 0;
  line-height: 1.5;
}

.view-education {
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  margin-bottom: 8px;
}

.view-education .edu-institution {
  font-weight: 500;
  margin-bottom: 4px;
}

.view-education .edu-degree {
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
}

.view-languages {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.view-lang {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 16px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
}

.view-lang .lang-name {
  font-weight: 500;
}

.view-lang .lang-level {
  color: rgba(255, 255, 255, 0.6);
  font-size: 13px;
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

/* History Dialog styles */
.history-dialog .el-dialog {
  background: rgba(20, 20, 35, 0.98) !important;
  border: 1px solid rgba(124, 58, 237, 0.3) !important;
  border-radius: 16px !important;
  backdrop-filter: blur(20px);
}

.history-dialog .el-dialog__header {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 20px 24px !important;
}

.history-dialog .el-dialog__title {
  color: #fff !important;
  font-size: 20px !important;
  font-weight: 700 !important;
}

.history-dialog .el-dialog__body {
  padding: 20px 24px !important;
  background: transparent !important;
}

.history-dialog .el-dialog__headerbtn .el-dialog__close {
  color: rgba(255, 255, 255, 0.6) !important;
}

.history-dialog .el-dialog__headerbtn:hover .el-dialog__close {
  color: #fff !important;
}

/* Column Settings Dialog styles */
.columns-settings-dialog .el-dialog {
  background: rgba(20, 20, 35, 0.98) !important;
  border: 1px solid rgba(124, 58, 237, 0.3) !important;
  border-radius: 16px !important;
  backdrop-filter: blur(20px);
}

.columns-settings-dialog .el-dialog__header {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 20px 24px !important;
}

.columns-settings-dialog .el-dialog__title {
  color: #fff !important;
  font-size: 20px !important;
  font-weight: 700 !important;
}

.columns-settings-dialog .el-dialog__body {
  padding: 20px 24px !important;
  background: transparent !important;
}

.columns-settings-dialog .el-dialog__footer {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 16px 24px !important;
}

.columns-settings-dialog .el-dialog__headerbtn .el-dialog__close {
  color: rgba(255, 255, 255, 0.6) !important;
}

.columns-settings-dialog .el-dialog__headerbtn:hover .el-dialog__close {
  color: #fff !important;
}

/* Resume View Dialog Global Styles */
.resume-view-dialog {
  background: linear-gradient(145deg, #2d2b55 0%, #1e1b4b 100%) !important;
  border-radius: 16px !important;
  border: 1px solid rgba(139, 92, 246, 0.3) !important;
}

.resume-view-dialog .el-dialog__header {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 20px 24px !important;
}

.resume-view-dialog .el-dialog__title {
  color: #fff !important;
  font-size: 20px !important;
  font-weight: 600 !important;
}

.resume-view-dialog .el-dialog__body {
  max-height: 70vh;
  overflow-y: auto;
  padding: 24px !important;
  background: transparent !important;
}

.resume-view-dialog .el-dialog__footer {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 16px 24px !important;
}

.resume-view-dialog .el-dialog__headerbtn .el-dialog__close {
  color: rgba(255, 255, 255, 0.6) !important;
}

.resume-view-dialog .el-dialog__headerbtn:hover .el-dialog__close {
  color: #fff !important;
}
</style>
