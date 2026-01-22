# Исправления UI заявок: редактирование, отображение данных, ошибки API

## Проблемы (по скриншотам)

### 1. Детальная страница заявки (ApplicationDetailView)
- Сотрудник показывает "-" (не отображается имя)
- Email сотрудника "-"
- Предлагаемая ЗП "-" (хотя данные есть)
- Автор заявки "-"
- **Нужно:** возможность редактировать поля прямо на этой странице и сохранять

### 2. Таблица заявок (ApplicationsView)
- Сотрудник показывает "ID: 524" вместо имени
- Целевое подразделение — колонка есть, но данные не отображаются
- **Убрать** отдельную кнопку "Изменить" из списка
- Поправить дизайн кнопок действий

### 3. Ошибки API
- "Ошибка загрузки заявок" при нажатии на "Назначенные мне"
- "Ошибка загрузки заявок" при нажатии на "Требуют согласования"

---

## Решения

### Часть 1: Исправить ошибки API на backend

**Проблема:** Эндпоинты `/applications/assigned` и `/applications/pending-approval` возвращают ошибку.

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/ApplicationController.java`

Проверить что эндпоинты существуют:

```java
@GetMapping("/assigned")
public ResponseEntity<Page<ApplicationDto>> getAssigned(Pageable pageable) {
    return ResponseEntity.ok(applicationService.getAssignedToMe(pageable));
}

@GetMapping("/pending-approval")
public ResponseEntity<Page<ApplicationDto>> getPendingApproval(Pageable pageable) {
    return ResponseEntity.ok(applicationService.getPendingMyApproval(pageable));
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/ApplicationService.java`

Проверить метод `getAssignedToMe` — он ищет по `recruiterId`, но у менеджера нет назначенных заявок как рекрутеру. Нужно изменить логику:

```java
public Page<ApplicationDto> getAssignedToMe(Pageable pageable) {
    User currentUser = currentUserService.getCurrentUser();
    
    // Для рекрутера — заявки где он назначен рекрутером
    if (currentUser.hasRole(Role.RECRUITER)) {
        return applicationRepository.findByRecruiterId(currentUser.getId(), pageable)
            .map(this::toDto);
    }
    
    // Для HR BP — заявки где он назначен HR BP
    if (currentUser.hasRole(Role.HR_BP)) {
        return applicationRepository.findByHrBpId(currentUser.getId(), pageable)
            .map(this::toDto);
    }
    
    // Для BORUP — заявки где он назначен BORUP
    if (currentUser.hasRole(Role.BORUP)) {
        return applicationRepository.findByBorupId(currentUser.getId(), pageable)
            .map(this::toDto);
    }
    
    // Для остальных — пустой список
    return Page.empty(pageable);
}
```

**Добавить в ApplicationRepository.java:**

```java
Page<Application> findByHrBpId(Long hrBpId, Pageable pageable);
Page<Application> findByBorupId(Long borupId, Pageable pageable);
```

---

### Часть 2: Исправить отображение сотрудника в таблице

**Файл:** `frontend/src/views/ApplicationsView.vue`

**Проблема:** Показывает "ID: 524" вместо имени.

**Причина:** Backend возвращает `employeeName` в DTO, но frontend ищет `employee.fullName`.

Исправить функцию:

```javascript
function getEmployeeName(application) {
  // Backend возвращает employeeName напрямую в DTO
  if (application.employeeName) {
    return application.employeeName
  }
  // Fallback
  if (application.employee?.fullName) {
    return application.employee.fullName
  }
  return `ID: ${application.employeeId}`
}
```

---

### Часть 3: Убрать кнопку "Изменить" из списка

**Файл:** `frontend/src/views/ApplicationsView.vue`

Заменить колонку действий — оставить только "Открыть":

```vue
<el-table-column label="Действия" width="100" fixed="right">
  <template #default="{ row }">
    <el-button
      type="primary"
      size="small"
      @click.stop="viewApplication(row.id)"
    >
      Открыть
    </el-button>
  </template>
</el-table-column>
```

Удалить:
- `editingApplication` ref
- функцию `canEdit()`
- функцию `editApplication()`
- кнопку "Изменить" из template

---

### Часть 4: Добавить редактирование на странице детальной заявки

**Файл:** `frontend/src/views/ApplicationDetailView.vue`

Нужно добавить режим редактирования прямо на странице детальной заявки.

**Добавить переменные:**

```javascript
const isEditing = ref(false)
const editForm = reactive({
  targetPosition: '',
  targetStack: '',
  currentSalary: 0,
  targetSalary: 0,
  comment: ''
})
```

**Добавить функции:**

```javascript
function startEdit() {
  if (!canEdit.value) return
  
  editForm.targetPosition = application.value.targetPosition || ''
  editForm.targetStack = application.value.targetStack || ''
  editForm.currentSalary = application.value.currentSalary || 0
  editForm.targetSalary = application.value.targetSalary || 0
  editForm.comment = application.value.comment || ''
  
  isEditing.value = true
}

function cancelEdit() {
  isEditing.value = false
}

async function saveEdit() {
  try {
    await applicationsStore.update(application.value.id, {
      targetPosition: editForm.targetPosition,
      targetStack: editForm.targetStack,
      currentSalary: editForm.currentSalary,
      targetSalary: editForm.targetSalary,
      comment: editForm.comment
    })
    ElMessage.success('Заявка обновлена')
    isEditing.value = false
    await loadApplication()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || 'Ошибка сохранения')
  }
}

