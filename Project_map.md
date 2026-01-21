# Birzha - Resource Manager (Биржа талантов 3.0)

**Дата:** 2026-01-21
**Версия:** 4.0 (Applications Workflow)

---

## Архитектура системы

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Vue.js SPA    │────▶│  Spring Boot    │────▶│   PostgreSQL    │
│   (nginx)       │     │  REST API       │     │                 │
│   port: 31080   │     │  port: 31081    │     │   port: 31432   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## Реализованные фазы

### ✅ Фаза 1: Мультитенантность (ДЗО)

**Модель данных:**
- `dzos` - дочерние зависимые общества
- Все основные таблицы имеют `dzo_id`
- Row-Level Security через `RoleService.canAccessDzo()`

**Основные компоненты:**
- [backend/src/main/java/com/company/resourcemanager/entity/Dzo.java](backend/src/main/java/com/company/resourcemanager/entity/Dzo.java:1)
- [backend/src/main/java/com/company/resourcemanager/repository/DzoRepository.java](backend/src/main/java/com/company/resourcemanager/repository/DzoRepository.java:1)
- [backend/src/main/java/com/company/resourcemanager/service/RoleService.java](backend/src/main/java/com/company/resourcemanager/service/RoleService.java:1)

---

### ✅ Фаза 2: Расширенная ролевая модель

**Роли:**
- `SYSTEM_ADMIN` - системный администратор (полный доступ)
- `DZO_ADMIN` - администратор ДЗО
- `MANAGER` - руководитель (создание заявок)
- `RECRUITER` - рекрутер (обработка заявок)
- `HR_BP` - HR Business Partner (согласование)
- `BORUP` - БОРУП (финальное согласование при увеличении ЗП >30%)

**Модель:**
- Таблица `user_roles` (многие-ко-многим)
- У пользователя может быть несколько ролей
- Проверка доступа через `@PreAuthorize` и `RoleService`

**Основные компоненты:**
- [backend/src/main/java/com/company/resourcemanager/entity/Role.java](backend/src/main/java/com/company/resourcemanager/entity/Role.java:1)
- [backend/src/main/java/com/company/resourcemanager/entity/UserRole.java](backend/src/main/java/com/company/resourcemanager/entity/UserRole.java:1)
- [backend/src/main/java/com/company/resourcemanager/service/UserService.java](backend/src/main/java/com/company/resourcemanager/service/UserService.java:1)

---

### ✅ Фаза 3: Заявки — Backend

**Модель данных:**

```sql
applications (
    id, dzo_id, employee_id, created_by, recruiter_id, hr_bp_id, borup_id,
    status, target_position, target_stack,
    current_salary, target_salary, salary_increase_percent,
    requires_borup_approval,
    hr_bp_decision, hr_bp_comment, hr_bp_decision_at,
    borup_decision, borup_comment, borup_decision_at,
    transfer_date, final_comment, completed_at,
    resume_file_path, comment
)

application_history (
    id, application_id, changed_by, changed_at,
    old_status, new_status, action, comment
)
```

**Статусы заявки:**
```
DRAFT → AVAILABLE_FOR_REVIEW → IN_PROGRESS → INTERVIEW →
PENDING_HR_BP → APPROVED_HR_BP / REJECTED_HR_BP →
PENDING_BORUP → APPROVED_BORUP / REJECTED_BORUP →
PREPARING_TRANSFER → TRANSFERRED

Также: DISMISSED, CANCELLED
```

**API Endpoints:**
- `GET /api/applications` - список с фильтрацией
- `GET /api/applications/{id}` - получить одну
- `POST /api/applications` - создать (MANAGER, HR_BP)
- `PUT /api/applications/{id}` - обновить
- `DELETE /api/applications/{id}` - удалить
- `GET /api/applications/my` - мои заявки (MANAGER)
- `GET /api/applications/assigned` - назначенные мне (RECRUITER)
- `GET /api/applications/pending-approval` - на согласовании (HR_BP, BORUP)
- `GET /api/applications/{id}/history` - история изменений
- `GET /api/applications/stats` - статистика
- `POST /api/applications/{id}/assign-hr-bp?hrBpId={id}` - назначить HR BP
- `POST /api/applications/{id}/assign-borup?borupId={id}` - назначить БОРУП

