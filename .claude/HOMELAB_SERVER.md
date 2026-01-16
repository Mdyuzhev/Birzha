# Home Lab Server — Resource Manager

## Connection

```bash
ssh -i ~/.ssh/id_ed25519 flomaster@flomasterserver
```

## Credentials

| Field | Value |
|-------|-------|
| User | flomaster |
| Password | Misha2021@1@ |
| Tailscale | flomasterserver (100.81.243.12) |
| LAN IP | 192.168.1.74 |

## Resource Manager App

| Service | URL | Port |
|---------|-----|------|
| Frontend | http://flomasterserver:31080 | 31080 |
| Backend API | http://flomasterserver:31081 | 31081 |
| PostgreSQL | flomasterserver:31432 | 31432 |

### App Credentials

| Login | Password |
|-------|----------|
| admin | admin123 |

### Database

```
Host: flomasterserver
Port: 31432
Database: resourcedb
User: resourceuser
Password: resourcepass
```

## Deploy

```bash
# На сервере
cd ~/projects/birzha
git pull
docker-compose up -d --build
```

## Useful Commands

```bash
# Статус контейнеров
ssh flomaster@flomasterserver "cd ~/projects/birzha && docker-compose ps"

# Логи backend
ssh flomaster@flomasterserver "cd ~/projects/birzha && docker-compose logs -f backend"

# Перезапуск
ssh flomaster@flomasterserver "cd ~/projects/birzha && docker-compose restart"
```
