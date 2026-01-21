# Home Lab Server — Resource Manager

## Connection Info

**ВАЖНО:** Используй LAN IP для подключения. Tailscale может быть недоступен.

| Parameter | Value |
|-----------|-------|
| LAN IP | 192.168.1.74 |
| User | flomaster |
| Password | Misha2021@1@ |
| Sudo Password | Misha2021@1@ |
| Tailscale IP | 100.81.243.12 (может быть недоступен) |
| Hostname | flomasterserver |

## Quick Connect

```bash
# Основной способ подключения (БЕЗ ПАРОЛЯ)
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74

# Или через alias (если настроен .ssh/config)
ssh homelab
```

**Статус SSH Key:** ✅ Установлен и работает

## SSH Setup (Windows)

**Цель:** SSH работает БЕЗ запросов пароля и подтверждений.

### 1. SSH Config (уже настроен)

Файл `~/.ssh/config`:

```
Host homelab
    HostName 192.168.1.74
    User flomaster
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host flomasterserver
    HostName 192.168.1.74
    User flomaster
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

### 2. SSH Key (уже установлен)

```bash
# Публичный ключ установлен на сервере:
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyd0u+2ZA2Dy/1fPXOsBTuQ9Xc6tD0bZoolqKQQ1u/w claude-agent

# Расположение ключей:
~/.ssh/id_ed25519      # Приватный ключ
~/.ssh/id_ed25519.pub  # Публичный ключ
```

### 3. Использование SSH

```bash
# Метод 1: С явным указанием ключа (рекомендуется для скриптов)
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "команда"

# Метод 2: Через alias homelab (может не работать в Git Bash)
ssh homelab "команда"

# Метод 3: Полный синтаксис для надёжности
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null flomaster@192.168.1.74
```

### 4. Проверка подключения

```bash
# Тест без пароля
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "echo 'SSH OK'"
```

**Ожидаемый результат:** `SSH OK` БЕЗ запроса пароля

---

## Credentials Summary

| Type | Username | Password |
|------|----------|----------|
| SSH | flomaster | Misha2021@1@ |
| Sudo | flomaster | Misha2021@1@ |
| PostgreSQL | resourceuser | resourcepass |
| App Admin | admin | admin123 |

## Resource Manager App

### URLs

| Service | LAN URL | Tailscale URL | Port |
|---------|---------|---------------|------|
| Frontend | http://192.168.1.74:31080 | http://flomasterserver:31080 | 31080 |
| Backend API | http://192.168.1.74:31081 | http://flomasterserver:31081 | 31081 |
| PostgreSQL | 192.168.1.74:31432 | flomasterserver:31432 | 31432 |

### Database Connection

```
Host: 192.168.1.74
Port: 31432
Database: resourcedb
User: resourceuser
Password: resourcepass
```

---

## Deploy Commands

### Автоматический деплой с локальной машины

```bash
# Full deploy: git push + pull + rebuild на сервере
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && git pull && docker-compose down && docker-compose up -d --build"

# Quick restart (без пересборки)
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose restart"
```

### Деплой с сервера

```bash
# Подключиться к серверу
ssh flomaster@192.168.1.74

# Обновить код и пересобрать
cd ~/projects/birzha
git pull
docker-compose down
docker-compose up -d --build

# Проверить статус
docker-compose ps
```

---

## Useful Commands

### Мониторинг

```bash
# Статус контейнеров
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose ps"

# Логи backend (последние 50 строк)
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker logs resource-manager-backend --tail 50"

# Логи frontend
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker logs resource-manager-frontend --tail 50"

# Логи PostgreSQL
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker logs resource-manager-db --tail 50"

# Следить за логами в реальном времени
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose logs -f backend"
```

### Управление контейнерами

```bash
# Перезапуск всех сервисов
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose restart"

# Перезапуск только backend
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose restart backend"

# Остановить все
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose down"

# Запустить все
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose up -d"

# Пересобрать все с нуля (clean build)
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose down -v && docker-compose up -d --build"
```

### Проверка сервисов

```bash
# Проверка backend API
curl -s http://192.168.1.74:31081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | head -c 200

# Проверка PostgreSQL
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "docker exec resource-manager-db psql -U resourceuser -d resourcedb -c 'SELECT version();'"

# Проверка Flyway миграций
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker logs resource-manager-backend 2>&1 | grep -i 'flyway\|migration' | tail -10"
```

---

## Troubleshooting

### Backend не запускается

```bash
# Проверить логи на ошибки
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "docker logs resource-manager-backend --tail 100"

# Проверить подключение к БД
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "docker exec resource-manager-db pg_isready -U resourceuser -d resourcedb"

# Пересобрать backend
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose up -d --build backend"
```

### Ошибки миграций Flyway

```bash
# Проверить статус миграций
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "docker exec resource-manager-db psql -U resourceuser -d resourcedb -c 'SELECT * FROM flyway_schema_history ORDER BY installed_rank;'"

# Последние миграции
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "docker exec resource-manager-db psql -U resourceuser -d resourcedb -c 'SELECT installed_rank, version, description, success FROM flyway_schema_history ORDER BY installed_rank DESC LIMIT 5;'"
```

### Очистка и полная пересборка

```bash
# ОСТОРОЖНО: удаляет volumes с данными БД!
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose down -v && docker system prune -af && docker-compose up -d --build"
```

---

## Project Info

### Server Paths

```
Project Root: ~/projects/birzha
Backend: ~/projects/birzha/backend
Frontend: ~/projects/birzha/frontend
Docker Compose: ~/projects/birzha/docker-compose.yml
```

### Git Repository

```
Remote: https://github.com/Mdyuzhev/Birzha.git
Branch: main
Last Deploy: 2026-01-21 (Phase 7: Tech Stacks)
```

### Current Phase Status

| Phase | Module | Status |
|-------|--------|--------|
| 1 | Multitenancy (DZO) | ✅ Completed |
| 2 | Role Model (6 roles) | ✅ Completed |
| 3 | Applications Backend | ✅ Completed |
| 4 | Applications Workflow | ✅ Completed |
| 5 | Applications Frontend | ⏳ In Progress |
| 6 | Blacklist Module | ✅ Completed |
| 7 | Tech Stacks Module | ✅ Completed |
| 8 | Analytics | ⏳ Pending |
| 9 | Email Notifications | ⏳ Pending |
| 10 | 2FA Authentication | ⏳ Pending |

### Latest Features (Phase 7)

- ✅ 7 Tech Directions (Backend, Frontend, Mobile, DevOps, Data, QA, Management)
- ✅ 22 Tech Stacks with JSONB technologies
- ✅ Tech Stack workflow (ACTIVE/PROPOSED/DEPRECATED/REJECTED)
- ✅ Admin stack management + User proposals
- ✅ Search and filtering
- ✅ Integration with Application forms

---

## Quick Reference Card

```bash
# === DEPLOYMENT === #
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && git pull && docker-compose up -d --build"

# === STATUS === #
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose ps"

# === LOGS === #
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "docker logs resource-manager-backend --tail 50"

# === RESTART === #
ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no flomaster@192.168.1.74 "cd ~/projects/birzha && docker-compose restart"

# === TEST API === #
curl http://192.168.1.74:31081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# === ACCESS === #
Frontend: http://192.168.1.74:31080
Backend:  http://192.168.1.74:31081
Login:    admin / admin123
```