**Основные компоненты:**
- [backend/src/main/java/com/company/resourcemanager/entity/Application.java](backend/src/main/java/com/company/resourcemanager/entity/Application.java:1)
- [backend/src/main/java/com/company/resourcemanager/entity/ApplicationStatus.java](backend/src/main/java/com/company/resourcemanager/entity/ApplicationStatus.java:1)
- [backend/src/main/java/com/company/resourcemanager/repository/ApplicationRepository.java](backend/src/main/java/com/company/resourcemanager/repository/ApplicationRepository.java:1)
- [backend/src/main/java/com/company/resourcemanager/service/ApplicationService.java](backend/src/main/java/com/company/resourcemanager/service/ApplicationService.java:1)
- [backend/src/main/java/com/company/resourcemanager/controller/ApplicationController.java](backend/src/main/java/com/company/resourcemanager/controller/ApplicationController.java:1)

---

### ✅ Фаза 4: Заявки — Workflow

**Статусная машина:**

```
                    ┌─────────────────────────────────────────────────────────────────┐
                    │                                                                 │
                    ▼                                                                 │
┌──────────┐    ┌──────────────────────┐    ┌─────────────┐    ┌────────────┐        │
│  DRAFT   │───▶│ AVAILABLE_FOR_REVIEW │───▶│ IN_PROGRESS │───▶│ INTERVIEW  │        │
└──────────┘    └──────────────────────┘    └─────────────┘    └────────────┘        │
   submit()         assignRecruiter()          startInterview()       │              │
                                                                      │              │
                                               ┌──────────────────────┘              │
                                               ▼                                      │
                                        ┌──────────────┐                             │
                                        │ PENDING_HR_BP│◀────────────────────────────┤
                                        └──────────────┘      returnToHrBp()         │
                                               │                                      │
                              ┌────────────────┼────────────────┐                    │
                              ▼                                 ▼                    │
                    ┌─────────────────┐              ┌─────────────────┐             │
                    │ APPROVED_HR_BP  │              │ REJECTED_HR_BP  │─────────────┘
                    └─────────────────┘              └─────────────────┘
                              │                              cancel()
                              │
              ┌───────────────┴───────────────┐
              │ requiresBorupApproval?        │
              ▼ YES                           ▼ NO
      ┌──────────────┐                ┌───────────────────┐
      │PENDING_BORUP │                │PREPARING_TRANSFER │
      └──────────────┘                └───────────────────┘
              │                               │
    ┌─────────┼─────────┐                     │
    ▼                   ▼                     ▼
┌──────────────┐ ┌──────────────┐     ┌─────────────┐
│APPROVED_BORUP│ │REJECTED_BORUP│     │ TRANSFERRED │
└──────────────┘ └──────────────┘     └─────────────┘
        │               │
        ▼               │             ┌─────────────┐
┌───────────────────┐   └────────────▶│  DISMISSED  │
│PREPARING_TRANSFER │                 └─────────────┘
└───────────────────┘
        │
        ▼
┌─────────────┐
│ TRANSFERRED │
└─────────────┘
```

**Workflow API Endpoints:**

| Действие | Endpoint | Роль | Описание |
|----------|----------|------|----------|
| submit | POST /{id}/submit | MANAGER, HR_BP | Подать заявку |
| assignRecruiter | POST /{id}/assign-recruiter | RECRUITER | Взять в работу |
| startInterview | POST /{id}/start-interview | RECRUITER | Начать собеседование |
| sendToHrBpApproval | POST /{id}/send-to-hr-bp | RECRUITER | Отправить на HR BP |
| approveByHrBp | POST /{id}/approve-hr-bp | HR_BP | Согласовать (HR BP) |
| rejectByHrBp | POST /{id}/reject-hr-bp | HR_BP | Отклонить (HR BP) |
| sendToBorupApproval | POST /{id}/send-to-borup | RECRUITER | Отправить на БОРУП |
| approveByBorup | POST /{id}/approve-borup | BORUP | Согласовать (БОРУП) |
| rejectByBorup | POST /{id}/reject-borup | BORUP | Отклонить (БОРУП) |
| prepareTransfer | POST /{id}/prepare-transfer | RECRUITER | Подготовка к переводу |
| completeTransfer | POST /{id}/complete-transfer | RECRUITER | Завершить перевод |
| dismiss | POST /{id}/dismiss | RECRUITER, DZO_ADMIN | Увольнение |
| cancel | POST /{id}/cancel | Создатель, DZO_ADMIN | Отменить заявку |
| returnToHrBp | POST /{id}/return-to-hr-bp | RECRUITER | Вернуть на доработку |
| returnToBorup | POST /{id}/return-to-borup | RECRUITER | Вернуть на доработку |
| getAvailableActions | GET /{id}/available-actions | Все | Доступные действия |

