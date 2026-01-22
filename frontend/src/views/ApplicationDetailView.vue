<template>
  <div class="application-detail-view">
    <!-- Фон с orbs -->
    <div class="bg-orbs">
      <div class="orb orb-1"></div>
      <div class="orb orb-2"></div>
      <div class="orb orb-3"></div>
    </div>

    <!-- Навигация -->
    <div class="page-nav">
      <el-button text @click="goBack" style="color: rgba(255, 255, 255, 0.8);">
        ← Назад к списку
      </el-button>
      <span class="page-title">Заявка #{{ application?.id || applicationId }}</span>
    </div>

    <!-- Загрузка -->
    <div v-if="applicationsStore.loading && !application" class="loading-container">
      <el-skeleton :rows="10" animated />
    </div>

    <!-- Контент -->
    <div v-else-if="application" class="content">
      <!-- Основная информация -->
      <div class="info-card glass-card">
        <div class="card-header">
          <h2>Основная информация</h2>
          <div class="header-right">
            <ApplicationStatusBadge :status="application.status" size="large" />
            <el-button
              v-if="canEdit && !isEditing"
              type="primary"
              @click="startEdit"
            >
              Редактировать
            </el-button>
            <template v-if="isEditing">
              <el-button type="success" @click="saveEdit">Сохранить</el-button>
              <el-button @click="cancelEdit">Отмена</el-button>
            </template>
          </div>
        </div>

        <div class="info-grid">
          <!-- Левая колонка -->
          <div class="info-column">
            <div class="info-row">
              <span class="info-label">ID</span>
              <span class="info-value">{{ application.id }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Сотрудник</span>
              <span class="info-value">{{ application.employeeName || '-' }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Email</span>
              <span class="info-value">{{ application.employeeEmail || '-' }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Целевая должность</span>
              <span class="info-value" v-if="!isEditing">{{ application.targetPosition || '-' }}</span>
              <el-input v-else v-model="editForm.targetPosition" />
            </div>
            <div class="info-row">
              <span class="info-label">Целевой стек</span>
              <span class="info-value" v-if="!isEditing">{{ application.targetStack || '-' }}</span>
              <el-input v-else v-model="editForm.targetStack" />
            </div>
          </div>

          <!-- Правая колонка -->
          <div class="info-column">
            <div class="info-row">
              <span class="info-label">Текущая ЗП</span>
              <span class="info-value" v-if="!isEditing">
                {{ application.currentSalary ? formatSalary(application.currentSalary) : '-' }}
              </span>
              <el-input-number v-else v-model="editForm.currentSalary" :min="0" :step="10000" controls-position="right" style="width: 100%" />
            </div>
            <div class="info-row">
              <span class="info-label">Целевая ЗП</span>
              <span class="info-value" v-if="!isEditing">
                {{ application.targetSalary ? formatSalary(application.targetSalary) : '-' }}
              </span>
              <el-input-number v-else v-model="editForm.targetSalary" :min="0" :step="10000" controls-position="right" style="width: 100%" />
            </div>
            <div class="info-row">
              <span class="info-label">Изменение ЗП</span>
              <span class="info-value">
                <el-tag v-if="application.salaryIncreasePercent" :type="getSalaryChangeType()" size="small">
                  {{ application.salaryIncreasePercent > 0 ? '+' : '' }}{{ application.salaryIncreasePercent?.toFixed(1) }}%
                </el-tag>
                <span v-else>-</span>
              </span>
            </div>
            <div class="info-row">
              <span class="info-label">Создано</span>
              <span class="info-value">{{ formatDateTime(application.createdAt) }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Автор</span>
              <span class="info-value">{{ application.createdByName || '-' }}</span>
            </div>
          </div>
        </div>

        <!-- Участники -->
        <div class="participants-section">
          <h3>Участники</h3>
          <div class="participants-grid">
            <div class="participant">
              <span class="participant-role">Рекрутер</span>
              <span class="participant-name">{{ application.recruiterName || 'Не назначен' }}</span>
            </div>
            <div class="participant">
              <span class="participant-role">HR BP</span>
              <span class="participant-name">{{ application.hrBpName || 'Не назначен' }}</span>
            </div>
            <div class="participant" v-if="application.requiresBorupApproval">
              <span class="participant-role">БОРУП</span>
              <span class="participant-name">{{ application.borupName || 'Не назначен' }}</span>
            </div>
          </div>
        </div>

        <!-- Комментарий -->
        <div class="comment-section" v-if="application.comment || isEditing">
          <h3>Комментарий</h3>
          <p v-if="!isEditing" class="comment-text">{{ application.comment || '-' }}</p>
          <el-input v-else v-model="editForm.comment" type="textarea" :rows="3" />
        </div>

        <!-- Действия workflow -->
        <div class="actions-section" v-if="availableActions.length > 0">
          <ApplicationWorkflowActions
            :application-id="application.id"
            :available-actions="availableActions"
            @action-executed="handleActionExecuted"
          />
        </div>
      </div>

      <!-- История изменений -->
      <div class="history-card glass-card">
        <h2>История изменений</h2>
        <div v-if="history.length" class="history-timeline">
          <div v-for="item in history" :key="item.id" class="history-item">
            <div class="history-dot"></div>
            <div class="history-content">
              <div class="history-header">
                <span class="history-action">{{ item.action }}</span>
                <span class="history-date">{{ formatDateTime(item.changedAt) }}</span>
              </div>
              <div class="history-user">{{ item.changedByName }}</div>
              <div v-if="item.comment" class="history-comment">{{ item.comment }}</div>
              <div v-if="item.oldStatus || item.newStatus" class="history-status">
                <ApplicationStatusBadge v-if="item.oldStatus" :status="item.oldStatus" size="small" />
                <span v-if="item.oldStatus && item.newStatus"> → </span>
                <ApplicationStatusBadge v-if="item.newStatus" :status="item.newStatus" size="small" />
              </div>
            </div>
          </div>
        </div>
        <el-empty v-else description="История изменений отсутствует" />
      </div>
    </div>

    <el-empty v-else description="Заявка не найдена" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, reactive } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useApplicationsStore } from '@/stores/applications'
import { ElMessage } from 'element-plus'
import ApplicationStatusBadge from '@/components/applications/ApplicationStatusBadge.vue'
import ApplicationWorkflowActions from '@/components/applications/ApplicationWorkflowActions.vue'

const route = useRoute()
const router = useRouter()
const applicationsStore = useApplicationsStore()

const applicationId = computed(() => parseInt(route.params.id))
const application = computed(() => applicationsStore.currentApplication)
const history = computed(() => applicationsStore.history)
const availableActions = ref([])

const isEditing = ref(false)
const editForm = reactive({
  targetPosition: '',
  targetStack: '',
  currentSalary: 0,
  targetSalary: 0,
  comment: ''
})

const canEdit = computed(() => {
  const editableStatuses = ['DRAFT', 'AVAILABLE_FOR_REVIEW']
  return editableStatuses.includes(application.value?.status)
})

function goBack() {
  router.push('/applications')
}

function startEdit() {
  if (!canEdit.value) return

  editForm.targetPosition = application.value.targetPosition || ''
  editForm.targetStack = application.value.targetStack || ''
  editForm.currentSalary = application.value.currentSalary || 0
  editForm.targetSalary = application.value.targetSalary || 0
  editForm.comment = application.value.comment || ''

  isEditing.value = true
}

function cancelEdit() {
  isEditing.value = false
}

async function saveEdit() {
  try {
    await applicationsStore.update(application.value.id, {
      targetPosition: editForm.targetPosition,
      targetStack: editForm.targetStack,
      currentSalary: editForm.currentSalary,
      targetSalary: editForm.targetSalary,
      comment: editForm.comment
    })
    ElMessage.success('Заявка обновлена')
    isEditing.value = false
    await loadApplication()
  } catch (error) {
    const message = error.response?.data?.message || error.message || 'Ошибка сохранения'
    ElMessage.error({
      message: message,
      duration: 5000,
      showClose: true
    })
  }
}

function formatSalary(value) {
  if (!value) return '-'
  return new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
    minimumFractionDigits: 0
  }).format(value)
}

