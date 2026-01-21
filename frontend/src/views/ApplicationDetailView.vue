<template>
  <div class="application-detail-view">
    <el-page-header @back="goBack" title="Назад к списку">
      <template #content>
        <span class="page-title">Заявка #{{ applicationId }}</span>
      </template>
    </el-page-header>

    <div v-if="applicationsStore.loading && !application" class="loading-container">
      <el-skeleton :rows="10" animated />
    </div>

    <div v-else-if="application" class="content">
      <!-- Основная информация -->
      <el-card class="info-card">
        <template #header>
          <div class="card-header">
            <span>Основная информация</span>
            <ApplicationStatusBadge :status="application.status" size="large" />
          </div>
        </template>

        <el-descriptions :column="2" border>
          <el-descriptions-item label="ID">{{ application.id }}</el-descriptions-item>
          <el-descriptions-item label="Тип заявки">
            <el-tag>{{ application.applicationType === 'DEVELOPMENT' ? 'Развитие' : 'Ротация' }}</el-tag>
          </el-descriptions-item>

          <el-descriptions-item label="Сотрудник">
            {{ getEmployeeName() }}
          </el-descriptions-item>
          <el-descriptions-item label="Email сотрудника">
            {{ application.employee?.email || '-' }}
          </el-descriptions-item>

          <el-descriptions-item label="Целевая должность">
            {{ application.targetPosition }}
          </el-descriptions-item>
          <el-descriptions-item label="Целевое подразделение">
            {{ application.targetDepartment }}
          </el-descriptions-item>

          <el-descriptions-item label="Текущая ЗП">
            {{ formatSalary(application.currentSalary) }}
          </el-descriptions-item>
          <el-descriptions-item label="Предлагаемая ЗП">
            {{ formatSalary(application.proposedSalary) }}
            <el-tag :type="getSalaryChangeType()" size="small" style="margin-left: 8px">
              {{ getSalaryChangePercent() }}%
            </el-tag>
          </el-descriptions-item>

          <el-descriptions-item label="Целевая дата">
            {{ formatDate(application.targetDate) }}
          </el-descriptions-item>
          <el-descriptions-item label="Создано">
            {{ formatDateTime(application.createdAt) }}
          </el-descriptions-item>

          <el-descriptions-item label="Автор заявки">
            {{ application.submittedBy || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="Рекрутер">
            {{ application.recruiterUsername || '-' }}
          </el-descriptions-item>

          <el-descriptions-item label="HR BP">
            {{ application.hrBpUsername || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="БОРУП">
            {{ application.borupUsername || '-' }}
          </el-descriptions-item>

          <el-descriptions-item label="Обоснование" :span="2">
            {{ application.justification || '-' }}
          </el-descriptions-item>

          <el-descriptions-item label="Комментарий" :span="2">
            {{ application.comment || '-' }}
          </el-descriptions-item>
        </el-descriptions>

        <!-- Доступные действия -->
        <ApplicationWorkflowActions
          v-if="availableActions.length > 0"
          :application-id="application.id"
          :available-actions="availableActions"
          @action-executed="handleActionExecuted"
        />
      </el-card>

      <!-- История изменений -->
      <el-card class="history-card">
        <template #header>
          <span>История изменений</span>
        </template>

        <el-timeline v-if="history.length > 0">
          <el-timeline-item
            v-for="item in history"
            :key="item.id"
            :timestamp="formatDateTime(item.changedAt)"
            placement="top"
          >
            <el-card>
              <div class="history-item">
                <div class="history-header">
                  <ApplicationStatusBadge :status="item.newStatus" size="small" />
                  <span class="history-user">{{ item.changedBy }}</span>
                </div>
                <div v-if="item.comment" class="history-comment">
                  <strong>Комментарий:</strong> {{ item.comment }}
                </div>
                <div v-if="item.fieldChanges && item.fieldChanges.length > 0" class="history-changes">
                  <strong>Изменения:</strong>
                  <ul>
                    <li v-for="change in item.fieldChanges" :key="change.fieldName">
                      <strong>{{ change.fieldName }}:</strong>
                      {{ change.oldValue }} → {{ change.newValue }}
                    </li>
                  </ul>
                </div>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>

        <el-empty v-else description="История изменений отсутствует" />
      </el-card>
    </div>

    <el-empty v-else description="Заявка не найдена" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
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

function goBack() {
  router.push('/applications')
}

function getEmployeeName() {
  if (!application.value?.employee) return '-'
  const emp = application.value.employee
  return `${emp.lastName} ${emp.firstName} ${emp.middleName || ''}`.trim()
}

function formatSalary(value) {
  if (!value) return '-'
  return new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
    minimumFractionDigits: 0
  }).format(value)
}

function getSalaryChangePercent() {
  if (!application.value?.currentSalary || !application.value?.proposedSalary) return 0
  const change = ((application.value.proposedSalary - application.value.currentSalary) / application.value.currentSalary) * 100
  return change > 0 ? `+${change.toFixed(1)}` : change.toFixed(1)
}

function getSalaryChangeType() {
  if (!application.value?.currentSalary || !application.value?.proposedSalary) return 'info'
  const change = ((application.value.proposedSalary - application.value.currentSalary) / application.value.currentSalary) * 100
  if (change > 30) return 'danger'
  if (change > 15) return 'warning'
  if (change > 0) return 'success'
  return 'info'
}

function formatDate(dateString) {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('ru-RU')
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

    // Перезагрузить заявку, историю и доступные действия
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
  padding: 20px;
}

.page-title {
  font-size: 20px;
  font-weight: 600;
}

.loading-container {
  margin-top: 20px;
}

.content {
  margin-top: 20px;
}

.info-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.history-card {
  margin-bottom: 20px;
}

.history-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.history-header {
  display: flex;
  align-items: center;
  gap: 12px;
}

.history-user {
  font-weight: 500;
  color: var(--el-text-color-secondary);
}

.history-comment {
  padding: 8px;
  background-color: var(--el-fill-color-light);
  border-radius: 4px;
}

.history-changes {
  padding: 8px;
  background-color: var(--el-fill-color-lighter);
  border-radius: 4px;
}

.history-changes ul {
  margin: 4px 0 0 0;
  padding-left: 20px;
}

.history-changes li {
  margin: 4px 0;
}
</style>
