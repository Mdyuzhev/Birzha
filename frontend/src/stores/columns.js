import { defineStore } from 'pinia'
import { ref } from 'vue'
import { columnsApi } from '@/api/columns'
import { dictionariesApi } from '@/api/dictionaries'

export const useColumnsStore = defineStore('columns', () => {
  const columns = ref([])
  const dictionaries = ref({})
  const loading = ref(false)

  async function fetchColumns() {
    loading.value = true
    try {
      const response = await columnsApi.getAll()
      columns.value = response.data.sort((a, b) => a.sortOrder - b.sortOrder)

      // Загружаем справочники для SELECT полей
      const selectColumns = columns.value.filter(c => c.fieldType === 'SELECT' && c.dictionaryId)
      for (const col of selectColumns) {
        if (!dictionaries.value[col.dictionaryId]) {
          const dictResponse = await dictionariesApi.getById(col.dictionaryId)
          dictionaries.value[col.dictionaryId] = dictResponse.data
        }
      }
    } finally {
      loading.value = false
    }
  }

  function getDictionaryValues(dictionaryId) {
    return dictionaries.value[dictionaryId]?.values || []
  }

  return {
    columns,
    dictionaries,
    loading,
    fetchColumns,
    getDictionaryValues
  }
})
