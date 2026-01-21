# Фаза 5: Заявки — Frontend ✅ ЗАВЕРШЕНО

## Статус: ✅ Завершено
**Дата завершения:** 2026-01-21

---

## Цель

Реализовать frontend-часть модуля заявок: список заявок, создание/редактирование, карточка заявки с workflow действиями, фильтрация по статусам и ролям.

**Расположение проекта:** `E:\Birzha`

**Зависимости:** 
- Фаза 1-4 ✅ завершены
- Backend API готов и работает на порту 31081

---

## Результаты

### Созданные файлы

| Файл | Описание | Статус |
|------|----------|--------|
| `frontend/src/api/applications.js` | API модуль (30+ методов) | ✅ |
| `frontend/src/stores/applications.js` | Pinia store с workflow actions | ✅ |
| `frontend/src/components/applications/ApplicationStatusBadge.vue` | Компонент статуса | ✅ |
| `frontend/src/components/applications/ApplicationWorkflowActions.vue` | Кнопки workflow | ✅ |
| `frontend/src/components/applications/ApplicationForm.vue` | Форма создания/редактирования | ✅ |
| `frontend/src/views/ApplicationsView.vue` | Страница списка заявок | ✅ |
| `frontend/src/views/ApplicationDetailView.vue` | Карточка заявки | ✅ |

### Изменённые файлы

| Файл | Изменения | Статус |
|------|-----------|--------|
| `frontend/src/router/index.js` | Добавлены маршруты /applications | ✅ |
| `frontend/src/App.vue` | Добавлен пункт меню "Заявки" | ✅ |

---

## Реализованная функциональность

### 1. API модуль (applications.js) ✅

```javascript
// 30+ методов для работы с заявками
- getAll(params)           // Список с фильтрацией
- getById(id)              // Одна заявка
- create(data)             // Создание
- update(id, data)         // Обновление
- delete(id)               // Удаление
- getMy(params)            // Мои заявки
- getAssigned(params)      // Назначенные мне
- getPendingApproval(params) // На согласовании
- getHistory(id)           // История
- getStats()               // Статистика
- getStatuses()            // Список статусов
- getAvailableActions(id)  // Доступные действия

// Workflow действия
- submit(id, comment)
- assignRecruiter(id, comment)
- startInterview(id, comment)
- sendToHrBp(id, data)
- approveByHrBp(id, data)
- rejectByHrBp(id, data)
- sendToBorup(id, data)
- approveByBorup(id, data)
- rejectByBorup(id, data)
- prepareTransfer(id, comment)
- completeTransfer(id, data)
- dismiss(id, data)
- cancel(id, data)
- returnToHrBp(id, comment)
- returnToBorup(id, comment)
- assignHrBp(id, hrBpId)
- assignBorup(id, borupId)
```

### 2. Pinia Store (applications.js) ✅

**State:**
- `applications` — массив заявок
- `currentApplication` — текущая заявка
- `availableActions` — доступные действия
- `history` — история изменений
- `stats` — статистика
- `statuses` — список статусов
- `loading`, `error` — состояния загрузки
- `pagination` — пагинация
- `filters` — фильтры

**Actions:**
- `fetchApplications()` — загрузка списка
- `fetchMyApplications()` — мои заявки
- `fetchAssignedApplications()` — назначенные
- `fetchPendingApproval()` — на согласовании
- `fetchById(id)` — одна заявка
- `fetchAvailableActions(id)` — доступные действия
- `fetchHistory(id)` — история
- `fetchStats()` — статистика
- `fetchStatuses()` — статусы
- `createApplication(data)` — создание
- `updateApplication(id, data)` — обновление
- `deleteApplication(id)` — удаление
- `executeWorkflowAction(actionName, id, data)` — выполнение workflow

### 3. ApplicationStatusBadge.vue ✅

Компонент для отображения статуса заявки с цветокодированием:

| Тип статуса | Цвет | Статусы |
|-------------|------|---------|
| Начальные | Синий (info) | DRAFT, AVAILABLE_FOR_REVIEW |
| В работе | Синий (primary) | IN_PROGRESS, INTERVIEW, PREPARING_TRANSFER |
| Ожидание | Оранжевый (warning) | PENDING_HR_BP, PENDING_BORUP |
| Согласовано | Зелёный (success) | APPROVED_HR_BP, APPROVED_BORUP, TRANSFERRED |
| Отклонено | Красный (danger) | REJECTED_HR_BP, REJECTED_BORUP, DISMISSED |
| Отменено | Серый (info) | CANCELLED |

### 4. ApplicationWorkflowActions.vue ✅

Компонент с кнопками workflow действий и диалогами:

**Кнопки:**
- Взять в работу (assignRecruiter)
- Начать собеседование (startInterview)
- На согласование HR BP (sendToHrBpApproval)
- Согласовать / Отклонить (HR BP)
- На согласование БОРУП (sendToBorupApproval)
- Согласовать / Отклонить (БОРУП)
- Подготовить к переводу (prepareTransfer)
- Завершить перевод (completeTransfer)
- Вернуть HR BP / БОРУП (returnTo*)
- Увольнение (dismiss)
- Отменить (cancel)

