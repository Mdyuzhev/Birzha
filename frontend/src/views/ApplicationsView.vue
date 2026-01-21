<template>
  <div class="applications-view">
    <el-card>
      <template #header>
        <div class="card-header">
          <span class="title">Заявки</span>
          <el-button type="primary" @click="showCreateDialog">
            Создать заявку
          </el-button>
        </div>
      </template>

      <!-- Фильтры и переключение списков -->
      <div class="filters-section">
        <el-radio-group v-model="activeList" @change="loadApplications">
          <el-radio-button value="all">Все заявки</el-radio-button>
          <el-radio-button value="my">Мои заявки</el-radio-button>
          <el-radio-button value="assigned">Назначенные мне</el-radio-button>
          <el-radio-button value="pending">Требуют согласования</el-radio-button>
        </el-radio-group>

        <el-select
          v-model="statusFilter"
          placeholder="Фильтр по статусу"
          clearable
          style="width: 250px; margin-left: 16px"
          @change="loadApplications"
        >
          <el-option
            v-for="status in availableStatuses"
            :key="status.value"
            :label="status.label"
            :value="status.value"
          />
        </el-select>
      </div>

      <!-- Статистика -->
      <div v-if="stats" class="stats-section">
        <el-descriptions :column="4" border>
          <el-descriptions-item label="Всего">{{ stats.total || 0 }}</el-descriptions-item>
          <el-descriptions-item label="В работе">{{ stats.inProgress || 0 }}</el-descriptions-item>
          <el-descriptions-item label="На согласовании">{{ stats.pendingApproval || 0 }}</el-descriptions-item>
          <el-descriptions-item label="Завершено">{{ stats.completed || 0 }}</el-descriptions-item>
        </el-descriptions>
      </div>

      <!-- Таблица заявок -->
      <el-table
        :data="applicationsStore.applications"
        :loading="applicationsStore.loading"
        style="width: 100%; margin-top: 16px"
        @row-click="handleRowClick"
      >
        <el-table-column prop="id" label="ID" width="80" />

        <el-table-column label="Сотрудник" width="200">
          <template #default="{ row }">
            {{ getEmployeeName(row) }}
          </template>
        </el-table-column>

        <el-table-column label="Тип" width="120">
          <template #default="{ row }">
            <el-tag size="small">
              {{ row.applicationType === 'DEVELOPMENT' ? 'Развитие' : 'Ротация' }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="targetPosition" label="Целевая должность" min-width="180" />
        <el-table-column prop="targetDepartment" label="Целевое подразделение" min-width="180" />

        <el-table-column label="ЗП" width="200">
          <template #default="{ row }">
            <div v-if="row.currentSalary && row.proposedSalary">
              {{ formatSalary(row.currentSalary) }} → {{ formatSalary(row.proposedSalary) }}
              <el-tag :type="getSalaryChangeType(row)" size="small">
                {{ getSalaryChangePercent(row) }}%
              </el-tag>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="Статус" width="200">
          <template #default="{ row }">
            <ApplicationStatusBadge :status="row.status" />
          </template>
        </el-table-column>

        <el-table-column label="Создано" width="120">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>

        <el-table-column label="Действия" width="100" fixed="right">
          <template #default="{ row }">
            <el-button
              link
              type="primary"
              @click.stop="viewApplication(row.id)"
            >
              Открыть
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- Диалог создания заявки -->
    <el-dialog
      v-model="createDialogVisible"
      title="Создать заявку"
      width="700px"
    >
      <ApplicationForm
        :loading="formLoading"
        @submit="handleCreateApplication"
        @cancel="createDialogVisible = false"
      />
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useApplicationsStore } from '@/stores/applications'
import { ElMessage } from 'element-plus'
import ApplicationStatusBadge from '@/components/applications/ApplicationStatusBadge.vue'
import ApplicationForm from '@/components/applications/ApplicationForm.vue'

const router = useRouter()
const applicationsStore = useApplicationsStore()

