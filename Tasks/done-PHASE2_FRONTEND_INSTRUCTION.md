# Инструкция: Фаза 2 — Frontend Core

## Контекст

Backend готов и работает на http://localhost:31081. Теперь создаём Vue.js SPA для работы с системой управления ресурсами.

Прочитай `CLAUDE.md` в корне проекта для понимания общей архитектуры.

## Цель фазы

Получить работающий frontend, который:
- Позволяет залогиниться
- Показывает таблицу сотрудников с динамическими колонками
- Позволяет добавлять и редактировать сотрудников
- Поддерживает фильтрацию и сортировку

## Шаги выполнения

### Шаг 1: Инициализация проекта

1.1. Создай Vue проект через Vite:
```bash
npm create vite@latest frontend -- --template vue
cd frontend
npm install
```

1.2. Установи зависимости:
```bash
npm install vue-router@4 pinia axios element-plus @element-plus/icons-vue
```

1.3. Создай структуру директорий:
```
frontend/src/
├── api/           # Axios клиенты
├── components/    # Переиспользуемые компоненты
├── views/         # Страницы
├── stores/        # Pinia stores
├── router/        # Vue Router
├── utils/         # Вспомогательные функции
├── assets/        # Стили, картинки
├── App.vue
└── main.js
```

### Шаг 2: Конфигурация

2.1. Обнови `vite.config.js`:
```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src')
    }
  },
  server: {
    port: 31080,
    proxy: {
      '/api': {
        target: 'http://localhost:31081',
        changeOrigin: true
      }
    }
  }
})
```

2.2. Создай `src/main.js`:
```javascript
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import ru from 'element-plus/dist/locale/ru.mjs'
import App from './App.vue'
import router from './router'

const app = createApp(App)
app.use(createPinia())
app.use(router)
app.use(ElementPlus, { locale: ru })
app.mount('#app')
```

### Шаг 3: API клиент

3.1. Создай `src/api/client.js`:
```javascript
import axios from 'axios'
import { useAuthStore } from '@/stores/auth'
import router from '@/router'

const client = axios.create({
  baseURL: '/api',
  headers: {
    'Content-Type': 'application/json'
  }
})

// Interceptor для добавления токена
client.interceptors.request.use(config => {
  const authStore = useAuthStore()
  if (authStore.token) {
    config.headers.Authorization = `Bearer ${authStore.token}`
  }
  return config
})

// Interceptor для обработки 401
client.interceptors.response.use(
  response => response,
  error => {
    if (error.response?.status === 401) {
      const authStore = useAuthStore()
      authStore.logout()
      router.push('/login')
    }
    return Promise.reject(error)
  }
)

export default client
```

3.2. Создай `src/api/auth.js`:
```javascript
import client from './client'

export const authApi = {
  login(username, password) {
    return client.post('/auth/login', { username, password })
  },
  me() {
    return client.get('/auth/me')
  }
}
```

3.3. Создай `src/api/employees.js`:
```javascript
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
  }
}
```

3.4. Создай `src/api/columns.js`:
```javascript
import client from './client'

export const columnsApi = {
  getAll() {
    return client.get('/columns')
  }
}
```

3.5. Создай `src/api/dictionaries.js`:
```javascript
import client from './client'

export const dictionariesApi = {
  getAll() {
    return client.get('/dictionaries')
  },
  getById(id) {
    return client.get(`/dictionaries/${id}`)
  }
}
```

### Шаг 4: Pinia Stores

4.1. Создай `src/stores/auth.js`:
```javascript
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '@/api/auth'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token'))
  const user = ref(null)

  const isAuthenticated = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.role === 'ADMIN')

  async function login(username, password) {
    const response = await authApi.login(username, password)
    token.value = response.data.token
    user.value = {
      username: response.data.username,
      role: response.data.role
    }
    localStorage.setItem('token', token.value)
    return response.data
  }

  async function fetchCurrentUser() {
    if (!token.value) return null
    try {
      const response = await authApi.me()
      user.value = response.data
      return response.data
    } catch (e) {
      logout()
      return null
    }
  }

  function logout() {
    token.value = null
    user.value = null
    localStorage.removeItem('token')
  }

  return {
    token,
    user,
    isAuthenticated,
    isAdmin,
    login,
    fetchCurrentUser,
    logout
  }
})
```

