# Баг-фикс: Данные из формы создания заявки не сохраняются

## Проблема

При создании заявки под ролью менеджера данные, вводимые в модальном окне, не переходят в саму заявку. Причина — несовпадение имён полей между frontend и backend.

## Анализ

### Frontend отправляет (ApplicationForm.vue):
```javascript
{
  employeeId: Long,
  applicationType: String,      // ❌ НЕТ в backend
  targetPosition: String,
  targetDepartment: String,     // ❌ НЕТ в backend
  techStackIds: Array,          // ❌ backend ожидает targetStack (String)
  currentSalary: Number,
  proposedSalary: Number,       // ❌ backend ожидает targetSalary
  targetDate: Date,             // ❌ НЕТ в backend
  justification: String,        // ❌ backend ожидает comment
  comment: String
}
```

### Backend ожидает (CreateApplicationRequest.java):
```java
{
  employeeId: Long,
  targetPosition: String,
  targetStack: String,
  currentSalary: BigDecimal,
  targetSalary: BigDecimal,
  comment: String,
  hrBpId: Long
}
```

## Решение

Синхронизировать frontend форму с backend API.

### Шаг 1: Исправить ApplicationForm.vue

**Файл:** `frontend/src/components/applications/ApplicationForm.vue`

Заменить formData на:
```javascript
const formData = reactive({
  employeeId: null,
  targetPosition: '',
  targetStack: '',
  currentSalary: 0,
  targetSalary: 0,
  comment: '',
  hrBpId: null
})
```

Заменить rules на:
```javascript
const rules = {
  employeeId: [
    { required: true, message: 'Выберите сотрудника', trigger: 'change' }
  ],
  targetPosition: [
    { required: true, message: 'Укажите целевую должность', trigger: 'blur' }
  ]
}
```

Заменить вычисляемые свойства:
```javascript
const salaryIncreasePercent = computed(() => {
  if (!formData.currentSalary || !formData.targetSalary) return 0
  const increase = ((formData.targetSalary - formData.currentSalary) / formData.currentSalary) * 100
  return increase.toFixed(2)
})

const requiresBorup = computed(() => {
  return parseFloat(salaryIncreasePercent.value) > 30
})
```

Заменить handleSubmit:
```javascript
async function handleSubmit() {
  const valid = await formRef.value.validate()
  if (!valid) return

  const data = {
    employeeId: formData.employeeId,
    targetPosition: formData.targetPosition,
    targetStack: formData.targetStack || null,
    currentSalary: formData.currentSalary || null,
    targetSalary: formData.targetSalary || null,
    comment: formData.comment || null,
    hrBpId: formData.hrBpId || null
  }

  emit('submit', data)
}
```

### Шаг 2: Обновить template формы

Убрать поля которых нет в backend:
- ❌ Тип заявки (applicationType)
- ❌ Целевое подразделение (targetDepartment)
- ❌ Технологический стек как multiple select (techStackIds)
- ❌ Целевая дата (targetDate)
- ❌ Обоснование (justification)

Оставить/исправить:
- ✅ Сотрудник (employeeId)
- ✅ Целевая должность (targetPosition)
- ✅ Целевой стек как текст (targetStack)
- ✅ Текущая ЗП (currentSalary)
- ✅ Целевая ЗП (targetSalary) — было proposedSalary
- ✅ Комментарий (comment)

### Шаг 3: Обновить ApplicationsView.vue

В функции getEmployeeName исправить на:
```javascript
function getEmployeeName(application) {
  if (application.employeeName) {
    return application.employeeName
  }
  return `ID: ${application.employeeId}`
}
```

В таблице колонку ЗП исправить — backend возвращает `targetSalary`, не `proposedSalary`:
```vue
<el-table-column label="ЗП" width="200">
  <template #default="{ row }">
    <div v-if="row.currentSalary && row.targetSalary" class="salary-cell">
      <span>{{ formatSalary(row.currentSalary) }} → {{ formatSalary(row.targetSalary) }}</span>
      <el-tag :type="getSalaryChangeType(row)" size="small">
        {{ getSalaryChangePercent(row) }}%
      </el-tag>
    </div>
  </template>
</el-table-column>
```

