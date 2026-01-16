<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { employeesApi } from '@/api/employees'
import { nineBoxApi } from '@/api/nineBox'
import { ElMessage } from 'element-plus'

const router = useRouter()
const authStore = useAuthStore()

// Data
const employees = ref([])
const assessments = ref([])
const statistics = ref(null)
const loading = ref(false)
const searchQuery = ref('')
const selectedEmployee = ref(null)
const currentAssessment = ref(null)
const activeTab = ref('matrix')
const analyticsMode = ref('dept') // 'dept' or 'pos'
const selectedDept = ref(null)
const selectedPos = ref(null)

// Form
const form = ref({
  q1Results: 3,
  q2Goals: 3,
  q3Quality: 3,
  q4Growth: 3,
  q5Leadership: 3,
  comment: ''
})

const questions = [
  { key: 'q1Results', label: 'Выполнение KPI и плановых показателей', category: 'Performance' },
  { key: 'q2Goals', label: 'Достижение поставленных целей', category: 'Performance' },
  { key: 'q3Quality', label: 'Качество выполняемой работы', category: 'Performance' },
  { key: 'q4Growth', label: 'Способность к развитию и обучению', category: 'Potential' },
  { key: 'q5Leadership', label: 'Лидерские качества и инициативность', category: 'Potential' }
]

const boxNames = {
  1: 'Риск',
  2: 'Средний исполнитель',
  3: 'Надёжный профессионал',
  4: 'Нестабильный игрок',
  5: 'Ключевой сотрудник',
  6: 'Высокопроизводительный',
  7: 'Необработанный алмаз',
  8: 'Будущая звезда',
  9: 'Звезда'
}

