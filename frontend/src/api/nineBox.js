import client from './client'

export const nineBoxApi = {
  getAll() {
    return client.get('/nine-box')
  },
  getByEmployeeId(employeeId) {
    return client.get(`/nine-box/employee/${employeeId}`)
  },
  getByBoxPosition(boxPosition) {
    return client.get(`/nine-box/box/${boxPosition}`)
  },
  getStatistics() {
    return client.get('/nine-box/statistics')
  },
  createOrUpdate(data) {
    return client.post('/nine-box', data)
  },
  delete(id) {
    return client.delete(`/nine-box/${id}`)
  }
}
