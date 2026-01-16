<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { nineBoxApi } from '@/api/nineBox'
import { ElMessage } from 'element-plus'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const boxId = computed(() => parseInt(route.params.boxId))
const assessments = ref([])
const loading = ref(false)
const selectedAssessment = ref(null)

const boxNames = {
  1: 'Risk',
  2: 'Average Performer',
  3: 'Trusted Professional',
  4: 'Inconsistent Player',
  5: 'Core Player',
  6: 'High Performer',
  7: 'Rough Diamond',
  8: 'Future Star',
  9: 'Star'
}

const boxDescriptions = {
  1: 'Сотрудники с низкой производительностью и низким потенциалом. Требуют серьезного внимания и решения о дальнейшем развитии или расставании.',
  2: 'Стабильные исполнители со средней производительностью, но ограниченным потенциалом роста. Могут быть надежными на текущих позициях.',
  3: 'Высокопроизводительные специалисты с ограниченным потенциалом для роста. Ценные эксперты в своей области.',
  4: 'Сотрудники с высоким потенциалом, но нестабильной производительностью. Требуют внимания к мотивации и вовлеченности.',
  5: 'Надежные сотрудники со средними показателями. Основа команды, обеспечивающая стабильность.',
  6: 'Высокопроизводительные сотрудники со средним потенциалом. Кандидаты на расширение ответственности.',
  7: 'Сотрудники с высоким потенциалом, но пока низкой производительностью. Возможно, новички или на неподходящей позиции.',
  8: 'Перспективные сотрудники с высоким потенциалом и хорошей производительностью. Будущие лидеры компании.',
  9: 'Звезды организации. Высокая производительность и потенциал. Требуют особого внимания для удержания.'
}

const boxColors = {
  1: '#ef4444',
  2: '#f97316',
  3: '#eab308',
  4: '#f97316',
  5: '#22c55e',
  6: '#3b82f6',
  7: '#eab308',
  8: '#3b82f6',
  9: '#8b5cf6'
}

const boxRecommendations = {
  1: ['Провести честный разговор о перспективах', 'Установить четкие цели с дедлайнами', 'Рассмотреть перевод на другую позицию'],
  2: ['Поддерживать текущий уровень', 'Предоставить возможности для обучения', 'Признавать стабильный вклад'],
  3: ['Использовать как наставника', 'Документировать экспертизу', 'Обеспечить признание'],
  4: ['Выяснить причины нестабильности', 'Предоставить поддержку и ресурсы', 'Установить регулярную обратную связь'],
  5: ['Поддерживать развитие', 'Предоставлять новые задачи', 'Включать в проекты развития'],
  6: ['Расширить зону ответственности', 'Назначить на значимые проекты', 'Рассмотреть для повышения'],
  7: ['Провести оценку текущей роли', 'Обеспечить менторство', 'Дать время на адаптацию'],
  8: ['Создать план развития', 'Предоставить лидерские проекты', 'Включить в кадровый резерв'],
  9: ['Удерживать и развивать', 'Предоставить стратегические роли', 'Обеспечить конкурентную компенсацию']
}

async function fetchData() {
  loading.value = true
  try {
    const res = await nineBoxApi.getByBoxPosition(boxId.value)
    assessments.value = res.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки данных')
  } finally {
    loading.value = false
  }
}

function goBack() {
  router.push('/nine-box')
}

function viewEmployee(assessment) {
  selectedAssessment.value = assessment
}

function closeModal() {
  selectedAssessment.value = null
}

function formatDate(dateStr) {
  if (!dateStr) return ''
  return new Date(dateStr).toLocaleDateString('ru-RU')
}

onMounted(fetchData)
</script>