const canEdit = computed(() => {
  const editableStatuses = ['DRAFT', 'AVAILABLE_FOR_REVIEW']
  return editableStatuses.includes(application.value?.status)
})
```

**Изменить template — добавить режим редактирования:**

Вместо статичного отображения полей сделать переключаемый режим:

```vue
<!-- Кнопка редактирования в шапке -->
<div class="card-header">
  <span>Основная информация</span>
  <div class="header-actions">
    <el-tag :type="statusType">{{ application.statusDisplayName }}</el-tag>
    <el-button 
      v-if="canEdit && !isEditing" 
      type="primary" 
      size="small"
      @click="startEdit"
    >
      Редактировать
    </el-button>
    <template v-if="isEditing">
      <el-button type="success" size="small" @click="saveEdit">Сохранить</el-button>
      <el-button size="small" @click="cancelEdit">Отмена</el-button>
    </template>
  </div>
</div>

<!-- Поля с возможностью редактирования -->
<div class="info-row">
  <div class="info-label">Целевая должность</div>
  <div class="info-value">
    <template v-if="isEditing">
      <el-input v-model="editForm.targetPosition" />
    </template>
    <template v-else>
      {{ application.targetPosition || '-' }}
    </template>
  </div>
</div>

<div class="info-row">
  <div class="info-label">Целевой стек</div>
  <div class="info-value">
    <template v-if="isEditing">
      <el-input v-model="editForm.targetStack" />
    </template>
    <template v-else>
      {{ application.targetStack || '-' }}
    </template>
  </div>
</div>

<div class="info-row">
  <div class="info-label">Текущая ЗП</div>
  <div class="info-value">
    <template v-if="isEditing">
      <el-input-number v-model="editForm.currentSalary" :min="0" :step="10000" />
    </template>
    <template v-else>
      {{ application.currentSalary ? formatSalary(application.currentSalary) + ' ₽' : '-' }}
    </template>
  </div>
</div>

<div class="info-row">
  <div class="info-label">Целевая ЗП</div>
  <div class="info-value">
    <template v-if="isEditing">
      <el-input-number v-model="editForm.targetSalary" :min="0" :step="10000" />
    </template>
    <template v-else>
      {{ application.targetSalary ? formatSalary(application.targetSalary) + ' ₽' : '-' }}
    </template>
  </div>
</div>

<div class="info-row">
  <div class="info-label">Комментарий</div>
  <div class="info-value">
    <template v-if="isEditing">
      <el-input v-model="editForm.comment" type="textarea" :rows="3" />
    </template>
    <template v-else>
      {{ application.comment || '-' }}
    </template>
  </div>
</div>
```

---

### Часть 5: Исправить отображение данных на детальной странице

**Проблема:** Сотрудник, Email, Автор показывают "-"

**Причина:** Backend возвращает поля `employeeName`, `employeeEmail`, `createdByName`, но frontend может искать их по другому пути.

**Файл:** `frontend/src/views/ApplicationDetailView.vue`

Проверить и исправить отображение:

```vue
<div class="info-row">
  <div class="info-label">Сотрудник</div>
  <div class="info-value">{{ application.employeeName || '-' }}</div>
</div>

<div class="info-row">
  <div class="info-label">Email сотрудника</div>
  <div class="info-value">{{ application.employeeEmail || '-' }}</div>
</div>

<div class="info-row">
  <div class="info-label">Автор заявки</div>
  <div class="info-value">{{ application.createdByName || '-' }}</div>
</div>
```

---

### Часть 6: Поправить дизайн кнопок

**Файл:** `frontend/src/views/ApplicationsView.vue`

Стилизовать кнопку "Открыть":

```vue
<el-table-column label="" width="120" fixed="right">
  <template #default="{ row }">
    <el-button
      type="primary"
      size="small"
      round
      @click.stop="viewApplication(row.id)"
    >
      Открыть
    </el-button>
  </template>
</el-table-column>
```

Добавить стили:

```css
:deep(.el-table .el-button--primary) {
  background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);
  border: none;
  font-weight: 500;
}

:deep(.el-table .el-button--primary:hover) {
  background: linear-gradient(135deg, #6d28d9 0%, #8b5cf6 100%);
  transform: translateY(-1px);
}
```

---

### Часть 7: Убрать колонку "Целевое подразделение"

**Причина:** Поля `targetDepartment` нет в backend entity Application. Колонку нужно убрать.

**Файл:** `frontend/src/views/ApplicationsView.vue`

Удалить из таблицы:
```vue
<!-- УДАЛИТЬ ЭТУ КОЛОНКУ -->
<el-table-column prop="targetDepartment" label="Целевое подразделение" min-width="180" />
```

---

## Итоговый список файлов для изменения

| Файл | Изменения |
|------|-----------|
| `backend/.../repository/ApplicationRepository.java` | Добавить `findByHrBpId`, `findByBorupId` |
| `backend/.../service/ApplicationService.java` | Исправить `getAssignedToMe()` для разных ролей |
| `frontend/src/views/ApplicationsView.vue` | Убрать кнопку "Изменить", убрать колонку "Целевое подразделение", исправить `getEmployeeName()`, стили кнопок |
| `frontend/src/views/ApplicationDetailView.vue` | Добавить режим редактирования полей, исправить отображение employeeName/employeeEmail/createdByName |

---

## Тестирование

1. Пересобрать: `docker-compose build`
2. Перезапустить: `docker-compose up -d`
3. Войти под менеджером
4. Проверить вкладки "Назначенные мне" и "Требуют согласования" — не должно быть ошибки
5. Открыть заявку — должны отображаться все данные (сотрудник, email, автор)
6. На странице заявки нажать "Редактировать" — поля должны стать редактируемыми
7. Изменить данные и нажать "Сохранить" — изменения должны сохраниться
8. В списке заявок — только кнопка "Открыть", без "Изменить"
