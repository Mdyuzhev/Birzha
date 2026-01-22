# Birzha — Resource Management Tool

**Карта архитектуры проекта**
**Дата создания:** 2026-01-21
**Последнее обновление:** 2026-01-22
**Версия:** 1.6.1

---

## 1. Общее описание системы

### Назначение проекта

Birzha — внутренняя HRM-система для управления карьерными перемещениями и развитием сотрудников. Система позволяет:
- Централизованно хранить информацию о сотрудниках
- **Мультитенантность**: Поддержка нескольких ДЗО (дочерних зависимых обществ) с изоляцией данных
- **Расширенная система ролей**: 6 ролей (SYSTEM_ADMIN, DZO_ADMIN, RECRUITER, HR_BP, BORUP, MANAGER)
- **Заявки на развитие и ротацию**: Полный workflow с согласованиями HR BP и БОРУП
- Оценивать сотрудников по модели 9-Box (Performance vs Potential)
- Генерировать и экспортировать проектные резюме

### Технологический стек

| Компонент | Технология | Версия |
|-----------|------------|--------|
| **Backend** | Java, Spring Boot | 17, 3.2.5 |
| **Security** | Spring Security, JWT | jjwt 0.12.3 |
| **ORM** | Spring Data JPA, Hibernate | |
| **Миграции** | Flyway | 10.10.0 |
| **БД** | PostgreSQL | 15+ |
| **JSONB** | Hypersistence Utils | 3.7.3 |
| **Frontend** | Vue 3, Composition API | 3.5.24 |
| **State** | Pinia | 3.0.4 |
| **UI Kit** | Element Plus | 2.13.1 |
| **HTTP** | Axios | 1.13.2 |
| **Деплой** | Docker, docker-compose | |

### Архитектура

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Vue.js SPA    │────▶│  Spring Boot    │────▶│   PostgreSQL    │
│   (nginx)       │     │  REST API       │     │                 │
│   port: 31080   │     │  port: 31081    │     │   port: 31432   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## 2. Ролевая модель (6 ролей)

| Роль | Код | Описание |
|------|-----|----------|
| Администратор системы | `SYSTEM_ADMIN` | Полный доступ ко всем ДЗО |
| Администратор ДЗО | `DZO_ADMIN` | Управление своим ДЗО |
| Рекрутер | `RECRUITER` | Обработка заявок |
| HR BP | `HR_BP` | Согласование заявок |
| БОРУП | `BORUP` | Согласование при ЗП >30% |
| Руководитель | `MANAGER` | Подача заявок |

---

## 3. Модуль заявок (Phase 3-4)

### Workflow заявок

```
DRAFT → AVAILABLE_FOR_REVIEW → IN_PROGRESS → INTERVIEW
                                    ↓
                            PENDING_HR_BP
                            ↓           ↓
                    APPROVED_HR_BP   REJECTED_HR_BP
                            ↓               ↓
            (если >30%) PENDING_BORUP   returnToHrBp()
                        ↓           ↓
                APPROVED_BORUP   REJECTED_BORUP
                        ↓
                PREPARING_TRANSFER → TRANSFERRED / DISMISSED / CANCELLED
```

### Статусы заявок (14)

| Статус | Описание | Финальный |
|--------|----------|-----------|
| DRAFT | Черновик | ❌ |
| AVAILABLE_FOR_REVIEW | Свободен для рассмотрения | ❌ |
| IN_PROGRESS | В работе (рекрутер) | ❌ |
| INTERVIEW | На собеседовании | ❌ |
| PENDING_HR_BP | Ожидает согласования HR BP | ❌ |
| APPROVED_HR_BP | Согласован HR BP | ❌ |
| REJECTED_HR_BP | Отклонён HR BP | ❌ |
| PENDING_BORUP | Ожидает согласования БОРУП | ❌ |
| APPROVED_BORUP | Согласован БОРУП | ❌ |
| REJECTED_BORUP | Отклонён БОРУП | ❌ |
| PREPARING_TRANSFER | Готовится к переводу | ❌ |
| TRANSFERRED | Переведён | ✅ |
| DISMISSED | Увольнение | ✅ |
| CANCELLED | Отменена | ✅ |

