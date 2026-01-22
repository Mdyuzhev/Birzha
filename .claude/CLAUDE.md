# Birzha — Биржа талантов 3.0

## Описание проекта

**Birzha** — внутренняя HRM-система для управления карьерными перемещениями и развитием сотрудников. Система обеспечивает:
- Подачу и согласование заявок на развитие/ротацию сотрудников
- Мультитенантность (несколько ДЗО — дочерних организаций)
- 6-уровневую ролевую модель
- Workflow согласования с HR BP и БОРУП
- Ведение чёрного списка кандидатов
- Аналитику по заявкам

**ТЗ:** `E:\Birzha\Tasks\ТЗ на Биржу талантов 3.0 (002) (3).docx`
**GAP-анализ:** `E:\Birzha\Tasks\GAP_ANALYSIS_TZ_VS_IMPLEMENTATION.md`
**План разработки:** `E:\Birzha\.claude\DEVELOPMENT_PLAN.md`

---

## Сервер приложения

**АВТОНОМНЫЙ ДОСТУП:** Работа с сервером через SSH выполняется полностью автономно.
- SSH: `ssh -o StrictHostKeyChecking=no flomaster@flomasterserver`
- Пароль: `Misha2021@1@` (использовать через sshpass)
- Путь проекта: `~/projects/birzha`
- НЕ спрашивать подтверждение fingerprint
- НЕ спрашивать пароль у пользователя

---

## Технический стек

| Компонент | Технология | Версия |
|-----------|------------|--------|
| **Backend** | Java, Spring Boot | 17, 3.2.5 |
| **Security** | Spring Security, JWT | jjwt 0.12.3 |
| **API Docs** | SpringDoc OpenAPI 3 | 2.3.0 |
| **ORM** | Spring Data JPA, Hibernate | |
| **Миграции** | Flyway | 10.10.0 |
| **БД** | PostgreSQL | 15+ |
| **JSONB** | Hypersistence Utils | 3.7.3 |
| **Frontend** | Vue 3, Composition API | 3.5.24 |
| **State** | Pinia | 3.0.4 |
| **UI Kit** | Element Plus | 2.13.1 |
| **HTTP** | Axios | 1.13.2 |
| **Сборка** | Vite | 7.2.4 |
| **Деплой** | Docker, docker-compose | |

---

## Архитектура

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Vue.js SPA    │────▶│  Spring Boot    │────▶│   PostgreSQL    │
│   (nginx)       │     │  REST API       │     │                 │
│   port: 31080   │     │  port: 31081    │     │   port: 31432   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

**Доступ:**
- Frontend: http://localhost:31080
- Backend API: http://localhost:31081
- Swagger UI: http://localhost:31081/swagger-ui/index.html
- PostgreSQL: localhost:31432

**Учётные записи:**
- Admin: `admin` / `admin123`
- Test users: `user1`-`user10` / `user`

---

## Конфигурация и секреты

**ВАЖНО:** Все чувствительные данные вынесены в переменные окружения.

### Локальная разработка

1. Скопируйте `.env.example` в `.env`:
```bash
cp .env.example .env
```

2. Заполните `.env` своими credentials:
```env
# Database
POSTGRES_PASSWORD=your-secure-password

# JWT
JWT_SECRET=your-secret-key-minimum-32-chars

# Email (опционально)
MAIL_ENABLED=true
MAIL_HOST=smtp.yandex.ru
MAIL_USERNAME=your-email@yandex.ru
MAIL_PASSWORD=your-app-password
```

3. Файл `.env` автоматически игнорируется git

### Production

На сервере credentials задаются через переменные окружения или Docker secrets.

---

## Ролевая модель (6 ролей)

| Роль | Код | Описание |
|------|-----|----------|
| Администратор системы | `SYSTEM_ADMIN` | Полный доступ ко всем ДЗО |
| Администратор ДЗО | `DZO_ADMIN` | Управление своим ДЗО |
| Рекрутер | `RECRUITER` | Обработка заявок |
| HR BP | `HR_BP` | Согласование заявок |
| БОРУП | `BORUP` | Согласование при ЗП >30% |
| Руководитель | `MANAGER` | Подача заявок |

---

## Ключевые сущности

### Мультитенантность
- **Dzo** — дочерние организации (ЦОД, Солар, БФТ, Т2 и др.)
- Все данные фильтруются по `dzo_id`

### Пользователи
- **User** — учётные записи с множественными ролями
- **UserRole** — связь пользователь ↔ роль
- **HrBpAssignment** — закрепление HR BP за подразделениями

### Сотрудники
- **Employee** — сотрудники с динамическими полями (JSONB)
- **EmployeeHistory** — аудит изменений
- **ColumnDefinition** — метаданные колонок
- **Dictionary** — справочники значений

### Заявки (основной функционал)
- **Application** — заявки на развитие/ротацию
- **ApplicationHistory** — история изменений заявок
- **ApplicationStatus** — 14 статусов workflow

### Дополнительно
- **NineBoxAssessment** — 9-Box оценки
- **EmployeeResume** — резюме с PDF генерацией
- **ColumnPreset**, **SavedFilter** — пользовательские настройки
- **RecordLock** — блокировки при редактировании