function getSalaryChangeType() {
  if (!application.value?.salaryIncreasePercent) return 'info'
  const percent = application.value.salaryIncreasePercent
  if (percent > 30) return 'danger'
  if (percent > 15) return 'warning'
  if (percent > 0) return 'success'
  return 'info'
}

function formatDateTime(dateString) {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleString('ru-RU')
}

async function loadApplication() {
  try {
    await applicationsStore.fetchById(applicationId.value)
    await loadHistory()
    await loadAvailableActions()
  } catch (error) {
    ElMessage.error('Ошибка загрузки заявки')
  }
}

async function loadHistory() {
  try {
    await applicationsStore.fetchHistory(applicationId.value)
  } catch (error) {
    // Игнорируем ошибки загрузки истории
  }
}

async function loadAvailableActions() {
  try {
    const actions = await applicationsStore.fetchAvailableActions(applicationId.value)
    availableActions.value = actions || []
  } catch (error) {
    // Игнорируем ошибки загрузки действий
    availableActions.value = []
  }
}

async function handleActionExecuted({ action, applicationId, data }) {
  try {
    await applicationsStore.executeAction(action, applicationId, data)
    ElMessage.success('Действие выполнено успешно')
    await loadApplication()
  } catch (error) {
    ElMessage.error(error.message || 'Ошибка выполнения действия')
  }
}

