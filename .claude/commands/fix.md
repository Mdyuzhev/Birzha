# /fix — Исправление типичных ошибок

Быстрая диагностика и исправление частых проблем.

## Usage

```
/fix                # Диагностика и предложения
/fix backend        # Ошибки компиляции Java
/fix frontend       # Ошибки сборки Vue
/fix db             # Проблемы с БД
/fix cors           # Проблемы CORS
```

## /fix backend

```bash
echo "=== BACKEND DIAGNOSTICS ==="
cd backend

# Try compile
echo "1. Compilation check..."
./mvnw compile 2>&1 | tee /tmp/mvn-errors.txt

ERRORS=$(grep -c "ERROR" /tmp/mvn-errors.txt || echo "0")
echo "Found $ERRORS errors"

if [ "$ERRORS" -gt 0 ]; then
    echo ""
    echo "=== ERROR ANALYSIS ==="
    
    # Common patterns
    if grep -q "cannot find symbol" /tmp/mvn-errors.txt; then
        echo "❌ Missing imports or typos detected"
        grep -A2 "cannot find symbol" /tmp/mvn-errors.txt | head -10
        echo ""
        echo "Fix: Check import statements and class names"
    fi
    
    if grep -q "package .* does not exist" /tmp/mvn-errors.txt; then
        echo "❌ Missing dependency"
        grep "package .* does not exist" /tmp/mvn-errors.txt | head -5
        echo ""
        echo "Fix: Add dependency to pom.xml or check package name"
    fi
    
    if grep -q "incompatible types" /tmp/mvn-errors.txt; then
        echo "❌ Type mismatch"
        grep -B1 -A1 "incompatible types" /tmp/mvn-errors.txt | head -10
        echo ""
        echo "Fix: Check return types and assignments"
    fi
fi
```

## /fix frontend

```bash
echo "=== FRONTEND DIAGNOSTICS ==="
cd frontend

# Check node_modules
if [ ! -d "node_modules" ]; then
    echo "❌ node_modules missing"
    echo "Fix: npm install"
    exit 1
fi

# Try build
echo "1. Build check..."
npm run build 2>&1 | tee /tmp/npm-errors.txt

if grep -q "error" /tmp/npm-errors.txt; then
    echo ""
    echo "=== ERROR ANALYSIS ==="
    
    if grep -q "Cannot find module" /tmp/npm-errors.txt; then
        echo "❌ Missing module"
        grep "Cannot find module" /tmp/npm-errors.txt | head -5
        echo ""
        echo "Fix: npm install <module-name>"
    fi
    
    if grep -q "is not defined" /tmp/npm-errors.txt; then
        echo "❌ Undefined variable"
        grep -B1 "is not defined" /tmp/npm-errors.txt | head -10
        echo ""
        echo "Fix: Check imports and variable declarations"
    fi
fi
```

## /fix db

```bash
echo "=== DATABASE DIAGNOSTICS ==="

# Connection test
echo "1. Connection test..."
if ! docker-compose exec -T postgres pg_isready -U resourceuser -d resourcedb &>/dev/null; then
    echo "❌ Cannot connect to PostgreSQL"
    echo ""
    echo "Possible fixes:"
    echo "  1. Start containers: docker-compose up -d"
    echo "  2. Check logs: docker-compose logs postgres"
    echo "  3. Recreate: docker-compose down -v && docker-compose up -d"
    exit 1
fi

echo "✅ Connection OK"

# Check migrations
echo ""
echo "2. Flyway migrations..."
docker-compose exec -T postgres psql -U resourceuser -d resourcedb -c \
    "SELECT version, description, success FROM flyway_schema_history ORDER BY installed_rank" 2>/dev/null

# Check for failed migrations
FAILED=$(docker-compose exec -T postgres psql -U resourceuser -d resourcedb -t -c \
    "SELECT count(*) FROM flyway_schema_history WHERE success = false" 2>/dev/null | tr -d ' ')

if [ "$FAILED" != "0" ]; then
    echo ""
    echo "❌ Found $FAILED failed migrations"
    echo "Fix: Check migration SQL syntax, then run: ./mvnw flyway:repair"
fi
```

## /fix cors

```bash
echo "=== CORS DIAGNOSTICS ==="

# Check backend CORS config
echo "1. Backend CORS configuration..."
if [ -f "backend/src/main/java/com/company/resourcemanager/config/CorsConfig.java" ]; then
    echo "✅ CorsConfig.java exists"
    grep -A5 "allowedOrigins" backend/src/main/java/*/config/CorsConfig.java 2>/dev/null
else
    echo "❌ CorsConfig.java missing"
    echo ""
    echo "Create config with:"
    cat << 'EOF'
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
            .allowedOrigins("http://localhost:31080")
            .allowedMethods("GET", "POST", "PUT", "DELETE")
            .allowedHeaders("*")
            .allowCredentials(true);
    }
}
EOF
fi

# Check frontend proxy
echo ""
echo "2. Frontend proxy configuration..."
if [ -f "frontend/vite.config.js" ]; then
    grep -A10 "proxy" frontend/vite.config.js 2>/dev/null || echo "No proxy configured in vite.config.js"
fi
```

## Common Fixes Reference

### Backend не компилируется
```bash
cd backend
./mvnw clean compile -X 2>&1 | tail -50
```

### Frontend не запускается
```bash
cd frontend
rm -rf node_modules package-lock.json
npm install
npm run dev
```

### БД не стартует
```bash
docker-compose down -v
docker volume prune -f
docker-compose up -d postgres
sleep 5
docker-compose logs postgres
```

### JWT ошибки
```bash
# Проверить длину секрета (минимум 32 символа)
echo -n "$JWT_SECRET" | wc -c

# Сгенерировать новый
openssl rand -base64 32
```

## Output

```markdown
## 🔧 Fix Report

### Diagnosis
- Backend compilation: ✅
- Frontend build: ❌ 2 errors
- Database: ✅

### Issues Found
1. **frontend/src/api/index.js:15** - Missing import for `axios`

### Auto-Fixed
✅ None (manual review required)

### Manual Fix Required
```javascript
// Add at top of frontend/src/api/index.js
import axios from 'axios'
```
```
