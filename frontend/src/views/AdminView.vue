<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'
import { usersApi } from '@/api/users'
import { dictionariesApi } from '@/api/dictionaries'
import { columnsApi } from '@/api/columns'
import { ElMessage, ElMessageBox } from 'element-plus'

const router = useRouter()
const authStore = useAuthStore()
const themeStore = useThemeStore()

const activeTab = ref('users')

// Users
const users = ref([])
const usersLoading = ref(false)
const userDialogVisible = ref(false)
const editingUser = ref(null)
const selectedUser = ref(null)
const userForm = ref({
  username: '',
  password: '',
  role: 'USER'
})

// Dictionaries
const dictionaries = ref([])
const dictionariesLoading = ref(false)
const dictDialogVisible = ref(false)
const editingDict = ref(null)
const selectedDict = ref(null)
const dictForm = ref({
  name: '',
  displayName: '',
  values: []
})
const newValue = ref('')

// Columns
const columns = ref([])
const columnsLoading = ref(false)
const columnDialogVisible = ref(false)
const editingColumn = ref(null)
const selectedColumn = ref(null)
const columnForm = ref({
  name: '',
  displayName: '',
  fieldType: 'TEXT',
  dictionaryId: null,
  sortOrder: 0,
  isRequired: false
})

const fieldTypes = [
  { value: 'TEXT', label: 'Текст' },
  { value: 'SELECT', label: 'Выбор из списка' },
  { value: 'DATE', label: 'Дата' },
  { value: 'NUMBER', label: 'Число' }
]

async function fetchUsers() {
  usersLoading.value = true
  try {
    const response = await usersApi.getAll()
    users.value = response.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки пользователей')
  } finally {
    usersLoading.value = false
  }
}

async function fetchDictionaries() {
  dictionariesLoading.value = true
  try {
    const response = await dictionariesApi.getAll()
    dictionaries.value = response.data
  } catch (error) {
    ElMessage.error('Ошибка загрузки справочников')
  } finally {
    dictionariesLoading.value = false
  }
}

function handleSelectUser(row) {
  selectedUser.value = selectedUser.value?.id === row.id ? null : row
}

function openUserDialog(user = null) {
  editingUser.value = user
  if (user) {
    userForm.value = {
      username: user.username,
      password: '',
      role: user.role
    }
  } else {
    userForm.value = {
      username: '',
      password: '',
      role: 'USER'
    }
  }
  userDialogVisible.value = true
}

function openEditUserDialog() {
  if (!selectedUser.value) return
  openUserDialog(selectedUser.value)
}

async function saveUser() {
  try {
    if (editingUser.value) {
      await usersApi.update(editingUser.value.id, {
        password: userForm.value.password || null,
        role: userForm.value.role
      })
      ElMessage.success('Пользователь обновлен')
    } else {
      await usersApi.create(userForm.value)
      ElMessage.success('Пользователь создан')
    }
    userDialogVisible.value = false
    fetchUsers()
  } catch (error) {
    ElMessage.error('Ошибка сохранения')
  }
}

async function handleDeleteUser() {
  if (!selectedUser.value) return
  try {
    await ElMessageBox.confirm(
      `Удалить пользователя "${selectedUser.value.username}"?`,
      'Подтверждение',
      { type: 'warning' }
    )
    await usersApi.delete(selectedUser.value.id)
    ElMessage.success('Пользователь удален')
    selectedUser.value = null
    fetchUsers()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('Ошибка удаления')
    }
  }
}

function handleSelectDict(row) {
  selectedDict.value = selectedDict.value?.id === row.id ? null : row
}

function openDictDialog(dict = null) {
  editingDict.value = dict
  if (dict) {
    dictForm.value = {
      name: dict.name,
      displayName: dict.displayName,
      values: [...(dict.values || [])]
    }
  } else {
    dictForm.value = {
      name: '',
      displayName: '',
      values: []
    }
  }
  newValue.value = ''
  dictDialogVisible.value = true
}

function openEditDictDialog() {
  if (!selectedDict.value) return
  openDictDialog(selectedDict.value)
}

