# UI улучшения: Таблица заявок — убрать кнопку, ширина колонок, пагинация

## Требования (по скриншоту)

1. **Убрать кнопку "Открыть"** — заявка открывается по клику на строку (уже работает)
2. **ФИО сотрудника** — расширить колонку для полного отображения
3. **Целевая должность** — сузить колонку
4. **Процент изменения ЗП** — показывать ПОД суммой, а не рядом
5. **Добавить пагинацию** — 10 строк на странице

---

## Решение

### Файл: `frontend/src/views/ApplicationsView.vue`

#### 1. Убрать колонку с кнопкой "Открыть"

**Удалить эту колонку полностью:**
```vue
<!-- УДАЛИТЬ -->
<el-table-column label="Действия" width="100" fixed="right">
  <template #default="{ row }">
    <el-button ...>Открыть</el-button>
  </template>
</el-table-column>
```

Клик по строке уже работает через `@row-click="handleRowClick"`.

#### 2. Изменить ширину колонок

```vue
<el-table-column prop="id" label="ID" width="70" />

<el-table-column label="Сотрудник" min-width="220">
  <template #default="{ row }">
    {{ getEmployeeName(row) }}
  </template>
</el-table-column>

<el-table-column label="Тип" width="100">
  <template #default="{ row }">
    <el-tag :type="row.applicationType === 'DEVELOPMENT' ? 'success' : 'warning'" size="small">
      {{ row.applicationType === 'DEVELOPMENT' ? 'Развитие' : 'Ротация' }}
    </el-tag>
  </template>
</el-table-column>

<el-table-column prop="targetPosition" label="Целевая должность" width="180" show-overflow-tooltip />

<el-table-column label="ЗП" width="160">
  <template #default="{ row }">
    <div v-if="row.currentSalary && row.targetSalary" class="salary-cell">
      <div class="salary-change">
        {{ formatSalary(row.currentSalary) }} → {{ formatSalary(row.targetSalary) }}
      </div>
      <el-tag :type="getSalaryChangeType(row)" size="small" class="salary-percent">
        {{ getSalaryChangePercent(row) }}%
      </el-tag>
    </div>
    <span v-else>-</span>
  </template>
</el-table-column>

<el-table-column label="Статус" width="180">
  <template #default="{ row }">
    <ApplicationStatusBadge :status="row.status" />
  </template>
</el-table-column>

<el-table-column label="Создано" width="120">
  <template #default="{ row }">
    {{ formatDate(row.createdAt) }}
  </template>
</el-table-column>
```

#### 3. Стили для ЗП (процент под суммой)

Добавить в `<style scoped>`:

```css
.salary-cell {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 4px;
}

.salary-change {
  font-size: 13px;
  color: var(--text-primary);
  white-space: nowrap;
}

.salary-percent {
  font-size: 11px;
}
```

#### 4. Добавить пагинацию

**Добавить переменные:**

```javascript
const pagination = ref({
  page: 1,
  pageSize: 10,
  total: 0
})
```

**Изменить loadApplications:**

```javascript
async function loadApplications() {
  try {
    const params = {
      page: pagination.value.page - 1,  // Backend использует 0-based
      size: pagination.value.pageSize
    }
    
    if (statusFilter.value) {
      params.status = statusFilter.value
    }

    let response
    switch (activeList.value) {
      case 'my':
        response = await applicationsStore.fetchMy(params)
        break
      case 'assigned':
        response = await applicationsStore.fetchAssigned(params)
        break
      case 'pending':
        response = await applicationsStore.fetchPendingApproval(params)
        break
      default:
        response = await applicationsStore.fetchAll(params)
    }
    
    // Обновить total из ответа
    if (response?.totalElements !== undefined) {
      pagination.value.total = response.totalElements
    }
  } catch (error) {
    ElMessage.error('Ошибка загрузки заявок')
  }
}
```

**Добавить обработчики пагинации:**

```javascript
function handlePageChange(page) {
  pagination.value.page = page
  loadApplications()
}

function handleSizeChange(size) {
  pagination.value.pageSize = size
  pagination.value.page = 1
  loadApplications()
}
```

**Добавить компонент пагинации после таблицы:**

