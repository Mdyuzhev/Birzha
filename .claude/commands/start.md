# /start — Запуск проекта

Запуск сервисов для разработки или через Docker.

---

## Usage

```
/start           # Запустить всё через docker-compose
/start dev       # Запустить для разработки (postgres + backend + frontend dev)
/start db        # Только PostgreSQL
```

---

## /start (docker-compose)

```bash
echo "=== STARTING ALL SERVICES ==="

# Остановить если запущено
docker-compose down 2>/dev/null

# Запустить
docker-compose up -d --build

# Подождать готовности
echo "Waiting for services..."
sleep 10

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
