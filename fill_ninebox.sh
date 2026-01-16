#!/bin/bash

API="http://localhost:31081/api"

# Login
TOKEN=$(curl -s -X POST "$API/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

echo "Token: ${TOKEN:0:20}..."

# Get employees
EMPLOYEES=$(curl -s "$API/employees" -H "Authorization: Bearer $TOKEN" | grep -o '"id":[0-9]*' | cut -d: -f2 | head -50)
COUNT=$(echo "$EMPLOYEES" | wc -l)
echo "Found $COUNT employees"

# Box configurations: [q1,q2,q3,q4,q5]
# Box 1: Low perf, Low pot
# Box 2: Med perf, Low pot
# Box 3: High perf, Low pot
# Box 4: Low perf, Med pot
# Box 5: Med perf, Med pot
# Box 6: High perf, Med pot
# Box 7: Low perf, High pot
# Box 8: Med perf, High pot
# Box 9: High perf, High pot

declare -a CONFIGS=(
  "1,2,2,1,2"  # Box 1
  "1,2,1,2,1"  # Box 1
  "2,2,2,2,2"  # Box 1
  "3,3,3,1,2"  # Box 2
  "3,3,3,2,2"  # Box 2
  "3,4,2,1,2"  # Box 2
  "4,5,4,1,2"  # Box 3
  "5,4,4,2,2"  # Box 3
  "5,5,5,2,1"  # Box 3
  "1,2,2,3,3"  # Box 4
  "2,2,1,3,4"  # Box 4
  "2,1,2,4,3"  # Box 4
  "3,3,3,3,3"  # Box 5
  "3,3,4,3,3"  # Box 5
  "3,4,3,4,3"  # Box 5
  "4,5,4,3,3"  # Box 6
  "5,4,5,3,4"  # Box 6
  "5,5,4,4,3"  # Box 6
  "1,2,2,5,5"  # Box 7
  "2,2,1,4,5"  # Box 7
  "2,1,2,5,4"  # Box 7
  "3,3,3,4,5"  # Box 8
  "3,4,3,5,4"  # Box 8
  "4,3,3,5,5"  # Box 8
  "5,5,5,5,5"  # Box 9
  "4,5,5,5,4"  # Box 9
  "5,4,5,4,5"  # Box 9
)

i=0
for EMP_ID in $EMPLOYEES; do
  CONFIG=${CONFIGS[$((i % ${#CONFIGS[@]}))]}
  IFS=',' read -r Q1 Q2 Q3 Q4 Q5 <<< "$CONFIG"
  
  RESULT=$(curl -s -X POST "$API/nine-box" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"employeeId\":$EMP_ID,\"q1Results\":$Q1,\"q2Goals\":$Q2,\"q3Quality\":$Q3,\"q4Growth\":$Q4,\"q5Leadership\":$Q5,\"comment\":\"Auto assessment\"}")
  
  BOX=$(echo "$RESULT" | grep -o '"boxPosition":[0-9]*' | cut -d: -f2)
  echo "Employee $EMP_ID -> Box $BOX (q1=$Q1,q2=$Q2,q3=$Q3,q4=$Q4,q5=$Q5)"
  
  ((i++))
  if [ $i -ge 50 ]; then break; fi
done

echo ""
echo "=== Statistics ==="
curl -s "$API/nine-box/statistics" -H "Authorization: Bearer $TOKEN" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print('Box distribution:')
for box in range(1,10):
    count = data.get('boxDistribution',{}).get(str(box),0)
    print(f'  Box {box}: {count}')
print(f'Total: {data.get(\"totalAssessments\",0)}')" 2>/dev/null || echo "Stats loaded"
