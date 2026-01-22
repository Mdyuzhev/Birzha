#!/bin/bash

API_URL="http://localhost:31081"

# Получение JWT токена
echo "=== Авторизация ==="
TOKEN=$(curl -s -X POST "$API_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "❌ Ошибка авторизации"
    exit 1
fi

echo "✅ Токен получен"
echo ""

# Маппинг ДЗО на ID
declare -A DZO_MAP
DZO_MAP["ЦОД"]=1
DZO_MAP["Солар"]=2
DZO_MAP["БФТ"]=3
DZO_MAP["Т2"]=4
DZO_MAP["Базис"]=5
DZO_MAP["РТЛабс"]=6
DZO_MAP["ОМП"]=7
DZO_MAP["ПАО_РТК"]=8
DZO_MAP["РТК"]=9
DZO_MAP["РТК_ИТ"]=10

SUCCESS=0
FAILED=0

echo "=== Создание пользователей ==="

while IFS='|' read -r dzo login password role fio; do
    # Пропустить заголовок и пустые строки
    [[ "$login" =~ ^[[:space:]]*Логин ]] && continue
    [[ "$login" =~ ^[[:space:]]*---[[:space:]]*$ ]] && continue
    [[ -z "$login" ]] && continue
    
    # Убрать пробелы
    dzo=$(echo "$dzo" | xargs)
    login=$(echo "$login" | xargs)
    password=$(echo "$password" | xargs)
    role=$(echo "$role" | xargs)
    fio=$(echo "$fio" | xargs)
    
    # Получить ID ДЗО
    dzo_id="${DZO_MAP[$dzo]}"
    
    if [ -z "$dzo_id" ]; then
        echo "❌ $login - неизвестное ДЗО: $dzo"
        ((FAILED++))
        continue
    fi
    
    # Создать JSON payload
    payload=$(cat <<JSON_END
{
  "username": "$login",
  "password": "$password",
  "fullName": "$fio",
  "roles": ["$role"],
  "dzoId": $dzo_id
}
JSON_END
)
    
    # Отправить POST запрос
    response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL/api/users" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -d "$payload")
    
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" == "200" ]; then
        echo "✅ $login ($role @ $dzo)"
        ((SUCCESS++))
    else
        body=$(echo "$response" | head -n -1)
        echo "❌ $login (HTTP $http_code) - $body"
        ((FAILED++))
    fi
done < users_list.txt

echo ""
echo "=== РЕЗУЛЬТАТ ==="
echo "Успешно создано: $SUCCESS"
echo "Ошибок: $FAILED"
