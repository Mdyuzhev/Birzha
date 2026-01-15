# /test — Запуск тестов

Запуск unit и integration тестов.

## Usage

```
/test               # Все тесты
/test backend       # Только backend
/test api           # Проверка API через curl
```

## /test backend

```bash
echo "=== BACKEND TESTS ==="
cd backend

./mvnw test -q

if [ $? -eq 0 ]; then
    echo "✅ All tests passed"
    
    # Show summary
    TESTS=$(grep -r "Tests run:" target/surefire-reports/*.txt 2>/dev/null | tail -1)
    echo "📊 $TESTS"
else
    echo "❌ Tests failed"
    ./mvnw test 2>&1 | grep -A5 "FAILURE\|ERROR" | head -30
    exit 1
fi
```

## /test api

Проверка работы API через curl. Требует запущенный backend.

```bash
echo "=== API TESTS ==="

BASE_URL="http://localhost:31081/api"

# Health check
echo "1. Health check..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/auth/me)
if [ "$HTTP_CODE" = "401" ]; then
    echo "   ✅ Auth endpoint responds (401 without token - expected)"
else
    echo "   ❌ Unexpected response: $HTTP_CODE"
fi

# Login
echo "2. Login test..."
RESPONSE=$(curl -s -X POST $BASE_URL/auth/login \
    -H "Content-Type: application/json" \
    -d '{"username":"admin","password":"admin123"}')

TOKEN=$(echo $RESPONSE | jq -r '.token // empty')
if [ -n "$TOKEN" ]; then
    echo "   ✅ Login successful, got token"
else
    echo "   ❌ Login failed: $RESPONSE"
    exit 1
fi

# Get employees
echo "3. Get employees..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $TOKEN" \
    $BASE_URL/employees)
if [ "$HTTP_CODE" = "200" ]; then
    echo "   ✅ Employees endpoint works"
else
    echo "   ❌ Failed: HTTP $HTTP_CODE"
fi

# Get columns
echo "4. Get columns..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $TOKEN" \
    $BASE_URL/columns)
if [ "$HTTP_CODE" = "200" ]; then
    echo "   ✅ Columns endpoint works"
else
    echo "   ❌ Failed: HTTP $HTTP_CODE"
fi

# Get dictionaries
echo "5. Get dictionaries..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $TOKEN" \
    $BASE_URL/dictionaries)
if [ "$HTTP_CODE" = "200" ]; then
    echo "   ✅ Dictionaries endpoint works"
else
    echo "   ❌ Failed: HTTP $HTTP_CODE"
fi

echo ""
echo "=== API TEST COMPLETE ==="
```

## Output

```markdown
## 🧪 Test Results

| Suite | Status | Details |
|-------|--------|---------|
| Unit tests | ✅ | 24 passed |
| API tests | ✅ | 5/5 endpoints |

**Coverage:** 78% (target: 70%)
```
