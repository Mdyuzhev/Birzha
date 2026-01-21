<template>
  <el-form
    ref="formRef"
    :model="formData"
    :rules="rules"
    label-width="180px"
  >
    <el-form-item label="Сотрудник" prop="employeeId">
      <el-select
        v-model="formData.employeeId"
        filterable
        placeholder="Выберите сотрудника"
        style="width: 100%"
      >
        <el-option
          v-for="emp in employees"
          :key="emp.id"
          :label="`${emp.lastName} ${emp.firstName} ${emp.middleName || ''}`"
          :value="emp.id"
        />
      </el-select>
    </el-form-item>

    <el-form-item label="Тип заявки" prop="applicationType">
      <el-select
        v-model="formData.applicationType"
        placeholder="Выберите тип заявки"
        style="width: 100%"
      >
        <el-option label="Развитие" value="DEVELOPMENT" />
        <el-option label="Ротация" value="ROTATION" />
      </el-select>
    </el-form-item>

    <el-form-item label="Целевая должность" prop="targetPosition">
      <el-input v-model="formData.targetPosition" placeholder="Название должности" />
    </el-form-item>

    <el-form-item label="Целевое подразделение" prop="targetDepartment">
      <el-input v-model="formData.targetDepartment" placeholder="Название подразделения" />
    </el-form-item>

    <el-form-item label="Текущая ЗП">
      <el-input-number
        v-model="formData.currentSalary"
        :min="0"
        :step="1000"
        style="width: 100%"
      />
    </el-form-item>

    <el-form-item label="Предлагаемая ЗП">
      <el-input-number
        v-model="formData.proposedSalary"
        :min="0"
        :step="1000"
        style="width: 100%"
      />
    </el-form-item>

    <el-form-item label="Изменение ЗП (%)">
      <el-tag :type="salaryIncreaseType">
        {{ salaryIncreasePercent }}%
      </el-tag>
    </el-form-item>

    <el-form-item label="Целевая дата">
      <el-date-picker
        v-model="formData.targetDate"
        type="date"
        placeholder="Выберите дату"
        style="width: 100%"
      />
    </el-form-item>

    <el-form-item label="Обоснование" prop="justification">
      <el-input
        v-model="formData.justification"
        type="textarea"
        :rows="4"
        placeholder="Опишите причины и обоснование заявки"
      />
    </el-form-item>

    <el-form-item label="Комментарий">
      <el-input
        v-model="formData.comment"
        type="textarea"
        :rows="3"
        placeholder="Дополнительные комментарии"
      />
    </el-form-item>

    <el-form-item>
      <el-button type="primary" @click="handleSubmit" :loading="loading">
        {{ isEditMode ? 'Сохранить' : 'Создать' }}
      </el-button>
      <el-button @click="handleCancel">Отмена</el-button>
    </el-form-item>
  </el-form>
</template>

<script setup>
import { ref, reactive, computed, watch, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import client from '@/api/client'

const props = defineProps({
  application: {
    type: Object,
    default: null
  },
  loading: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['submit', 'cancel'])

const formRef = ref(null)
const employees = ref([])

const isEditMode = computed(() => !!props.application)

const formData = reactive({
  employeeId: null,
  applicationType: 'DEVELOPMENT',
  targetPosition: '',
  targetDepartment: '',
  currentSalary: 0,
  proposedSalary: 0,
  targetDate: null,
  justification: '',
  comment: ''
})

const rules = {
  employeeId: [
    { required: true, message: 'Выберите сотрудника', trigger: 'change' }
  ],
  applicationType: [
    { required: true, message: 'Выберите тип заявки', trigger: 'change' }
  ],
  targetPosition: [
    { required: true, message: 'Укажите целевую должность', trigger: 'blur' }
  ],
  targetDepartment: [
    { required: true, message: 'Укажите целевое подразделение', trigger: 'blur' }
  ],
  justification: [
    { required: true, message: 'Укажите обоснование', trigger: 'blur' }
  ]
}

const salaryIncreasePercent = computed(() => {
  if (!formData.currentSalary || !formData.proposedSalary) return 0
  const increase = ((formData.proposedSalary - formData.currentSalary) / formData.currentSalary) * 100
  return increase.toFixed(2)
})

const salaryIncreaseType = computed(() => {
  const percent = parseFloat(salaryIncreasePercent.value)
  if (percent > 30) return 'danger'
  if (percent > 15) return 'warning'
  if (percent > 0) return 'success'
  return 'info'
})

watch(() => props.application, (newVal) => {
  if (newVal) {
    Object.assign(formData, {
      employeeId: newVal.employeeId,
      applicationType: newVal.applicationType,
      targetPosition: newVal.targetPosition,
      targetDepartment: newVal.targetDepartment,
      currentSalary: newVal.currentSalary || 0,
      proposedSalary: newVal.proposedSalary || 0,
      targetDate: newVal.targetDate ? new Date(newVal.targetDate) : null,
      justification: newVal.justification || '',
      comment: newVal.comment || ''
    })
  }
}, { immediate: true })

async function fetchEmployees() {
  try {
    const response = await client.get('/employees')
    employees.value = response.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки списка сотрудников')
  }
}

async function handleSubmit() {
  const valid = await formRef.value.validate()
  if (!valid) return

  const data = {
    ...formData,
    targetDate: formData.targetDate?.toISOString().split('T')[0]
  }

  emit('submit', data)
}

function handleCancel() {
  emit('cancel')
}

onMounted(() => {
  fetchEmployees()
})
</script>
