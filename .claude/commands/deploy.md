# /deploy — Деплой в Docker

Сборка образов и запуск через docker-compose.

## Usage

```
/deploy             # Полный деплой
/deploy rebuild     # Пересборка с --no-cache
/deploy stop        # Остановка сервисов
```

## /deploy

```bash
echo "=== DOCKER DEPLOY ==="

# Check docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found"
    exit 1
fi

# Stop existing
echo "1. Stopping existing containers..."
docker-compose down 2>/dev/null

# Build and start
echo "2. Building and starting..."
docker-compose up --build -d

if [ $? -eq 0 ]; then
    echo "✅ Containers started"
else
    echo "❌ Failed to start"
    docker-compose logs --tail=50
    exit 1
fi

# Wait for services
echo "3. Waiting for services..."
sleep 10

# Check health
echo "4. Health check..."

# PostgreSQL
if docker-compose exec -T postgres pg_isready -U resourceuser -d resourcedb &>/dev/null; then
    echo "   ✅ PostgreSQL ready"
else
    echo "   ⏳ PostgreSQL starting..."
fi

# Backend
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:31081/api/auth/me 2>/dev/null)
if [ "$BACKEND_STATUS" = "401" ]; then
    echo "   ✅ Backend ready (port 31081)"
else
    echo "   ⏳ Backend starting... (status: $BACKEND_STATUS)"
fi

# Frontend
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:31080 2>/dev/null)
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "   ✅ Frontend ready (port 31080)"
else
    echo "   ⏳ Frontend starting... (status: $FRONTEND_STATUS)"
fi

echo ""
echo "=== DEPLOY COMPLETE ==="
echo ""
echo "🌐 Frontend: http://localhost:31080"
echo "🔧 Backend:  http://localhost:31081"
echo "🗄️  Database: localhost:31432"
echo ""
echo "Login: admin / admin123"
```

## /deploy rebuild

```bash
echo "=== REBUILD WITH NO CACHE ==="

docker-compose down
docker system prune -f
docker-compose build --no-cache
docker-compose up -d

echo "Waiting 15 seconds for startup..."
sleep 15

docker-compose ps
```

## /deploy stop

```bash
echo "=== STOPPING SERVICES ==="
docker-compose down
docker-compose ps
echo "✅ All services stopped"
```

## Output

```markdown
## 🚀 Deploy Result

| Service | Status | Port |
|---------|--------|------|
| PostgreSQL | ✅ | 31432 |
| Backend | ✅ | 31081 |
| Frontend | ✅ | 31080 |

**Access:** http://localhost:31080
**Login:** admin / admin123
```
