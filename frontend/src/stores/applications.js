import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { applicationsApi } from '@/api/applications'

export const useApplicationsStore = defineStore('applications', () => {
  const applications = ref([])
  const currentApplication = ref(null)
  const history = ref([])
  const availableActions = ref([])
  const stats = ref(null)
  const statuses = ref([])
  const loading = ref(false)
  const error = ref(null)

  // Computed
  const totalCount = computed(() => applications.value.length)
  const hasApplications = computed(() => totalCount.value > 0)

  // CRUD
  async function fetchAll(params = {}) {
    loading.value = true
    error.value = null
    try {
      const response = await applicationsApi.getAll(params)
      applications.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchById(id) {
    loading.value = true
    error.value = null
    try {
      const response = await applicationsApi.getById(id)
      currentApplication.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function create(data) {
    loading.value = true
    error.value = null
    try {
      const response = await applicationsApi.create(data)
      applications.value.unshift(response.data)
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function update(id, data) {
    loading.value = true
    error.value = null
    try {
      const response = await applicationsApi.update(id, data)
      const index = applications.value.findIndex(a => a.id === id)
      if (index !== -1) {
        applications.value[index] = response.data
      }
      if (currentApplication.value?.id === id) {
        currentApplication.value = response.data
      }
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function remove(id) {
    loading.value = true
    error.value = null
    try {
      await applicationsApi.delete(id)
      applications.value = applications.value.filter(a => a.id !== id)
      if (currentApplication.value?.id === id) {
        currentApplication.value = null
      }
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  // Специализированные списки
  async function fetchMy(params = {}) {
    loading.value = true
    error.value = null
    try {
      const response = await applicationsApi.getMy(params)
      applications.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchAssigned(params = {}) {
    loading.value = true
    error.value = null
    try {
      const response = await applicationsApi.getAssigned(params)
      applications.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchPendingApproval(params = {}) {
    loading.value = true
    error.value = null
    try {
      const response = await applicationsApi.getPendingApproval(params)
      applications.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  // Метаданные
  async function fetchHistory(id) {
    loading.value = true
    error.value = null
    try {
      const response = await applicationsApi.getHistory(id)
      history.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchStats() {
    loading.value = true
    error.value = null
    try {
      const response = await applicationsApi.getStats()
      stats.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchStatuses() {
    error.value = null
    try {
      const response = await applicationsApi.getStatuses()
      statuses.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    }
  }

  async function fetchAvailableActions(id) {
    error.value = null
    try {
      const response = await applicationsApi.getAvailableActions(id)
      availableActions.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    }
  }

  // Workflow действия
  async function executeAction(actionName, id, data = {}) {
    loading.value = true
    error.value = null
    try {
      let response
      switch (actionName) {
        case 'submit':
          response = await applicationsApi.submit(id, data.comment)
          break
        case 'assignRecruiter':
          response = await applicationsApi.assignRecruiter(id, data.comment)
          break
        case 'startInterview':
          response = await applicationsApi.startInterview(id, data.comment)
          break
        case 'sendToHrBp':
          response = await applicationsApi.sendToHrBp(id, data)
          break
        case 'approveByHrBp':
          response = await applicationsApi.approveByHrBp(id, data)
          break
        case 'rejectByHrBp':
          response = await applicationsApi.rejectByHrBp(id, data)
          break
        case 'sendToBorup':
          response = await applicationsApi.sendToBorup(id, data)
          break
        case 'approveByBorup':
          response = await applicationsApi.approveByBorup(id, data)
          break
        case 'rejectByBorup':
          response = await applicationsApi.rejectByBorup(id, data)
          break
        case 'prepareTransfer':
          response = await applicationsApi.prepareTransfer(id, data.comment)
          break
        case 'completeTransfer':
          response = await applicationsApi.completeTransfer(id, data)
          break
        case 'dismiss':
          response = await applicationsApi.dismiss(id, data)
          break
        case 'cancel':
          response = await applicationsApi.cancel(id, data)
          break
        case 'returnToHrBp':
          response = await applicationsApi.returnToHrBp(id, data.comment)
          break
        case 'returnToBorup':
          response = await applicationsApi.returnToBorup(id, data.comment)
          break
        default:
          throw new Error(`Unknown action: ${actionName}`)
      }

      // Обновить текущую заявку
      if (response?.data) {
        currentApplication.value = response.data
        const index = applications.value.findIndex(a => a.id === id)
        if (index !== -1) {
          applications.value[index] = response.data
        }
      }

      return response?.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  function clearError() {
    error.value = null
  }

  function clearCurrent() {
    currentApplication.value = null
    history.value = []
    availableActions.value = []
  }

  return {
    // State
    applications,
    currentApplication,
    history,
    availableActions,
    stats,
    statuses,
    loading,
    error,

    // Computed
    totalCount,
    hasApplications,

    // Actions
    fetchAll,
    fetchById,
    create,
    update,
    remove,
    fetchMy,
    fetchAssigned,
    fetchPendingApproval,
    fetchHistory,
    fetchStats,
    fetchStatuses,
    fetchAvailableActions,
    executeAction,
    clearError,
    clearCurrent
  }
})
