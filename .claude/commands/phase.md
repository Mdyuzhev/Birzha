# /phase — Выполнение фазы разработки

Пошаговое выполнение фазы из плана проекта.

## Usage

```
/phase 1            # Выполнить Фазу 1 (Backend Core)
/phase 2            # Выполнить Фазу 2 (Backend Admin)
/phase 3            # Выполнить Фазу 3 (Frontend Core)
/phase 4            # Выполнить Фазу 4 (Frontend Admin + Docker)
/phase status       # Показать прогресс по фазам
```

---

## /phase 1 — Backend Core

### Цель
Создать работающий backend с JWT авторизацией и CRUD для сотрудников.

### Шаги

**1.1 Структура проекта**
```
backend/
├── pom.xml (Spring Boot 3.x, Security, JPA, Flyway, jjwt)
└── src/main/java/com/company/resourcemanager/
    └── ResourceManagerApplication.java
```

**1.2 Entities и миграции**
- User.java (id, username, password_hash, role)
- Employee.java (id, full_name, email, custom_fields JSONB)
- Dictionary.java (id, name, display_name, values JSONB)
- ColumnDefinition.java (id, name, display_name, field_type, dictionary_id)
- EmployeeHistory.java (id, employee_id, changed_by, field_name, old_value, new_value)

Flyway миграции V1-V6 в `src/main/resources/db/migration/`

**1.3 Security конфигурация**
- SecurityConfig.java — отключить CSRF, настроить endpoints
- JwtTokenProvider.java — генерация и валидация токенов
- JwtAuthenticationFilter.java — фильтр для проверки токенов
- UserDetailsServiceImpl.java — загрузка пользователя из БД

**1.4 Auth API**
- AuthController.java: POST /api/auth/login, GET /api/auth/me
- AuthService.java: логика авторизации
- LoginRequest.java, LoginResponse.java: DTO

**1.5 Employees API**
- EmployeeController.java: GET/POST/PUT /api/employees
- EmployeeService.java: CRUD логика
- EmployeeRepository.java: JPA с поддержкой JSONB-фильтрации
- EmployeeDto.java: DTO для API

### Проверка
```bash
./mvnw spring-boot:run &
sleep 10
curl -X POST http://localhost:31081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

---

## /phase 2 — Backend Admin

### Цель
Добавить админские функции и аудит изменений.

### Шаги

**2.1 Columns API**
- ColumnController.java: CRUD для колонок (только ADMIN)
- ColumnService.java: бизнес-логика
- ColumnDefinitionRepository.java

**2.2 Dictionaries API**
- DictionaryController.java: CRUD для справочников (только ADMIN)
- DictionaryService.java
- DictionaryRepository.java

**2.3 Users API**
- UserController.java: создание пользователей (только ADMIN)
- UserService.java: с BCrypt для паролей
- UserDto.java

**2.4 История изменений**
- HistoryService.java: запись изменений в employee_history
- Интеграция с EmployeeService: перед обновлением фиксировать старые значения

**2.5 Role-based access**
- @PreAuthorize("hasRole('ADMIN')") на админских endpoints
- GlobalExceptionHandler: обработка AccessDeniedException

### Проверка
```bash
# Получить токен админа
TOKEN=$(curl -s -X POST http://localhost:31081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | jq -r '.token')

# Создать колонку
curl -X POST http://localhost:31081/api/columns \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"department","displayName":"Отдел","fieldType":"TEXT"}'
```

---

## /phase 3 — Frontend Core

### Цель
Создать Vue приложение с таблицей сотрудников.

### Шаги

**3.1 Структура проекта**
```bash
npm create vite@latest frontend -- --template vue
cd frontend
npm install axios pinia vue-router element-plus
```

**3.2 Конфигурация**
- vite.config.js: proxy на backend
- main.js: подключение Pinia, Router, Element Plus
- router/index.js: маршруты

**3.3 Auth**
- stores/auth.js: хранение токена, login/logout
- api/auth.js: вызовы API
- views/LoginView.vue: форма входа

**3.4 Employees**
- stores/employees.js: список сотрудников
- api/employees.js: CRUD вызовы
- views/EmployeesView.vue: страница со списком
- components/EmployeeTable.vue: таблица с динамическими колонками
- components/EmployeeForm.vue: форма создания/редактирования

**3.5 Защита роутов**
- router/index.js: navigation guard для проверки авторизации

### Проверка
```bash
npm run dev
# Открыть http://localhost:5173
# Залогиниться admin/admin123
# Увидеть таблицу сотрудников
```

---

## /phase 4 — Frontend Admin + Docker

### Цель
Завершить функциональность и собрать в Docker.

### Шаги

**4.1 Админка**
- views/AdminColumnsView.vue: управление колонками
- views/AdminDictionariesView.vue: управление справочниками
- views/AdminUsersView.vue: управление пользователями

**4.2 Фильтрация**
- components/FilterPanel.vue: панель фильтров
- Интеграция с EmployeeTable: применение фильтров

**4.3 История**
- components/HistoryDialog.vue: просмотр истории изменений
- api/employees.js: метод getHistory

**4.4 Docker**
- backend/Dockerfile: multi-stage build
- frontend/Dockerfile: nginx с собранным SPA
- frontend/nginx.conf: проксирование /api на backend
- docker-compose.yml: все сервисы

### Проверка
```bash
docker-compose up --build
# Открыть http://localhost:31080
# Проверить все функции
```

---

## /phase status

```bash
echo "=== PHASE STATUS ==="

# Check Phase 1
echo "Phase 1: Backend Core"
if [ -f "backend/pom.xml" ] && [ -d "backend/src/main/java" ]; then
    ENTITIES=$(find backend/src -name "*.java" -path "*/entity/*" 2>/dev/null | wc -l)
    if [ "$ENTITIES" -ge 4 ]; then
        echo "  ✅ Complete ($ENTITIES entities)"
    else
        echo "  🔄 In progress ($ENTITIES/5 entities)"
    fi
else
    echo "  ⬜ Not started"
fi

# Check Phase 2
echo "Phase 2: Backend Admin"
ADMIN_CONTROLLERS=$(grep -rl "hasRole.*ADMIN" backend/src 2>/dev/null | wc -l)
if [ "$ADMIN_CONTROLLERS" -ge 2 ]; then
    echo "  ✅ Complete"
else
    echo "  ⬜ Not started"
fi

# Check Phase 3
echo "Phase 3: Frontend Core"
if [ -f "frontend/package.json" ]; then
    VIEWS=$(find frontend/src -name "*View.vue" 2>/dev/null | wc -l)
    if [ "$VIEWS" -ge 2 ]; then
        echo "  ✅ Complete ($VIEWS views)"
    else
        echo "  🔄 In progress"
    fi
else
    echo "  ⬜ Not started"
fi

# Check Phase 4
echo "Phase 4: Docker"
if [ -f "docker-compose.yml" ] && [ -f "backend/Dockerfile" ] && [ -f "frontend/Dockerfile" ]; then
    echo "  ✅ Complete"
else
    echo "  ⬜ Not started"
fi
```

## Output

```markdown
## 📊 Phase Status

| Phase | Description | Status |
|-------|-------------|--------|
| 1 | Backend Core | ✅ Complete |
| 2 | Backend Admin | ✅ Complete |
| 3 | Frontend Core | 🔄 In Progress |
| 4 | Docker | ⬜ Not Started |

**Current:** Phase 3 (Frontend Core)
**Next:** Create EmployeeForm.vue component
```
