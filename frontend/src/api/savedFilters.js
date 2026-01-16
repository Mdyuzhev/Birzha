import client from './client'

export const savedFiltersApi = {
  getAll() {
    return client.get('/saved-filters')
  },
  getById(id) {
    return client.get(`/saved-filters/${id}`)
  },
  getDefault() {
    return client.get('/saved-filters/default')
  },
  create(data) {
    return client.post('/saved-filters', data)
  },
  update(id, data) {
    return client.put(`/saved-filters/${id}`, data)
  },
  delete(id) {
    return client.delete(`/saved-filters/${id}`)
  },
  setDefault(id) {
    return client.post(`/saved-filters/${id}/set-default`)
  },
  toggleGlobal(id) {
    return client.post(`/saved-filters/${id}/toggle-global`)
  }
}
