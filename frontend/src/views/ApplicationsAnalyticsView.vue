<template>
  <div class="analytics-view">
    <!-- Фон -->
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

    <!-- Заголовок -->
    <div class="page-header">
      <div>
        <h1>Аналитика заявок</h1>
        <p class="subtitle">Статистика по заявкам на ротацию и развитие</p>
      </div>
      <div class="header-actions">
        <el-date-picker
          v-model="dateRange"
          type="daterange"
          range-separator="—"
          start-placeholder="Начало"
          end-placeholder="Конец"
          format="DD.MM.YYYY"
          value-format="YYYY-MM-DD"
          @change="handleDateChange"
        />
        <el-select
          v-if="authStore.isSystemAdmin"
          v-model="selectedDzoId"
          placeholder="Все ДЗО"
          clearable
          @change="loadData"
        >
          <el-option
            v-for="dzo in dzos"
            :key="dzo.id"
            :label="dzo.name"
            :value="dzo.id"
          />
        </el-select>
      </div>
    </div>

    <!-- Карточки сводки -->
    <div class="summary-cards">
      <div class="summary-card glass-card">
        <div class="card-icon total">
          <el-icon><Document /></el-icon>
        </div>
        <div class="card-content">
          <div class="card-value">{{ summary?.total || 0 }}</div>
          <div class="card-label">Всего заявок</div>
        </div>
      </div>

      <div class="summary-card glass-card">
        <div class="card-icon in-progress">
          <el-icon><Loading /></el-icon>
        </div>
        <div class="card-content">
          <div class="card-value">{{ summary?.inProgress || 0 }}</div>
          <div class="card-label">В работе</div>
        </div>
      </div>

      <div class="summary-card glass-card">
        <div class="card-icon completed">
          <el-icon><CircleCheck /></el-icon>
        </div>
        <div class="card-content">
          <div class="card-value">{{ summary?.completed || 0 }}</div>
          <div class="card-label">Завершено</div>
        </div>
      </div>

      <div class="summary-card glass-card">
        <div class="card-icon rejected">
          <el-icon><CircleClose /></el-icon>
        </div>
        <div class="card-content">
          <div class="card-value">{{ summary?.rejected || 0 }}</div>
          <div class="card-label">Отклонено</div>
        </div>
      </div>
    </div>

    <!-- Графики -->
    <div class="charts-grid">
      <!-- Воронка конверсии -->
      <div class="chart-card glass-card">
        <h3>Воронка конверсии</h3>
        <div class="funnel-chart" v-if="funnel">
          <div class="funnel-step" :style="{ width: '100%' }">
            <span class="step-value">{{ funnel.created }}</span>
            <span class="step-label">Создано</span>
          </div>
          <div class="funnel-step" :style="{ width: funnelWidth(funnel.sentToHrBp, funnel.created) }">
            <span class="step-value">{{ funnel.sentToHrBp }}</span>
            <span class="step-label">Отправлено HR BP</span>
            <span class="step-percent">{{ funnel.conversionCreatedToHrBp?.toFixed(1) }}%</span>
          </div>
          <div class="funnel-step" :style="{ width: funnelWidth(funnel.approvedHrBp, funnel.created) }">
            <span class="step-value">{{ funnel.approvedHrBp }}</span>
            <span class="step-label">Согласовано HR BP</span>
            <span class="step-percent">{{ funnel.conversionHrBpToApproved?.toFixed(1) }}%</span>
          </div>
          <div class="funnel-step final" :style="{ width: funnelWidth(funnel.transferred, funnel.created) }">
            <span class="step-value">{{ funnel.transferred }}</span>
            <span class="step-label">Переведено</span>
            <span class="step-percent">{{ funnel.overallConversion?.toFixed(1) }}%</span>
          </div>
        </div>
      </div>

      <!-- Время согласования -->
      <div class="chart-card glass-card">
        <h3>Среднее время (дни)</h3>
        <div class="time-metrics" v-if="approvalTime">
          <div class="time-metric">
            <div class="metric-value">{{ approvalTime.avgTotalDays?.toFixed(1) }}</div>
            <div class="metric-label">Общее время</div>
          </div>
          <div class="time-metric">
            <div class="metric-value">{{ approvalTime.avgToHrBpDays?.toFixed(1) }}</div>
            <div class="metric-label">До HR BP</div>
          </div>
          <div class="time-metric">
            <div class="metric-value">{{ approvalTime.avgHrBpDecisionDays?.toFixed(1) }}</div>
            <div class="metric-label">Решение HR BP</div>
          </div>
          <div class="time-metric" v-if="approvalTime.avgBorupDecisionDays > 0">
            <div class="metric-value">{{ approvalTime.avgBorupDecisionDays?.toFixed(1) }}</div>
            <div class="metric-label">Решение БОРУП</div>
          </div>
        </div>
      </div>

      <!-- По стекам -->
      <div class="chart-card glass-card">
        <h3>Распределение по стекам</h3>
        <div class="stack-bars" v-if="stackDistribution.length">
          <div
            v-for="item in stackDistribution.slice(0, 8)"
            :key="item.stack"
            class="stack-bar"
          >
            <div class="bar-label">{{ item.stack || 'Не указан' }}</div>
            <div class="bar-container">
              <div
                class="bar-fill"
                :style="{ width: barWidth(item.count) }"
              ></div>
              <span class="bar-value">{{ item.count }}</span>
            </div>
          </div>
        </div>
        <div v-else class="no-data">Нет данных</div>
      </div>

      <!-- Статистика ЗП -->
      <div class="chart-card glass-card">
        <h3>Статистика по зарплатам</h3>
        <div class="salary-metrics" v-if="salaryStats">
          <div class="salary-metric">
            <div class="metric-label">Средняя текущая ЗП</div>
            <div class="metric-value">{{ formatSalary(salaryStats.avgCurrentSalary) }} ₽</div>
          </div>
          <div class="salary-metric">
            <div class="metric-label">Средняя целевая ЗП</div>
            <div class="metric-value">{{ formatSalary(salaryStats.avgTargetSalary) }} ₽</div>
          </div>
          <div class="salary-metric">
            <div class="metric-label">Средний рост</div>
            <div class="metric-value highlight">+{{ salaryStats.avgIncreasePercent?.toFixed(1) }}%</div>
          </div>
          <div class="salary-metric">
            <div class="metric-label">Требуют БОРУП</div>
            <div class="metric-value warning">{{ salaryStats.countRequiringBorup }}</div>
          </div>
        </div>
      </div>

      <!-- Динамика по месяцам -->
      <div class="chart-card glass-card wide">
        <h3>Динамика по месяцам</h3>
        <div class="trend-chart" v-if="monthlyTrend.length">
          <div class="trend-legend">
            <span class="legend-item created"><span class="dot"></span> Создано</span>
            <span class="legend-item completed"><span class="dot"></span> Завершено</span>
            <span class="legend-item rejected"><span class="dot"></span> Отклонено</span>
          </div>
          <div class="trend-bars">
            <div v-for="item in monthlyTrend" :key="`${item.year}-${item.month}`" class="trend-month">
              <div class="bars">
                <div class="bar created" :style="{ height: trendHeight(item.created) }"></div>
                <div class="bar completed" :style="{ height: trendHeight(item.completed) }"></div>
                <div class="bar rejected" :style="{ height: trendHeight(item.rejected) }"></div>
              </div>
              <div class="month-label">{{ formatMonth(item.month) }}</div>
            </div>
          </div>
        </div>
        <div v-else class="no-data">Нет данных</div>
      </div>
    </div>

    <!-- Топ рекрутеров (для админов) -->
    <div v-if="authStore.isAdmin" class="recruiters-section glass-card">
      <h3>Топ рекрутеров</h3>
      <el-table :data="topRecruiters" class="recruiters-table">
        <el-table-column prop="recruiterName" label="Рекрутер" />
        <el-table-column prop="completedCount" label="Завершено" width="120" />
        <el-table-column prop="inProgressCount" label="В работе" width="120" />
        <el-table-column label="Среднее время (дни)" width="180">
          <template #default="{ row }">
            {{ row.avgDaysToComplete?.toFixed(1) || '-' }}
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Document, Loading, CircleCheck, CircleClose } from '@element-plus/icons-vue'
import { useAnalyticsStore } from '@/stores/analytics'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'
import client from '@/api/client'

