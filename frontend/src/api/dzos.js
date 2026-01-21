import client from './client'

export const dzosApi = {
  getAll() {
    return client.get('/dzos')
  },
  getById(id) {
    return client.get(`/dzos/${id}`)
  },
  create(data) {
    return client.post('/dzos', data)
  },
  update(id, data) {
    return client.put(`/dzos/${id}`, data)
  }
}