### Workflow действия (Phase 4)

| Действие | Метод API | Роль | Из статуса | В статус |
|----------|-----------|------|------------|----------|
| submit | POST /{id}/submit | MANAGER, HR_BP | DRAFT | AVAILABLE_FOR_REVIEW |
| assignRecruiter | POST /{id}/assign-recruiter | RECRUITER | AVAILABLE_FOR_REVIEW | IN_PROGRESS |
| startInterview | POST /{id}/start-interview | RECRUITER | IN_PROGRESS | INTERVIEW |
| sendToHrBpApproval | POST /{id}/send-to-hr-bp | RECRUITER | IN_PROGRESS/INTERVIEW | PENDING_HR_BP |
| approveByHrBp | POST /{id}/approve-hr-bp | HR_BP | PENDING_HR_BP | APPROVED_HR_BP |
| rejectByHrBp | POST /{id}/reject-hr-bp | HR_BP | PENDING_HR_BP | REJECTED_HR_BP |
| sendToBorupApproval | POST /{id}/send-to-borup | RECRUITER | APPROVED_HR_BP | PENDING_BORUP |
| approveByBorup | POST /{id}/approve-borup | BORUP | PENDING_BORUP | APPROVED_BORUP |
| rejectByBorup | POST /{id}/reject-borup | BORUP | PENDING_BORUP | REJECTED_BORUP |
| prepareTransfer | POST /{id}/prepare-transfer | RECRUITER | APPROVED_* | PREPARING_TRANSFER |
| completeTransfer | POST /{id}/complete-transfer | RECRUITER | PREPARING_TRANSFER | TRANSFERRED |
| dismiss | POST /{id}/dismiss | RECRUITER, DZO_ADMIN | любой не финальный | DISMISSED |
| cancel | POST /{id}/cancel | Создатель, DZO_ADMIN | любой не финальный | CANCELLED |
| returnToHrBp | POST /{id}/return-to-hr-bp | RECRUITER | REJECTED_HR_BP | PENDING_HR_BP |
| returnToBorup | POST /{id}/return-to-borup | RECRUITER | REJECTED_BORUP | PENDING_BORUP |

---

## 4. Структура Backend

### Пакеты

```
com.company.resourcemanager/
├── config/                  # Security, JWT, CORS
├── controller/
│   ├── AuthController.java
│   ├── ApplicationController.java      # CRUD заявок
│   ├── ApplicationWorkflowController.java  # Workflow действия
│   ├── DzoController.java
│   ├── RoleController.java
│   ├── EmployeeController.java
│   ├── ColumnController.java
│   ├── DictionaryController.java
│   ├── UserController.java
│   ├── NineBoxController.java
│   └── ResumeController.java
├── service/
│   ├── ApplicationService.java         # CRUD + история + статистика
│   ├── ApplicationWorkflowService.java # 15 workflow методов
│   ├── CurrentUserService.java         # Проверка ролей и доступа
│   ├── RoleService.java                # Управление ролями
│   ├── EmployeeService.java
│   └── ...
├── repository/
│   ├── ApplicationRepository.java      # 20+ методов поиска
│   ├── ApplicationHistoryRepository.java
│   ├── UserRepository.java             # Поиск по username OR fullName
│   └── ...
├── entity/
│   ├── Application.java                # 20+ полей
│   ├── ApplicationHistory.java
│   ├── ApplicationStatus.java          # 14 статусов (enum)
│   ├── DecisionType.java               # PENDING, APPROVED, REJECTED
│   ├── Role.java                       # 6 ролей (enum)
│   ├── UserRole.java
│   ├── HrBpAssignment.java
│   └── ...
├── dto/
│   ├── ApplicationDto.java
│   ├── CreateApplicationRequest.java
│   ├── UpdateApplicationRequest.java
│   ├── ApplicationHistoryDto.java
│   ├── ApplicationFilterRequest.java
│   ├── ApplicationStatsDto.java
│   └── workflow/
│       ├── SendToApprovalRequest.java
│       ├── ApprovalDecisionRequest.java
│       ├── CompleteTransferRequest.java
│       ├── DismissRequest.java
│       └── CancelRequest.java
└── exception/
    ├── GlobalExceptionHandler.java
    ├── ResourceNotFoundException.java
    ├── BusinessException.java
    └── AccessDeniedException.java
```

