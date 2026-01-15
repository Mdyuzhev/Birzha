# /build — Сборка проекта

Компиляция backend и frontend с проверкой ошибок.

---

## Usage

```
/build           # Собрать всё
/build backend   # Только backend
/build frontend  # Только frontend
/build docker    # Docker образы
```

---

## /build backend

```bash
echo "=== BACKEND BUILD ==="
cd backend

if [ ! -f pom.xml ]; then
    echo "❌ pom.xml not found"
    exit 1
fi

echo "Compiling..."
./mvnw compile -q 2>&1 | tail -20

if [ $? -eq 0 ]; then
    echo "✅ Backend compiled successfully"
    echo "Classes: $(find target/classes -name '*.class' 2>/dev/null | wc -l)"
else
    echo "❌ Compilation failed"
    ./mvnw compile 2>&1 | grep -A2 "ERROR"
fi
```

---

## /build frontend

```bash
echo "=== FRONTEND BUILD ==="
cd frontend

if [ ! -f package.json ]; then
    echo "❌ package.json not found"
    exit 1
fi

if [ ! -d node_modules ]; then
    echo "Installing dependencies..."
    npm install
fi

echo "Building..."
npm run build 2>&1 | tail -20

if [ -d dist ]; then
    echo "✅ Frontend built successfully"
    echo "Files: $(find dist -type f | wc -l)"
    echo "Size: $(du -sh dist | cut -f1)"
else
    echo "❌ Build failed"
fi
```

---

## /build docker

```bash
echo "=== DOCKER BUILD ==="

echo "Building backend image..."
docker build -t resource-manager-backend ./backend 2>&1 | tail -10

echo "Building frontend image..."
docker build -t resource-manager-frontend ./frontend 2>&1 | tail -10

echo ""
docker images | grep resource-manager
```

---

## Output

```markdown
## Build Result

| Component | Status | Details |
|-----------|--------|---------|
| Backend   | ✅     | 45 classes |
| Frontend  | ✅     | 2.3 MB |

**Next:** `/start` or `docker-compose up`
```
