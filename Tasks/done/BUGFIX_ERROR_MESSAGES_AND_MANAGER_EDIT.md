# Улучшения UX: Понятные сообщения об ошибках и редактирование заявок менеджером

## Проблемы

### 1. Непонятные сообщения об ошибках

При ошибке 400 (например, "Employee already has an active application") пользователь видит только технический текст. Нужно показывать понятные сообщения на русском языке.

**Текущее поведение:**
- Ошибка 400: `Employee already has an active application`
- Пользователь не понимает что делать

**Ожидаемое поведение:**
- Понятное сообщение: `Сотрудник уже имеет активную заявку. Дождитесь завершения текущей заявки или отмените её.`

### 2. Менеджер не может редактировать созданную заявку

Менеджер создал заявку, но не может её отредактировать — только отменить. Нужно дать возможность редактирования в статусах DRAFT и AVAILABLE_FOR_REVIEW.

---

## Решение

### Часть 1: Локализация ошибок на backend

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/ApplicationService.java`

Заменить английские сообщения на русские:

```java
// В методе create()
if (applicationRepository.findByEmployeeIdAndStatusNotIn(employee.getId(), finalStatuses).isPresent()) {
    throw new BusinessException("Сотрудник уже имеет активную заявку. Дождитесь завершения текущей заявки или отмените её.");
}

// Проверка черного списка уже на русском - ОК
if (blacklistService.isEmployeeInBlacklist(request.getEmployeeId(), currentUser.getDzo().getId())) {
    throw new BusinessException("Сотрудник находится в чёрном списке. Создание заявки невозможно.");
}
```

```java
// В методе update()
if (application.getStatus() != ApplicationStatus.DRAFT &&
    application.getStatus() != ApplicationStatus.AVAILABLE_FOR_REVIEW) {
    throw new BusinessException("Редактирование заявки невозможно в статусе: " + application.getStatus().getDisplayName());
}
```

```java
// В методе delete()
if (application.getStatus() != ApplicationStatus.DRAFT) {
    throw new BusinessException("Удалить можно только черновик заявки");
}
```

### Часть 2: Разрешить менеджеру редактировать заявку

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/ApplicationService.java`

В методе `update()` изменить проверку прав:

**Было:**
```java
// Проверка прав: создатель или рекрутер
if (!application.getCreatedBy().getId().equals(currentUser.getId()) &&
    (application.getRecruiter() == null || !application.getRecruiter().getId().equals(currentUser.getId()))) {
    throw new AccessDeniedException("No permission to update this application");
}
```

**Стало:**
```java
// Проверка прав: создатель, рекрутер или менеджер из того же ДЗО
boolean isCreator = application.getCreatedBy().getId().equals(currentUser.getId());
boolean isRecruiter = application.getRecruiter() != null && 
    application.getRecruiter().getId().equals(currentUser.getId());
boolean isManagerSameDzo = currentUser.hasRole(Role.MANAGER) && 
    application.getDzo().getId().equals(currentUser.getDzo().getId());
boolean isAdmin = currentUser.hasRole(Role.DZO_ADMIN) || currentUser.hasRole(Role.SYSTEM_ADMIN);

if (!isCreator && !isRecruiter && !isManagerSameDzo && !isAdmin) {
    throw new AccessDeniedException("Нет прав для редактирования этой заявки");
}
```

### Часть 3: Улучшить отображение ошибок на frontend

**Файл:** `frontend/src/views/ApplicationsView.vue`

В методе `handleCreateApplication`:

```javascript
async function handleCreateApplication(data) {
  try {
    formLoading.value = true
    await applicationsStore.create(data)
    ElMessage.success('Заявка успешно создана')
    createDialogVisible.value = false
    await loadApplications()
  } catch (error) {
    // Показываем понятное сообщение от сервера
    const message = error.response?.data?.message || error.message || 'Ошибка создания заявки'
    ElMessage.error({
      message: message,
      duration: 5000,
      showClose: true
    })
  } finally {
    formLoading.value = false
  }
}
```

**Файл:** `frontend/src/stores/applications.js`

В методе `create`:

```javascript
async function create(data) {
  loading.value = true
  error.value = null
  try {
    const response = await applicationsApi.create(data)
    applications.value.unshift(response.data)
    return response.data
  } catch (e) {
    // Сохраняем сообщение от сервера
    error.value = e.response?.data?.message || e.message
    throw e  // Пробрасываем для обработки в компоненте
  } finally {
    loading.value = false
  }
}
```

