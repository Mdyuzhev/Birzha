import client from './client'

export const employeesApi = {
  getAll(params = {}) {
    return client.get('/employees', { params })
  },
  getById(id) {
    return client.get(`/employees/${id}`)
  },
  create(data) {
    return client.post('/employees', data)
  },
  update(id, data) {
    return client.put(`/employees/${id}`, data)
  },
  delete(id) {
    return client.delete(`/employees/${id}`)
  },
  getHistory(id) {
    return client.get(`/employees/${id}/history`)
  },
  getRecentHistory(limit = 15) {
    return client.get('/employees/history/recent', { params: { limit } })
  },
  export(params = {}) {
    return client.get('/employees/export', {
      params,
      responseType: 'blob'
    })
  }
}
