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
            <div class="header-actions">
              <ApplicationStatusBadge :status="application.status" size="large" />
              <el-button
                v-if="canEdit && !isEditing"
                type="primary"
                size="small"
                @click="startEdit"
              >
                Редактировать
              </el-button>
              <template v-if="isEditing">
                <el-button type="success" size="small" @click="saveEdit">Сохранить</el-button>
                <el-button size="small" @click="cancelEdit">Отмена</el-button>
              </template>
            </div>
          </div>
        </template>

        <el-descriptions :column="2" border>
          <el-descriptions-item label="ID">{{ application.id }}</el-descriptions-item>
          <el-descriptions-item label="Статус">
            {{ application.statusDisplayName }}
          </el-descriptions-item>

          <el-descriptions-item label="Сотрудник">
            {{ application.employeeName || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="Email сотрудника">
            {{ application.employeeEmail || '-' }}
          </el-descriptions-item>

          <el-descriptions-item label="Целевая должность" :span="2">
            <template v-if="isEditing">
              <el-input v-model="editForm.targetPosition" />
            </template>
            <template v-else>
              {{ application.targetPosition || '-' }}
            </template>
          </el-descriptions-item>

          <el-descriptions-item label="Целевой стек" :span="2">
            <template v-if="isEditing">
              <el-input v-model="editForm.targetStack" />
            </template>
            <template v-else>
              {{ application.targetStack || '-' }}
            </template>
          </el-descriptions-item>

          <el-descriptions-item label="Текущая ЗП">
            <template v-if="isEditing">
              <el-input-number v-model="editForm.currentSalary" :min="0" :step="10000" controls-position="right" style="width: 100%" />
            </template>
            <template v-else>
              {{ application.currentSalary ? formatSalary(application.currentSalary) : '-' }}
            </template>
          </el-descriptions-item>
          <el-descriptions-item label="Целевая ЗП">
            <template v-if="isEditing">
              <el-input-number v-model="editForm.targetSalary" :min="0" :step="10000" controls-position="right" style="width: 100%" />
            </template>
            <template v-else>
              {{ application.targetSalary ? formatSalary(application.targetSalary) : '-' }}
              <el-tag v-if="application.salaryIncreasePercent" :type="getSalaryChangeType()" size="small" style="margin-left: 8px">
                {{ application.salaryIncreasePercent > 0 ? '+' : '' }}{{ application.salaryIncreasePercent?.toFixed(1) }}%
              </el-tag>
            </template>
          </el-descriptions-item>

          <el-descriptions-item label="Создано">
            {{ formatDateTime(application.createdAt) }}
          </el-descriptions-item>
          <el-descriptions-item label="Автор заявки">
            {{ application.createdByName || '-' }}
          </el-descriptions-item>

          <el-descriptions-item label="Рекрутер">
            {{ application.recruiterName || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="HR BP">
            {{ application.hrBpName || '-' }}
          </el-descriptions-item>

          <el-descriptions-item label="БОРУП" :span="2">
            {{ application.borupName || '-' }}
          </el-descriptions-item>

          <el-descriptions-item label="Комментарий" :span="2">
            <template v-if="isEditing">
              <el-input v-model="editForm.comment" type="textarea" :rows="3" />
            </template>
            <template v-else>
              {{ application.comment || '-' }}
            </template>
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
                  <ApplicationStatusBadge v-if="item.newStatus" :status="item.newStatus" size="small" />
                  <span class="history-action">{{ item.action }}</span>
                  <span class="history-user">{{ item.changedByName }}</span>
                </div>
                <div v-if="item.comment" class="history-comment">
                  <strong>Комментарий:</strong> {{ item.comment }}
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

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
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

.history-action {
  font-weight: 500;
  color: var(--el-text-color-primary);
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