<template>
  <div class="detail-container">
    <div class="bg-orbs">
      <div class="orb orb-1"></div>
      <div class="orb orb-2"></div>
    </div>

    <!-- Header -->
    <header class="page-header glass-card">
      <div class="header-left">
        <button class="back-btn" @click="goBack">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor">
            <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/>
          </svg>
        </button>
        <div class="header-title">
          <h1 class="page-title" :style="{ color: boxColors[boxId] }">{{ boxNames[boxId] }}</h1>
          <span class="box-badge" :style="{ background: boxColors[boxId] }">Box {{ boxId }}</span>
        </div>
      </div>
      <div class="header-right">
        <span class="employee-count">{{ assessments.length }} сотрудников</span>
      </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
      <!-- Info Section -->
      <div class="info-section glass-card">
        <div class="info-grid">
          <div class="info-block">
            <h3>Описание категории</h3>
            <p>{{ boxDescriptions[boxId] }}</p>
          </div>
          <div class="info-block">
            <h3>Рекомендации</h3>
            <ul>
              <li v-for="rec in boxRecommendations[boxId]" :key="rec">{{ rec }}</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Employees List -->
      <div class="employees-section glass-card">
        <h2 class="section-title">Сотрудники в категории</h2>

        <div v-if="loading" class="loading">Загрузка...</div>

        <div v-else-if="assessments.length === 0" class="empty-state">
          <svg viewBox="0 0 24 24" width="48" height="48" fill="currentColor" opacity="0.3">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
          </svg>
          <p>В этой категории пока нет сотрудников</p>
        </div>

        <div v-else class="employees-grid">
          <div
            v-for="assessment in assessments"
            :key="assessment.id"
            class="employee-card"
            :style="{ '--box-color': boxColors[boxId] }"
            @click="viewEmployee(assessment)"
          >
            <div class="emp-avatar">{{ assessment.employeeFullName?.charAt(0) || '?' }}</div>
            <div class="emp-info">
              <div class="emp-name">{{ assessment.employeeFullName }}</div>
              <div class="emp-scores">
                <span class="score">P: {{ assessment.performanceScore?.toFixed(1) }}</span>
                <span class="score">Pot: {{ assessment.potentialScore?.toFixed(1) }}</span>
              </div>
              <div class="emp-date">Оценка: {{ formatDate(assessment.assessedAt) }}</div>
            </div>
            <svg class="arrow-icon" viewBox="0 0 24 24" width="20" height="20" fill="currentColor">
              <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/>
            </svg>
          </div>
        </div>
      </div>
    </main>

    <!-- Assessment Modal -->
    <el-dialog
      v-model="selectedAssessment"
      :title="selectedAssessment?.employeeFullName"
      width="500px"
      :before-close="closeModal"
    >
      <div v-if="selectedAssessment" class="assessment-details">
        <div class="detail-grid">
          <div class="detail-item">
            <span class="label">Performance</span>
            <span class="value">{{ selectedAssessment.performanceScore?.toFixed(2) }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Potential</span>
            <span class="value">{{ selectedAssessment.potentialScore?.toFixed(2) }}</span>
          </div>
        </div>

        <div class="scores-section">
          <h4>Детализация оценок</h4>
          <div class="score-row">
            <span>Выполнение KPI</span>
            <span class="score-value">{{ selectedAssessment.q1Results }}/5</span>
          </div>
          <div class="score-row">
            <span>Достижение целей</span>
            <span class="score-value">{{ selectedAssessment.q2Goals }}/5</span>
          </div>
          <div class="score-row">
            <span>Качество работы</span>
            <span class="score-value">{{ selectedAssessment.q3Quality }}/5</span>
          </div>
          <div class="score-row">
            <span>Способность к развитию</span>
            <span class="score-value">{{ selectedAssessment.q4Growth }}/5</span>
          </div>
          <div class="score-row">
            <span>Лидерские качества</span>
            <span class="score-value">{{ selectedAssessment.q5Leadership }}/5</span>
          </div>
        </div>

        <div v-if="selectedAssessment.comment" class="comment-section">
          <h4>Комментарий</h4>
          <p>{{ selectedAssessment.comment }}</p>
        </div>

        <div class="meta-section">
          <span>Оценил: {{ selectedAssessment.assessedByUsername }}</span>
          <span>Дата: {{ formatDate(selectedAssessment.assessedAt) }}</span>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped>
.detail-container {
  min-height: 100vh;
  position: relative;
  padding: 20px;
}

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
  opacity: 0.3;
}