**Диалоги:**
- Согласование (с комментарием)
- Отклонение (комментарий обязателен)
- Завершение перевода (дата + комментарий)
- Увольнение (причина обязательна)
- Отмена заявки
- Отправить HR BP (выбор HR BP если не назначен)
- Отправить БОРУП (выбор БОРУП если не назначен)

### 5. ApplicationForm.vue ✅

Форма создания/редактирования заявки:

**Поля:**
- Сотрудник (поиск с автодополнением)
- Целевая позиция
- Целевой стек (выбор из справочника)
- Текущая ЗП / Целевая ЗП
- HR BP (выбор из списка)
- Комментарий

**Особенности:**
- Автоматический расчёт % увеличения ЗП
- Предупреждение если >30% (требуется БОРУП)
- Валидация обязательных полей

### 6. ApplicationsView.vue ✅

Страница списка заявок:

**Вкладки по ролям:**
- "Все заявки" — RECRUITER, DZO_ADMIN, SYSTEM_ADMIN
- "Мои заявки" — MANAGER, HR_BP
- "В работе" — RECRUITER (назначенные)
- "На согласовании" — HR_BP, BORUP

**Функционал:**
- Таблица с заявками (el-table)
- Поиск по ФИО/позиции
- Фильтр по статусам (множественный выбор)
- Статистика (всего, в работе, на согласовании, завершено)
- Пагинация
- Кнопка создания заявки (для MANAGER, HR_BP)
- Клик по строке → переход на детальную страницу

**Колонки таблицы:**
- № (ID)
- Сотрудник (ФИО + email)
- Целевая позиция
- Стек
- Статус (цветной badge)
- ЗП (текущая → целевая + %)
- Рекрутер
- Дата создания

### 7. ApplicationDetailView.vue ✅

Детальная страница заявки:

**Секции:**
- **Действия** — workflow кнопки (если есть доступные)
- **Информация о заявке** — все поля заявки
- **Участники процесса** — создатель, рекрутер, HR BP, БОРУП с решениями
- **Итоговое решение** — для финальных статусов
- **История изменений** — timeline с действиями

**Функционал:**
- Редактирование (только DRAFT/AVAILABLE_FOR_REVIEW)
- Выполнение workflow действий
- Просмотр истории
- Навигация назад к списку

### 8. Маршруты ✅

```javascript
{
  path: '/applications',
  name: 'Applications',
  component: ApplicationsView,
  meta: { requiresAuth: true }
},
{
  path: '/applications/:id',
  name: 'ApplicationDetail',
  component: ApplicationDetailView,
  meta: { requiresAuth: true }
}
```

### 9. Навигация ✅

Добавлен пункт меню "Заявки" в боковую панель (App.vue или Sidebar):
```vue
<el-menu-item index="/applications">
  <el-icon><Document /></el-icon>
  <span>Заявки</span>
</el-menu-item>
```

---

## Критерии приёмки ✅

### Функциональность

- [x] Страница списка заявок загружается
- [x] Таблица с заявками отображается
- [x] Пагинация работает
- [x] Поиск по ФИО/позиции работает
- [x] Фильтр по статусам работает
- [x] Вкладки фильтруют по роли
- [x] Создание заявки работает
- [x] Форма с поиском сотрудника работает
- [x] Расчёт % увеличения ЗП отображается
- [x] Детальная страница отображает всю информацию
- [x] История изменений отображается
- [x] Доступные действия показываются по роли
- [x] Workflow действия работают
- [x] Диалоги открываются
- [x] После действия статус обновляется
- [x] Редактирование работает (только для редактируемых статусов)

### UI/UX

- [x] Статусы цветокодированы
- [x] Loading индикаторы при запросах
- [x] Ошибки отображаются через ElMessage

---

## Тестирование

### Проверка создания заявки

1. Войти как user1 (MANAGER)
2. Перейти на /applications
3. Нажать "Создать заявку"
4. Выбрать сотрудника, заполнить поля
5. Сохранить
6. Убедиться что заявка создана со статусом AVAILABLE_FOR_REVIEW

### Проверка workflow

1. Войти как рекрутер
2. Взять заявку в работу
3. Отправить на согласование HR BP
4. Войти как HR BP
5. Согласовать
6. Войти как рекрутер
7. Отправить на согласование БОРУП (если >30%)
8. Войти как БОРУП
9. Согласовать
10. Войти как рекрутер
11. Подготовить к переводу
12. Завершить перевод

---

## Документация обновлена

- [x] `E:\Birzha\.claude\Project_map.md` — версия 1.5.0
- [x] `E:\Birzha\.claude\DEVELOPMENT_PLAN.md` — Phase 5 завершена

---

## Следующая фаза

**Фаза 6: Чёрный список кандидатов**
- Entity Blacklist
- CRUD API
- Frontend страница
- Проверка при создании заявки
