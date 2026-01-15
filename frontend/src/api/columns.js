import client from './client'

export const columnsApi = {
  getAll() {
    return client.get('/columns')
  },
  getById(id) {
    return client.get(`/columns/${id}`)
  },
  create(data) {
    return client.post('/columns', data)
  },
  update(id, data) {
    return client.put(`/columns/${id}`, data)
  },
  delete(id) {
    return client.delete(`/columns/${id}`)
  },
  reorder(ids) {
    return client.put('/columns/reorder', ids)
  }
}
