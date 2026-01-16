# /server_build — Сборка на Home Lab сервере

Деплой актуальной версии приложения на production сервер (homelab).

## Права доступа

**АВТОНОМНЫЙ ДОСТУП:** Агент имеет полные права на выполнение команд на сервере без запроса подтверждения.

## Server Info

Перед выполнением изучи: `E:\Birzha\.claude\HOMELAB_SERVER.md`

| Field | Value |
|-------|-------|
| Host | flomasterserver |
| User | flomaster |
| Password | Misha2021@1@ |
| Project Path | ~/projects/birzha |
| Public URL | https://flomasterserver.taila40eda.ts.net/ |

---

## Usage

```
/server_build           # Pull + rebuild на сервере
/server_build status    # Проверить статус контейнеров
/server_build logs      # Показать логи
/server_build restart   # Перезапуск без пересборки
```

---

## /server_build

```bash
echo "=== SERVER BUILD: Home Lab ==="
echo ""

SERVER="flomaster@flomasterserver"
PROJECT_PATH="~/projects/birzha"

# 1. Git pull
echo "1. Pulling latest changes..."
ssh $SERVER "cd $PROJECT_PATH && git pull origin main"

if [ $? -ne 0 ]; then
    echo "❌ Git pull failed"
    exit 1
fi
echo "✅ Git pull complete"
echo ""

# 2. Docker build
echo "2. Building and starting containers..."
ssh $SERVER "cd $PROJECT_PATH && docker-compose down && docker-compose up -d --build"

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed"
    exit 1
fi
echo "✅ Docker build complete"
echo ""

# 3. Wait for startup
echo "3. Waiting for services to start..."
sleep 15

# 4. Check status
echo "4. Checking container status..."
ssh $SERVER "cd $PROJECT_PATH && docker-compose ps"
echo ""

# 5. Health check
echo "5. Health check..."

# PostgreSQL
PG_STATUS=$(ssh $SERVER "cd $PROJECT_PATH && docker-compose exec -T postgres pg_isready -U resourceuser -d resourcedb" 2>/dev/null && echo "ready" || echo "not ready")
if [ "$PG_STATUS" = "ready" ]; then
    echo "   ✅ PostgreSQL: ready"
else
    echo "   ⏳ PostgreSQL: starting..."
fi

# Backend
BACKEND_STATUS=$(ssh $SERVER "curl -s -o /dev/null -w '%{http_code}' http://localhost:31081/api/auth/me" 2>/dev/null)
if [ "$BACKEND_STATUS" = "401" ] || [ "$BACKEND_STATUS" = "403" ]; then
    echo "   ✅ Backend: ready (port 31081)"
else
    echo "   ⏳ Backend: starting... (status: $BACKEND_STATUS)"
fi

# Frontend
FRONTEND_STATUS=$(ssh $SERVER "curl -s -o /dev/null -w '%{http_code}' http://localhost:31080" 2>/dev/null)
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "   ✅ Frontend: ready (port 31080)"
else
    echo "   ⏳ Frontend: starting... (status: $FRONTEND_STATUS)"
fi

echo ""
echo "=== SERVER BUILD COMPLETE ==="
echo ""
echo "🌐 Public URL: https://flomasterserver.taila40eda.ts.net/"
echo "🔧 Backend:    http://flomasterserver:31081"
echo "🗄️  Database:   flomasterserver:31432"
echo ""
echo "Login: admin / admin123"
```

---

## /server_build status

```bash
echo "=== SERVER STATUS ==="
ssh flomaster@flomasterserver "cd ~/projects/birzha && docker-compose ps"
```

---

## /server_build logs

```bash
echo "=== SERVER LOGS (last 100 lines) ==="
ssh flomaster@flomasterserver "cd ~/projects/birzha && docker-compose logs --tail=100"
```

---

## /server_build restart

```bash
echo "=== SERVER RESTART ==="
ssh flomaster@flomasterserver "cd ~/projects/birzha && docker-compose restart"
sleep 10
ssh flomaster@flomasterserver "cd ~/projects/birzha && docker-compose ps"
echo ""
echo "✅ Services restarted"
echo "🌐 https://flomasterserver.taila40eda.ts.net/"
```

---

## Output

```markdown
## 🚀 Server Build Result

| Service | Status | Port |
|---------|--------|------|
| PostgreSQL | ✅ | 31432 |
| Backend | ✅ | 31081 |
| Frontend | ✅ | 31080 |

**Public URL:** https://flomasterserver.taila40eda.ts.net/
**Login:** admin / admin123
```
