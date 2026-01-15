<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'
import { ElMessage } from 'element-plus'

const router = useRouter()
const authStore = useAuthStore()
const themeStore = useThemeStore()

const form = ref({
  username: '',
  password: ''
})
const loading = ref(false)

async function handleLogin() {
  if (!form.value.username || !form.value.password) {
    ElMessage.warning('Введите логин и пароль')
    return
  }

  loading.value = true
  try {
    await authStore.login(form.value.username, form.value.password)
    ElMessage.success('Добро пожаловать!')
    router.push('/')
  } catch (error) {
    ElMessage.error('Неверный логин или пароль')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <!-- Theme Toggle -->
    <button class="theme-toggle" @click="themeStore.toggle()">
      <svg v-if="themeStore.isDark" viewBox="0 0 24 24" fill="currentColor">
        <path d="M12 3a9 9 0 109 9c0-.46-.04-.92-.1-1.36a5.389 5.389 0 01-4.4 2.26 5.403 5.403 0 01-3.14-9.8c-.44-.06-.9-.1-1.36-.1z"/>
      </svg>
      <svg v-else viewBox="0 0 24 24" fill="currentColor">
        <path d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58a.996.996 0 00-1.41 0 .996.996 0 000 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37a.996.996 0 00-1.41 0 .996.996 0 000 1.41l1.06 1.06c.39.39 1.03.39 1.41 0a.996.996 0 000-1.41l-1.06-1.06zm1.06-10.96a.996.996 0 000-1.41.996.996 0 00-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36a.996.996 0 000-1.41.996.996 0 00-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z"/>
      </svg>
    </button>

    <!-- Floating Orbs -->
    <div class="orbs">
      <div class="orb orb-1"></div>
      <div class="orb orb-2"></div>
      <div class="orb orb-3"></div>
      <div class="orb orb-4"></div>
    </div>

    <div class="login-container">
      <!-- Logo -->
      <div class="login-logo">
        <div class="logo-glow">
          <svg viewBox="0 0 48 48" class="logo-icon">
            <defs>
              <linearGradient id="logoGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" style="stop-color:#7c3aed"/>
                <stop offset="100%" style="stop-color:#a78bfa"/>
              </linearGradient>
            </defs>
            <circle cx="24" cy="24" r="22" fill="url(#logoGrad)"/>
            <circle cx="24" cy="24" r="8" fill="rgba(255,255,255,0.9)"/>
            <circle cx="24" cy="24" r="4" fill="url(#logoGrad)"/>
          </svg>
        </div>
        <h1 class="text-gradient">Resource Manager</h1>
        <p class="tagline">Система управления ресурсами</p>
      </div>

      <!-- Login Card -->
      <div class="login-card glass-card-strong">
        <h2>Вход в систему</h2>

        <el-form @submit.prevent="handleLogin" class="login-form">
          <el-form-item>
            <el-input
              v-model="form.username"
              placeholder="Логин"
              size="large"
              autocomplete="username"
            >
              <template #prefix>
                <svg viewBox="0 0 24 24" fill="var(--accent)" width="20" height="20">
                  <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                </svg>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item>
            <el-input
              v-model="form.password"
              type="password"
              placeholder="Пароль"
              size="large"
              show-password
              autocomplete="current-password"
              @keyup.enter="handleLogin"
            >
              <template #prefix>
                <svg viewBox="0 0 24 24" fill="var(--accent)" width="20" height="20">
                  <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/>
                </svg>
              </template>
            </el-input>
          </el-form-item>

          <el-button
            type="primary"
            :loading="loading"
            @click="handleLogin"
            size="large"
            class="login-btn"
          >
            <span>Войти</span>
            <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
              <path d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z"/>
            </svg>
          </el-button>
        </el-form>
      </div>

      <p class="copyright">2024 Resource Manager</p>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  padding: 20px;
}

/* Theme Toggle */
.theme-toggle {
  position: fixed;
  top: 24px;
  right: 24px;
  width: 48px;
  height: 48px;
  border-radius: var(--radius-md);
  background: var(--bg-glass);
  backdrop-filter: var(--blur);
  -webkit-backdrop-filter: var(--blur);
  border: 1px solid var(--border-glass);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-primary);
  transition: var(--transition);
  z-index: 100;
}

