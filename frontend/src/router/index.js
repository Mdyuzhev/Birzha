import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/LoginView.vue'),
    meta: { guest: true }
  },
  {
    path: '/',
    name: 'Employees',
    component: () => import('@/views/EmployeesView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/employees/:id',
    name: 'EmployeeDetail',
    component: () => import('@/views/EmployeeDetailView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('@/views/AdminView.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/analytics',
    name: 'Analytics',
    component: () => import('@/views/AnalyticsView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/nine-box',
    name: 'NineBox',
    component: () => import('@/views/NineBoxView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/nine-box/:boxId',
    name: 'NineBoxDetail',
    component: () => import('@/views/NineBoxDetailView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/resumes',
    name: 'Resumes',
    component: () => import('@/views/ResumesView.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()

  // Пробуем загрузить текущего пользователя если есть токен
  if (authStore.token && !authStore.user) {
    await authStore.fetchCurrentUser()
  }

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next('/login')
  } else if (to.meta.guest && authStore.isAuthenticated) {
    next('/')
  } else if (to.meta.requiresAdmin && !authStore.isAdmin) {
    next('/')
  } else {
    next()
  }
})

export default router
