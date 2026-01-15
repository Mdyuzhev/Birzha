import { defineStore } from 'pinia'
import { ref } from 'vue'
import { employeesApi } from '@/api/employees'

export const useNotificationsStore = defineStore('notifications', () => {
  const lastSeenId = ref(parseInt(localStorage.getItem('lastSeenHistoryId') || '0'))
  const newCount = ref(0)
  const latestItems = ref([])
  let pollInterval = null

  async function checkNewItems() {
    try {
      const response = await employeesApi.getRecentHistory(10)
      latestItems.value = response.data || []

      if (latestItems.value.length > 0) {
        const maxId = Math.max(...latestItems.value.map(i => i.id))
        newCount.value = latestItems.value.filter(i => i.id > lastSeenId.value).length
      }
    } catch (e) {
      console.error('Failed to check notifications:', e)
    }
  }

  function markAsSeen() {
    if (latestItems.value.length > 0) {
      const maxId = Math.max(...latestItems.value.map(i => i.id))
      lastSeenId.value = maxId
      localStorage.setItem('lastSeenHistoryId', maxId.toString())
      newCount.value = 0
    }
  }

  function startPolling() {
    checkNewItems()
    if (!pollInterval) {
      pollInterval = setInterval(checkNewItems, 30000) // каждые 30 сек
    }
  }

  function stopPolling() {
    if (pollInterval) {
      clearInterval(pollInterval)
      pollInterval = null
    }
  }

  return {
    newCount,
    latestItems,
    checkNewItems,
    markAsSeen,
    startPolling,
    stopPolling
  }
})