function addDictValue() {
  if (newValue.value.trim() && !dictForm.value.values.includes(newValue.value.trim())) {
    dictForm.value.values.push(newValue.value.trim())
    newValue.value = ''
  }
}

function removeDictValue(index) {
  dictForm.value.values.splice(index, 1)
}

async function saveDict() {
  try {
    if (editingDict.value) {
      await dictionariesApi.update(editingDict.value.id, dictForm.value)
      ElMessage.success('Справочник обновлен')
    } else {
      await dictionariesApi.create(dictForm.value)
      ElMessage.success('Справочник создан')
    }
    dictDialogVisible.value = false
    fetchDictionaries()
  } catch (error) {
    ElMessage.error('Ошибка сохранения')
  }
}

async function handleDeleteDict() {
  if (!selectedDict.value) return
  if (!authStore.isAdmin) {
    ElMessage.warning('Удаление доступно только администраторам')
    return
  }
  try {
    await ElMessageBox.confirm(
      `Удалить справочник "${selectedDict.value.displayName}"?`,
      'Подтверждение',
      { type: 'warning' }
    )
    await dictionariesApi.delete(selectedDict.value.id)
    ElMessage.success('Справочник удален')
    selectedDict.value = null
    fetchDictionaries()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('Ошибка удаления')
    }
  }
}

// Columns functions
async function fetchColumns() {
  columnsLoading.value = true
  try {
    const response = await columnsApi.getAll()
    columns.value = response.data.sort((a, b) => a.sortOrder - b.sortOrder)
  } catch (error) {
    ElMessage.error('Ошибка загрузки колонок')
  } finally {
    columnsLoading.value = false
  }
}

function handleSelectColumn(row) {
  selectedColumn.value = selectedColumn.value?.id === row.id ? null : row
}

function openColumnDialog(col = null) {
  editingColumn.value = col
  if (col) {
    columnForm.value = {
      name: col.name,
      displayName: col.displayName,
      fieldType: col.fieldType,
      dictionaryId: col.dictionaryId,
      sortOrder: col.sortOrder || 0,
      isRequired: col.isRequired || false
    }
  } else {
    columnForm.value = {
      name: '',
      displayName: '',
      fieldType: 'TEXT',
      dictionaryId: null,
      sortOrder: columns.value.length,
      isRequired: false
    }
  }
  columnDialogVisible.value = true
}

function openEditColumnDialog() {
  if (!selectedColumn.value) return
  openColumnDialog(selectedColumn.value)
}

async function saveColumn() {
  try {
    const data = { ...columnForm.value }
    if (data.fieldType !== 'SELECT') {
      data.dictionaryId = null
    }
    if (editingColumn.value) {
      await columnsApi.update(editingColumn.value.id, data)
      ElMessage.success('Колонка обновлена')
    } else {
      await columnsApi.create(data)
      ElMessage.success('Колонка создана')
    }
    columnDialogVisible.value = false
    fetchColumns()
  } catch (error) {
    ElMessage.error('Ошибка сохранения')
  }
}

async function handleDeleteColumn() {
  if (!selectedColumn.value) return
  if (!authStore.isAdmin) {
    ElMessage.warning('Удаление доступно только администраторам')
    return
  }
  try {
    await ElMessageBox.confirm(
      `Удалить колонку "${selectedColumn.value.displayName}"?`,
      'Подтверждение',
      { type: 'warning' }
    )
    await columnsApi.delete(selectedColumn.value.id)
    ElMessage.success('Колонка удалена')
    selectedColumn.value = null
    fetchColumns()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('Ошибка удаления')
    }
  }
}

function goBack() {
  router.push('/')
}

function handleLogout() {
  authStore.logout()
  router.push('/login')
}

// Сброс выделения при смене таба
watch(activeTab, () => {
  selectedUser.value = null
  selectedDict.value = null
  selectedColumn.value = null
})

onMounted(() => {
  fetchUsers()
  fetchDictionaries()
  fetchColumns()
})
</script>

