#!/bin/bash

TOKEN="eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhZG1pbiIsInJvbGVzIjpbIlNZU1RFTV9BRE1JTiIsIk1BTkFHRVIiXSwiaWF0IjoxNzY5MDI3ODIwLCJleHAiOjE3NjkxMTQyMjB9.192n3xfyLXfHPJHIBwK5q8eC_AZHY_MF9SZClTsgN9wqpYB8BA2VRVs6qTJiRKTI"

# Массив ДЗО: id, код, название
dzos=(
  "1:cod:ЦОД"
  "2:solar:Солар"
  "3:bft:БФТ"
  "4:t2:Т2"
  "5:basis:Базис"
  "6:labs:РТЛабс"
  "7:omp:ОМП"
  "8:paortk:ПАО_РТК"
  "9:rtk:РТК"
  "10:rtkit:РТК_ИТ"
)

# Роли
roles=("DZO_ADMIN" "RECRUITER" "HR_BP" "BORUP" "MANAGER")

echo "=== СОЗДАНИЕ ПОЛЬЗОВАТЕЛЕЙ ==="
echo ""

# Файл для сохранения результатов
output_file="users_list.txt"
echo "ДЗО | Логин | Пароль | Роль" > $output_file
echo "---|---|---|---" >> $output_file

for dzo_entry in "${dzos[@]}"; do
  IFS=':' read -r dzo_id dzo_code dzo_name <<< "$dzo_entry"

  echo "=== $dzo_name (ID: $dzo_id, Code: $dzo_code) ==="

  for role in "${roles[@]}"; do
    username="${dzo_code}_${role,,}"
    password="pass123"

    # Создание пользователя
    result=$(curl -s -X POST http://localhost:31081/api/users \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"username\":\"$username\",\"password\":\"$password\",\"roles\":[\"$role\"],\"dzoId\":$dzo_id}")

    # Проверка результата
    if echo "$result" | grep -q '"id"'; then
      echo "✅ $username - $role"
      echo "$dzo_name | $username | $password | $role" >> $output_file
    else
      echo "❌ $username - ОШИБКА: $result"
      echo "$dzo_name | $username | $password | $role (ОШИБКА)" >> $output_file
    fi
  done

  echo ""
done

echo ""
echo "=== ГОТОВО ==="
echo "Список пользователей сохранён в: $output_file"
cat $output_file
