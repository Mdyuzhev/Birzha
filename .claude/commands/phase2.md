# /phase2 — Backend Admin

Расширение backend: управление колонками, справочниками, пользователями, история изменений.

---

## Предварительные условия

Фаза 1 должна быть завершена — backend компилируется, авторизация работает.

---

## Шаги выполнения

### 1. Создать ColumnController и ColumnService

```java
// Только для ADMIN
GET    /api/columns         — список всех колонок (отсортированный)
POST   /api/columns         — создание колонки
PUT    /api/columns/{id}    — обновление колонки
DELETE /api/columns/{id}    — удаление колонки
PUT    /api/columns/reorder — изменение порядка (принимает List<Long> ids)
```

DTO: ColumnDto с полями name, displayName, fieldType, dictionaryId, sortOrder, isRequired

Валидация:
- name — уникальный, только латиница и underscore
- displayName — не пустой
- fieldType — один из TEXT, SELECT, DATE, NUMBER
- если fieldType = SELECT, то dictionaryId обязателен

### 2. Создать DictionaryController и DictionaryService

```java
// Только для ADMIN
GET    /api/dictionaries      — список всех справочников
POST   /api/dictionaries      — создание
PUT    /api/dictionaries/{id} — обновление
DELETE /api/dictionaries/{id} — удаление (проверить что не используется в columns)
```

DTO: DictionaryDto с полями name, displayName, values (List<String>)

### 3. Создать UserController и UserService

```java
// Только для ADMIN
GET    /api/users      — список пользователей (без паролей)
POST   /api/users      — создание (хешировать пароль)
PUT    /api/users/{id} — обновление (пароль опционально)
DELETE /api/users/{id} — деактивация (не удаление)
```

DTO: UserDto, CreateUserRequest (с паролем), UpdateUserRequest

### 4. Реализовать HistoryService

При каждом изменении Employee автоматически записывать в employee_history:
- Сравнивать старые и новые значения
- Записывать только изменённые поля
- changed_by берётся из SecurityContext

```java
@Service
public class HistoryService {
    public void recordChanges(Employee oldEmployee, Employee newEmployee, Long userId) {
        // Сравнить fullName, email
        // Сравнить каждое поле в customFields
        // Записать различия в employee_history
    }
}
```

### 5. Добавить endpoint истории

```java
GET /api/employees/{id}/history — список изменений для сотрудника
```

### 6. Настроить Role-based access

В SecurityConfig:

```java
.requestMatchers("/api/columns/**").hasRole("ADMIN")
.requestMatchers("/api/dictionaries/**").hasRole("ADMIN")
.requestMatchers("/api/users/**").hasRole("ADMIN")
.requestMatchers("/api/employees/**").authenticated()
.requestMatchers("/api/auth/**").permitAll()
```

### 7. Добавить валидацию в EmployeeService

При создании/обновлении проверять:
- Обязательные поля (isRequired в column_definitions) заполнены
- Значения SELECT-полей есть в соответствующем справочнике

---

## Проверка результата

```bash
# Получить токен админа
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | jq -r '.token')

# Тест колонок
curl -s http://localhost:8080/api/columns \
  -H "Authorization: Bearer $TOKEN" | jq

# Создать новую колонку
curl -s -X POST http://localhost:8080/api/columns \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"phone","displayName":"Телефон","fieldType":"TEXT","isRequired":false}' | jq

# Тест справочников
curl -s http://localhost:8080/api/dictionaries \
  -H "Authorization: Bearer $TOKEN" | jq

# Добавить значение в справочник
curl -s -X PUT http://localhost:8080/api/dictionaries/1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"grades","displayName":"Грейд","values":["Junior","Middle","Senior","Lead","Principal","Architect"]}' | jq

# Создать пользователя
curl -s -X POST http://localhost:8080/api/users \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"user123","role":"USER"}' | jq

# Тест истории — изменить сотрудника
curl -s -X PUT http://localhost:8080/api/employees/1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Иванов Иван Иванович","email":"ivanov@company.ru","customFields":{"status":"На бенче","project":""}}' | jq

# Проверить историю
curl -s http://localhost:8080/api/employees/1/history \
  -H "Authorization: Bearer $TOKEN" | jq
```

---

## Критерии завершения фазы

- CRUD для колонок работает
- CRUD для справочников работает
- CRUD для пользователей работает (пароли хешируются)
- История изменений записывается автоматически
- Endpoints защищены по ролям (USER не может менять колонки)
