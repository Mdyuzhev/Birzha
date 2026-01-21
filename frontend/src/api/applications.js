import client from './client'

export const applicationsApi = {
  // CRUD
  getAll(params) {
    return client.get('/applications', { params })
  },
  getById(id) {
    return client.get(`/applications/${id}`)
  },
  create(data) {
    return client.post('/applications', data)
  },
  update(id, data) {
    return client.put(`/applications/${id}`, data)
  },
  delete(id) {
    return client.delete(`/applications/${id}`)
  },

  // Специализированные списки
  getMy(params) {
    return client.get('/applications/my', { params })
  },
  getAssigned(params) {
    return client.get('/applications/assigned', { params })
  },
  getPendingApproval(params) {
    return client.get('/applications/pending-approval', { params })
  },

  // Метаданные
  getHistory(id) {
    return client.get(`/applications/${id}/history`)
  },
  getStats() {
    return client.get('/applications/stats')
  },
  getStatuses() {
    return client.get('/applications/statuses')
  },
  getAvailableActions(id) {
    return client.get(`/applications/${id}/available-actions`)
  },

  // Workflow действия
  submit(id, comment) {
    return client.post(`/applications/${id}/submit`, null, { params: { comment } })
  },
  assignRecruiter(id, comment) {
    return client.post(`/applications/${id}/assign-recruiter`, null, { params: { comment } })
  },
  startInterview(id, comment) {
    return client.post(`/applications/${id}/start-interview`, null, { params: { comment } })
  },
  sendToHrBp(id, data = {}) {
    return client.post(`/applications/${id}/send-to-hr-bp`, data)
  },
  approveByHrBp(id, data = {}) {
    return client.post(`/applications/${id}/approve-hr-bp`, data)
  },
  rejectByHrBp(id, data) {
    return client.post(`/applications/${id}/reject-hr-bp`, data)
  },
  sendToBorup(id, data = {}) {
    return client.post(`/applications/${id}/send-to-borup`, data)
  },
  approveByBorup(id, data = {}) {
    return client.post(`/applications/${id}/approve-borup`, data)
  },
  rejectByBorup(id, data) {
    return client.post(`/applications/${id}/reject-borup`, data)
  },
  prepareTransfer(id, comment) {
    return client.post(`/applications/${id}/prepare-transfer`, null, { params: { comment } })
  },
  completeTransfer(id, data) {
    return client.post(`/applications/${id}/complete-transfer`, data)
  },
  dismiss(id, data) {
    return client.post(`/applications/${id}/dismiss`, data)
  },
  cancel(id, data = {}) {
    return client.post(`/applications/${id}/cancel`, data)
  },
  returnToHrBp(id, comment) {
    return client.post(`/applications/${id}/return-to-hr-bp`, null, { params: { comment } })
  },
  returnToBorup(id, comment) {
    return client.post(`/applications/${id}/return-to-borup`, null, { params: { comment } })
  },

  // Назначения
  assignHrBp(id, hrBpId) {
    return client.post(`/applications/${id}/assign-hr-bp`, null, { params: { hrBpId } })
  },
  assignBorup(id, borupId) {
    return client.post(`/applications/${id}/assign-borup`, null, { params: { borupId } })
  }
}
