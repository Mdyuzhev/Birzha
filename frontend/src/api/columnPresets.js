import client from './client'

export const columnPresetsApi = {
  getAll() {
    return client.get('/column-presets')
  },
  getById(id) {
    return client.get(`/column-presets/${id}`)
  },
  getDefault() {
    return client.get('/column-presets/default')
  },
  create(data) {
    return client.post('/column-presets', data)
  },
  update(id, data) {
    return client.put(`/column-presets/${id}`, data)
  },
  delete(id) {
    return client.delete(`/column-presets/${id}`)
  },
  setDefault(id) {
    return client.post(`/column-presets/${id}/set-default`)
  }
}