---

## 5. Структура Frontend (Phase 5)

### Пакеты

```
frontend/src/
├── api/
│   ├── client.js                    # Axios клиент с JWT
│   ├── auth.js
│   ├── applications.js              # 20+ методов для заявок (Phase 5)
│   ├── employees.js
│   ├── resumes.js
│   └── ...
├── stores/
│   ├── auth.js
│   ├── applications.js              # Pinia store для заявок (Phase 5)
│   ├── columns.js
│   ├── dzo.js
│   ├── notifications.js
│   └── theme.js
├── components/
│   ├── applications/                # Phase 5
│   │   ├── ApplicationStatusBadge.vue       # Бейдж статуса (14 статусов)
│   │   ├── ApplicationWorkflowActions.vue   # Кнопки workflow действий
│   │   └── ApplicationForm.vue              # Форма создания/редактирования
│   └── EmployeeDialog.vue
├── views/
│   ├── LoginView.vue
│   ├── EmployeesView.vue
│   ├── ApplicationsView.vue         # Список заявок с фильтрами (Phase 5)
│   ├── ApplicationDetailView.vue    # Детальная страница + история (Phase 5)
│   ├── AdminView.vue                # Пользователи, колонки, справочники
│   ├── AnalyticsView.vue
│   ├── NineBoxView.vue
│   ├── NineBoxDetailView.vue
│   └── ResumesView.vue
└── router/
    └── index.js                     # Маршруты /applications, /applications/:id
```

### ApplicationsView.vue функционал

- Переключение между списками: все / мои / назначенные / требуют согласования
- Фильтрация по статусу
- Таблица с колонками: ID, Сотрудник, Тип, Должность, ЗП, Статус, Дата
- Создание новой заявки через диалог
- Статистика: всего / в работе / на согласовании / завершено

### ApplicationDetailView.vue функционал

- Просмотр всех полей заявки
- История изменений (timeline)
- Доступные workflow действия
- Выполнение действий с комментариями
- Автообновление после действия

### AdminView.vue функционал (v1.6.1)

**Вкладка "Пользователи":**
- Таблица с колонками: ID, Логин, ФИО, ДЗО, Роли
- **Поиск** по логину ИЛИ ФИО (регистронезависимый, подстрока)
  - Автоматический поиск с дебаунсом 500ms
  - Поддержка кириллицы
- Пагинация: 6, 12, 24 на странице
- CRUD: добавить, изменить, удалить пользователя
- Множественные роли на пользователя

**Вкладка "Колонки":**
- Управление динамическими колонками для сотрудников

**Вкладка "Справочники":**
- Управление словарями значений

### Workflow Actions

15 действий с UI:
- submit, assignRecruiter, startInterview - без диалога
- sendToHrBp, approveByHrBp, sendToBorup, approveByBorup, prepareTransfer - без диалога
- rejectByHrBp, rejectByBorup, cancel - диалог с обязательным комментарием
- completeTransfer - диалог с полями (должность, подразделение)
- dismiss - диалог с датой увольнения
- returnToHrBp, returnToBorup - без диалога

---

## 6. API Endpoints

### Auth
```
POST   /api/auth/login        # Авторизация → JWT
GET    /api/auth/me           # Текущий пользователь
POST   /api/auth/logout       # Выход
```

### ДЗО (ADMIN)
```
GET    /api/dzos
POST   /api/dzos
GET    /api/dzos/{id}
PUT    /api/dzos/{id}
```