---

## Workflow заявок

```
DRAFT → AVAILABLE_FOR_REVIEW → IN_PROGRESS → INTERVIEW
                                    ↓
                            PENDING_HR_BP
                            ↓           ↓
                    APPROVED_HR_BP   REJECTED_HR_BP
                            ↓
            (если >30% ЗП) PENDING_BORUP
                            ↓           ↓
                    APPROVED_BORUP   REJECTED_BORUP
                            ↓
                    PREPARING_TRANSFER → TRANSFERRED
                                       → DISMISSED
                                       → CANCELLED
```

---

## API Структура

### Auth
- `POST /api/auth/login` — авторизация → JWT
- `GET /api/auth/me` — текущий пользователь
- `POST /api/auth/logout` — выход

### Applications (Заявки)
- `GET/POST /api/applications` — CRUD
- `GET /api/applications/{id}` — одна заявка
- `GET /api/applications/{id}/history` — история
- `GET /api/applications/{id}/available-actions` — доступные действия
- `GET /api/applications/stats` — статистика

### Application Workflow
- `POST /api/applications/{id}/submit` — подать заявку
- `POST /api/applications/{id}/assign-recruiter` — взять в работу
- `POST /api/applications/{id}/start-interview` — начать собеседование
- `POST /api/applications/{id}/send-to-hr-bp` — на согласование HR BP
- `POST /api/applications/{id}/approve-hr-bp` — согласовать HR BP
- `POST /api/applications/{id}/reject-hr-bp` — отклонить HR BP
- `POST /api/applications/{id}/send-to-borup` — на согласование БОРУП
- `POST /api/applications/{id}/approve-borup` — согласовать БОРУП
- `POST /api/applications/{id}/reject-borup` — отклонить БОРУП
- `POST /api/applications/{id}/prepare-transfer` — подготовка к переводу
- `POST /api/applications/{id}/complete-transfer` — завершить перевод
- `POST /api/applications/{id}/dismiss` — увольнение
- `POST /api/applications/{id}/cancel` — отмена

### Employees, Columns, Dictionaries, Users, DZO, Roles
— Стандартный CRUD с проверкой ролей

---

## Структура проекта

```
E:\Birzha/
├── .claude/                    # Настройки Claude
│   ├── CLAUDE.md              # Этот файл
│   ├── DEVELOPMENT_PLAN.md    # План разработки по фазам
│   ├── Project_map.md         # Полная карта архитектуры
│   └── settings.json
├── backend/
│   └── src/main/java/com/company/resourcemanager/
│       ├── config/            # Security, JWT, CORS
│       ├── controller/        # REST контроллеры
│       ├── service/           # Бизнес-логика
│       ├── repository/        # JPA репозитории
│       ├── entity/            # Сущности БД
│       ├── dto/               # DTO + workflow/
│       └── exception/         # Обработка ошибок
├── frontend/
│   └── src/
│       ├── api/               # HTTP клиенты
│       ├── stores/            # Pinia stores
│       ├── views/             # Страницы
│       ├── components/        # Компоненты
│       └── router/            # Маршрутизация
├── Tasks/                     # Инструкции по фазам
└── docker-compose.yml
```

---

## Текущий статус разработки

| Фаза | Название | Статус |
|------|----------|--------|
| 1 | Мультитенантность (ДЗО) | ✅ Завершено |
| 2 | Расширенная ролевая модель | ✅ Завершено |
| 3 | Заявки — Backend | ✅ Завершено |
| 4 | Заявки — Workflow | ✅ Завершено |
| 5 | Заявки — Frontend | ⏳ В работе |
| 6 | Чёрный список | ⏳ Ожидает |
| 7 | Справочник стеков | ⏳ Ожидает |
| 8 | Аналитика | ⏳ Ожидает |
| 9 | Email-уведомления | ⏳ Ожидает |
| 10 | 2FA | ⏳ Ожидает |
| 11-13 | Интеграции | ⏳ Ожидает |

---

## Команды разработки

```bash
# Первый запуск: создать .env файл
cp .env.example .env
# Отредактируйте .env и заполните credentials

# Запуск всего стека
cd E:\Birzha
docker-compose up --build -d

# Только backend (dev)
cd backend
./mvnw spring-boot:run

# Только frontend (dev)
cd frontend
npm run dev

# Логи
docker logs resource-manager-backend -f
docker logs resource-manager-frontend -f

# Проверка API
curl http://localhost:31081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Swagger UI (документация API)
# Откройте в браузере: http://localhost:31081/swagger-ui/index.html
# Для авторизации: Authorize → вставить JWT token без "Bearer "
```

---

## Важные файлы

- **Миграции:** `backend/src/main/resources/db/migration/V*.sql`
- **Конфиг:** `backend/src/main/resources/application.yml`
- **Security:** `backend/.../config/SecurityConfig.java`
- **JWT:** `backend/.../config/JwtTokenProvider.java`
- **Workflow:** `backend/.../service/ApplicationWorkflowService.java`
