<script setup>
import { ref, onMounted, onUnmounted, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'
import { useColumnsStore } from '@/stores/columns'
import { useNotificationsStore } from '@/stores/notifications'
import { employeesApi } from '@/api/employees'
import { dictionariesApi } from '@/api/dictionaries'
import { ElMessage } from 'element-plus'

const router = useRouter()
const authStore = useAuthStore()
const themeStore = useThemeStore()
const columnsStore = useColumnsStore()
const notificationsStore = useNotificationsStore()

const loading = ref(false)
const employees = ref([])
const dictionaries = ref({})
const historyDialogVisible = ref(false)
const historyLoading = ref(false)
const historyItems = ref([])

// Настройки круговой диаграммы
const pieField = ref('status')
const pieOptions = ref([
  { value: 'status', label: 'Статус' },
  { value: 'department', label: 'Отдел' },
  { value: 'grade', label: 'Грейд' },
  { value: 'location', label: 'Локация' }
])

// Настройки столбчатой диаграммы
const barField = ref('department')
const barOptions = ref([
  { value: 'department', label: 'Отдел' },
  { value: 'grade', label: 'Грейд' },
  { value: 'status', label: 'Статус' },
  { value: 'location', label: 'Локация' }
])

// Данные для диаграмм
const pieData = computed(() => {
  const counts = {}
  employees.value.forEach(emp => {
    const value = emp.customFields?.[pieField.value] || 'Не указано'
    counts[value] = (counts[value] || 0) + 1
  })
  return Object.entries(counts).map(([name, value]) => ({ name, value }))
})

const barData = computed(() => {
  const counts = {}
  employees.value.forEach(emp => {
    const value = emp.customFields?.[barField.value] || 'Не указано'
    counts[value] = (counts[value] || 0) + 1
  })
  return {
    labels: Object.keys(counts),
    values: Object.values(counts)
  }
})

// Цвета для диаграмм
const chartColors = [
  '#7c3aed', '#a78bfa', '#c4b5fd', '#ddd6fe',
  '#10b981', '#34d399', '#6ee7b7',
  '#f59e0b', '#fbbf24', '#fcd34d',
  '#ef4444', '#f87171'
]

async function fetchData() {
  loading.value = true
  try {
    // Загружаем всех сотрудников для статистики
    const response = await employeesApi.getAll({ page: 0, size: 1000 })
    employees.value = response.data.content || response.data

    // Загружаем справочники
    await columnsStore.fetchColumns()
    for (const col of columnsStore.columns) {
      if (col.dictionaryId) {
        try {
          const dictResponse = await dictionariesApi.getById(col.dictionaryId)
          dictionaries.value[col.name] = dictResponse.data.values || []
        } catch (e) {
          console.error('Error loading dictionary:', e)
        }
      }
    }
  } catch (error) {
    console.error('Error fetching data:', error)
  } finally {
    loading.value = false
  }
}

function goBack() {
  router.push('/')
}

function goToAdmin() {
  router.push('/admin')
}

async function handleLogout() {
  await authStore.logout()
  router.push('/login')
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

onMounted(() => {
  fetchData()
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
        <div class="logo" @click="goBack" style="cursor: pointer;">
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
        <el-button class="header-btn active-btn">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
          </svg>
          <span>Аналитика</span>
        </el-button>
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
    <main class="app-main" v-loading="loading">
      <div class="page-header">
        <div class="page-title">
          <h1>Аналитика</h1>
          <p class="subtitle">Статистика по сотрудникам</p>
        </div>
        <div class="page-stats glass-card">
          <div class="stat">
            <span class="stat-value">{{ employees.length }}</span>
            <span class="stat-label">Сотрудников</span>
          </div>
        </div>
      </div>

      <!-- Charts Grid -->
      <div class="charts-grid">
        <!-- Pie Chart Card -->
        <div class="chart-card glass-card-strong">
          <div class="chart-header">
            <h3>Распределение по категории</h3>
            <el-select v-model="pieField" class="chart-select" size="small">
              <el-option
                v-for="opt in pieOptions"
                :key="opt.value"
                :value="opt.value"
                :label="opt.label"
              />
            </el-select>
          </div>
          <div class="chart-container">
            <svg viewBox="0 0 400 300" class="pie-chart">
              <g transform="translate(200, 150)">
                <template v-for="(item, index) in pieData" :key="index">
                  <path
                    :d="getPieSlicePath(index)"
                    :fill="chartColors[index % chartColors.length]"
                    class="pie-slice"
                  />
                </template>
              </g>
            </svg>
            <div class="chart-legend">
              <div
                v-for="(item, index) in pieData"
                :key="index"
                class="legend-item"
              >
                <span
                  class="legend-color"
                  :style="{ background: chartColors[index % chartColors.length] }"
                ></span>
                <span class="legend-label">{{ item.name }}</span>
                <span class="legend-value">{{ item.value }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Bar Chart Card -->
        <div class="chart-card glass-card-strong">
          <div class="chart-header">
            <h3>Количество по категории</h3>
            <el-select v-model="barField" class="chart-select" size="small">
              <el-option
                v-for="opt in barOptions"
                :key="opt.value"
                :value="opt.value"
                :label="opt.label"
              />
            </el-select>
          </div>
          <div class="chart-container bar-container">
            <svg viewBox="0 0 500 300" class="bar-chart">
              <!-- Y Axis -->
              <line x1="50" y1="20" x2="50" y2="250" stroke="var(--border-color)" stroke-width="1"/>
              <!-- X Axis -->
              <line x1="50" y1="250" x2="480" y2="250" stroke="var(--border-color)" stroke-width="1"/>

              <!-- Bars -->
              <g v-for="(value, index) in barData.values" :key="index">
                <rect
                  :x="70 + index * (400 / barData.labels.length)"
                  :y="250 - (value / Math.max(...barData.values)) * 200"
                  :width="Math.max(20, (380 / barData.labels.length) - 10)"
                  :height="(value / Math.max(...barData.values)) * 200"
                  :fill="chartColors[index % chartColors.length]"
                  class="bar"
                  rx="4"
                />
                <text
                  :x="70 + index * (400 / barData.labels.length) + Math.max(10, (380 / barData.labels.length) - 10) / 2"
                  :y="250 - (value / Math.max(...barData.values)) * 200 - 5"
                  text-anchor="middle"
                  class="bar-value"
                  fill="var(--text-primary)"
                  font-size="12"
                >{{ value }}</text>
                <text
                  :x="70 + index * (400 / barData.labels.length) + Math.max(10, (380 / barData.labels.length) - 10) / 2"
                  y="268"
                  text-anchor="middle"
                  class="bar-label"
                  fill="var(--text-secondary)"
                  font-size="10"
                  :transform="`rotate(-30, ${70 + index * (400 / barData.labels.length) + Math.max(10, (380 / barData.labels.length) - 10) / 2}, 268)`"
                >{{ barData.labels[index]?.substring(0, 10) }}</text>
              </g>
            </svg>
          </div>
        </div>
      </div>

      <!-- Summary Cards -->
      <div class="summary-grid">
        <div class="summary-card glass-card" v-for="(item, index) in pieData.slice(0, 4)" :key="index">
          <div class="summary-icon" :style="{ background: chartColors[index % chartColors.length] }">
            <svg viewBox="0 0 24 24" fill="white" width="24" height="24">
              <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
            </svg>
          </div>
          <div class="summary-info">
            <span class="summary-value">{{ item.value }}</span>
            <span class="summary-label">{{ item.name }}</span>
          </div>
        </div>
      </div>
    </main>

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

<script>
export default {
  methods: {
    getPieSlicePath(index) {
      const data = this.pieData
      if (!data || data.length === 0) return ''

      const total = data.reduce((sum, item) => sum + item.value, 0)
      if (total === 0) return ''

      let startAngle = 0
      for (let i = 0; i < index; i++) {
        startAngle += (data[i].value / total) * 360
      }

      const sliceAngle = (data[index].value / total) * 360
      const endAngle = startAngle + sliceAngle

      const radius = 100
      const startRad = (startAngle - 90) * Math.PI / 180
      const endRad = (endAngle - 90) * Math.PI / 180

      const x1 = Math.cos(startRad) * radius
      const y1 = Math.sin(startRad) * radius
      const x2 = Math.cos(endRad) * radius
      const y2 = Math.sin(endRad) * radius

      const largeArc = sliceAngle > 180 ? 1 : 0

      return `M 0 0 L ${x1} ${y1} A ${radius} ${radius} 0 ${largeArc} 1 ${x2} ${y2} Z`
    }
  }
}
</script>

<style scoped>
.app-container {
  min-height: 100vh;
  background: var(--bg-primary);
  position: relative;
  overflow-x: hidden;
}

.bg-orbs {
  position: fixed;
  inset: 0;
  pointer-events: none;
  overflow: hidden;
  z-index: 0;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.5;
}

.orb-1 {
  width: 600px;
  height: 600px;
  background: linear-gradient(135deg, var(--accent), var(--accent-light));
  top: -200px;
  right: -100px;
  animation: float 20s ease-in-out infinite;
}

.orb-2 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #10b981, #34d399);
  bottom: -100px;
  left: -100px;
  animation: float 25s ease-in-out infinite reverse;
}

.orb-3 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #f59e0b, #fbbf24);
  top: 50%;
  left: 50%;
  animation: float 30s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translate(0, 0) scale(1); }
  25% { transform: translate(50px, -50px) scale(1.05); }
  50% { transform: translate(-30px, 30px) scale(0.95); }
  75% { transform: translate(-50px, -30px) scale(1.02); }
}

.glass-card {
  background: var(--bg-glass);
  backdrop-filter: blur(20px);
  border-radius: 16px;
  border: 1px solid var(--border-glass);
}

.glass-card-strong {
  background: var(--bg-card);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid var(--border-color);
  box-shadow: var(--shadow-lg);
}

.text-gradient {
  background: linear-gradient(135deg, var(--accent), var(--accent-light));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
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
  font-weight: 800;
  letter-spacing: -0.5px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.theme-btn {
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

.theme-btn:hover {
  background: var(--bg-hover);
  border-color: var(--accent);
  color: var(--accent);
}

.theme-btn svg {
  width: 22px;
  height: 22px;
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

.header-btn.active-btn {
  background: var(--accent) !important;
  border-color: var(--accent) !important;
  color: white !important;
}

.user-badge {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  font-weight: 500;
  color: var(--text-primary);
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

/* Main */
.app-main {
  padding: 32px 24px;
  max-width: 1400px;
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

/* Charts */
.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  margin-bottom: 24px;
}

.chart-card {
  padding: 24px;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.chart-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary);
}

.chart-select {
  width: 140px;
}

.chart-container {
  display: flex;
  align-items: flex-start;
  gap: 24px;
}

.bar-container {
  flex-direction: column;
}

.pie-chart, .bar-chart {
  flex-shrink: 0;
}

.pie-chart {
  width: 220px;
  height: 220px;
}

.bar-chart {
  width: 100%;
  height: 300px;
}

.pie-slice {
  transition: transform 0.2s ease;
  cursor: pointer;
}

.pie-slice:hover {
  transform: scale(1.05);
  filter: brightness(1.1);
}

.bar {
  transition: all 0.2s ease;
  cursor: pointer;
}

.bar:hover {
  filter: brightness(1.2);
}

.chart-legend {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: var(--bg-glass);
  border-radius: 8px;
}

.legend-color {
  width: 12px;
  height: 12px;
  border-radius: 4px;
  flex-shrink: 0;
}

.legend-label {
  flex: 1;
  font-size: 13px;
  color: var(--text-primary);
}

.legend-value {
  font-weight: 600;
  color: var(--accent);
}

/* Summary Cards */
.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

.summary-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
}

.summary-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.summary-info {
  display: flex;
  flex-direction: column;
}

.summary-value {
  font-size: 24px;
  font-weight: 800;
  color: var(--text-primary);
}

.summary-label {
  font-size: 13px;
  color: var(--text-secondary);
}

/* Responsive */
@media (max-width: 1200px) {
  .charts-grid {
    grid-template-columns: 1fr;
  }

  .summary-grid {
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
  }

  .chart-container {
    flex-direction: column;
  }

  .pie-chart {
    width: 100%;
    max-width: 250px;
    margin: 0 auto;
  }

  .summary-grid {
    grid-template-columns: 1fr;
  }
}
</style>

<style>
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
</style>
