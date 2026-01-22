#!/usr/bin/env python3
"""
Генератор исторических данных по заявкам за последние 6 месяцев
Создает заявки через API
"""

import requests
import random
from datetime import datetime, timedelta
import sys

# API URL
API_URL = "http://localhost:31081"

# Параметры генерации
START_DATE = datetime(2025, 7, 22)
END_DATE = datetime(2026, 1, 22)
TOTAL_APPLICATIONS = 180

# Статусы и их вероятности
STATUS_DISTRIBUTION = {
    'TRANSFERRED': 0.30,
    'CANCELLED': 0.08,
    'REJECTED_HR_BP': 0.04,
    'REJECTED_BORUP': 0.03,
    'PREPARING_TRANSFER': 0.10,
    'PENDING_HR_BP': 0.08,
    'PENDING_BORUP': 0.07,
    'IN_PROGRESS': 0.12,
    'INTERVIEW': 0.08,
    'AVAILABLE_FOR_REVIEW': 0.07,
    'DRAFT': 0.03,
}

TARGET_POSITIONS = [
    'Senior Java Developer',
    'Lead Frontend Developer',
    'DevOps Engineer',
    'Solution Architect',
    'Team Lead',
    'Principal Engineer',
    'Senior QA Engineer',
    'Product Manager',
    'Senior Business Analyst',
    'Data Engineer',
    'ML Engineer',
    'Security Engineer',
    'Senior Backend Developer',
    'Senior Python Developer',
    'Cloud Architect'
]

TECH_STACKS = [
    'Java/Spring',
    'Python/Django',
    'React/TypeScript',
    'Vue.js/Node.js',
    'Go/Kubernetes',
    'DevOps/AWS',
    'Data Science/ML',
    'Security/Pen Testing',
    'QA/Automation',
    'Product/Agile'
]

def random_date(start, end):
    """Генерирует случайную дату между start и end"""
    delta = end - start
    random_days = random.randint(0, delta.days)
    return start + timedelta(days=random_days)

def generate_salary_data():
    """Генерирует текущую и целевую зарплату"""
    current = random.randint(80, 300) * 1000
    rand = random.random()
    if rand < 0.40:
        increase_pct = random.uniform(0.05, 0.20)
    elif rand < 0.75:
        increase_pct = random.uniform(0.20, 0.30)
    else:
        increase_pct = random.uniform(0.30, 0.50)
    target = int(current * (1 + increase_pct))
    return current, target

def get_status_by_probability():
    """Выбирает статус на основе вероятности"""
    rand = random.random()
    cumulative = 0
    for status, prob in STATUS_DISTRIBUTION.items():
        cumulative += prob
        if rand < cumulative:
            return status
    return 'DRAFT'

def auth():
    """Авторизация в API"""
    print("=== Authorization ===")
    try:
        response = requests.post(f"{API_URL}/api/auth/login", json={
            "username": "admin",
            "password": "admin123"
        })
        response.raise_for_status()
        token = response.json()["token"]
        print("Token received")
        return token
    except Exception as e:
        print(f"Authorization error: {e}")
        sys.exit(1)

def get_employees(token):
    """Получает список ID сотрудников"""
    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.get(f"{API_URL}/api/employees?size=1000", headers=headers)
        response.raise_for_status()
        employees = response.json()["content"]
        employee_ids = [e["id"] for e in employees]
        print(f"Found {len(employee_ids)} employees")
        return employee_ids
    except Exception as e:
        print(f"Error fetching employees: {e}")
        return []

def get_users(token):
    """Получает список ID пользователей"""
    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.get(f"{API_URL}/api/users?size=1000", headers=headers)
        response.raise_for_status()
        users = response.json()
        # API возвращает массив, а не объект с content
        if isinstance(users, list):
            user_ids = [u["id"] for u in users]
        else:
            user_ids = [u["id"] for u in users["content"]]
        print(f"Found {len(user_ids)} users")
        return user_ids
    except Exception as e:
        print(f"Error fetching users: {e}")
        return []