4.2. Создай `src/stores/columns.js`:
```javascript
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { columnsApi } from '@/api/columns'
import { dictionariesApi } from '@/api/dictionaries'

export const useColumnsStore = defineStore('columns', () => {
  const columns = ref([])
  const dictionaries = ref({})
  const loading = ref(false)

  async function fetchColumns() {
    loading.value = true
    try {
      const response = await columnsApi.getAll()
      columns.value = response.data.sort((a, b) => a.sortOrder - b.sortOrder)
      
      // Загружаем справочники для SELECT полей
      const selectColumns = columns.value.filter(c => c.fieldType === 'SELECT' && c.dictionaryId)
      for (const col of selectColumns) {
        if (!dictionaries.value[col.dictionaryId]) {
          const dictResponse = await dictionariesApi.getById(col.dictionaryId)
          dictionaries.value[col.dictionaryId] = dictResponse.data
        }
      }
    } finally {
      loading.value = false
    }
  }

  function getDictionaryValues(dictionaryId) {
    return dictionaries.value[dictionaryId]?.values || []
  }

  return {
    columns,
    dictionaries,
    loading,
    fetchColumns,
    getDictionaryValues
  }
})
```

### Шаг 5: Router

5.1. Создай `src/router/index.js`:
```javascript
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
  } else {
    next()
  }
})

export default router
```

### Шаг 6: Views

6.1. Создай `src/views/LoginView.vue`:
```vue
<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { ElMessage } from 'element-plus'

const router = useRouter()
const authStore = useAuthStore()

const form = ref({
  username: '',
  password: ''
})
const loading = ref(false)

async function handleLogin() {
  if (!form.value.username || !form.value.password) {
    ElMessage.warning('Введите логин и пароль')
    return
  }
  
  loading.value = true
  try {
    await authStore.login(form.value.username, form.value.password)
    ElMessage.success('Добро пожаловать!')
    router.push('/')
  } catch (error) {
    ElMessage.error('Неверный логин или пароль')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-container">
    <el-card class="login-card">
      <template #header>
        <h2>Resource Manager</h2>
      </template>
      
      <el-form @submit.prevent="handleLogin">
        <el-form-item label="Логин">
          <el-input 
            v-model="form.username" 
            placeholder="Введите логин"
            autocomplete="username"
          />
        </el-form-item>
        
        <el-form-item label="Пароль">
          <el-input 
            v-model="form.password" 
            type="password" 
            placeholder="Введите пароль"
            autocomplete="current-password"
            @keyup.enter="handleLogin"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button 
            type="primary" 
            :loading="loading" 
            @click="handleLogin"
            style="width: 100%"
          >
            Войти
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f0f2f5;
}

.login-card {
  width: 400px;
}

.login-card h2 {
  margin: 0;
  text-align: center;
}
</style>
```

6.2. Создай `src/views/EmployeesView.vue`:
```vue
<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useColumnsStore } from '@/stores/columns'
import { employeesApi } from '@/api/employees'
import { ElMessage, ElMessageBox } from 'element-plus'
import EmployeeDialog from '@/components/EmployeeDialog.vue'

const router = useRouter()
const authStore = useAuthStore()
const columnsStore = useColumnsStore()

const employees = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const editingEmployee = ref(null)
const filters = ref({})

// Фиксированные колонки + динамические
const tableColumns = computed(() => {
  const fixed = [
    { prop: 'fullName', label: 'ФИО', width: 250, fixed: true },
    { prop: 'email', label: 'Email', width: 200 }
  ]
  
  const dynamic = columnsStore.columns.map(col => ({
    prop: `customFields.${col.name}`,
    label: col.displayName,
    width: 150,
    fieldType: col.fieldType,
    dictionaryId: col.dictionaryId
  }))
  
  return [...fixed, ...dynamic]
})

async function fetchEmployees() {
  loading.value = true
  try {
    const response = await employeesApi.getAll(filters.value)
    employees.value = response.data.content || response.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки данных')
  } finally {
    loading.value = false
  }
}

function getNestedValue(obj, path) {
  return path.split('.').reduce((acc, part) => acc?.[part], obj)
}

function openCreateDialog() {
  editingEmployee.value = null
  dialogVisible.value = true
}

function openEditDialog(employee) {
  editingEmployee.value = { ...employee }
  dialogVisible.value = true
}

async function handleDelete(employee) {
  try {
    await ElMessageBox.confirm(
      `Удалить сотрудника "${employee.fullName}"?`,
      'Подтверждение',
      { type: 'warning' }
    )
    await employeesApi.delete(employee.id)
    ElMessage.success('Сотрудник удалён')
    fetchEmployees()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('Ошибка удаления')
    }
  }
}

function handleDialogClose(saved) {
  dialogVisible.value = false
  if (saved) {
    fetchEmployees()
  }
}

function handleLogout() {
  authStore.logout()
  router.push('/login')
}

onMounted(async () => {
  await columnsStore.fetchColumns()
  await fetchEmployees()
})
</script>

<template>
  <div class="employees-container">
    <!-- Header -->
    <el-header class="page-header">
      <h1>Управление ресурсами</h1>
      <div class="header-actions">
        <span class="user-info">{{ authStore.user?.username }}</span>
        <el-button @click="handleLogout">Выйти</el-button>
      </div>
    </el-header>

    <!-- Toolbar -->
    <div class="toolbar">
      <el-button type="primary" @click="openCreateDialog">
        Добавить сотрудника
      </el-button>
      <el-button @click="fetchEmployees" :loading="loading">
        Обновить
      </el-button>
    </div>

    <!-- Table -->
    <el-table 
      :data="employees" 
      v-loading="loading"
      stripe
      border
      style="width: 100%"
    >
      <el-table-column
        v-for="col in tableColumns"
        :key="col.prop"
        :prop="col.prop"
        :label="col.label"
        :width="col.width"
        :fixed="col.fixed"
      >
        <template #default="{ row }">
          {{ getNestedValue(row, col.prop) || '—' }}
        </template>
      </el-table-column>
      
      <el-table-column label="Действия" width="180" fixed="right">
        <template #default="{ row }">
          <el-button size="small" @click="openEditDialog(row)">
            Редактировать
          </el-button>
          <el-button size="small" type="danger" @click="handleDelete(row)">
            Удалить
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- Dialog -->
    <EmployeeDialog
      v-model:visible="dialogVisible"
      :employee="editingEmployee"
      @close="handleDialogClose"
    />
  </div>
</template>

<style scoped>
.employees-container {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 0;
}

.page-header h1 {
  margin: 0;
  font-size: 24px;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.user-info {
  color: #606266;
}

.toolbar {
  margin-bottom: 16px;
  display: flex;
  gap: 12px;
}
</style>
```