const router = useRouter()
const analyticsStore = useAnalyticsStore()
const authStore = useAuthStore()
const themeStore = useThemeStore()

const dateRange = ref(null)
const selectedDzoId = ref(null)
const dzos = ref([])

const summary = computed(() => analyticsStore.summary)
const funnel = computed(() => analyticsStore.funnel)
const approvalTime = computed(() => analyticsStore.approvalTime)
const stackDistribution = computed(() => analyticsStore.stackDistribution)
const salaryStats = computed(() => analyticsStore.salaryStats)
const monthlyTrend = computed(() => analyticsStore.monthlyTrend)
const topRecruiters = computed(() => analyticsStore.topRecruiters)

const maxStackCount = computed(() => {
  if (!stackDistribution.value.length) return 1
  return Math.max(...stackDistribution.value.map(s => s.count))
})

const maxTrendCount = computed(() => {
  if (!monthlyTrend.value.length) return 1
  return Math.max(...monthlyTrend.value.flatMap(m => [m.created, m.completed, m.rejected]))
})

function getFilterParams() {
  const params = {}
  if (selectedDzoId.value) {
    params.dzoId = selectedDzoId.value
  }
  if (dateRange.value && dateRange.value[0]) {
    params.startDate = dateRange.value[0]
    params.endDate = dateRange.value[1]
  }
  return params
}

