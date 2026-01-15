<script setup>
import { ref, watch, computed } from 'vue'
import { useColumnsStore } from '@/stores/columns'
import { employeesApi } from '@/api/employees'
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

const isEdit = computed(() => !!props.employee?.id)
const title = computed(() => isEdit.value ? 'Редактирование сотрудника' : 'Новый сотрудник')

// Инициализация формы при открытии
watch(() => props.visible, (val) => {
  if (val) {
    if (props.employee) {
      form.value = {
        fullName: props.employee.fullName,
        email: props.employee.email || '',
        customFields: { ...props.employee.customFields }
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
  }
})

async function handleSave() {
  if (!form.value.fullName.trim()) {
    ElMessage.warning('Введите ФИО')
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
    ElMessage.error('Ошибка сохранения')
  } finally {
    loading.value = false
  }
}

function handleClose() {
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
    <el-form :model="form" label-width="140px" class="employee-form">
      <!-- Фиксированные поля -->
      <div class="form-section">
        <div class="section-title">
          <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
          <span>Основная информация</span>
        </div>

        <el-form-item label="ФИО" required>
          <el-input
            v-model="form.fullName"
            placeholder="Иванов Иван Иванович"
            size="large"
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
          <span>Отмена</span>
        </el-button>
        <el-button type="primary" :loading="loading" @click="handleSave" size="large">
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
