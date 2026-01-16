import client from './client'

export const authApi = {
  login(username, password) {
    return client.post('/auth/login', { username, password })
  },
  me() {
    return client.get('/auth/me')
  },
  logout() {
    return client.post('/auth/logout')
  }
}