### Роли (SYSTEM_ADMIN)
```
GET    /api/roles
POST   /api/roles/assign
POST   /api/roles/remove
GET    /api/hr-bp-assignments
POST   /api/hr-bp-assignments
DELETE /api/hr-bp-assignments/{id}
```

### Пользователи (SYSTEM_ADMIN, DZO_ADMIN)
```
GET    /api/users/search         # Поиск по username OR fullName (+ пагинация)
POST   /api/users                # Создание
GET    /api/users/{id}           # Получение
PUT    /api/users/{id}           # Обновление
DELETE /api/users/{id}           # Удаление
```

### Заявки CRUD
```
GET    /api/applications                    # Список с фильтрацией
POST   /api/applications                    # Создание (MANAGER, HR_BP)
GET    /api/applications/{id}               # Одна заявка
PUT    /api/applications/{id}               # Обновление
DELETE /api/applications/{id}               # Удаление (только DRAFT)
GET    /api/applications/my                 # Мои заявки
GET    /api/applications/assigned           # Назначенные мне
GET    /api/applications/pending-approval   # На моё согласование
GET    /api/applications/{id}/history       # История
GET    /api/applications/stats              # Статистика
GET    /api/applications/statuses           # Список статусов
GET    /api/applications/{id}/available-actions  # Доступные действия
```

### Заявки Workflow
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
POST   /api/applications/{id}/assign-hr-bp
POST   /api/applications/{id}/assign-borup
```

### Чёрный список (RECRUITER, HR_BP, DZO_ADMIN, SYSTEM_ADMIN)
```
GET    /api/blacklist                        # Список с фильтрацией
POST   /api/blacklist                        # Добавить в ЧС
GET    /api/blacklist/{id}                   # Одна запись
PUT    /api/blacklist/{id}                   # Обновить
POST   /api/blacklist/{id}/remove            # Снять с ЧС
POST   /api/blacklist/{id}/reactivate        # Восстановить в ЧС
GET    /api/blacklist/check                  # Проверить кандидата (MANAGER тоже)
GET    /api/blacklist/{id}/history           # История
GET    /api/blacklist/stats                  # Статистика
GET    /api/blacklist/categories             # Категории причин
```

### Сотрудники, Колонки, Справочники, 9-Box, Резюме
— Стандартный CRUD с фильтрацией по ДЗО

---

## 7. База данных

### Таблицы

| Таблица | Описание | Миграция |
|---------|----------|----------|
| dzos | ДЗО (организации) | V15 |
| users | Пользователи (+ full_name) | V1, V26 |
| user_roles | Связь пользователь-роль | V17 |
| hr_bp_assignments | Назначения HR BP на ДЗО | V18 |
| employees | Сотрудники (JSONB) | V4 |
| employee_history | История изменений сотрудников | V5 |
| applications | Заявки на развитие/ротацию | V19 |
| application_history | История изменений заявок | V20 |
| blacklist | Чёрный список кандидатов | V21 |
| blacklist_history | История изменений ЧС | V22 |
| column_definitions | Метаданные колонок | V3 |
| dictionaries | Справочники | V2 |
| column_presets | Пресеты колонок | V7 |
| saved_filters | Сохранённые фильтры | V9 |
| record_locks | Блокировки записей | V10 |
| user_sessions | Сессии | V11 |
| nine_box_assessments | 9-Box оценки | V12 |
| employee_resumes | Резюме | V13 |

### Миграции

| Версия | Файл | Описание |
|--------|------|----------|
| V1-V14 | ... | Базовая структура |
| V15 | create_dzos_table.sql | Таблица ДЗО |
| V16 | add_dzo_id_to_tables.sql | dzo_id во все таблицы |
| V17 | update_user_roles.sql | Таблица user_roles |
| V18 | create_hr_bp_assignments.sql | Назначения HR BP |
| V19 | create_applications_table.sql | Таблица заявок |
| V20 | create_application_history_table.sql | История заявок |
| V21 | create_blacklist_table.sql | Таблица чёрного списка |
| V22 | create_blacklist_history_table.sql | История чёрного списка |
| V26 | add_full_name_to_users.sql | Поле ФИО в users |
| V29 | seed_dzo_users.sql | Seed 50 пользователей ДЗО |

---

## 8. Credentials

| Сервис | Хост | Порт | Учётные данные |
|--------|------|------|----------------|
| Frontend | localhost | 31080 | — |
| Backend API | localhost | 31081 | — |
| PostgreSQL | localhost | 31432 | resourcedb / resourceuser / resourcepass |
| Admin | — | — | admin / admin123 |
| Test Users | — | — | user1-user10 / user |
| **ДЗО Users** | — | — | **50 пользователей**: {dzo_prefix}_{role} / pass123 |

### Пользователи ДЗО (V29)

**10 ДЗО × 5 ролей = 50 пользователей**

| ДЗО | Код | Префиксы логинов |
|-----|-----|------------------|
| ЦОД | rt-dc | cod_* |
| Солар | rt-solar | solar_* |
| БФТ | bft | bft_* |
| Т2 | t2 | t2_* |
| Базис | basistech | basis_* |
| РТЛабс | rtlabs | labs_* |
| ОМП | omp | omp_* |
| ПАО РТК | pao-rtk | paortk_* |
| РТК | rtk | rtk_* |
| РТК ИТ | rtk-it | rtkit_* |

**Роли для каждого ДЗО:**
- `{prefix}_dzo_admin` - DZO_ADMIN
- `{prefix}_recruiter` - RECRUITER
- `{prefix}_hr_bp` - HR_BP
- `{prefix}_borup` - BORUP
- `{prefix}_manager` - MANAGER

**Пароль для всех:** `pass123`

**Пример:** `cod_hr_bp` / `pass123` - Сидорова Елена Александровна, HR BP ЦОД

---

## 9. Команды

```bash
# Запуск всего стека
cd E:\Birzha && docker-compose up --build -d

