import client from './client'

export const analyticsApi = {
  // Общая сводка
  getSummary(params = {}) {
    return client.get('/analytics/summary', { params })
  },

  // По стекам
  getByStack(params = {}) {
    return client.get('/analytics/by-stack', { params })
  },

  // По ДЗО (только для системного админа)
  getByDzo(params = {}) {
    return client.get('/analytics/by-dzo', { params })
  },

  // Воронка конверсии
  getFunnel(params = {}) {
    return client.get('/analytics/funnel', { params })
  },

  // Время согласования
  getApprovalTime(params = {}) {
    return client.get('/analytics/approval-time', { params })
  },

  // Топ рекрутеров
  getTopRecruiters(params = {}) {
    return client.get('/analytics/top-recruiters', { params })
  },

  // Динамика по месяцам
  getMonthlyTrend(params = {}) {
    return client.get('/analytics/monthly-trend', { params })
  },

  // Статистика по зарплатам
  getSalaryStats(params = {}) {
    return client.get('/analytics/salary-stats', { params })
  }
}
