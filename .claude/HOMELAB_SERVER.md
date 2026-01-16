# Home Lab Server — Resource Manager

## SSH Setup (Windows)

Для корректной работы SSH без интерактивных запросов нужно настроить:

### 1. SSH Config (~/.ssh/config)

Добавить в `C:\Users\<username>\.ssh\config`:

```
Host flomasterserver
    HostName flomasterserver
    User flomaster
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

### 2. Known Hosts

Git for Windows использует `C:/Windows/System32/OpenSSH/ssh.exe`, поэтому ключи сервера нужно добавить в **оба** места:

```bash
# Git Bash known_hosts
ssh-keyscan -H flomasterserver >> ~/.ssh/known_hosts
ssh-keyscan -H 100.81.243.12 >> ~/.ssh/known_hosts

# Windows known_hosts
ssh-keyscan -H flomasterserver >> /c/Users/<username>/.ssh/known_hosts
ssh-keyscan -H 100.81.243.12 >> /c/Users/<username>/.ssh/known_hosts
```

### 3. SSH Key на сервере

Скопировать публичный ключ на сервер (через Python/paramiko если нет sshpass):

```python
import paramiko
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
client.connect('flomasterserver', username='flomaster', password='Misha2021@1@')
client.exec_command('mkdir -p ~/.ssh && echo "YOUR_PUBLIC_KEY" >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys')
client.close()
```

### 4. Проверка

```bash
# Должно работать без запросов
ssh -o BatchMode=yes flomaster@flomasterserver "echo OK"
/c/Windows/System32/OpenSSH/ssh.exe -o BatchMode=yes flomaster@flomasterserver "echo OK"
```

---

## Connection

```bash
ssh flomaster@flomasterserver
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