# Логи
docker logs resource-manager-backend -f

# Проверка API
curl -X POST http://localhost:31081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

---

## 10. История версий

| Версия | Дата | Описание |
|--------|------|----------|
| 1.0.0 | — | Исходная система |
| 1.1.0 | 2026-01-21 | Phase 1: Мультитенантность (ДЗО) |
| 1.2.0 | 2026-01-21 | Phase 2: Расширенная ролевая модель |
| 1.3.0 | 2026-01-21 | Phase 3: Заявки — Backend |
| 1.4.0 | 2026-01-21 | Phase 4: Заявки — Workflow |
| 1.5.0 | 2026-01-21 | Phase 5: Заявки — Frontend UI |
| 1.6.0 | 2026-01-21 | Чёрный список кандидатов |
| 1.6.1 | 2026-01-22 | **Улучшения AdminView**: ФИО пользователей, поиск по ФИО, 50 тестовых пользователей ДЗО |

---

## 11. Изменения v1.6.1 (2026-01-22)

### Backend
- **V26**: Добавлено поле `full_name VARCHAR(255)` в таблицу `users`
- **V29**: Seed данные - 50 пользователей для 10 ДЗО (5 ролей на каждое ДЗО)
- **UserRepository**: Новый метод поиска `findByUsernameContainingIgnoreCaseOrFullNameContainingIgnoreCase`
  - Поиск по логину ИЛИ ФИО (регистронезависимый)
  - Поиск подстроки в любой части строки

### Frontend
- **AdminView.vue**:
  - Добавлена колонка "ФИО" в таблицу пользователей
  - Удалена колонка "Создан"
  - Автоматический поиск с дебаунсом 500ms
  - Placeholder: "Поиск по логину или ФИО"

### Данные
- **50 тестовых пользователей** с русскими ФИО
- Пароль для всех: `pass123`
- Полный список в [users_list.txt](E:\Birzha\users_list.txt)

---

**Дата актуальности:** 2026-01-22
**Автор:** Claude Code Agent