<template>
  <div class="app-container">
    <!-- Floating Orbs Background -->
    <div class="bg-orbs">
      <div class="orb orb-1"></div>
      <div class="orb orb-2"></div>
      <div class="orb orb-3"></div>
    </div>

    <!-- Header -->
    <header class="app-header glass-card">
      <div class="header-left">
        <button class="back-btn" @click="goBack">
          <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
            <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/>
          </svg>
        </button>
        <div class="logo">
          <svg viewBox="0 0 48 48" class="logo-icon">
            <defs>
              <linearGradient id="headerLogoGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" style="stop-color:#7c3aed"/>
                <stop offset="100%" style="stop-color:#a78bfa"/>
              </linearGradient>
            </defs>
            <circle cx="24" cy="24" r="20" fill="url(#headerLogoGrad)"/>
            <circle cx="24" cy="24" r="7" fill="rgba(255,255,255,0.9)"/>
            <circle cx="24" cy="24" r="3" fill="url(#headerLogoGrad)"/>
          </svg>
          <span class="logo-text text-gradient">Настройки</span>
        </div>
      </div>
      <div class="header-right">
        <button class="theme-btn" @click="themeStore.toggle()">
          <svg v-if="themeStore.isDark" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 3a9 9 0 109 9c0-.46-.04-.92-.1-1.36a5.389 5.389 0 01-4.4 2.26 5.403 5.403 0 01-3.14-9.8c-.44-.06-.9-.1-1.36-.1z"/>
          </svg>
          <svg v-else viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1z"/>
          </svg>
        </button>
        <div class="user-badge glass-card">
          <svg viewBox="0 0 24 24" fill="currentColor" class="user-icon">
            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
          <span>{{ authStore.user?.username }}</span>
        </div>
        <el-button class="logout-btn" @click="handleLogout">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/>
          </svg>
          <span>Выйти</span>
        </el-button>
      </div>
    </header>

    <!-- Main Content -->
    <main class="app-main">
      <div class="page-header">
        <div class="page-title">
          <h1>Администрирование</h1>
          <p class="subtitle">Управление пользователями, колонками и справочниками</p>
        </div>
      </div>

      <!-- Tabs -->
      <el-tabs v-model="activeTab" class="admin-tabs">
        <!-- Users Tab -->
        <el-tab-pane label="Пользователи" name="users">
          <div class="tab-toolbar">
            <el-button type="primary" @click="openUserDialog()">
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
              </svg>
              <span>Добавить</span>
            </el-button>
            <el-button class="btn-edit" :disabled="!selectedUser" @click="openEditUserDialog">
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
              </svg>
              <span>Изменить</span>
            </el-button>
            <el-button class="btn-delete" :disabled="!selectedUser" @click="handleDeleteUser">
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
              </svg>
              <span>Удалить</span>
            </el-button>
          </div>

          <div class="table-card glass-card-strong">
            <el-table :data="users" v-loading="usersLoading" stripe highlight-current-row @row-click="handleSelectUser">
              <el-table-column width="50" align="center">
                <template #default="{ row }">
                  <div class="radio-cell" @click.stop="handleSelectUser(row)">
                    <span class="custom-radio" :class="{ 'is-checked': selectedUser?.id === row.id }">
                      <span class="radio-inner"></span>
                    </span>
                  </div>
                </template>
              </el-table-column>
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="username" label="Логин" width="200" />
              <el-table-column prop="role" label="Роль" width="150">
                <template #default="{ row }">
                  <el-tag :type="row.role === 'ADMIN' ? 'danger' : 'info'">
                    {{ row.role === 'ADMIN' ? 'Администратор' : 'Пользователь' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="createdAt" label="Создан">
                <template #default="{ row }">
                  {{ row.createdAt ? new Date(row.createdAt).toLocaleString('ru') : '—' }}
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>

        <!-- Columns Tab -->
        <el-tab-pane label="Колонки" name="columns">
          <div class="tab-toolbar">
            <el-button type="primary" @click="openColumnDialog()">
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
              </svg>
              <span>Добавить</span>
            </el-button>
            <el-button class="btn-edit" :disabled="!selectedColumn" @click="openEditColumnDialog">
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
              </svg>
              <span>Изменить</span>
            </el-button>
            <el-button
              v-if="authStore.isAdmin"
              class="btn-delete"
              :disabled="!selectedColumn"
              @click="handleDeleteColumn"
            >
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
              </svg>
              <span>Удалить</span>
            </el-button>
          </div>

          <div class="table-card glass-card-strong">
            <el-table :data="columns" v-loading="columnsLoading" stripe highlight-current-row @row-click="handleSelectColumn">
              <el-table-column width="50" align="center">
                <template #default="{ row }">
                  <div class="radio-cell" @click.stop="handleSelectColumn(row)">
                    <span class="custom-radio" :class="{ 'is-checked': selectedColumn?.id === row.id }">
                      <span class="radio-inner"></span>
                    </span>
                  </div>
                </template>
              </el-table-column>
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="name" label="Код" width="180" />
              <el-table-column prop="displayName" label="Название" width="200" />
              <el-table-column prop="fieldType" label="Тип" width="150">
                <template #default="{ row }">
                  <el-tag size="small">
                    {{ fieldTypes.find(t => t.value === row.fieldType)?.label || row.fieldType }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="Справочник" width="180">
                <template #default="{ row }">
                  <span v-if="row.dictionaryId">
                    {{ dictionaries.find(d => d.id === row.dictionaryId)?.displayName || '—' }}
                  </span>
                  <span v-else class="text-muted">—</span>
                </template>
              </el-table-column>
              <el-table-column prop="isRequired" label="Обязат." width="100" align="center">
                <template #default="{ row }">
                  <el-tag v-if="row.isRequired" type="warning" size="small">Да</el-tag>
                  <span v-else class="text-muted">—</span>
                </template>
              </el-table-column>
              <el-table-column prop="sortOrder" label="Порядок" width="100" />
            </el-table>
          </div>
        </el-tab-pane>

        <!-- Dictionaries Tab -->
        <el-tab-pane label="Справочники" name="dictionaries">
          <div class="tab-toolbar">
            <el-button type="primary" @click="openDictDialog()">
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
              </svg>
              <span>Добавить</span>
            </el-button>
            <el-button class="btn-edit" :disabled="!selectedDict" @click="openEditDictDialog">
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
              </svg>
              <span>Изменить</span>
            </el-button>
            <el-button
              v-if="authStore.isAdmin"
              class="btn-delete"
              :disabled="!selectedDict"
              @click="handleDeleteDict"
            >
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
              </svg>
              <span>Удалить</span>
            </el-button>
          </div>

          <div class="table-card glass-card-strong">
            <el-table :data="dictionaries" v-loading="dictionariesLoading" stripe highlight-current-row @row-click="handleSelectDict">
              <el-table-column width="50" align="center">
                <template #default="{ row }">
                  <div class="radio-cell" @click.stop="handleSelectDict(row)">
                    <span class="custom-radio" :class="{ 'is-checked': selectedDict?.id === row.id }">
                      <span class="radio-inner"></span>
                    </span>
                  </div>
                </template>
              </el-table-column>
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="name" label="Код" width="200" />
              <el-table-column prop="displayName" label="Название" width="200" />
              <el-table-column label="Значения">
                <template #default="{ row }">
                  <div class="dict-values">
                    <el-tag
                      v-for="(val, i) in (row.values || []).slice(0, 5)"
                      :key="i"
                      size="small"
                      class="dict-tag"
                    >
                      {{ val }}
                    </el-tag>
                    <span v-if="(row.values || []).length > 5" class="more-values">
                      +{{ row.values.length - 5 }}
                    </span>
                  </div>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>
      </el-tabs>
    </main>

    <!-- User Dialog -->
    <el-dialog
      v-model="userDialogVisible"
      :title="editingUser ? 'Редактирование пользователя' : 'Новый пользователь'"
      width="480px"
      class="admin-dialog"
    >
      <el-form :model="userForm" label-position="top">
        <el-form-item label="Логин" :required="!editingUser">
          <el-input
            v-model="userForm.username"
            :disabled="!!editingUser"
            placeholder="Введите логин"
          />
        </el-form-item>
        <el-form-item :label="editingUser ? 'Новый пароль' : 'Пароль'" :required="!editingUser">
          <el-input
            v-model="userForm.password"
            type="password"
            :placeholder="editingUser ? 'Оставьте пустым, чтобы не менять' : 'Введите пароль'"
            show-password
          />
        </el-form-item>
        <el-form-item label="Роль">
          <el-select v-model="userForm.role" style="width: 100%">
            <el-option label="Пользователь (чтение)" value="USER" />
            <el-option label="Администратор (полный доступ)" value="ADMIN" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="userDialogVisible = false">Отмена</el-button>
        <el-button type="primary" @click="saveUser">Сохранить</el-button>
      </template>
    </el-dialog>

    <!-- Dictionary Dialog -->
    <el-dialog
      v-model="dictDialogVisible"
      :title="editingDict ? 'Редактирование справочника' : 'Новый справочник'"
      width="560px"
      class="admin-dialog"
    >
      <el-form :model="dictForm" label-position="top">
        <el-form-item label="Код (системное имя)" required>
          <el-input
            v-model="dictForm.name"
            :disabled="!!editingDict"
            placeholder="например: status"
          />
        </el-form-item>
        <el-form-item label="Название" required>
          <el-input
            v-model="dictForm.displayName"
            placeholder="например: Статус сотрудника"
          />
        </el-form-item>
        <el-form-item label="Значения">
          <div class="dict-values-edit">
            <div class="add-value-row">
              <el-input
                v-model="newValue"
                placeholder="Новое значение"
                @keyup.enter="addDictValue"
              />
              <el-button @click="addDictValue">Добавить</el-button>
            </div>
            <div class="values-list">
              <el-tag
                v-for="(val, index) in dictForm.values"
                :key="index"
                closable
                @close="removeDictValue(index)"
                class="value-tag"
              >
                {{ val }}
              </el-tag>
            </div>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dictDialogVisible = false">Отмена</el-button>
        <el-button type="primary" @click="saveDict">Сохранить</el-button>
      </template>
    </el-dialog>

    <!-- Column Dialog -->
    <el-dialog
      v-model="columnDialogVisible"
      :title="editingColumn ? 'Редактирование колонки' : 'Новая колонка'"
      width="520px"
      class="admin-dialog"
    >
      <el-form :model="columnForm" label-position="top">
        <el-form-item label="Код (системное имя)" required>
          <el-input
            v-model="columnForm.name"
            :disabled="!!editingColumn"
            placeholder="например: department"
          />
        </el-form-item>
        <el-form-item label="Название" required>
          <el-input
            v-model="columnForm.displayName"
            placeholder="например: Отдел"
          />
        </el-form-item>
        <el-form-item label="Тип поля" required>
          <el-select v-model="columnForm.fieldType" style="width: 100%">
            <el-option
              v-for="type in fieldTypes"
              :key="type.value"
              :label="type.label"
              :value="type.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item v-if="columnForm.fieldType === 'SELECT'" label="Справочник" required>
          <el-select v-model="columnForm.dictionaryId" style="width: 100%" placeholder="Выберите справочник">
            <el-option
              v-for="dict in dictionaries"
              :key="dict.id"
              :label="dict.displayName"
              :value="dict.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="Порядок сортировки">
          <el-input-number v-model="columnForm.sortOrder" :min="0" style="width: 100%" />
        </el-form-item>
        <el-form-item>
          <el-checkbox v-model="columnForm.isRequired">Обязательное поле</el-checkbox>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="columnDialogVisible = false">Отмена</el-button>
        <el-button type="primary" @click="saveColumn">Сохранить</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.app-container {
  min-height: 100vh;
  position: relative;
}

.bg-orbs {
  position: fixed;
  inset: 0;
  overflow: hidden;
  pointer-events: none;
  z-index: 0;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.4;
  animation: float 12s ease-in-out infinite;
}

.orb-1 {
  width: 500px;
  height: 500px;
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
  top: -150px;
  right: -100px;
}

.orb-2 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #06b6d4 0%, #22d3ee 100%);
  bottom: -100px;
  left: -100px;
  animation-delay: -4s;
}

.orb-3 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #ec4899 0%, #f472b6 100%);
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  animation-delay: -8s;
}

.app-header {
  position: sticky;
  top: 16px;
  margin: 16px 24px 0;
  padding: 16px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  z-index: 100;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.back-btn {
  width: 42px;
  height: 42px;
  border-radius: var(--radius-md);
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-primary);
  transition: var(--transition);
}

.back-btn:hover {
  background: var(--bg-glass-strong);
  border-color: var(--accent);
}

.logo {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  width: 42px;
  height: 42px;
  filter: drop-shadow(0 4px 12px rgba(124, 58, 237, 0.3));
}

.logo-text {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: -0.5px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.theme-btn {
  width: 42px;
  height: 42px;
  border-radius: var(--radius-md);
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-primary);
  transition: var(--transition);
}

.theme-btn:hover {
  background: var(--bg-glass-strong);
  border-color: var(--accent);
  transform: scale(1.05);
}

.theme-btn svg {
  width: 20px;
  height: 20px;
}

.user-badge {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  color: var(--text-primary);
  font-size: 14px;
  font-weight: 500;
}

.user-icon {
  width: 20px;
  height: 20px;
  color: var(--accent);
}

.logout-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-glass) !important;
  color: var(--text-primary) !important;
}