onMounted(() => {
  loadApplication()
})
</script>

<style scoped>
.application-detail-view {
  padding: 24px;
  min-height: 100vh;
  position: relative;
  background: #0a0a1a;
}

/* Фон с orbs - как у резюме */
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

/* Навигация */
.page-nav {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
  position: relative;
  z-index: 1;
}

.page-title {
  font-size: 24px;
  font-weight: 600;
  color: #f0f0f5;
}

/* Glass card */
.glass-card {
  background: rgba(30, 30, 50, 0.8);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 24px;
  position: relative;
  z-index: 1;
}

.loading-container {
  position: relative;
  z-index: 1;
}

.content {
  position: relative;
  z-index: 1;
}

/* Карточка информации */
.info-card .card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.info-card h2 {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  color: #f0f0f5;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

/* Сетка информации */
.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  margin-bottom: 24px;
}

.info-column {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.info-row {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-label {
  font-size: 12px;
  font-weight: 500;
  color: #9ca3af;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.info-value {
  font-size: 15px;
  color: #f0f0f5;
}

/* Участники */
.participants-section {
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.participants-section h3 {
  font-size: 16px;
  font-weight: 600;
  color: #f0f0f5;
  margin: 0 0 16px 0;
}

.participants-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.participant {
  background: rgba(124, 58, 237, 0.1);
  border-radius: 12px;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.participant-role {
  font-size: 12px;
  color: #a78bfa;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.participant-name {
  font-size: 14px;
  color: #f0f0f5;
  font-weight: 500;
}

/* Комментарий */
.comment-section {
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.comment-section h3 {
  font-size: 16px;
  font-weight: 600;
  color: #f0f0f5;
  margin: 0 0 12px 0;
}

.comment-text {
  color: #d1d5db;
  line-height: 1.6;
  margin: 0;
}

/* Действия */
.actions-section {
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

/* История */
.history-card h2 {
  margin: 0 0 24px 0;
  font-size: 20px;
  font-weight: 600;
  color: #f0f0f5;
}

.history-timeline {
  position: relative;
  padding-left: 24px;
}

.history-timeline::before {
  content: '';
  position: absolute;
  left: 6px;
  top: 0;
  bottom: 0;
  width: 2px;
  background: rgba(124, 58, 237, 0.3);
}

.history-item {
  position: relative;
  padding-bottom: 24px;
}

.history-item:last-child {
  padding-bottom: 0;
}

.history-dot {
  position: absolute;
  left: -24px;
  top: 4px;
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: #7c3aed;
  border: 3px solid rgba(30, 30, 50, 0.8);
}

.history-content {
  background: rgba(124, 58, 237, 0.1);
  border-radius: 12px;
  padding: 16px;
}

.history-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.history-action {
  font-weight: 600;
  color: #f0f0f5;
}

.history-date {
  font-size: 12px;
  color: #9ca3af;
}

.history-user {
  font-size: 13px;
  color: #d1d5db;
  margin-bottom: 8px;
}

.history-comment {
  font-size: 14px;
  color: #d1d5db;
  margin-bottom: 8px;
  font-style: italic;
}

.history-status {
  display: flex;
  align-items: center;
  gap: 8px;
}

/* Стили для Element Plus в тёмной теме */
:deep(.el-input__wrapper),
:deep(.el-input-number__wrapper),
:deep(.el-textarea__inner) {
  background: rgba(30, 30, 50, 0.6) !important;
  border-color: rgba(255, 255, 255, 0.15) !important;
  box-shadow: none !important;
}

:deep(.el-input__inner),
:deep(.el-textarea__inner) {
  color: #f0f0f5 !important;
}

:deep(.el-empty__description p) {
  color: #9ca3af;
}

:deep(.el-skeleton) {
  background: rgba(30, 30, 50, 0.6);
  border-radius: 16px;
  padding: 24px;
}

/* Responsive */
@media (max-width: 768px) {
  .info-grid {
    grid-template-columns: 1fr;
  }

  .participants-grid {
    grid-template-columns: 1fr;
  }
}
</style>
