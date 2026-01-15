# Resource Management Tool

## Описание проекта

Внутренняя система для отслеживания доступности сотрудников и их аллокации на проекты. Позволяет видеть кто занят, кто освободился и готов к новым задачам.

## Технический стек

**Backend**: Java 17+, Spring Boot 3.x, Spring Security, Spring Data JPA, Flyway
**Frontend**: Vue 3, Composition API, Pinia, Axios, Element Plus
**Database**: PostgreSQL 15+
**Auth**: JWT (jjwt library)
**Deploy**: Docker, docker-compose

## Архитектура

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Vue.js SPA    │────▶│  Spring Boot    │────▶│   PostgreSQL    │
│   (nginx)       │     │  REST API       │     │                 │
│   port: 31080   │     │  port: 31081    │     │   port: 31432   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

## Модель данных

### users (учётные записи)
```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'USER')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT REFERENCES users(id)
);
```

### employees (сотрудники)
```sql
CREATE TABLE employees (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    custom_fields JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_employees_custom_fields ON employees USING GIN (custom_fields);
```

### column_definitions (динамические колонки)
```sql
CREATE TABLE column_definitions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    field_type VARCHAR(20) NOT NULL CHECK (field_type IN ('TEXT', 'SELECT', 'DATE', 'NUMBER')),
    dictionary_id BIGINT REFERENCES dictionaries(id),
    sort_order INT DEFAULT 0,
    is_required BOOLEAN DEFAULT FALSE
);
```

### dictionaries (справочники)
```sql
CREATE TABLE dictionaries (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    values JSONB NOT NULL DEFAULT '[]'
);
```

### employee_history (аудит изменений)
```sql
CREATE TABLE employee_history (
    id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(id),
    changed_by BIGINT NOT NULL REFERENCES users(id),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    field_name VARCHAR(100) NOT NULL,
    old_value TEXT,
    new_value TEXT
);

CREATE INDEX idx_employee_history_employee ON employee_history(employee_id);
```

## API Endpoints

### Auth
POST /api/auth/login — авторизация, возвращает JWT
GET /api/auth/me — текущий пользователь

### Employees
GET /api/employees — список с фильтрацией и пагинацией
GET /api/employees/{id} — один сотрудник
POST /api/employees — создание
PUT /api/employees/{id} — обновление
DELETE /api/employees/{id} — удаление
GET /api/employees/{id}/history — история изменений

### Columns (только ADMIN)
GET /api/columns — список колонок
POST /api/columns — создание
PUT /api/columns/{id} — обновление
DELETE /api/columns/{id} — удаление
PUT /api/columns/reorder — изменение порядка

### Dictionaries (только ADMIN)
GET /api/dictionaries — список справочников
POST /api/dictionaries — создание
PUT /api/dictionaries/{id} — обновление
DELETE /api/dictionaries/{id} — удаление

### Users (только ADMIN)
GET /api/users — список пользователей
POST /api/users — создание
PUT /api/users/{id} — обновление
DELETE /api/users/{id} — деактивация

## Структура проекта

```
resource-manager/
├── .claude/
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── settings.local.json
│   └── commands/
├── backend/
│   ├── src/main/java/com/company/resourcemanager/
│   │   ├── ResourceManagerApplication.java
│   │   ├── config/
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── entity/
│   │   ├── dto/
│   │   ├── security/
│   │   └── exception/
│   ├── src/main/resources/
│   │   ├── application.yml
│   │   └── db/migration/
│   ├── pom.xml
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── views/
│   │   ├── stores/
│   │   ├── api/
│   │   ├── router/
│   │   └── utils/
│   ├── package.json
│   ├── vite.config.js
│   ├── nginx.conf
│   └── Dockerfile
├── docker-compose.yml
└── init-data.sql
```

## Фазы разработки

### Фаза 1: Backend Core
Структура проекта, pom.xml с зависимостями
Entities и Flyway миграции
JWT авторизация (login, token validation)
CRUD для employees с фильтрацией

### Фаза 2: Backend Admin
CRUD для columns, dictionaries, users
История изменений
Role-based access (ADMIN vs USER)

### Фаза 3: Frontend Core
Структура Vue проекта, роутинг
Страница логина
Таблица сотрудников с динамическими колонками
Форма добавления/редактирования

### Фаза 4: Frontend Admin + Docker
Админка: колонки, справочники, пользователи
Фильтрация и сортировка
Docker-compose с полной сборкой

## Критерии готовности

- Авторизация работает (admin/admin123)
- Таблица сотрудников с динамическими колонками
- CRUD для сотрудников
- Фильтрация по любому полю
- Админ управляет колонками и справочниками
- Админ создаёт пользователей
- История изменений записывается
- docker-compose поднимает всё одной командой
