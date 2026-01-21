# План доработки Birzha по ТЗ "Биржа талантов 3.0"

**Дата создания:** 2026-01-21
**Последнее обновление:** 2026-01-21
**Основание:** GAP-анализ `E:\Birzha\Tasks\GAP_ANALYSIS_TZ_VS_IMPLEMENTATION.md`

---

## Прогресс

```
[████████████████░░░░░░░░] 46% (6 из 13 фаз завершено)
```

**Текущая фаза:** 7 — Справочник стеков с workflow

---

## Фазы разработки

### Внутренняя архитектура

| Фаза | Название | Статус | Инструкция |
|------|----------|--------|------------|
| 1 | Мультитенантность (ДЗО) | ✅ Завершено | `Tasks/PHASE_01_MULTITENANCY_DZO.md` |
| 2 | Расширенная ролевая модель | ✅ Завершено | `Tasks/PHASE_02_ROLE_MODEL.md` |

**Результаты Фазы 1:**
- Entity Dzo с 10 пилотными организациями
- dzo_id во всех таблицах
- Фильтрация данных по ДЗО
- API `/api/dzos`

**Результаты Фазы 2:**
- 6 ролей: SYSTEM_ADMIN, DZO_ADMIN, RECRUITER, HR_BP, BORUP, MANAGER
- Множественные роли на пользователя (user_roles)
- Закрепление HR BP (hr_bp_assignments)
- JWT с массивом ролей
- RoleService для проверки прав

---

### Модуль заявок

| Фаза | Название | Статус | Инструкция |
|------|----------|--------|------------|
| 3 | Заявки — Backend | ✅ Завершено | `Tasks/PHASE_03_APPLICATIONS_BACKEND.md` |
| 4 | Заявки — Workflow | ✅ Завершено | `Tasks/PHASE_04_APPLICATIONS_WORKFLOW.md` |
| 5 | Заявки — Frontend | ✅ Завершено | `Tasks/PHASE_05_APPLICATIONS_FRONTEND.md` |

**Результаты Фазы 3:**
- Entity Application (20+ полей)
- Entity ApplicationHistory
- 14 статусов (ApplicationStatus enum)
- ApplicationRepository с 20+ методами
- ApplicationService с CRUD и статистикой
- ApplicationController с 11 эндпоинтами

**Результаты Фазы 4:**
- ApplicationWorkflowService с 15 workflow действиями
- ApplicationWorkflowController с 15 эндпоинтами
- Полная валидация переходов статусов
- Проверка ролей и назначений
- getAvailableActions() по роли/статусу

**Результаты Фазы 5:**
- API модуль applications.js (30+ методов)
- Pinia store applications.js
- ApplicationStatusBadge.vue (цветокодирование)
- ApplicationWorkflowActions.vue (кнопки + диалоги)
- ApplicationForm.vue (создание/редактирование)
- ApplicationsView.vue (список с вкладками по ролям)
- ApplicationDetailView.vue (карточка + история)
- Маршруты /applications и /applications/:id
- Пункт меню в навигации

---

### Дополнительные модули

| Фаза | Название | Статус | Инструкция |
|------|----------|--------|------------|
| 6 | Чёрный список кандидатов | ✅ Завершено | `Tasks/PHASE_06_BLACKLIST.md` |
| 7 | Справочник стеков с workflow | ⏳ Ожидает | `Tasks/PHASE_07_TECH_STACKS.md` |
| 8 | Аналитика по заявкам | ⏳ Ожидает | — |

**Результаты Фазы 6:**
- Entity BlacklistEntry и BlacklistHistory
- BlacklistReasonCategory enum (10 категорий)
- Миграции V21, V22 (blacklist, blacklist_history)
- BlacklistRepository с полнотекстовым поиском
- BlacklistService с CRUD, проверкой, историей
- BlacklistController (11 эндпоинтов)
- Интеграция с ApplicationService (блокировка заявок)
- API: /api/blacklist, /check, /stats, /categories

---

### Уведомления и аутентификация

| Фаза | Название | Статус | Инструкция |
|------|----------|--------|------------|
| 9 | Email-уведомления | ⏳ Ожидает | — |
| 10 | 2FA (OTP по email) | ⏳ Ожидает | — |

---

### Интеграции (в последнюю очередь)