```vue
<!-- После </el-table> внутри table-card -->
<div class="pagination-wrapper">
  <el-pagination
    v-model:current-page="pagination.page"
    v-model:page-size="pagination.pageSize"
    :page-sizes="[10, 20, 50]"
    :total="pagination.total"
    layout="total, sizes, prev, pager, next"
    @size-change="handleSizeChange"
    @current-change="handlePageChange"
  />
</div>
```

**Стили для пагинации:**

```css
.pagination-wrapper {
  padding: 16px 20px;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid var(--border-glass);
}

:deep(.el-pagination) {
  --el-pagination-bg-color: transparent;
  --el-pagination-button-bg-color: var(--bg-glass);
  --el-pagination-hover-color: var(--accent);
}

:deep(.el-pagination .el-pager li) {
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  border-radius: 6px;
  margin: 0 2px;
}

:deep(.el-pagination .el-pager li.is-active) {
  background: var(--accent);
  border-color: var(--accent);
}

:deep(.el-pagination button) {
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-glass);
  border-radius: 6px;
}

:deep(.el-pagination .el-select .el-input__wrapper) {
  background: var(--bg-glass);
  border: 1px solid var(--border-glass);
  box-shadow: none;
}
```

#### 5. Стиль курсора для строк таблицы

```css
:deep(.el-table__row) {
  cursor: pointer;
  transition: background-color 0.2s ease;
}

:deep(.el-table__row:hover) {
  background-color: rgba(124, 58, 237, 0.1) !important;
}
```

---

## Полный итоговый код таблицы

```vue
<!-- Таблица заявок -->
<div class="table-card glass-card-strong">
  <el-table
    :data="applicationsStore.applications"
    :loading="applicationsStore.loading"
    class="data-table"
    @row-click="handleRowClick"
  >
    <el-table-column prop="id" label="ID" width="70" />

    <el-table-column label="Сотрудник" min-width="220">
      <template #default="{ row }">
        {{ getEmployeeName(row) }}
      </template>
    </el-table-column>

    <el-table-column label="Тип" width="100">
      <template #default="{ row }">
        <el-tag :type="row.applicationType === 'DEVELOPMENT' ? 'success' : 'warning'" size="small">
          {{ row.applicationType === 'DEVELOPMENT' ? 'Развитие' : 'Ротация' }}
        </el-tag>
      </template>
    </el-table-column>

    <el-table-column prop="targetPosition" label="Целевая должность" width="180" show-overflow-tooltip />

    <el-table-column label="ЗП" width="160">
      <template #default="{ row }">
        <div v-if="row.currentSalary && row.targetSalary" class="salary-cell">
          <div class="salary-change">
            {{ formatSalary(row.currentSalary) }} → {{ formatSalary(row.targetSalary) }}
          </div>
          <el-tag :type="getSalaryChangeType(row)" size="small" class="salary-percent">
            {{ getSalaryChangePercent(row) }}%
          </el-tag>
        </div>
        <span v-else>-</span>
      </template>
    </el-table-column>

    <el-table-column label="Статус" width="180">
      <template #default="{ row }">
        <ApplicationStatusBadge :status="row.status" />
      </template>
    </el-table-column>

    <el-table-column label="Создано" width="120">
      <template #default="{ row }">
        {{ formatDate(row.createdAt) }}
      </template>
    </el-table-column>
  </el-table>

  <div class="pagination-wrapper">
    <el-pagination
      v-model:current-page="pagination.page"
      v-model:page-size="pagination.pageSize"
      :page-sizes="[10, 20, 50]"
      :total="pagination.total"
      layout="total, sizes, prev, pager, next"
      @size-change="handleSizeChange"
      @current-change="handlePageChange"
    />
  </div>
</div>
```

---

## Файлы для изменения

| Файл | Изменения |
|------|-----------|
| `frontend/src/views/ApplicationsView.vue` | Убрать колонку "Действия", изменить ширину колонок, стили ЗП, добавить пагинацию |

---

## Тестирование

1. Пересобрать frontend: `docker-compose build frontend`
2. Перезапустить: `docker-compose up -d frontend`
3. Проверить:
   - Нет кнопки "Открыть"
   - Клик по строке открывает заявку
   - ФИО показывается полностью
   - Процент ЗП под суммой
   - Пагинация работает (10 строк на странице)
