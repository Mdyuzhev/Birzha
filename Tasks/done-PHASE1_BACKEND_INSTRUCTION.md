# Инструкция: Фаза 1 — Backend Core

## Контекст

Создаём систему управления ресурсами (сотрудниками). Это первая фаза — нужно создать работающий Spring Boot backend с JWT авторизацией и CRUD для сотрудников.

Прочитай `CLAUDE.md` в корне проекта — там полная спецификация: модель данных, API endpoints, структура проекта.

## Цель фазы

Получить работающий backend, который:
- Запускается и отвечает на запросы
- Позволяет залогиниться и получить JWT токен
- Позволяет получить список сотрудников и редактировать их
- Хранит данные в PostgreSQL

## Шаги выполнения

### Шаг 1: Структура Maven проекта

Создай директорию `backend/` и внутри неё:

1.1. Файл `pom.xml` со следующими зависимостями:
- spring-boot-starter-web
- spring-boot-starter-data-jpa
- spring-boot-starter-security
- spring-boot-starter-validation
- postgresql driver
- flyway-core
- jjwt-api, jjwt-impl, jjwt-jackson (версия 0.12.3)
- lombok
- spring-boot-starter-test (scope test)

Версия Spring Boot: 3.2.x
Версия Java: 17

1.2. Создай структуру пакетов:
```
src/main/java/com/company/resourcemanager/
├── ResourceManagerApplication.java
├── config/
├── controller/
├── service/
├── repository/
├── entity/
├── dto/
└── exception/
```

1.3. Создай `src/main/resources/application.yml`:
```yaml
spring:
  datasource:
    url: jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:31432}/${DB_NAME:resourcedb}
    username: ${DB_USER:resourceuser}
    password: ${DB_PASSWORD:resourcepass}
  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
  flyway:
    enabled: true
    locations: classpath:db/migration

server:
  port: 8080

jwt:
  secret: ${JWT_SECRET:default-secret-key-for-development-minimum-32-chars}
  expiration: 86400000

logging:
  level:
    com.company.resourcemanager: DEBUG
```

### Шаг 2: Flyway миграции

Создай миграции в `src/main/resources/db/migration/`:

2.1. `V1__create_users_table.sql` — таблица users
2.2. `V2__create_dictionaries_table.sql` — таблица dictionaries  
2.3. `V3__create_column_definitions_table.sql` — таблица column_definitions
2.4. `V4__create_employees_table.sql` — таблица employees
2.5. `V5__create_employee_history_table.sql` — таблица employee_history
2.6. `V6__init_data.sql` — начальные данные (админ, справочники, колонки)

SQL схемы возьми из `CLAUDE.md`. Для V6 используй данные из `init-data.sql` в корне проекта.

### Шаг 3: JPA Entities

Создай entity-классы в пакете `entity/`:

3.1. `User.java` — пользователь системы
3.2. `Dictionary.java` — справочник (values как JSONB)
3.3. `ColumnDefinition.java` — определение колонки
3.4. `Employee.java` — сотрудник (custom_fields как JSONB)
3.5. `EmployeeHistory.java` — запись истории изменений

Для работы с JSONB используй:
```java
@Type(JsonBinaryType.class)
@Column(columnDefinition = "jsonb")
private Map<String, Object> customFields;
```

Добавь зависимость hypersistence-utils-hibernate-63 для JsonBinaryType.

### Шаг 4: Security и JWT

4.1. Создай `config/SecurityConfig.java`:
- Отключи CSRF (stateless API)
- Настрой CORS для localhost
- Разреши без авторизации: /api/auth/login, /actuator/health
- Остальные endpoints требуют JWT

4.2. Создай `config/JwtTokenProvider.java`:
- Метод generateToken(username, role) — создаёт токен
- Метод validateToken(token) — проверяет подпись и срок
- Метод getUsernameFromToken(token) — извлекает username

4.3. Создай `config/JwtAuthenticationFilter.java`:
- Extends OncePerRequestFilter
- Извлекает токен из заголовка Authorization: Bearer xxx
- Валидирует и устанавливает SecurityContext

### Шаг 5: Auth Controller и Service

5.1. `dto/LoginRequest.java` — username, password
5.2. `dto/LoginResponse.java` — token, username, role
5.3. `dto/UserDto.java` — id, username, role, createdAt

5.4. `service/AuthService.java`:
- login(username, password) — проверяет credentials, возвращает токен
- getCurrentUser() — возвращает текущего пользователя из SecurityContext

5.5. `controller/AuthController.java`:
- POST /api/auth/login — авторизация
- GET /api/auth/me — текущий пользователь

### Шаг 6: Employee CRUD

6.1. DTO:
- `EmployeeDto.java` — полные данные сотрудника
- `EmployeeListDto.java` — краткие данные для списка
- `CreateEmployeeRequest.java` — данные для создания
- `UpdateEmployeeRequest.java` — данные для обновления

6.2. `repository/EmployeeRepository.java`:
- Стандартные JpaRepository методы
- Кастомный метод поиска с фильтрацией (можно через Specification)

6.3. `service/EmployeeService.java`:
- findAll(filters, pageable) — список с фильтрацией
- findById(id) — один сотрудник
- create(request) — создание
- update(id, request) — обновление с записью в историю
- delete(id) — удаление (или soft delete)

6.4. `controller/EmployeeController.java`:
- GET /api/employees — список
- GET /api/employees/{id} — один
- POST /api/employees — создание
- PUT /api/employees/{id} — обновление
- DELETE /api/employees/{id} — удаление

### Шаг 7: Exception Handling

7.1. `exception/ResourceNotFoundException.java`
7.2. `exception/BadRequestException.java`
7.3. `exception/GlobalExceptionHandler.java` с @ControllerAdvice

### Шаг 8: Dockerfile

Создай `backend/Dockerfile`:
```dockerfile
FROM eclipse-temurin:17-jdk as build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN ./mvnw package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## Проверка результата

После выполнения всех шагов:

1. Запусти PostgreSQL:
```bash
docker-compose up -d postgres
```

2. Дождись готовности (healthcheck пройдёт)

3. Собери и запусти backend:
```bash
cd backend
./mvnw spring-boot:run
```

4. Проверь endpoints:
```bash
# Health check
curl http://localhost:8080/actuator/health

# Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Сохрани токен и проверь employees
TOKEN="<токен из ответа>"
curl http://localhost:8080/api/employees \
  -H "Authorization: Bearer $TOKEN"
```

## Критерии завершения фазы

- [ ] Backend компилируется без ошибок
- [ ] Flyway миграции применяются при старте
- [ ] POST /api/auth/login возвращает JWT токен
- [ ] GET /api/employees возвращает список сотрудников
- [ ] POST /api/employees создаёт нового сотрудника
- [ ] PUT /api/employees/{id} обновляет сотрудника
- [ ] Запросы без токена возвращают 401

## Важно

- Используй Lombok (@Data, @Builder, @NoArgsConstructor, @AllArgsConstructor) для сокращения boilerplate
- Все строки в логах и исключениях на английском
- Коммить после каждого логического блока (после entities, после security, после CRUD)
- При ошибках компиляции — исправляй сразу, не накапливай

Приступай к выполнению. Начни с создания структуры проекта и pom.xml.
