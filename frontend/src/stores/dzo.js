import { defineStore } from 'pinia'
import { ref } from 'vue'
import { dzosApi } from '@/api/dzos'

export const useDzoStore = defineStore('dzo', () => {
  const dzos = ref([])
  const currentDzo = ref(null)
  const loading = ref(false)

  async function fetchDzos() {
    loading.value = true
    try {
      const response = await dzosApi.getAll()
      dzos.value = response.data
    } finally {
      loading.value = false
    }
  }

  function setCurrentDzo(dzo) {
    currentDzo.value = dzo
  }

  return { dzos, currentDzo, loading, fetchDzos, setCurrentDzo }
})