const boxDescriptions = {
  1: 'Низкая эффективность и потенциал. Требует решения.',
  2: 'Стабильный результат, ограниченный рост.',
  3: 'Высокий результат, эксперт в своей области.',
  4: 'Высокий потенциал, нестабильный результат.',
  5: 'Надёжная основа команды.',
  6: 'Отличный результат, кандидат на рост.',
  7: 'Потенциал есть, нужно развитие.',
  8: 'Перспективный, будущий лидер.',
  9: 'Лучшие из лучших. Удерживать!'
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

// Filtered employees for search
const filteredEmployees = computed(() => {
  if (!searchQuery.value) return []
  const query = searchQuery.value.toLowerCase()
  return employees.value
    .filter(e => e.fullName.toLowerCase().includes(query))
    .slice(0, 10)
})

// Matrix data
const matrixData = computed(() => {
  const matrix = {}
  for (let i = 1; i <= 9; i++) {
    matrix[i] = assessments.value.filter(a => a.boxPosition === i)
  }
  return matrix
})

// Calculated scores preview
const previewScores = computed(() => {
  const perf = (form.value.q1Results + form.value.q2Goals + form.value.q3Quality) / 3
  const pot = (form.value.q4Growth + form.value.q5Leadership) / 2

  const perfLevel = perf <= 2.3 ? 0 : perf <= 3.6 ? 1 : 2
  const potLevel = pot <= 2.3 ? 0 : pot <= 3.6 ? 1 : 2
  const boxPosition = potLevel * 3 + perfLevel + 1

  return {
    performance: perf.toFixed(2),
    potential: pot.toFixed(2),
    boxPosition,
    boxName: boxNames[boxPosition]
  }
})

async function fetchData() {
  loading.value = true
  try {
    const [empRes, assRes, statsRes] = await Promise.all([
      employeesApi.getAll({ size: 1000 }),
      nineBoxApi.getAll(),
      nineBoxApi.getStatistics()
    ])
    employees.value = empRes.data.content || empRes.data
    assessments.value = assRes.data
    statistics.value = statsRes.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки данных')
  } finally {
    loading.value = false
  }
}

function selectEmployee(employee) {
  selectedEmployee.value = employee
  searchQuery.value = employee.fullName

  // Check if already assessed
  const existing = assessments.value.find(a => a.employeeId === employee.id)
  if (existing) {
    currentAssessment.value = existing
    form.value = {
      q1Results: existing.q1Results,
      q2Goals: existing.q2Goals,
      q3Quality: existing.q3Quality,
      q4Growth: existing.q4Growth,
      q5Leadership: existing.q5Leadership,
      comment: existing.comment || ''
    }
  } else {
    currentAssessment.value = null
    form.value = {
      q1Results: 3,
      q2Goals: 3,
      q3Quality: 3,
      q4Growth: 3,
      q5Leadership: 3,
      comment: ''
    }
  }
}

async function saveAssessment() {
  if (!selectedEmployee.value) {
    ElMessage.warning('Выберите сотрудника')
    return
  }

  loading.value = true
  try {
    await nineBoxApi.createOrUpdate({
      employeeId: selectedEmployee.value.id,
      ...form.value
    })
    ElMessage.success('Оценка сохранена')
    await fetchData()
    // Update current assessment
    currentAssessment.value = assessments.value.find(a => a.employeeId === selectedEmployee.value.id)
  } catch (error) {
    ElMessage.error('Ошибка сохранения')
  } finally {
    loading.value = false
  }
}

function clearSelection() {
  selectedEmployee.value = null
  currentAssessment.value = null
  searchQuery.value = ''
  form.value = {
    q1Results: 3,
    q2Goals: 3,
    q3Quality: 3,
    q4Growth: 3,
    q5Leadership: 3,
    comment: ''
  }
}

function goBack() {
  router.push('/')
}

function formatDate(dateStr) {
  if (!dateStr) return ''
  return new Date(dateStr).toLocaleDateString('ru-RU')
}

// Chart data helpers
function getChartData(data) {
  if (!data) return []
  return Object.entries(data).map(([name, boxes]) => {
    const total = Object.values(boxes).reduce((sum, count) => sum + count, 0)
    return { name, boxes, total }
  }).sort((a, b) => b.total - a.total)
}

function getPieSlices(data) {
  const chartData = getChartData(data)
  const total = chartData.reduce((sum, item) => sum + item.total, 0)
  if (total === 0) return []

  let currentAngle = 0
  const slices = []
  const colors = ['#7c3aed', '#3b82f6', '#22c55e', '#eab308', '#f97316', '#ef4444', '#ec4899', '#06b6d4', '#84cc16']

  chartData.forEach((item, index) => {
    const angle = (item.total / total) * 360
    const startAngle = currentAngle
    const endAngle = currentAngle + angle

    // SVG arc calculation
    const startRad = (startAngle - 90) * Math.PI / 180
    const endRad = (endAngle - 90) * Math.PI / 180
    const largeArc = angle > 180 ? 1 : 0

    const x1 = 100 + 80 * Math.cos(startRad)
    const y1 = 100 + 80 * Math.sin(startRad)
    const x2 = 100 + 80 * Math.cos(endRad)
    const y2 = 100 + 80 * Math.sin(endRad)

    // Label position (middle of slice)
    const midRad = ((startAngle + endAngle) / 2 - 90) * Math.PI / 180
    const labelX = 100 + 50 * Math.cos(midRad)
    const labelY = 100 + 50 * Math.sin(midRad)

    slices.push({
      name: item.name,
      total: item.total,
      percent: Math.round((item.total / total) * 100),
      color: colors[index % colors.length],
      path: `M 100 100 L ${x1} ${y1} A 80 80 0 ${largeArc} 1 ${x2} ${y2} Z`,
      labelX,
      labelY
    })

    currentAngle = endAngle
  })

  return slices
}

function getMaxBarValue(data) {
  const chartData = getChartData(data)
  return Math.max(...chartData.map(d => d.total), 1)
}

function selectDepartment(dept) {
  selectedDept.value = selectedDept.value === dept ? null : dept
}

function selectPosition(pos) {
  selectedPos.value = selectedPos.value === pos ? null : pos
}

function getSelectedDeptData() {
  if (!selectedDept.value || !statistics.value?.byDepartment) return null
  return statistics.value.byDepartment[selectedDept.value]
}

function getSelectedPosData() {
  if (!selectedPos.value || !statistics.value?.byPosition) return null
  return statistics.value.byPosition[selectedPos.value]
}

onMounted(fetchData)
</script>

<template>
  <div class="nine-box-container">
    <!-- Background -->
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
        <h1 class="page-title">9-Box Assessment</h1>
      </div>
      <div class="header-right">
        <div class="user-badge glass-card">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
          <span>{{ authStore.user?.username }}</span>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
      <!-- Left Panel: Search & Form -->
      <div class="left-panel glass-card">
        <h2 class="panel-title">Оценка сотрудника</h2>

        <!-- Search -->
        <div class="search-section">
          <label class="field-label">Поиск по ФИО</label>
          <el-input
            v-model="searchQuery"
            placeholder="Введите имя сотрудника..."
            clearable
            @clear="clearSelection"
          >
            <template #prefix>
              <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
                <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
              </svg>
            </template>
          </el-input>

          <!-- Search Results -->
          <div v-if="filteredEmployees.length > 0 && !selectedEmployee" class="search-results">
            <div
              v-for="emp in filteredEmployees"
              :key="emp.id"
              class="search-item"
              @click="selectEmployee(emp)"
            >
              <span class="emp-name">{{ emp.fullName }}</span>
              <span class="emp-dept">{{ emp.customFields?.department || '—' }}</span>
            </div>
          </div>
        </div>

        <!-- Selected Employee Info -->
        <div v-if="selectedEmployee" class="selected-employee">
          <div class="emp-info">
            <div class="emp-avatar">{{ selectedEmployee.fullName.charAt(0) }}</div>
            <div class="emp-details">
              <div class="emp-name">{{ selectedEmployee.fullName }}</div>
              <div class="emp-meta">
                {{ selectedEmployee.customFields?.department || '—' }} •
                {{ selectedEmployee.customFields?.position || '—' }}
              </div>
            </div>
            <button class="clear-btn" @click="clearSelection">
              <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
                <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
              </svg>
            </button>
          </div>

          <div v-if="currentAssessment" class="existing-badge">
            Последняя оценка: {{ formatDate(currentAssessment.assessedAt) }}
          </div>
        </div>

        <!-- Assessment Form -->
        <div v-if="selectedEmployee" class="assessment-form">
          <div v-for="q in questions" :key="q.key" class="question-item">
            <div class="question-header">
              <span class="question-label">{{ q.label }}</span>
              <span class="question-category" :class="q.category.toLowerCase()">{{ q.category }}</span>
            </div>
            <div class="rating-slider">
              <el-slider
                v-model="form[q.key]"
                :min="1"
                :max="5"
                :step="1"
                :marks="{ 1: '1', 2: '2', 3: '3', 4: '4', 5: '5' }"
                show-stops
              />
            </div>
          </div>

          <div class="question-item">
            <label class="question-label">Комментарий</label>
            <el-input
              v-model="form.comment"
              type="textarea"
              :rows="3"
              placeholder="Дополнительные заметки..."
            />
          </div>

          <!-- Preview -->
          <div class="preview-section">
            <div class="preview-title">Результат оценки</div>
            <div class="preview-grid">
              <div class="preview-item">
                <span class="preview-label">Performance</span>
                <span class="preview-value">{{ previewScores.performance }}</span>
              </div>
              <div class="preview-item">
                <span class="preview-label">Potential</span>
                <span class="preview-value">{{ previewScores.potential }}</span>
              </div>
              <div class="preview-item box-preview" :style="{ '--box-color': boxColors[previewScores.boxPosition] }">
                <span class="preview-label">Box</span>
                <span class="preview-value">{{ previewScores.boxName }}</span>
              </div>
            </div>
          </div>

          <el-button type="primary" class="save-btn" :loading="loading" @click="saveAssessment">
            {{ currentAssessment ? 'Обновить оценку' : 'Сохранить оценку' }}
          </el-button>
        </div>
      </div>

      <!-- Right Panel: Matrix & Analytics -->
      <div class="right-panel">
        <!-- Tabs -->
        <div class="tabs glass-card">
          <button
            class="tab-btn"
            :class="{ active: activeTab === 'matrix' }"
            @click="activeTab = 'matrix'"
          >Матрица</button>
          <button
            class="tab-btn"
            :class="{ active: activeTab === 'analytics' }"
            @click="activeTab = 'analytics'"
          >Аналитика</button>
        </div>

        <!-- Matrix View -->
        <div v-if="activeTab === 'matrix'" class="matrix-section glass-card">
          <div class="matrix-wrapper">
            <!-- Y-axis label -->
            <div class="y-axis-label">ПОТЕНЦИАЛ</div>

            <!-- Row labels -->
            <div class="row-labels">
              <span>Высокий</span>
              <span>Средний</span>
              <span>Низкий</span>
            </div>

            <!-- Matrix Grid 3x3 -->
            <div class="matrix-grid-square">
              <!-- Row 3: High Potential (boxes 7, 8, 9) -->
              <div
                class="matrix-box"
                :style="{ '--box-color': boxColors[7] }"
                @click="router.push('/nine-box/7')"
              >
                <div class="box-header">
                  <span class="box-name">{{ boxNames[7] }}</span>
                  <span class="box-count" :style="{ background: boxColors[7] }">{{ matrixData[7]?.length || 0 }}</span>
                </div>
                <p class="box-desc">{{ boxDescriptions[7] }}</p>
              </div>
              <div
                class="matrix-box"
                :style="{ '--box-color': boxColors[8] }"
                @click="router.push('/nine-box/8')"
              >
                <div class="box-header">
                  <span class="box-name">{{ boxNames[8] }}</span>
                  <span class="box-count" :style="{ background: boxColors[8] }">{{ matrixData[8]?.length || 0 }}</span>
                </div>
                <p class="box-desc">{{ boxDescriptions[8] }}</p>
              </div>
              <div
                class="matrix-box"
                :style="{ '--box-color': boxColors[9] }"
                @click="router.push('/nine-box/9')"
              >
                <div class="box-header">
                  <span class="box-name">{{ boxNames[9] }}</span>
                  <span class="box-count" :style="{ background: boxColors[9] }">{{ matrixData[9]?.length || 0 }}</span>
                </div>
                <p class="box-desc">{{ boxDescriptions[9] }}</p>
              </div>

              <!-- Row 2: Medium Potential (boxes 4, 5, 6) -->
              <div
                class="matrix-box"
                :style="{ '--box-color': boxColors[4] }"
                @click="router.push('/nine-box/4')"
              >
                <div class="box-header">
                  <span class="box-name">{{ boxNames[4] }}</span>
                  <span class="box-count" :style="{ background: boxColors[4] }">{{ matrixData[4]?.length || 0 }}</span>
                </div>
                <p class="box-desc">{{ boxDescriptions[4] }}</p>
              </div>
              <div
                class="matrix-box"
                :style="{ '--box-color': boxColors[5] }"
                @click="router.push('/nine-box/5')"
              >
                <div class="box-header">
                  <span class="box-name">{{ boxNames[5] }}</span>
                  <span class="box-count" :style="{ background: boxColors[5] }">{{ matrixData[5]?.length || 0 }}</span>
                </div>
                <p class="box-desc">{{ boxDescriptions[5] }}</p>
              </div>
              <div
                class="matrix-box"
                :style="{ '--box-color': boxColors[6] }"
                @click="router.push('/nine-box/6')"
              >
                <div class="box-header">
                  <span class="box-name">{{ boxNames[6] }}</span>
                  <span class="box-count" :style="{ background: boxColors[6] }">{{ matrixData[6]?.length || 0 }}</span>
                </div>
                <p class="box-desc">{{ boxDescriptions[6] }}</p>
              </div>

              <!-- Row 1: Low Potential (boxes 1, 2, 3) -->
              <div
                class="matrix-box"
                :style="{ '--box-color': boxColors[1] }"
                @click="router.push('/nine-box/1')"
              >
                <div class="box-header">
                  <span class="box-name">{{ boxNames[1] }}</span>
                  <span class="box-count" :style="{ background: boxColors[1] }">{{ matrixData[1]?.length || 0 }}</span>
                </div>
                <p class="box-desc">{{ boxDescriptions[1] }}</p>
              </div>
              <div
                class="matrix-box"
                :style="{ '--box-color': boxColors[2] }"
                @click="router.push('/nine-box/2')"
              >
                <div class="box-header">
                  <span class="box-name">{{ boxNames[2] }}</span>
                  <span class="box-count" :style="{ background: boxColors[2] }">{{ matrixData[2]?.length || 0 }}</span>
                </div>
                <p class="box-desc">{{ boxDescriptions[2] }}</p>
              </div>
              <div
                class="matrix-box"
                :style="{ '--box-color': boxColors[3] }"
                @click="router.push('/nine-box/3')"
              >
                <div class="box-header">
                  <span class="box-name">{{ boxNames[3] }}</span>
                  <span class="box-count" :style="{ background: boxColors[3] }">{{ matrixData[3]?.length || 0 }}</span>
                </div>
                <p class="box-desc">{{ boxDescriptions[3] }}</p>
              </div>
            </div>

            <!-- Column labels -->
            <div class="col-labels">
              <span>Низкая</span>
              <span>Средняя</span>
              <span>Высокая</span>
            </div>

            <!-- X-axis label -->
            <div class="x-axis-label">ЭФФЕКТИВНОСТЬ</div>
          </div>
        </div>

        <!-- Analytics View -->
        <div v-if="activeTab === 'analytics'" class="analytics-section glass-card">
          <div v-if="statistics" class="analytics-content">
            <!-- Total -->
            <div class="stat-card">
              <div class="stat-value">{{ statistics.totalAssessments }}</div>
              <div class="stat-label">Всего оценок</div>
            </div>

            <!-- Distribution -->
            <div class="analytics-block">
              <h3>Распределение по матрице</h3>
              <div class="distribution-grid">
                <div
                  v-for="box in [7, 8, 9, 4, 5, 6, 1, 2, 3]"
                  :key="box"
                  class="dist-item"
                  :style="{ '--box-color': boxColors[box] }"
                  @click="router.push('/nine-box/' + box)"
                >
                  <span class="dist-name">{{ boxNames[box] }}</span>
                  <span class="dist-count">{{ statistics.boxDistribution?.[box] || 0 }}</span>
                </div>
              </div>
            </div>

            <!-- Analytics Tabs -->
            <div class="analytics-tabs-block">
              <div class="analytics-tabs">
                <button
                  class="analytics-tab"
                  :class="{ active: analyticsMode === 'dept' }"
                  @click="analyticsMode = 'dept'; selectedDept = null"
                >
                  По подразделениям
                </button>
                <button
                  class="analytics-tab"
                  :class="{ active: analyticsMode === 'pos' }"
                  @click="analyticsMode = 'pos'; selectedPos = null"
                >
                  По должностям
                </button>
              </div>

              <!-- Department Content -->
              <div v-if="analyticsMode === 'dept' && statistics.byDepartment" class="analytics-two-col">
                <!-- Left: List -->
                <div class="analytics-list">
                  <div
                    v-for="(boxes, dept) in statistics.byDepartment"
                    :key="dept"
                    class="analytics-list-item"
                    :class="{ active: selectedDept === dept }"
                    @click="selectDepartment(dept)"
                  >
                    <span class="item-name">{{ dept }}</span>
                    <span class="item-count">{{ Object.values(boxes).reduce((a, b) => a + b, 0) }}</span>
                  </div>
                </div>

                <!-- Right: Matrix -->
                <div class="analytics-matrix">
                  <div v-if="selectedDept" class="matrix-header">
                    <h4>{{ selectedDept }}</h4>
                    <button class="close-btn" @click="selectedDept = null">
                      <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                        <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                      </svg>
                    </button>
                  </div>
                  <div v-else class="matrix-header">
                    <h4>Выберите подразделение</h4>
                  </div>

                  <div class="box-grid-matrix">
                    <div
                      v-for="box in [7, 8, 9, 4, 5, 6, 1, 2, 3]"
                      :key="box"
                      class="box-matrix-item"
                      :class="{ empty: !selectedDept || !getSelectedDeptData()?.[box] }"
                      :style="{ '--box-color': boxColors[box] }"
                    >
                      <span class="box-matrix-count">{{ selectedDept ? (getSelectedDeptData()?.[box] || 0) : '-' }}</span>
                      <span class="box-matrix-name">{{ boxNames[box] }}</span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Position Content -->
              <div v-if="analyticsMode === 'pos' && statistics.byPosition" class="analytics-two-col">
                <!-- Left: List -->
                <div class="analytics-list">
                  <div
                    v-for="(boxes, pos) in statistics.byPosition"
                    :key="pos"
                    class="analytics-list-item"
                    :class="{ active: selectedPos === pos }"
                    @click="selectPosition(pos)"
                  >
                    <span class="item-name">{{ pos }}</span>
                    <span class="item-count">{{ Object.values(boxes).reduce((a, b) => a + b, 0) }}</span>
                  </div>
                </div>

                <!-- Right: Matrix -->
                <div class="analytics-matrix">
                  <div v-if="selectedPos" class="matrix-header">
                    <h4>{{ selectedPos }}</h4>
                    <button class="close-btn" @click="selectedPos = null">
                      <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                        <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                      </svg>
                    </button>
                  </div>
                  <div v-else class="matrix-header">
                    <h4>Выберите должность</h4>
                  </div>

                  <div class="box-grid-matrix">
                    <div
                      v-for="box in [7, 8, 9, 4, 5, 6, 1, 2, 3]"
                      :key="box"
                      class="box-matrix-item"
                      :class="{ empty: !selectedPos || !getSelectedPosData()?.[box] }"
                      :style="{ '--box-color': boxColors[box] }"
                    >
                      <span class="box-matrix-count">{{ selectedPos ? (getSelectedPosData()?.[box] || 0) : '-' }}</span>
                      <span class="box-matrix-name">{{ boxNames[box] }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
.nine-box-container {
  min-height: 100vh;
  position: relative;
  padding: 20px;
}

/* Background */
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

.page-title {
  font-size: 24px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
}

.user-badge {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  font-size: 14px;
  color: var(--text-primary);
}

/* Main Content */
.main-content {
  display: grid;
  grid-template-columns: 400px 1fr;
  gap: 20px;
  position: relative;
  z-index: 10;
}

/* Left Panel */
.left-panel {
  padding: 24px;
  height: fit-content;
  position: sticky;
  top: 20px;
}

.panel-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 20px 0;
}

.field-label {
  display: block;
  font-size: 13px;
  color: var(--text-secondary);
  margin-bottom: 8px;
}

/* Search */
.search-section {
  position: relative;
  margin-bottom: 20px;
}

.search-results {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: rgba(30, 30, 50, 0.98);
  border: 1px solid var(--border-glass);
  border-radius: 8px;
  margin-top: 4px;
  max-height: 300px;
  overflow-y: auto;
  z-index: 100;
}

.search-item {
  padding: 12px 16px;
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid var(--border-glass);
  transition: background 0.2s;
}

.search-item:last-child {
  border-bottom: none;
}

.search-item:hover {
  background: rgba(124, 58, 237, 0.2);
}

.search-item .emp-name {
  color: var(--text-primary);
  font-weight: 500;
}

.search-item .emp-dept {
  color: var(--text-muted);
  font-size: 12px;
}

/* Selected Employee */
.selected-employee {
  background: rgba(124, 58, 237, 0.1);
  border: 1px solid rgba(124, 58, 237, 0.3);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 20px;
}

.emp-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.emp-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: var(--accent);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: 600;
}

