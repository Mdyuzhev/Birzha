# Home Lab Server — Agent Reference

## Connection

**Tailscale** (рекомендуется — работает из любой сети):
```bash
ssh -i ~/.ssh/id_ed25519 flomaster@flomasterserver
```

**LAN** (только в локальной сети 192.168.1.x):
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
| SSH Key | ~/.ssh/id_ed25519 (authorized) |
| Sudo | NOPASSWD (via /etc/sudoers.d/flomaster) |

## Tailscale

| Property | Value |
|----------|-------|
| Hostname | flomasterserver |
| IP | 100.81.243.12 |
| Service | tailscaled (enabled, autostart) |

## Hardware

| Component | Spec |
|-----------|------|
| Host | Lenovo Legion |
| CPU | Intel i7-9750HF (6C/12T) |
| RAM | 24GB |
| GPU | GTX 1660 Ti Mobile (6GB) |
| Disk | 915GB (10% used) |
| OS | Ubuntu 24.04.3 LTS |

## Lab Control

```bash
lab status              # Current state + resources
lab stop-all            # Free maximum resources
lab start-session       # Full: GitLab + YouTrack (~14GB RAM)
lab start-ci            # GitLab only (~7GB)
lab stop-session        # Idle mode (~4GB)
```

## Resource Modes

| Mode | RAM | Use |
|------|-----|-----|
| IDLE | ~4GB | ML training, heavy tasks |
| CI/CD | ~7GB | Development |
| FULL | ~14GB | All services |

## Before Heavy Tasks (ML, builds)

```bash
# Free maximum resources
lab stop-all
sudo systemctl stop docker
sudo systemctl stop k3s

# Verify
free -h          # Expect ~20GB free
nvidia-smi       # GPU status
htop             # CPU idle
```

## After Heavy Tasks

```bash
sudo systemctl start k3s
sudo systemctl start docker
lab start-ci     # or lab start-session
```

## GPU Setup (if needed)

```bash
# Install NVIDIA driver
sudo apt update
sudo apt install -y nvidia-driver-550
sudo reboot

# Verify
nvidia-smi
```

## Key Paths

| Path | Content |
|------|---------|
| `/home/flomaster/projects/` | All projects |
| `/home/flomaster/scripts/` | Lab control, utilities |
| `/home/flomaster/scripts/lab-control.sh` | Lab management |

## K8s Namespaces

| Namespace | Service | Ports |
|-----------|---------|-------|
| warehouse | Logistics API | 30080, 30081 |
| warehouse-dev | Dev environment | 31080, 31081 |
| errorlens-stage | ErrorLens | 31200, 31201 |
| monitoring | Grafana/Prometheus | 30300, 30090 |

## Common Commands

```bash
# Check resources
ssh flomaster@flomasterserver "free -h && df -h && nvidia-smi 2>/dev/null || echo 'No GPU driver'"

# Deploy image to k3s
docker save myimage:latest | ssh flomaster@flomasterserver 'sudo k3s ctr images import -'

# Pod logs
ssh flomaster@flomasterserver "kubectl logs -f deployment/myapp -n mynamespace"

# Run command
ssh flomaster@flomasterserver "cd ~/projects/myproject && git pull && ./build.sh"
```

## SSH Tunnel (for local access to services)

```bash
# GitLab
ssh -L 8080:localhost:8080 flomaster@flomasterserver

# PostgreSQL
ssh -L 5432:localhost:30432 flomaster@flomasterserver

# Grafana
ssh -L 3000:localhost:30300 flomaster@flomasterserver
```

## ML Environment (QLoRA)

```bash
# Activate (already installed)
source ~/qlora-env/bin/activate

# Verify CUDA
python -c "import torch; print(torch.cuda.get_device_name(0), torch.cuda.mem_get_info()[1]//1024**3, 'GB')"
```

### QLoRA Stack (Installed)

| Package | Version | Purpose |
|---------|---------|---------|
| torch | CUDA 12.1 | Deep learning framework |
| transformers | 4.44.0 | Hugging Face models |
| peft | 0.13.0 | LoRA/QLoRA adapters |
| bitsandbytes | 0.49.0 | 4-bit quantization |
| accelerate | 1.7.0 | Distributed training |
| trl | 0.9.6 | RLHF/SFT trainers |
| datasets | - | Data loading |

### Training Workflow

1. `sudo systemctl stop docker k3s` — free GPU memory
2. `source ~/qlora-env/bin/activate`
3. `nvidia-smi` — verify GPU available (need 5GB+)
4. Run training script
5. `sudo systemctl start k3s docker` — restore services

## Quick Commands

```bash
# Остановить всё (IDLE mode, ~1.4GB RAM)
ssh -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null flomaster@flomasterserver "docker stop postgres-stage warehouse-orchestrator-ui 2>/dev/null; sudo systemctl stop k3s docker"

# Запустить всё (CI mode, ~4GB RAM)
ssh -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null flomaster@flomasterserver "sudo systemctl start docker k3s && sleep 5 && docker start postgres-stage warehouse-orchestrator-ui"

# Статус
ssh -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null flomaster@flomasterserver "free -h | head -2 && systemctl is-active k3s docker && nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv"
```

