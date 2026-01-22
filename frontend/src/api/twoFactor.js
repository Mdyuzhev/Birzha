import client from './client'

export const twoFactorApi = {
  // Получить статус 2FA
  getStatus() {
    return client.get('/2fa/status')
  },

  // Начать настройку — получить QR-код
  setup() {
    return client.post('/2fa/setup')
  },

  // Подтвердить настройку и включить 2FA
  enable(code) {
    return client.post('/2fa/enable', { code })
  },

  // Отключить 2FA
  disable() {
    return client.post('/2fa/disable')
  },

  // Проверить код при логине
  verify(twoFactorToken, code) {
    return client.post('/auth/verify-2fa', { twoFactorToken, code })
  }
}