.emp-details {
  flex: 1;
}

.emp-details .emp-name {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
}

.emp-meta {
  font-size: 13px;
  color: var(--text-muted);
  margin-top: 2px;
}

.clear-btn {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: transparent;
  border: none;
  color: var(--text-muted);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.clear-btn:hover {
  background: rgba(239, 68, 68, 0.2);
  color: #ef4444;
}

.existing-badge {
  margin-top: 12px;
  padding: 8px 12px;
  background: rgba(34, 197, 94, 0.1);
  border-radius: 6px;
  font-size: 12px;
  color: #22c55e;
}

/* Assessment Form */
.assessment-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.question-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.question-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.question-label {
  font-size: 14px;
  color: var(--text-primary);
}

.question-category {
  font-size: 10px;
  padding: 2px 8px;
  border-radius: 10px;
  font-weight: 600;
  text-transform: uppercase;
}

.question-category.performance {
  background: rgba(59, 130, 246, 0.2);
  color: #3b82f6;
}

.question-category.potential {
  background: rgba(139, 92, 246, 0.2);
  color: #8b5cf6;
}

.rating-slider {
  padding: 0 8px;
}

.rating-slider :deep(.el-slider__runway) {
  background: rgba(255, 255, 255, 0.1);
}

.rating-slider :deep(.el-slider__bar) {
  background: var(--accent);
}

.rating-slider :deep(.el-slider__button) {
  border-color: var(--accent);
}

/* Preview */
.preview-section {
  background: rgba(30, 30, 50, 0.8);
  border-radius: 12px;
  padding: 16px;
}

.preview-title {
  font-size: 13px;
  color: var(--text-muted);
  margin-bottom: 12px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.preview-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.preview-item {
  text-align: center;
  padding: 12px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
}

.preview-item.box-preview {
  background: color-mix(in srgb, var(--box-color) 20%, transparent);
  border: 1px solid var(--box-color);
}

.preview-label {
  display: block;
  font-size: 11px;
  color: var(--text-muted);
  margin-bottom: 4px;
}

.preview-value {
  display: block;
  font-size: 16px;
  font-weight: 700;
  color: var(--text-primary);
}

.save-btn {
  width: 100%;
  height: 48px;
  font-size: 15px;
  font-weight: 600;
}

/* Right Panel */
.right-panel {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* Tabs */
.tabs {
  display: flex;
  padding: 6px;
  gap: 6px;
}

.tab-btn {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 10px;
  background: transparent;
  color: var(--text-secondary);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.tab-btn:hover {
  background: rgba(255, 255, 255, 0.05);
}

.tab-btn.active {
  background: var(--accent);
  color: white;
}

/* Matrix */
.matrix-section {
  padding: 16px;
  flex: 1;
  display: flex;
}

.matrix-wrapper {
  display: grid;
  grid-template-columns: auto auto 1fr;
  grid-template-rows: 1fr auto auto;
  gap: 8px;
  width: 100%;
  height: 100%;
  min-height: 500px;
}

.y-axis-label {
  grid-column: 1;
  grid-row: 1;
  font-size: 11px;
  font-weight: 600;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 1px;
  writing-mode: vertical-rl;
  text-orientation: mixed;
  transform: rotate(180deg);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 8px;
}

.row-labels {
  grid-column: 2;
  grid-row: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  padding-right: 8px;
}

.row-labels span {
  font-size: 11px;
  color: var(--text-muted);
  font-weight: 500;
  text-align: right;
  writing-mode: vertical-rl;
  text-orientation: mixed;
  transform: rotate(180deg);
}

.matrix-grid-square {
  grid-column: 3;
  grid-row: 1;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: repeat(3, 1fr);
  gap: 8px;
  width: 100%;
  height: 100%;
}

.col-labels {
  grid-column: 3;
  grid-row: 2;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}

.col-labels span {
  text-align: center;
  font-size: 11px;
  color: var(--text-muted);
  font-weight: 500;
}

.x-axis-label {
  grid-column: 3;
  grid-row: 3;
  font-size: 11px;
  font-weight: 600;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 1px;
  text-align: center;
  padding-top: 4px;
}

.matrix-box {
  background: color-mix(in srgb, var(--box-color) 15%, transparent);
  border: 1px solid color-mix(in srgb, var(--box-color) 40%, transparent);
  border-radius: 12px;
  padding: 12px;
  display: flex;
  flex-direction: column;
  cursor: pointer;
  transition: all 0.2s;
  overflow: hidden;
}

.matrix-box:hover {
  border-color: var(--box-color);
  transform: scale(1.02);
  box-shadow: 0 8px 32px color-mix(in srgb, var(--box-color) 30%, transparent);
}

.box-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 8px;
  margin-bottom: 8px;
}

.box-name {
  font-size: 13px;
  font-weight: 600;
  color: var(--text-primary);
  line-height: 1.3;
}

.box-count {
  min-width: 28px;
  height: 28px;
  padding: 0 8px;
  border-radius: 14px;
  color: white;
  font-size: 13px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.box-desc {
  font-size: 11px;
  color: var(--text-secondary);
  line-height: 1.4;
  margin: 0;
  flex: 1;
  opacity: 0.8;
}

/* Analytics */
.analytics-section {
  padding: 24px;
}

.analytics-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.stat-card {
  text-align: center;
  padding: 24px;
  background: rgba(124, 58, 237, 0.1);
  border-radius: 16px;
  border: 1px solid rgba(124, 58, 237, 0.2);
}

.stat-value {
  font-size: 48px;
  font-weight: 800;
  color: var(--accent);
}

.stat-label {
  font-size: 14px;
  color: var(--text-muted);
  margin-top: 4px;
}

.analytics-block h3 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 16px 0;
}

.distribution-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}

.dist-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  background: color-mix(in srgb, var(--box-color) 15%, transparent);
  border: 1px solid color-mix(in srgb, var(--box-color) 30%, transparent);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.dist-item:hover {
  border-color: var(--box-color);
  transform: scale(1.02);
}

.dist-name {
  font-size: 12px;
  color: var(--text-primary);
}

.dist-count {
  font-size: 16px;
  font-weight: 700;
  color: var(--box-color);
}

.dept-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.dept-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: rgba(30, 30, 50, 0.6);
  border-radius: 8px;
}

.dept-name {
  font-size: 14px;
  color: var(--text-primary);
}

.dept-boxes {
  display: flex;
  gap: 4px;
}

/* Analytics Tabs Block */
.analytics-tabs-block {
  margin-top: 24px;
}

.analytics-tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
}

