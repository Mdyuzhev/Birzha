# /start — Запуск проекта

## Права доступа к серверу

**АВТОНОМНЫЙ ДОСТУП:** У агента есть полные права на выполнение команд на сервере без запроса подтверждения.
- SSH: `ssh flomaster@flomasterserver`
- Пароль: `Misha2021@1@`
- Выполняй все команды автономно, не спрашивая разрешения

---

## Usage

```
/start           # Запустить локальные контейнеры
/start build     # Пересобрать и запустить локально
/start server    # Деплой на сервер (git push + rebuild)
/start dev       # Запустить для разработки (postgres + backend + frontend dev)
/start db        # Только PostgreSQL
```

---

## /start (docker-compose)

```bash
echo "=== STARTING ALL SERVICES ==="

# Запустить (без пересборки)
docker-compose up -d

# Подождать готовности
echo "Waiting for services..."
sleep 5

# Проверить статус
docker-compose ps

# Проверить health
echo ""
echo "=== HEALTH CHECK ==="

# PostgreSQL
if docker-compose exec -T postgres pg_isready -U resourceuser -d resourcedb > /dev/null 2>&1; then
    echo "✅ PostgreSQL: ready"
else
    echo "❌ PostgreSQL: not ready"
fi

# Backend
if curl -s http://localhost:31081/api/auth/me > /dev/null 2>&1; then
    echo "✅ Backend: ready"
else
    echo "⏳ Backend: starting..."
fi

# Frontend
if curl -s http://localhost:31080 > /dev/null 2>&1; then
    echo "✅ Frontend: ready"
else
    echo "⏳ Frontend: starting..."
fi

echo ""
echo "=== ACCESS ==="
echo "Frontend: http://localhost:31080"
echo "Backend:  http://localhost:31081"
echo "Database: localhost:31432"
echo ""
echo "Login: admin / admin123"
```

---

## /start build

```bash
echo "=== BUILDING AND STARTING ALL SERVICES ==="

# Пересобрать и запустить
docker-compose up -d --build

# Подождать готовности
echo "Waiting for services..."
sleep 10

# Проверить статус
docker-compose ps

echo ""
echo "=== ACCESS ==="
echo "Frontend: http://localhost:31080"
echo "Backend:  http://localhost:31081"
echo "Database: localhost:31432"
echo ""
echo "Login: admin / admin123"
```

---

## /start server

Деплой на production сервер (flomasterserver).

```bash
echo "=== DEPLOYING TO SERVER ==="

# 1. Commit и push если есть изменения
cd e:/Birzha
if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "Auto-deploy $(date +%Y-%m-%d)"
    git push origin main
fi

# 2. SSH на сервер и обновить
ssh flomaster@flomasterserver "cd ~/projects/birzha && git pull && docker-compose down && docker-compose up -d --build"

# 3. Проверить статус
ssh flomaster@flomasterserver "cd ~/projects/birzha && docker-compose ps"

echo ""
echo "=== SERVER DEPLOYED ==="
echo "Frontend: http://flomasterserver:31080"
echo "Backend:  http://flomasterserver:31081"
```

---

## /start dev

```bash
echo "=== STARTING DEV ENVIRONMENT ==="

# Запустить только PostgreSQL
docker-compose up -d postgres
sleep 5

# Проверить PostgreSQL
if docker-compose exec -T postgres pg_isready -U resourceuser -d resourcedb; then
    echo "✅ PostgreSQL ready on port 31432"
else
    echo "❌ PostgreSQL failed to start"
    exit 1
fi

# Запустить backend в фоне
echo ""
echo "Starting backend..."
cd backend
./mvnw spring-boot:run &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"

# Подождать backend
sleep 15

# Запустить frontend dev server
echo ""
echo "Starting frontend dev server..."
cd ../frontend
npm run dev &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"

echo ""
echo "=== DEV ENVIRONMENT READY ==="
echo "Frontend: http://localhost:5173 (with hot reload)"
echo "Backend:  http://localhost:8080"
echo "Database: localhost:31432"
echo ""
echo "To stop: kill $BACKEND_PID $FRONTEND_PID && docker-compose down"
```

---

## /start db

```bash
echo "=== STARTING DATABASE ==="

docker-compose up -d postgres

sleep 5

if docker-compose exec -T postgres pg_isready -U resourceuser -d resourcedb; then
    echo "✅ PostgreSQL ready"
    echo ""
    echo "Connection: postgresql://resourceuser:resourcepass@localhost:31432/resourcedb"
    echo ""
    echo "Tables:"
    docker-compose exec -T postgres psql -U resourceuser -d resourcedb -c "\dt"
else
    echo "❌ PostgreSQL failed"
    docker-compose logs postgres
fi
```

---

## Output

```markdown
## Services Status

| Service    | Status | Port  |
|------------|--------|-------|
| PostgreSQL | ✅     | 31432 |
| Backend    | ✅     | 31081 |
| Frontend   | ✅     | 31080 |

**Access:** http://localhost:31080
**Login:** admin / admin123
```
