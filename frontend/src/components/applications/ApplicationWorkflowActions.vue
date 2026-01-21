<template>
  <div class="workflow-actions">
    <el-space wrap>
      <el-button
        v-for="action in availableActions"
        :key="action"
        :type="getActionButtonType(action)"
        @click="handleAction(action)"
        :loading="loading"
      >
        {{ getActionLabel(action) }}
      </el-button>
    </el-space>

    <!-- Диалог для комментария/причины -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="500px"
    >
      <el-form :model="formData" label-width="120px">
        <el-form-item :label="currentAction.requiresReason ? 'Причина' : 'Комментарий'">
          <el-input
            v-model="formData.comment"
            type="textarea"
            :rows="4"
            :placeholder="currentAction.requiresReason ? 'Укажите причину' : 'Опциональный комментарий'"
          />
        </el-form-item>

        <!-- Дополнительные поля для специфичных действий -->
        <el-form-item v-if="currentAction.name === 'completeTransfer'" label="Новая должность">
          <el-input v-model="formData.newPosition" placeholder="Название должности" />
        </el-form-item>

        <el-form-item v-if="currentAction.name === 'completeTransfer'" label="Новое подразделение">
          <el-input v-model="formData.newDepartment" placeholder="Название подразделения" />
        </el-form-item>

        <el-form-item v-if="currentAction.name === 'dismiss'" label="Дата увольнения">
          <el-date-picker
            v-model="formData.dismissalDate"
            type="date"
            placeholder="Выберите дату"
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">Отмена</el-button>
        <el-button
          type="primary"
          @click="executeAction"
          :loading="loading"
          :disabled="currentAction.requiresReason && !formData.comment"
        >
          Подтвердить
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { ElMessage } from 'element-plus'

const props = defineProps({
  applicationId: {
    type: Number,
    required: true
  },
  availableActions: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['action-executed'])

const loading = ref(false)
const dialogVisible = ref(false)
const currentAction = reactive({
  name: '',
  requiresReason: false
})
const formData = reactive({
  comment: '',
  newPosition: '',
  newDepartment: '',
  dismissalDate: null
})

const actionConfig = {
  submit: { label: 'Подать заявку', type: 'primary', requiresDialog: false },
  assignRecruiter: { label: 'Взять в работу', type: 'primary', requiresDialog: false },
  startInterview: { label: 'Начать собеседование', type: 'primary', requiresDialog: false },
  sendToHrBp: { label: 'На согласование HR BP', type: 'warning', requiresDialog: false },
  approveByHrBp: { label: 'Согласовать (HR BP)', type: 'success', requiresDialog: false },
  rejectByHrBp: { label: 'Отклонить (HR BP)', type: 'danger', requiresDialog: true, requiresReason: true },
  sendToBorup: { label: 'На согласование БОРУП', type: 'warning', requiresDialog: false },
  approveByBorup: { label: 'Согласовать (БОРУП)', type: 'success', requiresDialog: false },
  rejectByBorup: { label: 'Отклонить (БОРУП)', type: 'danger', requiresDialog: true, requiresReason: true },
  prepareTransfer: { label: 'Подготовить перевод', type: 'primary', requiresDialog: false },
  completeTransfer: { label: 'Завершить перевод', type: 'success', requiresDialog: true },
  dismiss: { label: 'Увольнение', type: 'warning', requiresDialog: true },
  cancel: { label: 'Отменить заявку', type: 'info', requiresDialog: true, requiresReason: true },
  returnToHrBp: { label: 'Вернуть HR BP', type: 'warning', requiresDialog: false },
  returnToBorup: { label: 'Вернуть БОРУП', type: 'warning', requiresDialog: false }
}

const dialogTitle = computed(() => {
  const config = actionConfig[currentAction.name]
  return config?.label || 'Действие'
})

function getActionLabel(action) {
  return actionConfig[action]?.label || action
}

function getActionButtonType(action) {
  return actionConfig[action]?.type || 'default'
}

function handleAction(action) {
  const config = actionConfig[action]
  currentAction.name = action
  currentAction.requiresReason = config?.requiresReason || false

  if (config?.requiresDialog) {
    // Показать диалог для ввода данных
    resetFormData()
    dialogVisible.value = true
  } else {
    // Выполнить действие сразу
    executeAction()
  }
}

function resetFormData() {
  formData.comment = ''
  formData.newPosition = ''
  formData.newDepartment = ''
  formData.dismissalDate = null
}

async function executeAction() {
  try {
    loading.value = true

    const data = {
      comment: formData.comment || undefined
    }

    // Добавить специфичные поля для определённых действий
    if (currentAction.name === 'completeTransfer') {
      data.newPosition = formData.newPosition
      data.newDepartment = formData.newDepartment
    } else if (currentAction.name === 'dismiss') {
      data.dismissalDate = formData.dismissalDate?.toISOString()
    }

    emit('action-executed', {
      action: currentAction.name,
      applicationId: props.applicationId,
      data
    })

    dialogVisible.value = false
    ElMessage.success('Действие выполнено успешно')
  } catch (error) {
    ElMessage.error(error.message || 'Ошибка выполнения действия')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.workflow-actions {
  margin-top: 16px;
}
</style>
