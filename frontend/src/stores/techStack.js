import { defineStore } from 'pinia'
import * as techStackApi from '@/api/techStack'
import { ElMessage } from 'element-plus'

export const useTechStackStore = defineStore('techStack', {
  state: () => ({
    directions: [],
    stacks: [],
    pendingStacks: [],
    loading: false,
    error: null
  }),

  getters: {
    // Получить направление по ID
    getDirectionById: (state) => (id) => {
      return state.directions.find(d => d.id === id)
    },

    // Получить стек по ID
    getStackById: (state) => (id) => {
      return state.stacks.find(s => s.id === id)
    },

    // Получить стеки по направлению
    getStacksByDirection: (state) => (directionId) => {
      return state.stacks.filter(s => s.directionId === directionId)
    },

    // Получить активные стеки
    activeStacks: (state) => {
      return state.stacks.filter(s => s.status === 'ACTIVE')
    }
  },

  actions: {
    async fetchDirections(includeStacks = true) {
      this.loading = true
      this.error = null
      try {
        const response = await techStackApi.getDirections(includeStacks)
        this.directions = response.data

        if (includeStacks) {
          // Извлекаем все стеки из направлений
          this.stacks = this.directions.flatMap(d => d.stacks || [])
        }
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка загрузки направлений'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchStacks() {
      this.loading = true
      this.error = null
      try {
        const response = await techStackApi.getSelectableStacks()
        this.stacks = response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка загрузки стеков'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchStacksByDirection(directionId) {
      this.loading = true
      this.error = null
      try {
        const response = await techStackApi.getStacksByDirection(directionId)
        return response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка загрузки стеков'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async searchStacks(query) {
      this.loading = true
      this.error = null
      try {
        const response = await techStackApi.searchStacks(query)
        return response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка поиска стеков'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async createStack(data) {
      this.loading = true
      this.error = null
      try {
        const response = await techStackApi.createStack(data)
        this.stacks.push(response.data)
        ElMessage.success('Стек успешно создан')
        return response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка создания стека'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async proposeStack(data) {
      this.loading = true
      this.error = null
      try {
        const response = await techStackApi.proposeStack(data)
        ElMessage.success('Стек отправлен на согласование')
        return response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка предложения стека'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchPendingStacks() {
      this.loading = true
      this.error = null
      try {
        const response = await techStackApi.getPendingStacks()
        this.pendingStacks = response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка загрузки предложенных стеков'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async approveStack(id, code = null) {
      this.loading = true
      this.error = null
      try {
        const response = await techStackApi.approveStack(id, code)

        // Удаляем из pending и добавляем в основной список
        this.pendingStacks = this.pendingStacks.filter(s => s.id !== id)
        this.stacks.push(response.data)

        ElMessage.success('Стек успешно согласован')
        return response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка согласования стека'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async rejectStack(id, reason) {
      this.loading = true
      this.error = null
      try {
        await techStackApi.rejectStack(id, reason)

        // Удаляем из pending
        this.pendingStacks = this.pendingStacks.filter(s => s.id !== id)

        ElMessage.success('Стек отклонен')
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка отклонения стека'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async deprecateStack(id) {
      this.loading = true
      this.error = null
      try {
        const response = await techStackApi.deprecateStack(id)

        // Обновляем стек в списке
        const index = this.stacks.findIndex(s => s.id === id)
        if (index !== -1) {
          this.stacks[index] = response.data
        }

        ElMessage.success('Стек помечен как устаревший')
        return response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Ошибка обновления стека'
        ElMessage.error(this.error)
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
