# /phase3 — Frontend Core

Создание Vue.js приложения: логин, таблица сотрудников, форма редактирования.

---

## Предварительные условия

Фазы 1 и 2 завершены — backend полностью работает.

---

## Шаги выполнения

### 1. Инициализировать Vue проект

```bash
cd frontend
npm create vite@latest . -- --template vue
npm install
npm install vue-router@4 pinia axios element-plus @element-plus/icons-vue
```

### 2. Настроить vite.config.js

```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
```

### 3. Настроить main.js

```javascript
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import ru from 'element-plus/es/locale/lang/ru'
import App from './App.vue'
import router from './router'

const app = createApp(App)
app.use(createPinia())
app.use(router)
app.use(ElementPlus, { locale: ru })
app.mount('#app')
```

### 4. Создать API модуль (src/api/index.js)

```javascript
import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  headers: { 'Content-Type': 'application/json' }
})

// Interceptor для добавления токена
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Interceptor для обработки 401
api.interceptors.response.use(
  response => response,
  error => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export default api
```

### 5. Создать Auth store (src/stores/auth.js)

```javascript
import { defineStore } from 'pinia'
import api from '@/api'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    token: localStorage.getItem('token')
  }),
  getters: {
    isAuthenticated: state => !!state.token,
    isAdmin: state => state.user?.role === 'ADMIN'
  },
  actions: {
    async login(username, password) {
      const { data } = await api.post('/auth/login', { username, password })
      this.token = data.token
      localStorage.setItem('token', data.token)
      await this.fetchUser()
    },
    async fetchUser() {
      const { data } = await api.get('/auth/me')
      this.user = data
    },
    logout() {
      this.token = null
      this.user = null
      localStorage.removeItem('token')
    }
  }
})
```

### 6. Создать Router (src/router/index.js)

```javascript
import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
  { path: '/login', name: 'Login', component: () => import('@/views/LoginView.vue') },
  { path: '/', name: 'Employees', component: () => import('@/views/EmployeesView.vue'), meta: { requiresAuth: true } },
  { path: '/admin/columns', name: 'AdminColumns', component: () => import('@/views/AdminColumnsView.vue'), meta: { requiresAuth: true, requiresAdmin: true } },
  { path: '/admin/dictionaries', name: 'AdminDictionaries', component: () => import('@/views/AdminDictionariesView.vue'), meta: { requiresAuth: true, requiresAdmin: true } },
  { path: '/admin/users', name: 'AdminUsers', component: () => import('@/views/AdminUsersView.vue'), meta: { requiresAuth: true, requiresAdmin: true } }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach(async (to, from, next) => {
  const auth = useAuthStore()
  
  if (to.meta.requiresAuth && !auth.isAuthenticated) {
    return next('/login')
  }
  
  if (to.meta.requiresAdmin && !auth.isAdmin) {
    return next('/')
  }
  
  next()
})

export default router
```

### 7. Создать LoginView.vue

Форма с полями username/password, кнопка входа, обработка ошибок.
После успешного логина — redirect на главную.

### 8. Создать Employees store (src/stores/employees.js)

```javascript
export const useEmployeesStore = defineStore('employees', {
  state: () => ({
    employees: [],
    columns: [],
    loading: false,
    filters: {}
  }),
  actions: {
    async fetchColumns() { /* GET /api/columns */ },
    async fetchEmployees() { /* GET /api/employees с filters */ },
    async createEmployee(data) { /* POST /api/employees */ },
    async updateEmployee(id, data) { /* PUT /api/employees/{id} */ },
    async deleteEmployee(id) { /* DELETE /api/employees/{id} */ }
  }
})
```

### 9. Создать EmployeesView.vue

Компоненты:
- FilterPanel — фильтры на основе columns
- EmployeeTable — el-table с динамическими колонками
- EmployeeForm — el-dialog с формой

Таблица строится динамически на основе columns:
```vue
<el-table-column 
  v-for="col in columns" 
  :key="col.name"
  :prop="'customFields.' + col.name"
  :label="col.displayName"
/>
```

### 10. Создать EmployeeForm.vue

Форма строится динамически:
- TEXT → el-input
- SELECT → el-select с options из dictionary
- DATE → el-date-picker
- NUMBER → el-input-number

Валидация на основе isRequired.

---

## Проверка результата

```bash
# Запустить frontend
cd frontend
npm run dev

# Открыть http://localhost:5173
# Логин: admin / admin123
# Должна открыться таблица сотрудников
# Проверить добавление/редактирование сотрудника
```

---

## Критерии завершения фазы

- Страница логина работает
- После логина открывается таблица сотрудников
- Колонки таблицы соответствуют column_definitions
- Форма добавления/редактирования открывается
- Поля формы соответствуют типам колонок
- SELECT-поля показывают значения из справочников
- CRUD операции работают
