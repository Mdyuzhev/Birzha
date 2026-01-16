#!/bin/bash

API="http://localhost:31081/api"

# Login
TOKEN=$(curl -s -X POST "$API/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

# Create 50 employees if needed
DEPS=("IT" "HR" "Finance" "Sales" "Marketing" "Operations")
POSITIONS=("Junior" "Middle" "Senior" "Lead" "Manager")

for i in $(seq 1 50); do
  DEP=${DEPS[$((RANDOM % ${#DEPS[@]}))]}
  POS=${POSITIONS[$((RANDOM % ${#POSITIONS[@]}))]}
  
  curl -s -X POST "$API/employees" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"fullName\":\"Сотрудник Test $i\",\"email\":\"test$i@company.com\",\"customFields\":{\"department\":\"$DEP\",\"position\":\"$POS\"}}" > /dev/null
done
echo "Created test employees"

# Get all employees
EMPLOYEES=$(curl -s "$API/employees" -H "Authorization: Bearer $TOKEN" | grep -o '"id":[0-9]*' | cut -d: -f2)
COUNT=$(echo "$EMPLOYEES" | wc -l)
echo "Total employees: $COUNT"

# Assessment configs for each box (at least 5 per box)
# Format: q1,q2,q3,q4,q5
# Performance = (q1+q2+q3)/3: <=2.3=Low, <=3.6=Med, >3.6=High
# Potential = (q4+q5)/2: <=2.3=Low, <=3.6=Med, >3.6=High

declare -A BOX_CONFIGS
BOX_CONFIGS[1]="1,1,1,1,1 1,2,1,1,2 2,1,2,2,1 1,2,2,1,1 2,2,2,2,2"  # Low perf, Low pot
BOX_CONFIGS[2]="3,3,3,1,1 3,3,3,2,2 3,3,4,1,2 3,4,3,2,1 4,3,2,2,2"  # Med perf, Low pot
BOX_CONFIGS[3]="5,5,5,1,1 4,5,5,2,2 5,4,5,1,2 5,5,4,2,1 4,4,5,2,2"  # High perf, Low pot
BOX_CONFIGS[4]="1,1,1,3,3 1,2,1,3,4 2,1,2,4,3 1,2,2,3,3 2,2,2,3,4"  # Low perf, Med pot
BOX_CONFIGS[5]="3,3,3,3,3 3,3,4,3,4 3,4,3,4,3 4,3,3,3,4 3,4,4,4,3"  # Med perf, Med pot
BOX_CONFIGS[6]="5,5,5,3,3 4,5,5,3,4 5,4,5,4,3 5,5,4,3,4 4,4,5,4,3"  # High perf, Med pot
BOX_CONFIGS[7]="1,1,1,5,5 1,2,1,4,5 2,1,2,5,4 1,2,2,5,5 2,2,2,4,5"  # Low perf, High pot
BOX_CONFIGS[8]="3,3,3,5,5 3,3,4,4,5 3,4,3,5,4 4,3,3,5,5 3,4,4,5,4"  # Med perf, High pot
BOX_CONFIGS[9]="5,5,5,5,5 4,5,5,5,4 5,4,5,4,5 5,5,4,5,5 4,4,5,5,5"  # High perf, High pot

# Assign assessments
i=0
for EMP_ID in $EMPLOYEES; do
  BOX=$(( (i % 9) + 1 ))
  CONFIGS=(${BOX_CONFIGS[$BOX]})
  CONFIG=${CONFIGS[$((RANDOM % ${#CONFIGS[@]}))]}
  IFS=',' read -r Q1 Q2 Q3 Q4 Q5 <<< "$CONFIG"
  
  curl -s -X POST "$API/nine-box" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"employeeId\":$EMP_ID,\"q1Results\":$Q1,\"q2Goals\":$Q2,\"q3Quality\":$Q3,\"q4Growth\":$Q4,\"q5Leadership\":$Q5,\"comment\":\"Assessment for box $BOX\"}" > /dev/null
  
  echo -n "."
  ((i++))
  if [ $i -ge 54 ]; then break; fi
done

echo ""
echo "Assigned $i assessments"

# Statistics
echo ""
echo "=== Box Distribution ==="
STATS=$(curl -s "$API/nine-box/statistics" -H "Authorization: Bearer $TOKEN")
for box in $(seq 1 9); do
  COUNT=$(echo "$STATS" | grep -o "\"$box\":[0-9]*" | head -1 | cut -d: -f2)
  echo "Box $box: ${COUNT:-0}"
done
