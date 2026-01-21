import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '@/api/auth'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token'))
  const user = ref(null)

  const isAuthenticated = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.roles?.includes('SYSTEM_ADMIN'))

  async function login(username, password) {
    const response = await authApi.login(username, password)
    token.value = response.data.token
    user.value = {
      username: response.data.username,
      role: response.data.role,
      roles: response.data.roles
    }
    localStorage.setItem('token', token.value)
    return response.data
  }

  async function fetchCurrentUser() {
    if (!token.value) return null
    try {
      const response = await authApi.me()
      user.value = response.data
      return response.data
    } catch (e) {
      logout()
      return null
    }
  }

  async function logout() {
    try {
      if (token.value) {
        await authApi.logout()
      }
    } catch (e) {
      // Ignore logout errors
    } finally {
      token.value = null
      user.value = null
      localStorage.removeItem('token')
    }
  }

  return {
    token,
    user,
    isAuthenticated,
    isAdmin,
    login,
    fetchCurrentUser,
    logout
  }
})