### Часть 4: Добавить кнопку редактирования в таблицу заявок

**Файл:** `frontend/src/views/ApplicationsView.vue`

В таблице заменить колонку "Действия":

```vue
<el-table-column label="Действия" width="150" fixed="right">
  <template #default="{ row }">
    <el-button
      link
      type="primary"
      @click.stop="viewApplication(row.id)"
    >
      Открыть
    </el-button>
    <el-button
      v-if="canEdit(row)"
      link
      type="warning"
      @click.stop="editApplication(row)"
    >
      Изменить
    </el-button>
  </template>
</el-table-column>
```

Добавить функции:

```javascript
function canEdit(application) {
  // Можно редактировать только в начальных статусах
  const editableStatuses = ['DRAFT', 'AVAILABLE_FOR_REVIEW']
  return editableStatuses.includes(application.status)
}

function editApplication(application) {
  editingApplication.value = application
  createDialogVisible.value = true
}
```

Добавить реактивную переменную:

```javascript
const editingApplication = ref(null)
```

Изменить диалог:

```vue
<el-dialog
  v-model="createDialogVisible"
  :title="editingApplication ? 'Редактировать заявку' : 'Создать заявку'"
  width="700px"
  class="create-dialog"
  @close="editingApplication = null"
>
  <ApplicationForm
    :application="editingApplication"
    :loading="formLoading"
    @submit="handleSaveApplication"
    @cancel="createDialogVisible = false; editingApplication = null"
  />
</el-dialog>
```

Изменить обработчик:

```javascript
async function handleSaveApplication(data) {
  try {
    formLoading.value = true
    
    if (editingApplication.value) {
      // Редактирование
      await applicationsStore.update(editingApplication.value.id, data)
      ElMessage.success('Заявка обновлена')
    } else {
      // Создание
      await applicationsStore.create(data)
      ElMessage.success('Заявка создана')
    }
    
    createDialogVisible.value = false
    editingApplication.value = null
    await loadApplications()
  } catch (error) {
    const message = error.response?.data?.message || error.message || 'Ошибка сохранения заявки'
    ElMessage.error({
      message: message,
      duration: 5000,
      showClose: true
    })
  } finally {
    formLoading.value = false
  }
}
```

---

## Список всех ошибок для локализации

В `ApplicationService.java` заменить:

| Было (английский) | Стало (русский) |
|-------------------|-----------------|
| `Only MANAGER or HR_BP can create applications` | `Только Руководитель или HR BP могут создавать заявки` |
| `Employee not found` | `Сотрудник не найден` |
| `Employee already has an active application` | `Сотрудник уже имеет активную заявку. Дождитесь завершения текущей или отмените её.` |
| `Cannot update application in status: X` | `Редактирование невозможно в статусе: X` |
| `No permission to update this application` | `Нет прав для редактирования этой заявки` |
| `Can only delete DRAFT applications` | `Удалить можно только черновик заявки` |
| `No permission to delete this application` | `Нет прав для удаления этой заявки` |
| `Application not found` | `Заявка не найдена` |
| `HR BP not found` | `HR BP не найден` |
| `User is not HR BP` | `Пользователь не является HR BP` |
| `BORUP not found` | `БОРУП не найден` |
| `User is not BORUP` | `Пользователь не является БОРУП` |
| `No access to this DZO` | `Нет доступа к этому ДЗО` |

---

## Тестирование

1. Пересобрать: `docker-compose build`
2. Перезапустить: `docker-compose up -d`
3. Войти под менеджером
4. Попробовать создать заявку на сотрудника с активной заявкой — должно показать понятное сообщение
5. Создать заявку, затем попробовать её отредактировать — должна быть кнопка "Изменить"
6. Проверить что после редактирования данные сохраняются

---

## Файлы для изменения

| Файл | Изменения |
|------|-----------|
| `backend/.../service/ApplicationService.java` | Локализация ошибок + права редактирования для менеджера |
| `frontend/src/views/ApplicationsView.vue` | Кнопка редактирования + улучшенный показ ошибок |
| `frontend/src/stores/applications.js` | Передача сообщения ошибки от сервера |
