import client from './client'

// Получение всех направлений с стеками
export const getDirections = (includeStacks = true) => {
  return client.get('/tech-stacks/directions', { params: { includeStacks } })
}

// Получение активных стеков для выбора
export const getSelectableStacks = () => {
  return client.get('/tech-stacks')
}

// Получение стеков по направлению
export const getStacksByDirection = (directionId) => {
  return client.get(`/tech-stacks/by-direction/${directionId}`)
}

// Получение одного стека
export const getStack = (id) => {
  return client.get(`/tech-stacks/${id}`)
}

// Поиск стеков
export const searchStacks = (query) => {
  return client.get('/tech-stacks/search', { params: { q: query } })
}

// Создание стека (админ)
export const createStack = (data) => {
  return client.post('/tech-stacks', data)
}

// Предложение нового стека (любой пользователь)
export const proposeStack = (data) => {
  return client.post('/tech-stacks/propose', data)
}

// Получение предложенных стеков (админ)
export const getPendingStacks = () => {
  return client.get('/tech-stacks/pending')
}

// Согласование стека (админ)
export const approveStack = (id, code = null) => {
  return client.post(`/tech-stacks/${id}/approve`, null, { params: { code } })
}

// Отклонение стека (админ)
export const rejectStack = (id, reason) => {
  return client.post(`/tech-stacks/${id}/reject`, { reason })
}

// Пометить стек как устаревший (админ)
export const deprecateStack = (id) => {
  return client.post(`/tech-stacks/${id}/deprecate`)
}