.logout-btn:hover {
  background: rgba(239, 68, 68, 0.1) !important;
  border-color: var(--danger) !important;
  color: var(--danger) !important;
}

.app-main {
  padding: 32px 24px;
  max-width: 1400px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

.page-header {
  margin-bottom: 28px;
}

.page-title h1 {
  margin: 0 0 6px 0;
  font-size: 32px;
  font-weight: 800;
  color: var(--text-primary);
  letter-spacing: -0.5px;
}

.subtitle {
  margin: 0;
  color: var(--text-secondary);
  font-size: 15px;
}

.admin-tabs {
  background: var(--bg-glass);
  border-radius: var(--radius-lg);
  padding: 20px;
  border: 1px solid var(--border-glass);
}

.tab-toolbar {
  margin-bottom: 20px;
  display: flex;
  gap: 12px;
}

.table-card {
  overflow: hidden;
}

.dict-values {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  align-items: center;
}

.dict-tag {
  margin: 0 !important;
}

.more-values {
  color: var(--text-muted);
  font-size: 12px;
  margin-left: 4px;
}

/* Buttons */
.btn-edit {
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--bg-glass) !important;
  border: 1px solid var(--accent) !important;
  color: var(--accent) !important;
}

.btn-edit:hover:not(:disabled) {
  background: var(--accent) !important;
  color: white !important;
}

