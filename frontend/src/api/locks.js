import client from './client'

export const locksApi = {
  acquire(entityType, entityId) {
    return client.post('/locks/acquire', { entityType, entityId })
  },
  renew(entityType, entityId) {
    return client.post('/locks/renew', { entityType, entityId })
  },
  release(entityType, entityId) {
    return client.post('/locks/release', { entityType, entityId })
  },
  getStatus(entityType, entityId) {
    return client.get('/locks/status', { params: { entityType, entityId } })
  }
}