6.3. Создай `src/views/EmployeeDetailView.vue`:
```vue
<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { employeesApi } from '@/api/employees'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()

const employee = ref(null)
const history = ref([])
const loading = ref(false)

async function fetchData() {
  loading.value = true
  try {
    const [empResponse, histResponse] = await Promise.all([
      employeesApi.getById(route.params.id),
      employeesApi.getHistory(route.params.id)
    ])
    employee.value = empResponse.data
    history.value = histResponse.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки')
    router.push('/')
  } finally {
    loading.value = false
  }
}

function formatDate(dateStr) {
  return new Date(dateStr).toLocaleString('ru-RU')
}

onMounted(fetchData)
</script>

<template>
  <div class="detail-container" v-loading="loading">
    <el-page-header @back="router.push('/')">
      <template #content>
        {{ employee?.fullName || 'Загрузка...' }}
      </template>
    </el-page-header>

    <el-card v-if="employee" class="info-card">
      <template #header>Информация о сотруднике</template>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="ФИО">
          {{ employee.fullName }}
        </el-descriptions-item>
        <el-descriptions-item label="Email">
          {{ employee.email || '—' }}
        </el-descriptions-item>
        <el-descriptions-item 
          v-for="(value, key) in employee.customFields" 
          :key="key"
          :label="key"
        >
          {{ value || '—' }}
        </el-descriptions-item>
      </el-descriptions>
    </el-card>

    <el-card class="history-card">
      <template #header>История изменений</template>
      <el-table :data="history" stripe>
        <el-table-column prop="changedAt" label="Дата" width="180">
          <template #default="{ row }">
            {{ formatDate(row.changedAt) }}
          </template>
        </el-table-column>
        <el-table-column prop="changedByUsername" label="Пользователь" width="150" />
        <el-table-column prop="fieldName" label="Поле" width="150" />
        <el-table-column prop="oldValue" label="Было" />
        <el-table-column prop="newValue" label="Стало" />
      </el-table>
    </el-card>
  </div>
</template>

<style scoped>
.detail-container {
  padding: 20px;
}

.info-card {
  margin: 20px 0;
}

.history-card {
  margin-top: 20px;
}
</style>
```

### Шаг 7: Components