**Валидации:**
- Проверка роли пользователя
- Проверка текущего статуса заявки
- Проверка что пользователь является назначенным исполнителем
- Комментарий обязателен при отклонении
- БОРУП требуется при увеличении ЗП >30%

**Основные компоненты:**
- [backend/src/main/java/com/company/resourcemanager/service/ApplicationWorkflowService.java](backend/src/main/java/com/company/resourcemanager/service/ApplicationWorkflowService.java:1)
- [backend/src/main/java/com/company/resourcemanager/controller/ApplicationWorkflowController.java](backend/src/main/java/com/company/resourcemanager/controller/ApplicationWorkflowController.java:1)
- [backend/src/main/java/com/company/resourcemanager/dto/workflow/](backend/src/main/java/com/company/resourcemanager/dto/workflow/) - DTO для workflow

---

## Следующие фазы

### ⏳ Фаза 5: Заявки — Frontend
- Views для создания/редактирования заявок
- Таблица заявок с фильтрацией
- Workflow UI (кнопки действий в зависимости от роли и статуса)
- История изменений

### ⏳ Фаза 6: Чёрный список кандидатов
### ⏳ Фаза 7: Справочник стеков с workflow
### ⏳ Фаза 8: Аналитика по заявкам
### ⏳ Фаза 9: Email-уведомления
### ⏳ Фаза 10: 2FA (OTP по email)
### ⏳ Фаза 11: LDAP/AD интеграция
### ⏳ Фаза 12: Интеграция с 1С ЗУП
### ⏳ Фаза 13: Интеграция с ATS (IQHR)

---

## Структура проекта

```
E:\Birzha/
├── backend/
│   ├── src/main/java/com/company/resourcemanager/
│   │   ├── entity/           # Entities (User, Dzo, Application, etc.)
│   │   ├── repository/       # JPA Repositories
│   │   ├── service/          # Business Logic
│   │   ├── controller/       # REST Controllers
│   │   ├── dto/              # Data Transfer Objects
│   │   ├── dto/workflow/     # Workflow-specific DTOs
│   │   ├── security/         # JWT, Authentication
│   │   ├── exception/        # Custom Exceptions
│   │   └── config/           # Configuration
│   ├── src/main/resources/
│   │   ├── application.yml   # Application config
│   │   └── db/migration/     # Flyway migrations
│   ├── pom.xml
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── components/       # Vue components
│   │   ├── views/            # Pages
│   │   ├── stores/           # Pinia stores
│   │   ├── api/              # API client
│   │   ├── router/           # Vue Router
│   │   └── utils/            # Utilities
│   ├── package.json
│   ├── vite.config.js
│   ├── nginx.conf
│   └── Dockerfile
├── docker-compose.yml
├── init-data.sql
└── .claude/
    ├── CLAUDE.md             # Project instructions
    ├── DEVELOPMENT_PLAN.md   # Development roadmap
    └── commands/             # Custom CLI commands
```

---

## Запуск проекта

```bash
# Локальный запуск
docker-compose up -d

# С пересборкой
docker-compose up -d --build

# Остановка
docker-compose down

# Логи
docker-compose logs -f backend
docker-compose logs -f frontend
```

**Доступ:**
- Frontend: http://localhost:31080
- Backend API: http://localhost:31081
- PostgreSQL: localhost:31432

**Учётные данные:**
- admin / admin123 (SYSTEM_ADMIN + MANAGER)
- manager / admin123 (MANAGER)
- recruiter / admin123 (RECRUITER)
- hr_bp / admin123 (HR_BP)
- borup / admin123 (BORUP)