.analytics-tab {
  flex: 1;
  padding: 14px 24px;
  border: none;
  border-radius: 12px;
  background: rgba(30, 30, 50, 0.6);
  color: var(--text-secondary);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  border: 1px solid transparent;
}

.analytics-tab:hover {
  background: rgba(124, 58, 237, 0.15);
  color: var(--text-primary);
}

.analytics-tab.active {
  background: linear-gradient(135deg, rgba(124, 58, 237, 0.4), rgba(168, 85, 247, 0.3));
  border-color: #a855f7;
  color: white;
  box-shadow: 0 4px 20px rgba(168, 85, 247, 0.3);
}

/* Two Column Layout */
.analytics-two-col {
  display: grid;
  grid-template-columns: 200px 1fr;
  gap: 20px;
  min-height: 400px;
}

.analytics-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
  height: 100%;
  overflow-y: auto;
}

.analytics-list-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 16px;
  background: rgba(30, 30, 50, 0.6);
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;
  border: 2px solid transparent;
}

.analytics-list-item:hover {
  background: rgba(124, 58, 237, 0.15);
  border-color: rgba(124, 58, 237, 0.3);
}

.analytics-list-item.active {
  background: linear-gradient(135deg, rgba(124, 58, 237, 0.4), rgba(168, 85, 247, 0.3));
  border-color: #a855f7;
  box-shadow: 0 0 16px rgba(168, 85, 247, 0.5);
}