.btn-edit:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-delete {
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--bg-glass) !important;
  border: 1px solid var(--danger) !important;
  color: var(--danger) !important;
}

.btn-delete:hover:not(:disabled) {
  background: var(--danger) !important;
  color: white !important;
}

.btn-delete:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Radio */
.radio-cell {
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
}

.custom-radio {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 2px solid var(--border-glass-strong);
  background: var(--bg-glass);
  transition: var(--transition);
}

.custom-radio:hover {
  border-color: var(--accent);
}

.custom-radio.is-checked {
  border-color: var(--accent);
  background: var(--accent);
}

.radio-inner {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: transparent;
  transition: var(--transition);
}

.custom-radio.is-checked .radio-inner {
  background: white;
}

/* Selected row */
:deep(.el-table__body tr.current-row > td) {
  background: var(--bg-glass-strong) !important;
}

.text-muted {
  color: var(--text-muted);
}

.dict-values-edit {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.add-value-row {
  display: flex;
  gap: 8px;
}

.values-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  min-height: 40px;
  padding: 12px;
  background: var(--bg-glass);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-glass);
}

.value-tag {
  margin: 0 !important;
}

@media (max-width: 768px) {
  .app-header {
    margin: 12px 16px 0;
    padding: 12px 16px;
    flex-wrap: wrap;
    gap: 12px;
  }

  .app-main {
    padding: 24px 16px;
  }

  .page-title h1 {
    font-size: 24px;
  }
}
</style>
