#!/bin/bash

API="http://localhost:31081/api"

TOKEN=$(curl -s -X POST "$API/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

echo "Creating employees..."
DEPS=("IT" "HR" "Finance" "Sales" "Marketing")
POSITIONS=("Junior" "Middle" "Senior" "Lead" "Manager")
NAMES=("Ivan" "Petr" "Sergey" "Dmitry" "Alexey" "Nikolay" "Andrey" "Mikhail" "Viktor" "Oleg")
SURNAMES=("Ivanov" "Petrov" "Sidorov" "Kozlov" "Smirnov" "Volkov" "Fedorov" "Morozov" "Novikov" "Orlov")

for i in $(seq 1 50); do
  NAME="${NAMES[$((RANDOM % 10))]} ${SURNAMES[$((RANDOM % 10))]} $i"
  DEP="${DEPS[$((RANDOM % 5))]}"
  POS="${POSITIONS[$((RANDOM % 5))]}"
  
  curl -s -X POST "$API/employees" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"fullName\":\"$NAME\",\"email\":\"emp$i@company.com\",\"customFields\":{\"department\":\"$DEP\",\"position\":\"$POS\"}}" > /dev/null 2>&1
done
echo "Done creating"

# Get employees
EMPLOYEES=$(curl -s "$API/employees" -H "Authorization: Bearer $TOKEN" | grep -o '"id":[0-9]*' | cut -d: -f2)
COUNT=$(echo "$EMPLOYEES" | wc -l)
echo "Total: $COUNT employees"

# Delete old assessments
echo "Clearing old assessments..."
OLD_IDS=$(curl -s "$API/nine-box" -H "Authorization: Bearer $TOKEN" | grep -o '"id":[0-9]*' | cut -d: -f2)
for ID in $OLD_IDS; do
  curl -s -X DELETE "$API/nine-box/$ID" -H "Authorization: Bearer $TOKEN" > /dev/null
done

# Configs for each box (6 employees each)
declare -A CONFIGS
CONFIGS[1]="1,1,1,1,1"  # Low/Low
CONFIGS[2]="3,3,3,1,2"  # Med/Low  
CONFIGS[3]="5,5,5,1,2"  # High/Low
CONFIGS[4]="1,1,1,3,3"  # Low/Med
CONFIGS[5]="3,3,3,3,3"  # Med/Med
CONFIGS[6]="5,5,5,3,3"  # High/Med
CONFIGS[7]="1,1,1,5,5"  # Low/High
CONFIGS[8]="3,3,3,5,5"  # Med/High
CONFIGS[9]="5,5,5,5,5"  # High/High

echo "Assigning assessments..."
i=0
for EMP_ID in $EMPLOYEES; do
  BOX=$(( (i % 9) + 1 ))
  IFS=',' read -r Q1 Q2 Q3 Q4 Q5 <<< "${CONFIGS[$BOX]}"
  
  # Add some variation
  Q1=$((Q1 + (RANDOM % 2)))
  Q2=$((Q2 + (RANDOM % 2)))
  [ $Q1 -gt 5 ] && Q1=5
  [ $Q2 -gt 5 ] && Q2=5
  
  curl -s -X POST "$API/nine-box" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"employeeId\":$EMP_ID,\"q1Results\":$Q1,\"q2Goals\":$Q2,\"q3Quality\":$Q3,\"q4Growth\":$Q4,\"q5Leadership\":$Q5,\"comment\":\"Auto\"}" > /dev/null
  
  ((i++))
done
echo "Created $i assessments"

echo ""
echo "=== Distribution ==="
curl -s "$API/nine-box/statistics" -H "Authorization: Bearer $TOKEN" | \
  sed 's/.*boxDistribution":{//' | sed 's/},.*//' | tr ',' '\n' | \
  sed 's/"//g' | sort -t: -k1 -n