async function loadData() {
  const params = getFilterParams()
  await analyticsStore.fetchAll(params)

  if (authStore.isAdmin) {
    await analyticsStore.fetchTopRecruiters({ ...params, limit: 10 })
  }
}

async function loadDzos() {
  if (authStore.isSystemAdmin) {
    try {
      const response = await client.get('/dzos')
      dzos.value = response.data
    } catch (e) {
      console.error('Failed to load DZOs:', e)
    }
  }
}

function handleDateChange() {
  loadData()
}

function funnelWidth(value, total) {
  if (!total || !value) return '20%'
  const percent = Math.max(20, (value / total) * 100)
  return `${percent}%`
}

function barWidth(count) {
  return `${(count / maxStackCount.value) * 100}%`
}

function trendHeight(count) {
  if (!count) return '0px'
  return `${Math.max(6, (count / maxTrendCount.value) * 150)}px`
}

function formatSalary(value) {
  if (!value) return '0'
  return new Intl.NumberFormat('ru-RU').format(Math.round(value))
}

function formatMonth(month) {
  const months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек']
  return months[month - 1] || month
}

function goToHome() {
  router.push('/')
}

function goToApplications() {
  router.push('/applications')
}

function goToAdmin() {
  router.push('/admin')
}

async function handleLogout() {
  await authStore.logout()
  router.push('/login')
}

onMounted(async () => {
  const endDate = new Date()
  const startDate = new Date()
  startDate.setMonth(startDate.getMonth() - 12)
  dateRange.value = [
    startDate.toISOString().split('T')[0],
    endDate.toISOString().split('T')[0]
  ]

  await loadDzos()
  await loadData()
})
</script>

<style scoped>
.analytics-view {
  min-height: 100vh;
  position: relative;
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

.text-gradient {
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
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

.bg-orbs {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  overflow: hidden;
  z-index: 0;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.4;
  animation: float 20s ease-in-out infinite;
}

.orb-1 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
  top: -100px;
  right: -100px;
}

.orb-2 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%);
  bottom: 100px;
  left: -50px;
  animation-delay: -7s;
}

.orb-3 {
  width: 250px;
  height: 250px;
  background: linear-gradient(135deg, #8b5cf6 0%, #c4b5fd 100%);
  top: 50%;
  right: 20%;
  animation-delay: -14s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-30px) rotate(5deg); }
}

.glass-card {
  background: rgba(30, 30, 50, 0.8);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  position: relative;
  z-index: 1;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin: 0 24px 24px 24px;
  padding-top: 24px;
  position: relative;
  z-index: 1;
}

.page-header h1 {
  font-size: 32px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
}

.subtitle {
  color: var(--text-muted);
  margin-top: 4px;
}

.header-actions {
  display: flex;
  gap: 12px;
}

.summary-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin: 0 24px 24px 24px;
}

.summary-card {
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
}

.card-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
}