---

## База данных

**Основные таблицы:**

1. **users** - пользователи
2. **user_roles** - роли пользователей (многие-ко-многим)
3. **dzos** - дочерние зависимые общества
4. **employees** - сотрудники (с JSONB custom_fields)
5. **applications** - заявки на перевод
6. **application_history** - история изменений заявок
7. **dictionaries** - справочники
8. **column_definitions** - динамические колонки
9. **resumes** - резюме сотрудников

---

## Технологии

**Backend:**
- Java 17
- Spring Boot 3.x
- Spring Security (JWT)
- Spring Data JPA
- Flyway (миграции)
- PostgreSQL 15+
- Lombok

**Frontend:**
- Vue 3 (Composition API)
- Pinia (State Management)
- Vue Router
- Axios
- Element Plus (UI компоненты)
- Vite

**DevOps:**
- Docker
- Docker Compose
- Nginx

---

## Миграции базы данных

**Последние миграции:**
- V15__create_dzos_table.sql - таблица ДЗО
- V16__add_dzo_id_to_tables.sql - добавление dzo_id
- V17__update_user_roles.sql - новая ролевая модель
- V18__create_hr_bp_assignments.sql - назначения HR BP
- V19__create_applications_table.sql - таблица заявок
- V20__create_application_history_table.sql - история заявок

---

## Тестирование

### Пример workflow теста:

```bash
# 1. Создать заявку (MANAGER)
curl -X POST http://localhost:31081/api/applications \
  -H "Authorization: Bearer $MANAGER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"employeeId":52,"targetPosition":"Senior Developer","targetStack":"Java","currentSalary":100000,"targetSalary":150000,"hrBpId":24}'

# 2. Рекрутер берёт в работу
curl -X POST http://localhost:31081/api/applications/2/assign-recruiter \
  -H "Authorization: Bearer $RECRUITER_TOKEN"

# 3. Начать собеседование
curl -X POST http://localhost:31081/api/applications/2/start-interview \
  -H "Authorization: Bearer $RECRUITER_TOKEN"

# 4. Отправить на HR BP
curl -X POST http://localhost:31081/api/applications/2/send-to-hr-bp \
  -H "Authorization: Bearer $RECRUITER_TOKEN"

# 5. HR BP согласует
curl -X POST http://localhost:31081/api/applications/2/approve-hr-bp \
  -H "Authorization: Bearer $HR_BP_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"comment":"Approved"}'

# 6. Отправить на БОРУП
curl -X POST http://localhost:31081/api/applications/2/send-to-borup \
  -H "Authorization: Bearer $RECRUITER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"approverId":25}'

# 7. БОРУП согласует
curl -X POST http://localhost:31081/api/applications/2/approve-borup \
  -H "Authorization: Bearer $BORUP_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"comment":"Approved by BORUP"}'

# 8. Подготовка к переводу
curl -X POST http://localhost:31081/api/applications/2/prepare-transfer \
  -H "Authorization: Bearer $RECRUITER_TOKEN"

# 9. Завершить перевод
curl -X POST http://localhost:31081/api/applications/2/complete-transfer \
  -H "Authorization: Bearer $RECRUITER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"transferDate":"2026-02-01","comment":"Transfer complete"}'

# Проверка истории
curl -X GET http://localhost:31081/api/applications/2/history \
  -H "Authorization: Bearer $TOKEN"

# Доступные действия
curl -X GET http://localhost:31081/api/applications/2/available-actions \
  -H "Authorization: Bearer $TOKEN"
```

---

## Известные проблемы

1. **Ограничение сессий** - логин блокируется если уже есть активная сессия пользователя (user_sessions)
2. **Кодировка** - при отправке кириллицы в комментариях нужно указывать `Content-Type: application/json; charset=utf-8`

---

## Контакты и документация

- ТЗ: `E:\Birzha\Tasks\GAP_ANALYSIS_TZ_VS_IMPLEMENTATION.md`
- Инструкции: `E:\Birzha\.claude\CLAUDE.md`
- План развития: `E:\Birzha\.claude\DEVELOPMENT_PLAN.md`
