import client from './client'

export const resumesApi = {
  getAll(search = '') {
    const params = search ? { search } : {}
    return client.get('/resumes', { params })
  },
  getById(id) {
    return client.get(`/resumes/${id}`)
  },
  getByEmployeeId(employeeId) {
    return client.get(`/resumes/employee/${employeeId}`)
  },
  create(data) {
    return client.post('/resumes', data)
  },
  update(id, data) {
    return client.put(`/resumes/${id}`, data)
  },
  delete(id) {
    return client.delete(`/resumes/${id}`)
  },
  exportPdf(id) {
    return client.get(`/resumes/${id}/pdf`, { responseType: 'blob' })
  },
  exportPdfByEmployee(employeeId) {
    return client.get(`/resumes/employee/${employeeId}/pdf`, { responseType: 'blob' })
  }
}
