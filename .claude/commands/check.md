# /check — Проверка состояния

Диагностика текущего состояния проекта и сервисов.

## Usage

```
/check              # Полная диагностика
/check services     # Только Docker сервисы
/check db           # Проверка базы данных
/check code         # Проверка структуры кода
```

## /check services

```bash
echo "=== SERVICE STATUS ==="

# Docker containers
echo "Docker containers:"
docker-compose ps 2>/dev/null || echo "  docker-compose not running"

echo ""

# Ports
echo "Port check:"
for PORT in 31080 31081 31432; do
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT &>/dev/null || \
       pg_isready -h localhost -p $PORT &>/dev/null 2>&1; then
        echo "  ✅ Port $PORT is open"
    else
        echo "  ❌ Port $PORT is closed"
    fi
done
```

## /check db

```bash
echo "=== DATABASE CHECK ==="

# Connection
echo "1. Connection test..."
if docker-compose exec -T postgres pg_isready -U resourceuser -d resourcedb &>/dev/null; then
    echo "   ✅ PostgreSQL is ready"
else
    echo "   ❌ PostgreSQL not responding"
    exit 1
fi

# Tables
echo "2. Tables..."
docker-compose exec -T postgres psql -U resourceuser -d resourcedb -c "\dt" 2>/dev/null | grep -E "users|employees|dictionaries|column_definitions|employee_history"

# Data counts
echo ""
echo "3. Data counts..."
docker-compose exec -T postgres psql -U resourceuser -d resourcedb -t -c "
SELECT 'users' as table_name, count(*) from users
UNION ALL
SELECT 'employees', count(*) from employees
UNION ALL
SELECT 'dictionaries', count(*) from dictionaries
UNION ALL
SELECT 'column_definitions', count(*) from column_definitions
UNION ALL
SELECT 'employee_history', count(*) from employee_history
" 2>/dev/null
```

## /check code

```bash
echo "=== CODE STRUCTURE CHECK ==="

# Backend
echo "Backend:"
if [ -f "backend/pom.xml" ]; then
    echo "  ✅ pom.xml exists"
else
    echo "  ❌ pom.xml missing"
fi

ENTITIES=$(find backend/src -name "*.java" -path "*/entity/*" 2>/dev/null | wc -l)
REPOS=$(find backend/src -name "*Repository.java" 2>/dev/null | wc -l)
CONTROLLERS=$(find backend/src -name "*Controller.java" 2>/dev/null | wc -l)
SERVICES=$(find backend/src -name "*Service.java" 2>/dev/null | wc -l)

echo "  📋 Entities: $ENTITIES"
echo "  📋 Repositories: $REPOS"
echo "  📋 Controllers: $CONTROLLERS"
echo "  📋 Services: $SERVICES"

# Migrations
MIGRATIONS=$(find backend/src -name "V*.sql" 2>/dev/null | wc -l)
echo "  📋 Migrations: $MIGRATIONS"

echo ""

# Frontend
echo "Frontend:"
if [ -f "frontend/package.json" ]; then
    echo "  ✅ package.json exists"
else
    echo "  ❌ package.json missing"
fi

VIEWS=$(find frontend/src -name "*View.vue" 2>/dev/null | wc -l)
COMPONENTS=$(find frontend/src -name "*.vue" -not -name "*View.vue" 2>/dev/null | wc -l)
STORES=$(find frontend/src -name "*.js" -path "*/stores/*" 2>/dev/null | wc -l)

echo "  📋 Views: $VIEWS"
echo "  📋 Components: $COMPONENTS"
echo "  📋 Stores: $STORES"
```

## Output

```markdown
## 📊 System Status

### Services
| Service | Status | Details |
|---------|--------|---------|
| PostgreSQL | ✅ | 5 tables, 3 users |
| Backend | ✅ | Running on :31081 |
| Frontend | ✅ | Running on :31080 |

### Code
| Layer | Count |
|-------|-------|
| Entities | 5 |
| Controllers | 5 |
| Vue Components | 8 |

**Health:** All systems operational
```
