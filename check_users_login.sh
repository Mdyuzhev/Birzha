#!/bin/bash

API_URL="http://localhost:31081/api/auth/login"
FAILED=()
SUCCESS=0

echo "Проверка логина всех пользователей..."
echo ""

while IFS='|' read -r dzo login password role fio; do
    # Пропустить заголовок и пустые строки
    [[ "$login" =~ ^[[:space:]]*Логин ]] && continue
    [[ "$login" =~ ^[[:space:]]*---[[:space:]]*$ ]] && continue
    [[ -z "$login" ]] && continue
    
    # Убрать пробелы
    login=$(echo "$login" | xargs)
    password=$(echo "$password" | xargs)
    
    # Проверить логин
    response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -d "{\"username\":\"$login\",\"password\":\"$password\"}")
    
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" == "200" ]; then
        echo "✅ $login"
        ((SUCCESS++))
    else
        echo "❌ $login (HTTP $http_code)"
        FAILED+=("$login")
    fi
done < users_list.txt

echo ""
echo "=== РЕЗУЛЬТАТ ==="
echo "Успешно: $SUCCESS"
echo "Ошибок: ${#FAILED[@]}"

if [ ${#FAILED[@]} -gt 0 ]; then
    echo ""
    echo "Не прошли проверку:"
    for user in "${FAILED[@]}"; do
        echo "  - $user"
    done
fi
