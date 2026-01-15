<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { employeesApi } from '@/api/employees'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()

const employee = ref(null)
const history = ref([])
const loading = ref(false)

async function fetchData() {
  loading.value = true
  try {
    const [empResponse, histResponse] = await Promise.all([
      employeesApi.getById(route.params.id),
      employeesApi.getHistory(route.params.id)
    ])
    employee.value = empResponse.data
    history.value = histResponse.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки')
    router.push('/')
  } finally {
    loading.value = false
  }
}

function formatDate(dateStr) {
  return new Date(dateStr).toLocaleString('ru-RU')
}

onMounted(fetchData)
</script>

<template>
  <div class="detail-container" v-loading="loading">
    <el-page-header @back="router.push('/')">
      <template #content>
        {{ employee?.fullName || 'Загрузка...' }}
      </template>
    </el-page-header>

    <el-card v-if="employee" class="info-card">
      <template #header>Информация о сотруднике</template>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="ФИО">
          {{ employee.fullName }}
        </el-descriptions-item>
        <el-descriptions-item label="Email">
          {{ employee.email || '—' }}
        </el-descriptions-item>
        <el-descriptions-item
          v-for="(value, key) in employee.customFields"
          :key="key"
          :label="key"
        >
          {{ value || '—' }}
        </el-descriptions-item>
      </el-descriptions>
    </el-card>

    <el-card class="history-card">
      <template #header>История изменений</template>
      <el-table :data="history" stripe>
        <el-table-column prop="changedAt" label="Дата" width="180">
          <template #default="{ row }">
            {{ formatDate(row.changedAt) }}
          </template>
        </el-table-column>
        <el-table-column prop="changedByUsername" label="Пользователь" width="150" />
        <el-table-column prop="fieldName" label="Поле" width="150" />
        <el-table-column prop="oldValue" label="Было" />
        <el-table-column prop="newValue" label="Стало" />
      </el-table>
    </el-card>
  </div>
</template>

<style scoped>
.detail-container {
  padding: 20px;
}

.info-card {
  margin: 20px 0;
}

.history-card {
  margin-top: 20px;
}
</style>
