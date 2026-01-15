# /push — Отправка изменений

Push изменений в удалённый репозиторий.

## Usage

```
/push               # Push в текущую ветку
/push force         # Force push (осторожно!)
```

## Workflow

```bash
echo "=== GIT PUSH ==="

# 1. Check status
BRANCH=$(git branch --show-current)
echo "Current branch: $BRANCH"

UNPUSHED=$(git log origin/$BRANCH..$BRANCH --oneline 2>/dev/null | wc -l)
echo "Unpushed commits: $UNPUSHED"

if [ "$UNPUSHED" -eq 0 ]; then
    echo "✅ Nothing to push"
    exit 0
fi

# 2. Show commits to push
echo ""
echo "Commits to push:"
git log origin/$BRANCH..$BRANCH --oneline 2>/dev/null

# 3. Push
echo ""
echo "Pushing..."
git push origin $BRANCH

if [ $? -eq 0 ]; then
    echo "✅ Push successful"
else
    echo "❌ Push failed"
    echo ""
    echo "Possible fixes:"
    echo "  1. Pull first: git pull --rebase"
    echo "  2. Force push: /push force (destroys remote history!)"
fi
```

## Output

```markdown
## ✅ Pushed

**Branch:** main
**Commits:** 3
**Remote:** origin/main

Latest commits pushed:
- feat(api): add employee CRUD
- feat(entity): create Employee model
- chore(deps): add spring boot dependencies
```