7.1. Создай `src/components/EmployeeDialog.vue`:
```vue
<script setup>
import { ref, watch, computed } from 'vue'
import { useColumnsStore } from '@/stores/columns'
import { employeesApi } from '@/api/employees'
import { ElMessage } from 'element-plus'

const props = defineProps({
  visible: Boolean,
  employee: Object
})

const emit = defineEmits(['update:visible', 'close'])

const columnsStore = useColumnsStore()

const form = ref({
  fullName: '',
  email: '',
  customFields: {}
})
const loading = ref(false)

const isEdit = computed(() => !!props.employee?.id)
const title = computed(() => isEdit.value ? 'Редактирование сотрудника' : 'Новый сотрудник')

// Инициализация формы при открытии
watch(() => props.visible, (val) => {
  if (val) {
    if (props.employee) {
      form.value = {
        fullName: props.employee.fullName,
        email: props.employee.email || '',
        customFields: { ...props.employee.customFields }
      }
    } else {
      form.value = {
        fullName: '',
        email: '',
        customFields: {}
      }
      // Инициализируем customFields пустыми значениями
      columnsStore.columns.forEach(col => {
        form.value.customFields[col.name] = ''
      })
    }
  }
})

async function handleSave() {
  if (!form.value.fullName.trim()) {
    ElMessage.warning('Введите ФИО')
    return
  }

  loading.value = true
  try {
    if (isEdit.value) {
      await employeesApi.update(props.employee.id, form.value)
      ElMessage.success('Сотрудник обновлён')
    } else {
      await employeesApi.create(form.value)
      ElMessage.success('Сотрудник создан')
    }
    emit('close', true)
  } catch (error) {
    ElMessage.error('Ошибка сохранения')
  } finally {
    loading.value = false
  }
}

function handleClose() {
  emit('update:visible', false)
  emit('close', false)
}
</script>

<template>
  <el-dialog
    :model-value="visible"
    :title="title"
    width="600px"
    @close="handleClose"
  >
    <el-form :model="form" label-width="140px">
      <!-- Фиксированные поля -->
      <el-form-item label="ФИО" required>
        <el-input v-model="form.fullName" placeholder="Иванов Иван Иванович" />
      </el-form-item>
      
      <el-form-item label="Email">
        <el-input v-model="form.email" placeholder="ivanov@company.ru" />
      </el-form-item>

      <el-divider>Дополнительные поля</el-divider>

      <!-- Динамические поля -->
      <el-form-item 
        v-for="col in columnsStore.columns" 
        :key="col.name"
        :label="col.displayName"
        :required="col.isRequired"
      >
        <!-- SELECT -->
        <el-select 
          v-if="col.fieldType === 'SELECT'"
          v-model="form.customFields[col.name]"
          placeholder="Выберите значение"
          clearable
          style="width: 100%"
        >
          <el-option
            v-for="opt in columnsStore.getDictionaryValues(col.dictionaryId)"
            :key="opt"
            :label="opt"
            :value="opt"
          />
        </el-select>

        <!-- DATE -->
        <el-date-picker
          v-else-if="col.fieldType === 'DATE'"
          v-model="form.customFields[col.name]"
          type="date"
          placeholder="Выберите дату"
          format="DD.MM.YYYY"
          value-format="YYYY-MM-DD"
          style="width: 100%"
        />

        <!-- NUMBER -->
        <el-input-number
          v-else-if="col.fieldType === 'NUMBER'"
          v-model="form.customFields[col.name]"
          :min="0"
          style="width: 100%"
        />

        <!-- TEXT (default) -->
        <el-input
          v-else
          v-model="form.customFields[col.name]"
          placeholder="Введите значение"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button @click="handleClose">Отмена</el-button>
      <el-button type="primary" :loading="loading" @click="handleSave">
        {{ isEdit ? 'Сохранить' : 'Создать' }}
      </el-button>
    </template>
  </el-dialog>
</template>
```

### Шаг 8: App.vue и стили

8.1. Обнови `src/App.vue`:
```vue
<script setup>
import { onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

onMounted(() => {
  if (authStore.token) {
    authStore.fetchCurrentUser()
  }
})
</script>

<template>
  <router-view />
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  background: #f5f7fa;
  min-height: 100vh;
}
</style>
```

### Шаг 9: Dockerfile для production

9.1. Создай `frontend/Dockerfile`:
```dockerfile
# Build stage
FROM node:20-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

9.2. Создай `frontend/nginx.conf`:
```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # SPA fallback
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Proxy API requests to backend
    location /api/ {
        proxy_pass http://backend:8080/api/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Проверка результата

1. Убедись что backend запущен на порту 31081

2. Запусти frontend в dev режиме:
```bash
cd frontend
npm run dev
```

3. Открой http://localhost:31080

4. Проверь:
   - Страница логина отображается
   - Логин admin/admin123 работает
   - После логина видна таблица сотрудников
   - Кнопка "Добавить сотрудника" открывает форму
   - Форма содержит динамические поля из справочников
   - Создание и редактирование работают
   - Кнопка "Выйти" разлогинивает

## Критерии завершения фазы

- [ ] npm run dev запускается без ошибок
- [ ] Страница логина работает
- [ ] Таблица сотрудников отображается с динамическими колонками
- [ ] Форма создания/редактирования работает
- [ ] SELECT поля показывают значения из справочников
- [ ] Данные сохраняются в backend
- [ ] При 401 происходит редирект на логин
- [ ] Dockerfile собирается

## Важно

- Используй `<script setup>` синтаксис Vue 3
- Не забудь импорты в каждом файле
- Проверяй консоль браузера на ошибки
- При ошибках CORS — проверь что proxy в vite.config.js настроен
- Коммить после каждого логического блока

Приступай. Начни с инициализации проекта и установки зависимостей.
