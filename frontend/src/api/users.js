import client from './client'

export const usersApi = {
  getAll() {
    return client.get('/users')
  },
  search(params) {
    return client.get('/users/search', { params })
  },
  getById(id) {
    return client.get(`/users/${id}`)
  },
  create(data) {
    return client.post('/users', data)
  },
  update(id, data) {
    return client.put(`/users/${id}`, data)
  },
  delete(id) {
    return client.delete(`/users/${id}`)
  }
}