.card-icon.total {
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  color: white;
}

.card-icon.in-progress {
  background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%);
  color: white;
}

.card-icon.completed {
  background: linear-gradient(135deg, #10b981 0%, #34d399 100%);
  color: white;
}

.card-icon.rejected {
  background: linear-gradient(135deg, #ef4444 0%, #f87171 100%);
  color: white;
}

.card-value {
  font-size: 28px;
  font-weight: 700;
  color: var(--text-primary);
}

.card-label {
  font-size: 13px;
  color: var(--text-muted);
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin: 0 24px 24px 24px;
}

.chart-card {
  padding: 20px;
}

.chart-card.wide {
  grid-column: span 2;
}

.chart-card h3 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 16px 0;
}

.funnel-chart {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.funnel-step {
  background: linear-gradient(90deg, rgba(124, 58, 237, 0.3) 0%, rgba(124, 58, 237, 0.1) 100%);
  border-radius: 8px;
  padding: 12px 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  transition: width 0.3s ease;
}

.funnel-step.final {
  background: linear-gradient(90deg, rgba(16, 185, 129, 0.3) 0%, rgba(16, 185, 129, 0.1) 100%);
}

.step-value {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
  min-width: 40px;
}

.step-label {
  flex: 1;
  color: var(--text-secondary);
}

.step-percent {
  color: var(--accent);
  font-weight: 600;
}

.time-metrics {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.time-metric {
  text-align: center;
  padding: 16px;
  background: rgba(124, 58, 237, 0.1);
  border-radius: 12px;
}

.metric-value {
  font-size: 28px;
  font-weight: 700;
  color: var(--accent);
}

.metric-label {
  font-size: 12px;
  color: var(--text-muted);
  margin-top: 4px;
}

.stack-bars {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.stack-bar {
  display: flex;
  align-items: center;
  gap: 12px;
}

.bar-label {
  width: 100px;
  font-size: 13px;
  color: var(--text-secondary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.bar-container {
  flex: 1;
  height: 24px;
  background: rgba(124, 58, 237, 0.1);
  border-radius: 4px;
  position: relative;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #7c3aed 0%, #a78bfa 100%);
  border-radius: 4px;
  transition: width 0.3s ease;
}

.bar-value {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 12px;
  font-weight: 600;
  color: var(--text-primary);
}

.salary-metrics {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.salary-metric {
  padding: 12px;
  background: rgba(124, 58, 237, 0.1);
  border-radius: 8px;
}

.salary-metric .metric-value {
  font-size: 18px;
}

.salary-metric .metric-value.highlight {
  color: #10b981;
}

.salary-metric .metric-value.warning {
  color: #f59e0b;
}

.trend-legend {
  display: flex;
  gap: 20px;
  margin-bottom: 16px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: var(--text-secondary);
}

.legend-item .dot {
  width: 10px;
  height: 10px;
  border-radius: 2px;
}

.legend-item.created .dot { background: #6366f1; }
.legend-item.completed .dot { background: #10b981; }
.legend-item.rejected .dot { background: #ef4444; }

.trend-bars {
  display: flex;
  gap: 16px;
  align-items: flex-end;
  height: 180px;
  padding: 0 16px;
}

.trend-month {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.trend-month .bars {
  display: flex;
  gap: 4px;
  align-items: flex-end;
  height: 150px;
}

.trend-month .bar {
  width: 28px;
  border-radius: 4px 4px 0 0;
  transition: height 0.3s ease;
}

.trend-month .bar.created { background: #6366f1; }
.trend-month .bar.completed { background: #10b981; }
.trend-month .bar.rejected { background: #ef4444; }

.month-label {
  font-size: 11px;
  color: var(--text-muted);
  margin-top: 8px;
}

.recruiters-section {
  padding: 20px;
  margin: 0 24px 24px 24px;
}

.recruiters-section h3 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 16px 0;
}

.no-data {
  text-align: center;
  padding: 40px;
  color: var(--text-muted);
}

@media (max-width: 1200px) {
  .summary-cards {
    grid-template-columns: repeat(2, 1fr);
  }

  .charts-grid {
    grid-template-columns: 1fr;
  }

  .chart-card.wide {
    grid-column: span 1;
  }
}
</style>