.theme-toggle:hover {
  background: var(--bg-glass-strong);
  transform: scale(1.05);
  border-color: var(--accent);
}

.theme-toggle svg {
  width: 24px;
  height: 24px;
}

/* Floating Orbs */
.orbs {
  position: absolute;
  inset: 0;
  overflow: hidden;
  pointer-events: none;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(60px);
  opacity: 0.6;
  animation: float 8s ease-in-out infinite;
}

.orb-1 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
  top: -100px;
  right: -50px;
  animation-delay: 0s;
}

.orb-2 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #ec4899 0%, #f472b6 100%);
  bottom: -50px;
  left: -50px;
  animation-delay: -2s;
}

.orb-3 {
  width: 250px;
  height: 250px;
  background: linear-gradient(135deg, #06b6d4 0%, #22d3ee 100%);
  top: 40%;
  left: 20%;
  animation-delay: -4s;
}

.orb-4 {
  width: 200px;
  height: 200px;
  background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%);
  bottom: 30%;
  right: 15%;
  animation-delay: -6s;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px) scale(1);
  }
  50% {
    transform: translateY(-30px) scale(1.05);
  }
}

/* Container */
.login-container {
  position: relative;
  z-index: 10;
  display: flex;
  flex-direction: column;
  align-items: center;
}

/* Logo */
.login-logo {
  text-align: center;
  margin-bottom: 40px;
}

.logo-glow {
  display: inline-block;
  animation: pulse-glow 3s ease-in-out infinite;
}

.logo-icon {
  width: 80px;
  height: 80px;
  margin-bottom: 20px;
  filter: drop-shadow(0 8px 24px rgba(124, 58, 237, 0.4));
}

.login-logo h1 {
  font-size: 36px;
  font-weight: 800;
  margin: 0 0 8px 0;
  letter-spacing: -1px;
}

.tagline {
  color: var(--text-secondary);
  font-size: 15px;
  margin: 0;
  font-weight: 500;
}

/* Login Card */
.login-card {
  padding: 48px;
  width: 420px;
  max-width: 100%;
}

.login-card h2 {
  margin: 0 0 32px 0;
  font-size: 22px;
  font-weight: 700;
  color: var(--text-primary);
  text-align: center;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.login-form :deep(.el-form-item) {
  margin-bottom: 16px;
}

.login-form :deep(.el-input__wrapper) {
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-glass) !important;
  box-shadow: none !important;
}

.login-form :deep(.el-input__wrapper:hover) {
  border-color: var(--accent) !important;
}

.login-form :deep(.el-input__wrapper.is-focus) {
  border-color: var(--accent) !important;
  box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.15) !important;
}

.login-form :deep(.el-input__inner) {
  color: var(--text-primary) !important;
}

.login-form :deep(.el-input__inner::placeholder) {
  color: var(--text-muted) !important;
}

.login-btn {
  width: 100%;
  height: 52px;
  font-size: 16px;
  font-weight: 600;
  margin-top: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.login-btn svg {
  transition: transform 0.3s;
}

.login-btn:hover svg {
  transform: translateX(4px);
}

/* Copyright */
.copyright {
  margin-top: 32px;
  color: var(--text-muted);
  font-size: 13px;
}

/* Responsive */
@media (max-width: 480px) {
  .login-card {
    padding: 32px 24px;
  }

  .login-logo h1 {
    font-size: 28px;
  }

  .logo-icon {
    width: 64px;
    height: 64px;
  }
}
</style>