.analytics-list-item .item-name {
  font-size: 14px;
  color: var(--text-primary);
  font-weight: 500;
}

.analytics-list-item .item-count {
  font-size: 16px;
  font-weight: 700;
  color: #a855f7;
}

.analytics-matrix {
  display: flex;
  flex-direction: column;
}

.matrix-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.matrix-header h4 {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
}

.close-btn {
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.1);
  color: var(--text-muted);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.close-btn:hover {
  background: rgba(239, 68, 68, 0.2);
  color: #ef4444;
}

/* Box Grid Matrix */
.box-grid-matrix {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  flex: 1;
}

.box-matrix-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px 12px;
  background: color-mix(in srgb, var(--box-color) 50%, rgba(20, 20, 40, 0.8));
  border: 2px solid var(--box-color);
  border-radius: 14px;
  transition: all 0.2s;
  box-shadow: 0 4px 24px color-mix(in srgb, var(--box-color) 40%, transparent);
}

.box-matrix-item.empty {
  background: color-mix(in srgb, var(--box-color) 8%, transparent);
  border: 1px solid color-mix(in srgb, var(--box-color) 20%, transparent);
  box-shadow: none;
  opacity: 0.5;
}

.box-matrix-item:not(.empty):hover {
  transform: scale(1.02);
  box-shadow: 0 8px 32px color-mix(in srgb, var(--box-color) 50%, transparent);
}

.box-matrix-count {
  font-size: 32px;
  font-weight: 800;
  color: var(--box-color);
}

.box-matrix-name {
  font-size: 11px;
  color: var(--text-secondary);
  text-align: center;
  margin-top: 8px;
  line-height: 1.3;
}

/* Responsive */
@media (max-width: 1024px) {
  .main-content {
    grid-template-columns: 1fr;
  }

  .left-panel {
    position: static;
  }
}
</style>
