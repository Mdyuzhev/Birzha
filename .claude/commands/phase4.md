# /phase4 — Frontend Admin + Docker

Завершение проекта: админка, фильтрация, Docker-образы.

---

## Предварительные условия

Фазы 1-3 завершены — backend и базовый frontend работают.

---

## Шаги выполнения

### 1. Создать AdminColumnsView.vue

Страница управления колонками:
- el-table со списком колонок
- Кнопка "Добавить колонку" → диалог с формой
- Редактирование по клику на строку
- Удаление с подтверждением
- Drag-and-drop для изменения порядка (el-table-draggable или кнопки вверх/вниз)

Форма колонки:
- name (латиница, readonly при редактировании)
- displayName
- fieldType (select: TEXT, SELECT, DATE, NUMBER)
- dictionaryId (показывать только если fieldType = SELECT)
- isRequired (checkbox)

### 2. Создать AdminDictionariesView.vue

Страница управления справочниками:
- el-table со списком справочников
- Кнопка "Добавить справочник"
- Редактирование значений — динамический список с кнопками добавить/удалить

Форма справочника:
- name (латиница)
- displayName
- values — список el-input с кнопками + и -

### 3. Создать AdminUsersView.vue

Страница управления пользователями:
- el-table: username, role, createdAt
- Кнопка "Добавить пользователя"
- Редактирование (смена роли, сброс пароля)
- Деактивация (не удаление)

Форма пользователя:
- username
- password (обязательно при создании, опционально при редактировании)
- role (select: ADMIN, USER)

### 4. Добавить навигацию для админа

В App.vue или отдельном компоненте Header.vue:
- Меню с ссылками: Сотрудники, [Админ: Колонки, Справочники, Пользователи]
- Админские ссылки показывать только для role=ADMIN
- Кнопка выхода

### 5. Реализовать фильтрацию в EmployeesView

FilterPanel.vue:
- Динамические фильтры на основе columns
- TEXT → el-input с поиском по подстроке
- SELECT → el-select с опциями из справочника
- DATE → el-date-picker range
- Кнопка "Сбросить фильтры"

Передавать фильтры в API: `GET /api/employees?filter[status]=На бенче&filter[grade]=Senior`

### 6. Добавить историю изменений

EmployeeHistory.vue — компонент или вкладка в форме сотрудника:
- Таблица: дата, пользователь, поле, старое значение, новое значение
- Загружать по `GET /api/employees/{id}/history`

### 7. Создать Dockerfile для backend

```dockerfile
# Build stage
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apk add --no-cache maven && mvn package -DskipTests

# Run stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 8. Создать Dockerfile для frontend

```dockerfile
# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Run stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 9. Создать nginx.conf

```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://backend:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 10. Финализировать docker-compose.yml

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: resourcedb
      POSTGRES_USER: resourceuser
      POSTGRES_PASSWORD: resourcepass
    ports:
      - "31432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U resourceuser -d resourcedb"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build: ./backend
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/resourcedb
      SPRING_DATASOURCE_USERNAME: resourceuser
      SPRING_DATASOURCE_PASSWORD: resourcepass
      JWT_SECRET: resource-manager-jwt-secret-key-minimum-32-characters
    ports:
      - "31081:8080"
    depends_on:
      postgres:
        condition: service_healthy

  frontend:
    build: ./frontend
    ports:
      - "31080:80"
    depends_on:
      - backend

volumes:
  postgres_data:
```

---

## Проверка результата

```bash
# Полная сборка
docker-compose down -v
docker-compose up --build

# Подождать запуска
sleep 30

# Проверить frontend
curl -s http://localhost:31080 | head -20

# Проверить API через nginx
curl -s -X POST http://localhost:31080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Открыть в браузере
echo "Open http://localhost:31080"
```

---

## Критерии завершения фазы

- docker-compose up --build запускает всё без ошибок
- Frontend доступен на http://localhost:31080
- Логин работает
- Таблица сотрудников отображается
- Фильтрация работает
- Админка доступна для admin
- Управление колонками работает
- Управление справочниками работает
- Управление пользователями работает
- История изменений отображается
