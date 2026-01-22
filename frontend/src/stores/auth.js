import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '@/api/auth'
import { twoFactorApi } from '@/api/twoFactor'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token'))
  const user = ref(null)

  // Для 2FA
  const pendingTwoFactor = ref(null)  // { twoFactorToken }

  const isAuthenticated = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.roles?.includes('SYSTEM_ADMIN'))
  const isTotpEnabled = computed(() => user.value?.totpEnabled || false)

  async function login(username, password) {
    const response = await authApi.login(username, password)

    if (response.data.requiresTwoFactor) {
      // Нужна 2FA — сохраняем токен и ждём код
      pendingTwoFactor.value = {
        twoFactorToken: response.data.twoFactorToken
      }
      return { requiresTwoFactor: true }
    }

    // 2FA не нужна — сохраняем токен
    token.value = response.data.token
    user.value = {
      username: response.data.username,
      role: response.data.role,
      roles: response.data.roles,
      totpEnabled: response.data.totpEnabled
    }
    localStorage.setItem('token', token.value)
    return { success: true }
  }

  async function verifyTwoFactor(code) {
    if (!pendingTwoFactor.value) {
      throw new Error('No pending 2FA')
    }

    const response = await twoFactorApi.verify(
      pendingTwoFactor.value.twoFactorToken,
      code
    )

    // Успешно — сохраняем токен
    token.value = response.data.token
    user.value = {
      username: response.data.username,
      role: response.data.role,
      roles: response.data.roles,
      totpEnabled: response.data.totpEnabled
    }
    localStorage.setItem('token', token.value)

    pendingTwoFactor.value = null

    return { success: true }
  }

  function cancelTwoFactor() {
    pendingTwoFactor.value = null
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
      pendingTwoFactor.value = null
      localStorage.removeItem('token')
    }
  }

  return {
    token,
    user,
    pendingTwoFactor,
    isAuthenticated,
    isAdmin,
    isTotpEnabled,
    login,
    verifyTwoFactor,
    cancelTwoFactor,
    fetchCurrentUser,
    logout
  }
})
