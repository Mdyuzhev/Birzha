import client from './client'

export const dictionariesApi = {
  getAll() {
    return client.get('/dictionaries')
  },
  getById(id) {
    return client.get(`/dictionaries/${id}`)
  },
  create(data) {
    return client.post('/dictionaries', data)
  },
  update(id, data) {
    return client.put(`/dictionaries/${id}`, data)
  },
  delete(id) {
    return client.delete(`/dictionaries/${id}`)
  }
}
