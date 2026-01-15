# /commit — Умный коммит

Автоматическое определение типа изменений и форматирование commit message.

## Usage

```
/commit [message]       # Коммит с автоопределением типа
/commit fix: описание   # Коммит с явным типом
```

## Workflow

```bash
echo "=== COMMIT PREPARATION ==="

# 1. Show changes
git status --short
echo ""
git diff --stat HEAD 2>/dev/null || git diff --stat --cached

# 2. Analyze changed files
CHANGED=$(git diff --name-only HEAD 2>/dev/null || git diff --name-only --cached)

# Determine type and scope
if echo "$CHANGED" | grep -q "backend/src/main/java/.*entity/"; then
    TYPE="feat"
    SCOPE="entity"
elif echo "$CHANGED" | grep -q "backend/src/main/java/.*controller/"; then
    TYPE="feat"
    SCOPE="api"
elif echo "$CHANGED" | grep -q "backend/src/main/java/.*service/"; then
    TYPE="feat"
    SCOPE="service"
elif echo "$CHANGED" | grep -q "backend/src/main/resources/db/migration/"; then
    TYPE="feat"
    SCOPE="db"
elif echo "$CHANGED" | grep -q "frontend/src/views/"; then
    TYPE="feat"
    SCOPE="ui"
elif echo "$CHANGED" | grep -q "frontend/src/components/"; then
    TYPE="feat"
    SCOPE="component"
elif echo "$CHANGED" | grep -q "frontend/src/api/"; then
    TYPE="feat"
    SCOPE="api-client"
elif echo "$CHANGED" | grep -q "Dockerfile\|docker-compose"; then
    TYPE="chore"
    SCOPE="docker"
elif echo "$CHANGED" | grep -q "pom.xml\|package.json"; then
    TYPE="chore"
    SCOPE="deps"
elif echo "$CHANGED" | grep -q "README\|CLAUDE\|\.md"; then
    TYPE="docs"
    SCOPE=""
else
    TYPE="chore"
    SCOPE=""
fi

echo ""
echo "Detected: $TYPE($SCOPE)"
echo ""

# 3. Stage and commit
git add -A

# Message will be provided as argument or constructed
# Example: git commit -m "$TYPE($SCOPE): $MESSAGE"
```

## Commit Types

| Type | Description | Example |
|------|-------------|---------|
| feat | Новая функциональность | feat(api): add employee endpoint |
| fix | Исправление бага | fix(auth): token validation |
| refactor | Рефакторинг | refactor(service): extract method |
| docs | Документация | docs: update README |
| chore | Служебные изменения | chore(deps): update spring boot |
| test | Тесты | test(api): add auth tests |

## Scopes

| Scope | Files |
|-------|-------|
| entity | backend/*/entity/*.java |
| api | backend/*/controller/*.java |
| service | backend/*/service/*.java |
| db | backend/*/db/migration/*.sql |
| ui | frontend/src/views/*.vue |
| component | frontend/src/components/*.vue |
| api-client | frontend/src/api/*.js |
| docker | Dockerfile, docker-compose.yml |
| deps | pom.xml, package.json |

## Examples

```bash
# Auto-detected commit
/commit add employee CRUD operations
# → feat(api): add employee CRUD operations

# Explicit type
/commit fix: resolve CORS issue
# → fix: resolve CORS issue

# With scope override
/commit feat(db): add employee history table
```

## Output

```markdown
## ✅ Committed

**Type:** feat(api)
**Message:** add employee CRUD operations

**Files changed:** 5
- EmployeeController.java
- EmployeeService.java
- EmployeeRepository.java
- Employee.java
- V4__create_employees_table.sql

**Next:** `git push` or `/push`
```
