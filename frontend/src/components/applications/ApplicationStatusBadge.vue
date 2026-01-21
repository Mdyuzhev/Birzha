<template>
  <el-tag :type="statusType" :effect="effect" :size="size">
    {{ statusLabel }}
  </el-tag>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  status: {
    type: String,
    required: true
  },
  size: {
    type: String,
    default: 'default'
  },
  effect: {
    type: String,
    default: 'light'
  }
})

const statusConfig = {
  DRAFT: { type: 'info', label: 'Черновик' },
  AVAILABLE_FOR_REVIEW: { type: 'warning', label: 'Доступна для просмотра' },
  IN_PROGRESS: { type: 'primary', label: 'В работе' },
  INTERVIEW: { type: 'primary', label: 'Собеседование' },
  PENDING_HR_BP: { type: 'warning', label: 'На согласовании HR BP' },
  APPROVED_HR_BP: { type: 'success', label: 'Согласовано HR BP' },
  REJECTED_HR_BP: { type: 'danger', label: 'Отклонено HR BP' },
  PENDING_BORUP: { type: 'warning', label: 'На согласовании БОРУП' },
  APPROVED_BORUP: { type: 'success', label: 'Согласовано БОРУП' },
  REJECTED_BORUP: { type: 'danger', label: 'Отклонено БОРУП' },
  PREPARING_TRANSFER: { type: 'primary', label: 'Подготовка к переводу' },
  TRANSFERRED: { type: 'success', label: 'Переведен' },
  DISMISSED: { type: 'info', label: 'Уволен' },
  CANCELLED: { type: 'info', label: 'Отменена' }
}

const statusType = computed(() => {
  return statusConfig[props.status]?.type || 'info'
})

const statusLabel = computed(() => {
  return statusConfig[props.status]?.label || props.status
})
</script>
