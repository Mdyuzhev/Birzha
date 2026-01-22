#!/usr/bin/env python3
import requests
import json
import sys

API_URL = "http://localhost:31081"

# Маппинг ДЗО на ID
DZO_MAP = {
    "ЦОД": 1,
    "Солар": 2,
    "БФТ": 3,
    "Т2": 4,
    "Базис": 5,
    "РТЛабс": 6,
    "ОМП": 7,
    "ПАО_РТК": 8,
    "РТК": 9,
    "РТК_ИТ": 10
}

print("=== Авторизация ===")
try:
    response = requests.post(f"{API_URL}/api/auth/login", json={
        "username": "admin",
        "password": "admin123"
    })
    response.raise_for_status()
    token = response.json()["token"]
    print("✅ Токен получен")
except Exception as e:
    print(f"❌ Ошибка авторизации: {e}")
    sys.exit(1)

headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}

print()
print("=== Создание пользователей ===")

success = 0
failed = 0

with open("users_list.txt", "r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line or "Логин" in line or "---" in line:
            continue
        
        parts = [p.strip() for p in line.split("|")]
        if len(parts) < 5:
            continue
        
        dzo, login, password, role, fio = parts
        
        dzo_id = DZO_MAP.get(dzo)
        if not dzo_id:
            print(f"❌ {login} - неизвестное ДЗО: {dzo}")
            failed += 1
            continue
        
        payload = {
            "username": login,
            "password": password,
            "fullName": fio,
            "roles": [role],
            "dzoId": dzo_id
        }
        
        try:
            response = requests.post(f"{API_URL}/api/users", json=payload, headers=headers)
            if response.status_code == 200:
                print(f"✅ {login} ({role} @ {dzo})")
                success += 1
            else:
                print(f"❌ {login} (HTTP {response.status_code}) - {response.text}")
                failed += 1
        except Exception as e:
            print(f"❌ {login} - {e}")
            failed += 1

print()
print("=== РЕЗУЛЬТАТ ===")
print(f"Успешно создано: {success}")
print(f"Ошибок: {failed}")