Исправить функции:
```javascript
function getSalaryChangePercent(application) {
  if (!application.currentSalary || !application.targetSalary) return 0
  const change = ((application.targetSalary - application.currentSalary) / application.currentSalary) * 100
  return change.toFixed(1)
}
```

## Полный код ApplicationForm.vue после исправления

```vue
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
          :label="emp.fullName"
          :value="emp.id"
        />
      </el-select>
    </el-form-item>

    <el-form-item label="Целевая должность" prop="targetPosition">
      <el-input v-model="formData.targetPosition" placeholder="Название должности" />
    </el-form-item>

    <el-form-item label="Целевой стек">
      <el-input v-model="formData.targetStack" placeholder="Java, Python, React, DevOps..." />
    </el-form-item>

    <el-form-item label="Текущая ЗП">
      <el-input-number
        v-model="formData.currentSalary"
        :min="0"
        :step="10000"
        :precision="2"
        style="width: 100%"
      />
    </el-form-item>

    <el-form-item label="Целевая ЗП">
      <el-input-number
        v-model="formData.targetSalary"
        :min="0"
        :step="10000"
        :precision="2"
        style="width: 100%"
      />
    </el-form-item>

    <el-form-item label="Изменение ЗП (%)">
      <el-tag :type="salaryIncreaseType">
        {{ salaryIncreasePercent }}%
      </el-tag>
      <span v-if="requiresBorup" style="margin-left: 10px; color: #f59e0b;">
        ⚠️ Требует согласования БОРУП (>30%)
      </span>
    </el-form-item>

    <el-form-item label="Комментарий">
      <el-input
        v-model="formData.comment"
        type="textarea"
        :rows="4"
        placeholder="Опишите причины и обоснование заявки"
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
  targetPosition: '',
  targetStack: '',
  currentSalary: 0,
  targetSalary: 0,
  comment: '',
  hrBpId: null
})

const rules = {
  employeeId: [
    { required: true, message: 'Выберите сотрудника', trigger: 'change' }
  ],
  targetPosition: [
    { required: true, message: 'Укажите целевую должность', trigger: 'blur' }
  ]
}

const salaryIncreasePercent = computed(() => {
  if (!formData.currentSalary || !formData.targetSalary) return 0
  const increase = ((formData.targetSalary - formData.currentSalary) / formData.currentSalary) * 100
  return increase.toFixed(2)
})

const salaryIncreaseType = computed(() => {
  const percent = parseFloat(salaryIncreasePercent.value)
  if (percent > 30) return 'danger'
  if (percent > 15) return 'warning'
  if (percent > 0) return 'success'
  return 'info'
})

const requiresBorup = computed(() => {
  return parseFloat(salaryIncreasePercent.value) > 30
})

watch(() => props.application, (newVal) => {
  if (newVal) {
    Object.assign(formData, {
      employeeId: newVal.employeeId,
      targetPosition: newVal.targetPosition || '',
      targetStack: newVal.targetStack || '',
      currentSalary: newVal.currentSalary || 0,
      targetSalary: newVal.targetSalary || 0,
      comment: newVal.comment || '',
      hrBpId: newVal.hrBpId || null
    })
  }
}, { immediate: true })

async function fetchEmployees() {
  try {
    const response = await client.get('/employees')
    employees.value = response.data.content || response.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки списка сотрудников')
  }
}

async function handleSubmit() {
  const valid = await formRef.value.validate()
  if (!valid) return

  const data = {
    employeeId: formData.employeeId,
    targetPosition: formData.targetPosition,
    targetStack: formData.targetStack || null,
    currentSalary: formData.currentSalary || null,
    targetSalary: formData.targetSalary || null,
    comment: formData.comment || null,
    hrBpId: formData.hrBpId || null
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
```

## Тестирование

1. Пересобрать frontend: `docker-compose build frontend`
2. Перезапустить: `docker-compose up -d`
3. Войти под менеджером
4. Создать заявку
5. Проверить что данные сохраняются и отображаются в таблице

## Файлы для изменения

| Файл | Изменения |
|------|-----------|
| `frontend/src/components/applications/ApplicationForm.vue` | Полная переработка формы |
| `frontend/src/views/ApplicationsView.vue` | proposedSalary → targetSalary |