def create_application_via_sql(conn_string, data):
    """Создает заявку напрямую в БД через SQL"""
    import psycopg2
    conn = psycopg2.connect(conn_string)
    cur = conn.cursor()

    sql = """
    INSERT INTO applications (
        dzo_id, employee_id, created_by, created_at, updated_at, status,
        target_position, target_stack, current_salary, target_salary,
        recruiter_id, hr_bp_id, borup_id, comment
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """

    cur.execute(sql, (
        data['dzo_id'],
        data['employee_id'],
        data['created_by'],
        data['created_at'],
        data['updated_at'],
        data['status'],
        data['target_position'],
        data['target_stack'],
        data['current_salary'],
        data['target_salary'],
        data['recruiter_id'],
        data['hr_bp_id'],
        data['borup_id'],
        data['comment']
    ))

    conn.commit()
    cur.close()
    conn.close()

def main():
    """Основная функция"""
    print("=" * 80)
    print("HISTORIC APPLICATIONS DATA GENERATOR")
    print("=" * 80)
    print()

    # Авторизация
    token = auth()

    # Получаем существующие ID
    employee_ids = get_employees(token)
    user_ids = get_users(token)

    if not employee_ids or not user_ids:
        print("ERROR: No employees or users found")
        sys.exit(1)

    print()
    print("=" * 80)
    print(f"Generating {TOTAL_APPLICATIONS} applications...")
    print("=" * 80)
    print()

    # Подключение к БД
    conn_string = "host=localhost port=31432 dbname=resourcedb user=resourceuser password=resourcepass"

    success = 0
    failed = 0

    for i in range(1, TOTAL_APPLICATIONS + 1):
        dzo_id = random.randint(1, 10)
        employee_id = random.choice(employee_ids)
        created_by = random.choice(user_ids)

        created_at = random_date(START_DATE, END_DATE)
        updated_at = created_at + timedelta(days=random.randint(0, 30))

        status = get_status_by_probability()
        target_position = random.choice(TARGET_POSITIONS)
        target_stack = random.choice(TECH_STACKS)
        current_salary, target_salary = generate_salary_data()

        recruiter_id = None
        hr_bp_id = None
        borup_id = None

        if status not in ['DRAFT', 'AVAILABLE_FOR_REVIEW']:
            recruiter_id = random.choice(user_ids)

        if status in ['PENDING_HR_BP', 'APPROVED_HR_BP', 'REJECTED_HR_BP',
                      'PENDING_BORUP', 'APPROVED_BORUP', 'REJECTED_BORUP',
                      'PREPARING_TRANSFER', 'TRANSFERRED']:
            hr_bp_id = random.choice(user_ids)

        salary_increase_pct = ((target_salary - current_salary) / current_salary) * 100
        if salary_increase_pct > 30 and status in ['PENDING_BORUP', 'APPROVED_BORUP',
                                                     'REJECTED_BORUP', 'PREPARING_TRANSFER',
                                                     'TRANSFERRED']:
            borup_id = random.choice(user_ids)

        comments = [
            'Strong candidate',
            'Recommended by manager',
            'Team needs reinforcement',
            'Promising specialist',
            'Internal rotation',
            'Skills development',
            None
        ]
        comment = random.choice(comments)

        try:
            data = {
                'dzo_id': dzo_id,
                'employee_id': employee_id,
                'created_by': created_by,
                'created_at': created_at,
                'updated_at': updated_at,
                'status': status,
                'target_position': target_position,
                'target_stack': target_stack,
                'current_salary': current_salary,
                'target_salary': target_salary,
                'recruiter_id': recruiter_id,
                'hr_bp_id': hr_bp_id,
                'borup_id': borup_id,
                'comment': comment
            }

            create_application_via_sql(conn_string, data)
            success += 1
            if i % 10 == 0:
                print(f"Created {i}/{TOTAL_APPLICATIONS} applications...")
        except Exception as e:
            failed += 1
            print(f"ERROR creating application {i}: {e}")

    print()
    print("=" * 80)
    print(f"RESULT: {success} created, {failed} errors")
    print("=" * 80)

if __name__ == '__main__':
    main()
