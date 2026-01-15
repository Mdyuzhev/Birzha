# /phase1 — Backend Core

Создание основы backend: структура проекта, авторизация, CRUD сотрудников.

---

## Шаги выполнения

### 1. Создать структуру Maven проекта

```bash
mkdir -p backend/src/main/java/com/company/resourcemanager/{config,controller,service,repository,entity,dto,security,exception}
mkdir -p backend/src/main/resources/db/migration
mkdir -p backend/src/test/java/com/company/resourcemanager
```

### 2. Создать pom.xml

Зависимости:
- spring-boot-starter-web
- spring-boot-starter-data-jpa
- spring-boot-starter-security
- spring-boot-starter-validation
- postgresql
- flyway-core
- jjwt-api, jjwt-impl, jjwt-jackson (0.12.x)
- lombok
- spring-boot-starter-test

### 3. Создать application.yml

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:31432/resourcedb
    username: resourceuser
    password: resourcepass
  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
  flyway:
    enabled: true

jwt:
  secret: resource-manager-jwt-secret-key-minimum-32-characters
  expiration: 86400000

server:
  port: 8080
```

### 4. Создать Flyway миграции

V1__create_users.sql — таблица users
V2__create_dictionaries.sql — таблица dictionaries
V3__create_columns.sql — таблица column_definitions
V4__create_employees.sql — таблица employees с GIN индексом
V5__create_history.sql — таблица employee_history
V6__init_data.sql — начальные данные (admin, справочники, колонки)

### 5. Создать Entity классы

User.java — с @Entity, полями id, username, passwordHash, role, createdAt, createdBy
Employee.java — с JSONB полем customFields (используй @Type или @JdbcTypeCode)
ColumnDefinition.java
Dictionary.java — с JSONB полем values
EmployeeHistory.java

### 6. Создать Repository интерфейсы

UserRepository — findByUsername
EmployeeRepository — с @Query для фильтрации по JSONB
ColumnDefinitionRepository — findAllByOrderBySortOrder
DictionaryRepository
EmployeeHistoryRepository — findByEmployeeIdOrderByChangedAtDesc

### 7. Реализовать JWT Security

JwtTokenProvider.java — generateToken, validateToken, getUserIdFromToken
JwtAuthenticationFilter.java — extends OncePerRequestFilter
SecurityConfig.java — настройка endpoints, CORS, BCrypt encoder
UserPrincipal.java — implements UserDetails

### 8. Создать AuthController и AuthService

POST /api/auth/login — принимает LoginRequest, возвращает LoginResponse с токеном
GET /api/auth/me — возвращает текущего пользователя

### 9. Создать EmployeeController и EmployeeService

GET /api/employees — с пагинацией и фильтрацией
GET /api/employees/{id}
POST /api/employees
PUT /api/employees/{id}
DELETE /api/employees/{id}

### 10. Создать GlobalExceptionHandler

Обработка ResourceNotFoundException, ValidationException, AuthenticationException

---

## Проверка результата

```bash
# Запустить PostgreSQL
docker-compose up -d postgres

# Подождать готовности
sleep 5

# Запустить backend
cd backend
./mvnw spring-boot:run &
sleep 15

# Тест авторизации
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | jq -r '.token')

echo "Token: $TOKEN"

# Тест получения сотрудников
curl -s http://localhost:8080/api/employees \
  -H "Authorization: Bearer $TOKEN" | jq

# Тест создания сотрудника
curl -s -X POST http://localhost:8080/api/employees \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Тестов Тест","email":"test@test.ru","customFields":{"status":"На бенче"}}' | jq
```

---

## Критерии завершения фазы

- Backend компилируется без ошибок
- Flyway применяет все миграции
- Логин возвращает JWT токен
- CRUD для employees работает через curl
- Защищённые endpoints требуют токен
