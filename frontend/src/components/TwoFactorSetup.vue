<template>
  <div class="two-factor-setup">
    <!-- Статус -->
    <div class="status-section">
      <div class="status-indicator" :class="{ enabled: authStore.isTotpEnabled }">
        <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24">
          <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/>
        </svg>
      </div>
      <div class="status-text">
        <h3>Двухфакторная аутентификация</h3>
        <p v-if="authStore.isTotpEnabled" class="enabled">Включена</p>
        <p v-else class="disabled">Отключена</p>
      </div>
    </div>

    <!-- Кнопки -->
    <div class="actions">
      <el-button
        v-if="!authStore.isTotpEnabled"
        type="primary"
        @click="startSetup"
      >
        Включить 2FA
      </el-button>
      <el-button
        v-else
        type="danger"
        @click="confirmDisable"
      >
        Отключить 2FA
      </el-button>
    </div>

    <!-- Диалог настройки -->
    <el-dialog
      v-model="showSetupDialog"
      title="Настройка двухфакторной аутентификации"
      width="500px"
    >
      <div v-if="setupData" class="setup-content">
        <div class="step">
          <div class="step-number">1</div>
          <div class="step-text">
            <p>Установите Google Authenticator, Authy или Яндекс.Ключ</p>
          </div>
        </div>

        <div class="step">
          <div class="step-number">2</div>
          <div class="step-text">
            <p>Отсканируйте QR-код</p>
            <div class="qr-container">
              <img :src="setupData.qrCodeDataUrl" alt="QR Code" class="qr-code" />
            </div>
            <p class="manual-key">
              Или введите ключ вручную: <code>{{ setupData.manualEntryKey }}</code>
            </p>
          </div>
        </div>

        <div class="step">
          <div class="step-number">3</div>
          <div class="step-text">
            <p>Введите код из приложения</p>
            <el-input
              v-model="verifyCode"
              placeholder="000000"
              maxlength="6"
              class="verify-input"
            />
          </div>
        </div>
      </div>

      <template #footer>
        <el-button @click="cancelSetup">Отмена</el-button>
        <el-button type="primary" :loading="loading" @click="confirmSetup">
          Подтвердить
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useAuthStore } from '@/stores/auth'
import { twoFactorApi } from '@/api/twoFactor'

const authStore = useAuthStore()

const showSetupDialog = ref(false)
const setupData = ref(null)
const verifyCode = ref('')
const loading = ref(false)

async function startSetup() {
  loading.value = true
  try {
    const response = await twoFactorApi.setup()
    setupData.value = response.data
    showSetupDialog.value = true
  } catch (error) {
    ElMessage.error('Ошибка при настройке 2FA')
  } finally {
    loading.value = false
  }
}

async function confirmSetup() {
  if (verifyCode.value.length !== 6) {
    ElMessage.warning('Введите 6-значный код')
    return
  }

  loading.value = true
  try {
    const response = await twoFactorApi.enable(verifyCode.value)
    if (response.data.success) {
      ElMessage.success('2FA успешно включена!')
      showSetupDialog.value = false
      setupData.value = null
      verifyCode.value = ''
      // Обновить данные пользователя
      await authStore.fetchCurrentUser()
    }
  } catch (error) {
    ElMessage.error(error.response?.data?.message || 'Неверный код')
  } finally {
    loading.value = false
  }
}

function cancelSetup() {
  showSetupDialog.value = false
  setupData.value = null
  verifyCode.value = ''
}

async function confirmDisable() {
  try {
    await ElMessageBox.confirm(
      'Вы уверены, что хотите отключить двухфакторную аутентификацию?',
      'Подтверждение',
      {
        confirmButtonText: 'Отключить',
        cancelButtonText: 'Отмена',
        type: 'warning'
      }
    )
  } catch {
    return
  }

  loading.value = true
  try {
    const response = await twoFactorApi.disable()
    if (response.data.success) {
      ElMessage.success('2FA отключена')
      await authStore.fetchCurrentUser()
    }
  } catch (error) {
    ElMessage.error(error.response?.data?.message || 'Ошибка при отключении 2FA')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.two-factor-setup {
  padding: 20px;
}

.status-section {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
}

.status-indicator {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  background: rgba(239, 68, 68, 0.2);
  color: #ef4444;
}

.status-indicator.enabled {
  background: rgba(16, 185, 129, 0.2);
  color: #10b981;
}

.status-text h3 {
  margin: 0;
  font-size: 16px;
  color: var(--text-primary);
}

.status-text p {
  margin: 4px 0 0;
  font-size: 14px;
}

.status-text p.enabled {
  color: #10b981;
}

.status-text p.disabled {
  color: #ef4444;
}

.actions {
  margin-top: 16px;
}

.setup-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.step {
  display: flex;
  gap: 16px;
}

.step-number {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--accent, #7c3aed);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  flex-shrink: 0;
}

.step-text {
  flex: 1;
}

.step-text p {
  margin: 0 0 12px 0;
  color: var(--text-primary);
}

.qr-container {
  margin: 16px 0;
  display: flex;
  justify-content: center;
}

.qr-code {
  width: 200px;
  height: 200px;
  border-radius: 8px;
  background: white;
  padding: 8px;
}

.manual-key {
  font-size: 13px;
  color: var(--text-secondary);
}

.manual-key code {
  background: rgba(124, 58, 237, 0.2);
  padding: 4px 8px;
  border-radius: 4px;
  font-family: monospace;
  color: var(--accent);
}

.verify-input :deep(.el-input__inner) {
  text-align: center;
  font-size: 20px;
  letter-spacing: 4px;
  font-family: monospace;
}
</style>
