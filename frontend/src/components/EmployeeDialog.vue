<script setup>
import { ref, watch, computed, onUnmounted } from 'vue'
import { useColumnsStore } from '@/stores/columns'
import { employeesApi } from '@/api/employees'
import { locksApi } from '@/api/locks'
import { ElMessage } from 'element-plus'

const props = defineProps({
  visible: Boolean,
  employee: Object
})

const emit = defineEmits(['update:visible', 'close'])

const columnsStore = useColumnsStore()

const form = ref({
  fullName: '',
  email: '',
  customFields: {}
})
const loading = ref(false)
const fullNameError = ref('')

// Блокировка
const lockInfo = ref(null)
const lockInterval = ref(null)
const isLocked = computed(() => lockInfo.value?.locked && !lockInfo.value?.ownLock)

const isEdit = computed(() => !!props.employee?.id)
const title = computed(() => isEdit.value ? 'Редактирование сотрудника' : 'Новый сотрудник')

// Валидация ФИО: кириллица, три слова, каждое с заглавной буквы
const CYRILLIC_FIO_PATTERN = /^[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?\s+[А-ЯЁ][а-яё]+\s+[А-ЯЁ][а-яё]+$/

function validateFullName(value) {
  if (!value || !value.trim()) {
    return 'ФИО обязательно для заполнения'
  }
  const trimmed = value.trim()
  if (/[A-Za-z]/.test(trimmed)) {
    return 'ФИО должно быть на кириллице'
  }
  const parts = trimmed.split(/\s+/)
  if (parts.length !== 3) {
    return 'ФИО должно содержать три слова: Фамилия Имя Отчество'
  }
  if (!CYRILLIC_FIO_PATTERN.test(trimmed)) {
    return 'ФИО должно быть в формате: Фамилия Имя Отчество (кириллица, каждое слово с заглавной буквы)'
  }
  return ''
}

function onFullNameInput() {
  fullNameError.value = validateFullName(form.value.fullName)
}

// Функции для работы с блокировкой
async function acquireLock() {
  if (!props.employee?.id) return true

  try {
    const response = await locksApi.acquire('EMPLOYEE', props.employee.id)
    lockInfo.value = response.data

    if (lockInfo.value.locked && !lockInfo.value.ownLock) {
      ElMessage.warning(`Запись редактирует: ${lockInfo.value.lockedByName}`)
      return false
    }

    // Запустить heartbeat каждые 2 минуты
    lockInterval.value = setInterval(async () => {
      try {
        await locksApi.renew('EMPLOYEE', props.employee.id)
      } catch (e) {
        console.error('Failed to renew lock:', e)
      }
    }, 120000)

    return true
  } catch (error) {
    console.error('Failed to acquire lock:', error)
    return true // Разрешаем редактирование если сервис недоступен
  }
}

async function releaseLock() {
  if (lockInterval.value) {
    clearInterval(lockInterval.value)
    lockInterval.value = null
  }

  if (props.employee?.id && lockInfo.value?.ownLock) {
    try {
      await locksApi.release('EMPLOYEE', props.employee.id)
    } catch (e) {
      console.error('Failed to release lock:', e)
    }
  }
  lockInfo.value = null
}

// Инициализация формы при открытии
watch(() => props.visible, async (val) => {
  if (val) {
    fullNameError.value = ''
    lockInfo.value = null

    if (props.employee) {
      // Пытаемся получить блокировку
      const canEdit = await acquireLock()

      form.value = {
        fullName: props.employee.fullName,
        email: props.employee.email || '',
        customFields: { ...props.employee.customFields }
      }

      if (!canEdit) {
        // Блокировка не получена - можно только просматривать
      }
    } else {
      form.value = {
        fullName: '',
        email: '',
        customFields: {}
      }
      // Инициализируем customFields пустыми значениями
      columnsStore.columns.forEach(col => {
        form.value.customFields[col.name] = ''
      })
    }
  } else {
    // При закрытии освобождаем блокировку
    await releaseLock()
  }
})

// Освобождаем блокировку при размонтировании
onUnmounted(() => {
  releaseLock()
})

async function handleSave() {
  // Валидация ФИО
  const fioError = validateFullName(form.value.fullName)
  if (fioError) {
    fullNameError.value = fioError
    ElMessage.warning(fioError)
    return
  }

  loading.value = true
  try {
    if (isEdit.value) {
      await employeesApi.update(props.employee.id, form.value)
      ElMessage.success('Сотрудник обновлён')
    } else {
      await employeesApi.create(form.value)
      ElMessage.success('Сотрудник создан')
    }
    emit('close', true)
  } catch (error) {
    const msg = error.response?.data?.message || 'Ошибка сохранения'
    ElMessage.error(msg)
  } finally {
    loading.value = false
  }
}

async function handleClose() {
  await releaseLock()
  emit('update:visible', false)
  emit('close', false)
}
</script>

<template>
  <el-dialog
    :model-value="visible"
    :title="title"
    width="560px"
    @close="handleClose"
    class="glass-dialog"
    :close-on-click-modal="false"
  >
    <!-- Предупреждение о блокировке -->
    <div v-if="isLocked" class="lock-warning">
      <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
        <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/>
      </svg>
      <span>Запись редактирует: <strong>{{ lockInfo?.lockedByName }}</strong></span>
    </div>

    <el-form :model="form" label-width="140px" class="employee-form" :disabled="isLocked">
      <!-- Фиксированные поля -->
      <div class="form-section">
        <div class="section-title">
          <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
          <span>Основная информация</span>
        </div>

        <el-form-item label="ФИО" required :error="fullNameError">
          <el-input
            v-model="form.fullName"
            placeholder="Иванов Иван Иванович"
            size="large"
            @input="onFullNameInput"
            :class="{ 'is-error': fullNameError }"
          />
        </el-form-item>

        <el-form-item label="Email">
          <el-input
            v-model="form.email"
            placeholder="ivanov@company.ru"
            size="large"
          />
        </el-form-item>
      </div>

      <div class="form-divider"></div>

      <!-- Динамические поля -->
      <div class="form-section">
        <div class="section-title">
          <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
            <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
          </svg>
          <span>Дополнительные поля</span>
        </div>

        <el-form-item
          v-for="col in columnsStore.columns"
          :key="col.name"
          :label="col.displayName"
          :required="col.isRequired"
        >
          <!-- SELECT -->
          <el-select
            v-if="col.fieldType === 'SELECT'"
            v-model="form.customFields[col.name]"
            placeholder="Выберите значение"
            clearable
            size="large"
            style="width: 100%"
          >
            <el-option
              v-for="opt in columnsStore.getDictionaryValues(col.dictionaryId)"
              :key="opt"
              :label="opt"
              :value="opt"
            />
          </el-select>

          <!-- DATE -->
          <el-date-picker
            v-else-if="col.fieldType === 'DATE'"
            v-model="form.customFields[col.name]"
            type="date"
            placeholder="Выберите дату"
            format="DD.MM.YYYY"
            value-format="YYYY-MM-DD"
            size="large"
            style="width: 100%"
          />

          <!-- NUMBER -->
          <el-input-number
            v-else-if="col.fieldType === 'NUMBER'"
            v-model="form.customFields[col.name]"
            :min="0"
            size="large"
            style="width: 100%"
          />

          <!-- TEXT (default) -->
          <el-input
            v-else
            v-model="form.customFields[col.name]"
            placeholder="Введите значение"
            size="large"
          />
        </el-form-item>
      </div>
    </el-form>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose" size="large">
          <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
            <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
          </svg>
          <span>{{ isLocked ? 'Закрыть' : 'Отмена' }}</span>
        </el-button>
        <el-button v-if="!isLocked" type="primary" :loading="loading" @click="handleSave" size="large">
          <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
          </svg>
          <span>{{ isEdit ? 'Сохранить' : 'Создать' }}</span>
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<style scoped>
.lock-warning {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 18px;
  margin-bottom: 20px;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.2) 0%, rgba(245, 158, 11, 0.1) 100%);
  border: 1px solid rgba(245, 158, 11, 0.4);
  border-radius: 10px;
  color: #f59e0b;
  font-size: 14px;
}

.lock-warning svg {
  flex-shrink: 0;
}

.lock-warning strong {
  color: #fbbf24;
}

.employee-form {
  padding: 8px 0;
}

.form-section {
  margin-bottom: 8px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border-glass);
  color: var(--text-primary);
  font-weight: 600;
  font-size: 15px;
}

.section-title svg {
  color: var(--accent);
}

.form-divider {
  height: 1px;
  background: var(--border-glass);
  margin: 24px 0;
}

:deep(.el-form-item) {
  margin-bottom: 20px;
}

:deep(.el-form-item__label) {
  color: var(--text-secondary) !important;
  font-weight: 500;
}

:deep(.el-form-item__content) {
  flex-wrap: nowrap;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.dialog-footer .el-button {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 120px;
  justify-content: center;
}

:deep(.el-dialog__header) {
  padding-bottom: 20px !important;
}

:deep(.el-dialog__title) {
  font-size: 1.35rem !important;
}
</style>
