<script setup>
import { onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'

const authStore = useAuthStore()
const themeStore = useThemeStore()

onMounted(() => {
  // Инициализация темы
  themeStore.isDark

  if (authStore.token) {
    authStore.fetchCurrentUser()
  }
})
</script>

<template>
  <router-view />
</template>

<style>
/* Import global styles */
@import './style.css';
</style>
