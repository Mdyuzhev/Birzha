import { defineStore } from 'pinia'
import { ref } from 'vue'
import { analyticsApi } from '@/api/analytics'

export const useAnalyticsStore = defineStore('analytics', () => {
  const loading = ref(false)
  const error = ref(null)

  const summary = ref(null)
  const stackDistribution = ref([])
  const dzoDistribution = ref([])
  const funnel = ref(null)
  const approvalTime = ref(null)
  const topRecruiters = ref([])
  const monthlyTrend = ref([])
  const salaryStats = ref(null)

  async function fetchSummary(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getSummary(params)
      summary.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchStackDistribution(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getByStack(params)
      stackDistribution.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchDzoDistribution(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getByDzo(params)
      dzoDistribution.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchFunnel(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getFunnel(params)
      funnel.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchApprovalTime(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getApprovalTime(params)
      approvalTime.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchTopRecruiters(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getTopRecruiters(params)
      topRecruiters.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchMonthlyTrend(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getMonthlyTrend(params)
      monthlyTrend.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchSalaryStats(params = {}) {
    loading.value = true
    try {
      const response = await analyticsApi.getSalaryStats(params)
      salaryStats.value = response.data
      return response.data
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchAll(params = {}) {
    loading.value = true
    try {
      await Promise.all([
        fetchSummary(params),
        fetchStackDistribution(params),
        fetchFunnel(params),
        fetchApprovalTime(params),
        fetchMonthlyTrend(params),
        fetchSalaryStats(params)
      ])
    } catch (e) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  function clearError() {
    error.value = null
  }

  return {
    loading,
    error,
    summary,
    stackDistribution,
    dzoDistribution,
    funnel,
    approvalTime,
    topRecruiters,
    monthlyTrend,
    salaryStats,
    fetchSummary,
    fetchStackDistribution,
    fetchDzoDistribution,
    fetchFunnel,
    fetchApprovalTime,
    fetchTopRecruiters,
    fetchMonthlyTrend,
    fetchSalaryStats,
    fetchAll,
    clearError
  }
})