.orb-1 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #7c3aed, #a78bfa);
  top: -100px;
  right: -50px;
}

.orb-2 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #06b6d4, #22d3ee);
  bottom: -50px;
  left: -50px;
}

/* Header */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  margin-bottom: 20px;
  position: relative;
  z-index: 10;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.back-btn {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  color: var(--text-primary);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.back-btn:hover {
  background: var(--accent);
  border-color: var(--accent);
  color: white;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-title {
  font-size: 24px;
  font-weight: 700;
  margin: 0;
}

.box-badge {
  padding: 4px 12px;
  border-radius: 20px;
  color: white;
  font-size: 12px;
  font-weight: 600;
}

.employee-count {
  color: var(--text-secondary);
  font-size: 14px;
}

/* Main Content */
.main-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
  position: relative;
  z-index: 10;
}

/* Info Section */
.info-section {
  padding: 24px;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}

.info-block h3 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 12px 0;
}

.info-block p {
  color: var(--text-secondary);
  font-size: 14px;
  line-height: 1.6;
  margin: 0;
}

.info-block ul {
  margin: 0;
  padding-left: 20px;
  color: var(--text-secondary);
  font-size: 14px;
  line-height: 1.8;
}

/* Employees Section */
.employees-section {
  padding: 24px;
}

.section-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 20px 0;
}

.loading, .empty-state {
  text-align: center;
  padding: 40px;
  color: var(--text-muted);
}

.empty-state svg {
  margin-bottom: 16px;
}

.employees-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 12px;
}

.employee-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  background: rgba(30, 30, 50, 0.6);
  border: 1px solid var(--border-glass);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
}

.employee-card:hover {
  border-color: var(--box-color);
  background: color-mix(in srgb, var(--box-color) 10%, transparent);
  transform: translateX(4px);
}

.emp-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: var(--box-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: 600;
  flex-shrink: 0;
}

.emp-info {
  flex: 1;
}

.emp-name {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 4px;
}

.emp-scores {
  display: flex;
  gap: 12px;
  margin-bottom: 4px;
}

.emp-scores .score {
  font-size: 12px;
  color: var(--text-secondary);
  background: rgba(255, 255, 255, 0.1);
  padding: 2px 8px;
  border-radius: 4px;
}

.emp-date {
  font-size: 12px;
  color: var(--text-muted);
}

.arrow-icon {
  color: var(--text-muted);
  flex-shrink: 0;
}

/* Assessment Details Modal */
.assessment-details {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.detail-item {
  text-align: center;
  padding: 16px;
  background: rgba(124, 58, 237, 0.1);
  border-radius: 12px;
}

.detail-item .label {
  display: block;
  font-size: 12px;
  color: var(--text-muted);
  margin-bottom: 4px;
}

.detail-item .value {
  display: block;
  font-size: 24px;
  font-weight: 700;
  color: var(--accent);
}

.scores-section h4,
.comment-section h4 {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 12px 0;
}

.score-row {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid var(--border-glass);
  font-size: 14px;
  color: var(--text-secondary);
}

.score-row:last-child {
  border-bottom: none;
}

.score-value {
  font-weight: 600;
  color: var(--text-primary);
}

.comment-section p {
  color: var(--text-secondary);
  font-size: 14px;
  line-height: 1.6;
  margin: 0;
  padding: 12px;
  background: rgba(30, 30, 50, 0.6);
  border-radius: 8px;
}

.meta-section {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: var(--text-muted);
  padding-top: 12px;
  border-top: 1px solid var(--border-glass);
}

@media (max-width: 768px) {
  .info-grid {
    grid-template-columns: 1fr;
  }

  .employees-grid {
    grid-template-columns: 1fr;
  }
}
</style>