## Sharmanka on Homelab

### Deploy & Test

```bash
# 1. Copy project to homelab
rsync -avz --exclude='.git' --exclude='__pycache__' --exclude='output/*' \
  -e "ssh -i $HOME/.ssh/id_ed25519" \
  E:/Sharmanka/ flomaster@flomasterserver:~/projects/sharmanka/

# 2. Run on homelab (Docker)
ssh -i "$HOME/.ssh/id_ed25519" flomaster@flomasterserver \
  "cd ~/projects/sharmanka/docker && docker-compose up -d"

# 3. Access UI
# http://flomasterserver:5000
```

### Models on HomeLab

| Model | Size | Status | Notes |
|-------|------|--------|-------|
| sharmanka-v6:latest | 986 MB | ✅ Active | 147 tok/s, качественный код |
| sharmanka-v5:latest | 986 MB | ✅ Ready | Previous version |
| qwen2.5-coder:7b | 4.7 GB | ✅ Ready | Base model |

**sharmanka-v6 Result:**
```java
@Test
@DisplayName("Get user by ID")
void getApiUsersId() {
    Response response = client.getApiUsersId("id-" + System.currentTimeMillis());

    response.then()
        .statusCode(200)
        .contentType(ContentType.JSON)
        .body("id", matchesPattern("[a-f0-9-]{36}"))
        .body("status", notNullValue())
        .body("createdAt", notNullValue());
}
```

### LoRA Fine-tuning (sharmanka-v6)

| Stage | Status |
|-------|--------|
| Merge LoRA | ✅ 3GB merged model |
| Export GGUF | ✅ Q4_K_M (941MB) |
| Ollama create | ✅ sharmanka-v6:latest |
| Test | ✅ 147 tok/s |

**Dataset:** `training_data/sharmanka_lora_train.json` (675 examples)
**Script:** `scripts/train_lora_v5_simple.py`

```bash
# 1. Stop services (free GPU memory)
ssh -i ~/.ssh/id_ed25519 flomaster@flomasterserver "sudo systemctl stop docker k3s"

# 2. Run training (in screen for long tasks)
ssh -i ~/.ssh/id_ed25519 flomaster@flomasterserver "
  screen -dmS lora bash -c '
    source ~/qlora-env/bin/activate
    cd ~/projects/sharmanka
    python scripts/train_lora_v5_simple.py 2>&1 | tee training.log
  '
"

# 3. Monitor
ssh -i ~/.ssh/id_ed25519 flomaster@flomasterserver "screen -r lora"
# или
ssh -i ~/.ssh/id_ed25519 flomaster@flomasterserver "tail -f ~/projects/sharmanka/training.log"

# 4. After training — merge & export GGUF
ssh -i ~/.ssh/id_ed25519 flomaster@flomasterserver "
  source ~/qlora-env/bin/activate
  cd ~/projects/sharmanka
  python scripts/merge_lora_v5.py
"

# 5. Create Ollama model
ssh -i ~/.ssh/id_ed25519 flomaster@flomasterserver "
  ollama create sharmanka-v5 -f ~/projects/sharmanka/Modelfile
"

# 6. Restore services
ssh -i ~/.ssh/id_ed25519 flomaster@flomasterserver "sudo systemctl start k3s docker"
```

### Benchmark on Homelab

```bash
# Run INSANE benchmark
ssh -i "$HOME/.ssh/id_ed25519" flomaster@flomasterserver "
  cd ~/projects/sharmanka/docker && docker-compose up -d
  sleep 5
  curl -X POST -F 'file=@../samples/benchmark-api.json' http://localhost:5000/api/upload
  curl -X POST http://localhost:5000/api/generate \
    -H 'Content-Type: application/json' \
    -d '{\"framework\":\"restassured\",\"quality_level\":\"5stars\",\"model\":\"sharmanka-v5\"}'
"

# Monitor progress
ssh -i "$HOME/.ssh/id_ed25519" flomaster@flomasterserver \
  "watch -n 5 'curl -s http://localhost:5000/api/status | jq .progress'"
```

### Models on Homelab Ollama

```bash
# List models
ssh -i "$HOME/.ssh/id_ed25519" flomaster@flomasterserver "ollama list"

# Pull model
ssh -i "$HOME/.ssh/id_ed25519" flomaster@flomasterserver "ollama pull qwen2.5-coder:7b"

# Create custom model
ssh -i "$HOME/.ssh/id_ed25519" flomaster@flomasterserver "
  ollama create sharmanka-coder:v2 -f ~/projects/sharmanka/MODELFILE
"
```

## Agent Rules

1. Check resources before heavy operations
2. Stop services before ML training
3. Restore services after
4. Check disk space before large downloads
5. Use screen/tmux for long-running tasks
6. Use `-i "$HOME/.ssh/id_ed25519"` for all SSH commands (Cyrillic path fix)
