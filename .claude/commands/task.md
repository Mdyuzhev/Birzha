# /task — Выполнение задачи из очереди

Читает и выполняет следующую задачу из папки `Tasks/`.

## Workflow

1. **Сканирование** — найти .md файлы в Tasks/
2. **Проверка статуса** — пропустить файлы с префиксом `done-`
3. **Выполнение** — следовать инструкциям из файла
4. **Отметка** — переименовать в `done-{original-name}`
5. **Коммит** — закоммитить изменения

## Task File Format

Задачи могут быть в форматах:

**Markdown (.md)** — инструкции на естественном языке:
```markdown
# Добавить фильтрацию по статусу

## Описание
Добавить возможность фильтровать сотрудников по статусу (На проекте, На бенче и т.д.)

## Критерии готовности
- [ ] Backend: endpoint принимает параметр status
- [ ] Frontend: dropdown с выбором статуса
- [ ] Фильтр применяется при выборе
```

**JSON (.json)** — структурированное определение:
```json
{
  "type": "feature",
  "title": "Фильтрация по статусу",
  "files": ["EmployeeController.java", "FilterPanel.vue"],
  "tests": ["FilterTest.java"]
}
```

## Execution

```bash
echo "=== TASK QUEUE ==="

# 1. Find pending tasks
TASKS=$(find Tasks/ -name "*.md" -not -name "done-*" 2>/dev/null | sort)

if [ -z "$TASKS" ]; then
    echo "ℹ️ No pending tasks"
    exit 0
fi

# 2. Get first task
TASK=$(echo "$TASKS" | head -1)
echo "📋 Found task: $TASK"
echo ""

# 3. Show task content
cat "$TASK"
echo ""

# 4. Execute (agent follows instructions)
# ... implementation based on task content ...

# 5. Mark complete
DONE_NAME="Tasks/done-$(basename $TASK)"
mv "$TASK" "$DONE_NAME"
echo "✅ Task marked as done: $DONE_NAME"

# 6. Commit
git add -A
git commit -m "feat: complete task $(basename $TASK .md)"
```

## Task Templates

### Feature Task
```markdown
# [Feature] Название

## Описание
Что нужно сделать

## Файлы
- backend/src/.../Controller.java
- frontend/src/views/...View.vue

## Шаги
1. Создать endpoint
2. Добавить UI
3. Протестировать

## Критерии готовности
- [ ] Критерий 1
- [ ] Критерий 2
```

### Bug Fix Task
```markdown
# [Bug] Описание бага

## Симптомы
Что происходит неправильно

## Ожидаемое поведение
Как должно работать

## Воспроизведение
1. Шаг 1
2. Шаг 2

## Возможная причина
Где искать проблему
```

## Output

### Task Completed
```markdown
## ✅ Task Completed

**Task:** add-status-filter.md
**Action:** Added status filter to employees table

### Changes
- EmployeeController.java: added status parameter
- EmployeeService.java: filter logic
- FilterPanel.vue: status dropdown

Committed and ready for push.
```

### No Tasks
```markdown
## ℹ️ No Pending Tasks

Tasks folder is empty or all tasks completed.

**To add a task:**
1. Create `Tasks/your-task-name.md`
2. Run `/task` again
```