const activeList = ref('all')
const statusFilter = ref(null)
const stats = ref(null)
const createDialogVisible = ref(false)
const formLoading = ref(false)

const availableStatuses = [
  { value: 'DRAFT', label: 'Черновик' },
  { value: 'AVAILABLE_FOR_REVIEW', label: 'Доступна для просмотра' },
  { value: 'IN_PROGRESS', label: 'В работе' },
  { value: 'INTERVIEW', label: 'Собеседование' },
  { value: 'PENDING_HR_BP', label: 'На согласовании HR BP' },
  { value: 'APPROVED_HR_BP', label: 'Согласовано HR BP' },
  { value: 'REJECTED_HR_BP', label: 'Отклонено HR BP' },
  { value: 'PENDING_BORUP', label: 'На согласовании БОРУП' },
  { value: 'APPROVED_BORUP', label: 'Согласовано БОРУП' },
  { value: 'REJECTED_BORUP', label: 'Отклонено БОРУП' },
  { value: 'PREPARING_TRANSFER', label: 'Подготовка к переводу' },
  { value: 'TRANSFERRED', label: 'Переведен' },
  { value: 'DISMISSED', label: 'Уволен' },
  { value: 'CANCELLED', label: 'Отменена' }
]

async function loadApplications() {
  try {
    const params = {}
    if (statusFilter.value) {
      params.status = statusFilter.value
    }

    switch (activeList.value) {
      case 'my':
        await applicationsStore.fetchMy(params)
        break
      case 'assigned':
        await applicationsStore.fetchAssigned(params)
        break
      case 'pending':
        await applicationsStore.fetchPendingApproval(params)
        break
      default:
        await applicationsStore.fetchAll(params)
    }
  } catch (error) {
    ElMessage.error('Ошибка загрузки заявок')
  }
}

async function loadStats() {
  try {
    stats.value = await applicationsStore.fetchStats()
  } catch (error) {
    // Игнорируем ошибки загрузки статистики
  }
}

function showCreateDialog() {
  createDialogVisible.value = true
}

async function handleCreateApplication(data) {
  try {
    formLoading.value = true
    await applicationsStore.create(data)
    ElMessage.success('Заявка создана')
    createDialogVisible.value = false
    await loadApplications()
  } catch (error) {
    ElMessage.error(error.message || 'Ошибка создания заявки')
  } finally {
    formLoading.value = false
  }
}

function handleRowClick(row) {
  viewApplication(row.id)
}

function viewApplication(id) {
  router.push(`/applications/${id}`)
}

function getEmployeeName(application) {
  if (application.employee) {
    const emp = application.employee
    return `${emp.lastName} ${emp.firstName} ${emp.middleName || ''}`.trim()
  }
  return `ID: ${application.employeeId}`
}

function formatSalary(value) {
  return new Intl.NumberFormat('ru-RU').format(value)
}

function getSalaryChangePercent(application) {
  if (!application.currentSalary || !application.proposedSalary) return 0
  const change = ((application.proposedSalary - application.currentSalary) / application.currentSalary) * 100
  return change.toFixed(1)
}

function getSalaryChangeType(application) {
  const percent = parseFloat(getSalaryChangePercent(application))
  if (percent > 30) return 'danger'
  if (percent > 15) return 'warning'
  if (percent > 0) return 'success'
  return 'info'
}

function formatDate(dateString) {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('ru-RU')
}

onMounted(async () => {
  await loadApplications()
  await loadStats()
})
</script>

<style scoped>
.applications-view {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.title {
  font-size: 20px;
  font-weight: 600;
}

.filters-section {
  margin-bottom: 16px;
  display: flex;
  align-items: center;
}

.stats-section {
  margin-top: 16px;
}

:deep(.el-table__row) {
  cursor: pointer;
}

:deep(.el-table__row:hover) {
  background-color: var(--el-table-row-hover-bg-color);
}
</style>