| Фаза | Название | Статус | Инструкция |
|------|----------|--------|------------|
| 11 | LDAP/AD интеграция | ⏳ Ожидает | — |
| 12 | Интеграция с 1С ЗУП | ⏳ Ожидает | — |
| 13 | Интеграция с ATS (IQHR) | ⏳ Ожидает | — |

---

## Порядок выполнения

```
✅ Фазы 1-2   → Архитектурный фундамент (ЗАВЕРШЕНО)
✅ Фазы 3-5   → Модуль заявок полностью (ЗАВЕРШЕНО)
⏳ Фазы 6-8   → Дополнительные модули (ТЕКУЩАЯ)
⏳ Фазы 9-10  → Уведомления и безопасность
⏳ Фазы 11-13 → Интеграции
```

---

## Миграции БД

| Версия | Файл | Описание | Фаза |
|--------|------|----------|------|
| V1-V14 | (исходные) | Базовая структура | — |
| V15 | create_dzos_table.sql | Таблица ДЗО | 1 |
| V16 | add_dzo_id_to_tables.sql | dzo_id во все таблицы | 1 |
| V17 | update_user_roles.sql | Таблица user_roles | 2 |
| V18 | create_hr_bp_assignments.sql | Закрепление HR BP | 2 |
| V19 | create_applications_table.sql | Таблица заявок | 3 |
| V20 | create_application_history_table.sql | История заявок | 3 |

---

## API Endpoints

### ДЗО (Фаза 1)
```
GET    /api/dzos
POST   /api/dzos
GET    /api/dzos/{id}
PUT    /api/dzos/{id}
```

### Роли (Фаза 2)
```
GET    /api/roles
POST   /api/roles/assign
POST   /api/roles/remove
GET    /api/hr-bp-assignments
POST   /api/hr-bp-assignments
DELETE /api/hr-bp-assignments/{id}
```

### Заявки CRUD (Фаза 3)
```
GET    /api/applications
POST   /api/applications
GET    /api/applications/{id}
PUT    /api/applications/{id}
DELETE /api/applications/{id}
GET    /api/applications/my
GET    /api/applications/assigned
GET    /api/applications/pending-approval
GET    /api/applications/{id}/history
GET    /api/applications/stats
GET    /api/applications/statuses
```

### Заявки Workflow (Фаза 4)
```
POST   /api/applications/{id}/submit
POST   /api/applications/{id}/assign-recruiter
POST   /api/applications/{id}/start-interview
POST   /api/applications/{id}/send-to-hr-bp
POST   /api/applications/{id}/approve-hr-bp
POST   /api/applications/{id}/reject-hr-bp
POST   /api/applications/{id}/send-to-borup
POST   /api/applications/{id}/approve-borup
POST   /api/applications/{id}/reject-borup
POST   /api/applications/{id}/prepare-transfer
POST   /api/applications/{id}/complete-transfer
POST   /api/applications/{id}/dismiss
POST   /api/applications/{id}/cancel
POST   /api/applications/{id}/return-to-hr-bp
POST   /api/applications/{id}/return-to-borup
GET    /api/applications/{id}/available-actions
POST   /api/applications/{id}/assign-hr-bp
POST   /api/applications/{id}/assign-borup
```

---

## Frontend (Фаза 5)

### Созданные файлы
```
frontend/src/api/applications.js
frontend/src/stores/applications.js
frontend/src/components/applications/ApplicationStatusBadge.vue
frontend/src/components/applications/ApplicationWorkflowActions.vue
frontend/src/components/applications/ApplicationForm.vue
frontend/src/views/ApplicationsView.vue
frontend/src/views/ApplicationDetailView.vue
```

### Маршруты
```
/applications          → ApplicationsView (список)
/applications/:id      → ApplicationDetailView (карточка)
```

---

## Тестовые данные

**ДЗО (10 штук):**
rt-dc, rt-solar, bft, t2, basistech, rtlabs, omp, pao-rtk, rtk, rtk-it

**Пользователи:**
- admin (SYSTEM_ADMIN) — пароль: admin123
- user1-user10 (MANAGER) — пароль: user

**Для полного тестирования workflow:**
1. Назначить роли RECRUITER, HR_BP, BORUP пользователям
2. Создать заявку от MANAGER
3. Провести через весь workflow
