#!/usr/bin/env python3
"""
Генератор исторических данных по заявкам за последние 6 месяцев
Создает SQL скрипт для вставки напрямую в БД
"""

import random
from datetime import datetime, timedelta

# Параметры генерации
START_DATE = datetime(2025, 7, 22)
END_DATE = datetime(2026, 1, 22)
TOTAL_APPLICATIONS = 180

# Статусы и их вероятности
STATUS_DISTRIBUTION = {
    'TRANSFERRED': 0.30,  # 30% - завершено успешно
    'CANCELLED': 0.08,
    'REJECTED_HR_BP': 0.04,
    'REJECTED_BORUP': 0.03,  # 15% всего отклонено
    'PREPARING_TRANSFER': 0.10,
    'PENDING_HR_BP': 0.08,
    'PENDING_BORUP': 0.07,  # 15% на согласовании
    'IN_PROGRESS': 0.12,
    'INTERVIEW': 0.08,  # 20% в работе
    'AVAILABLE_FOR_REVIEW': 0.07,
    'DRAFT': 0.03,  # 10% новые
}

# Типы заявок
APPLICATION_TYPES = {
    'DEVELOPMENT': 0.60,
    'ROTATION': 0.40
}

# Целевые должности
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

# Технологические стеки
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

    # Распределение изменения ЗП
    rand = random.random()
    if rand < 0.40:  # 40% - до 20%
        increase_pct = random.uniform(0.05, 0.20)
    elif rand < 0.75:  # 35% - 20-30%
        increase_pct = random.uniform(0.20, 0.30)
    else:  # 25% - больше 30%
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

def get_application_type():
    """Выбирает тип заявки"""
    return 'DEVELOPMENT' if random.random() < 0.60 else 'ROTATION'

def generate_applications_sql():
    """Генерирует SQL скрипт для вставки заявок"""

    print("-- Генерация исторических данных по заявкам")
    print("-- Период:", START_DATE.strftime('%Y-%m-%d'), "до", END_DATE.strftime('%Y-%m-%d'))
    print("-- Количество заявок:", TOTAL_APPLICATIONS)
    print()

    # Получаем ID сотрудников (реально в БД 14 сотрудников)
    employees_count = 14
    # Получаем ID пользователей (61 пользователь в БД)
    users_count = 61

    sql_lines = []

    for i in range(1, TOTAL_APPLICATIONS + 1):
        # Базовые данные
        dzo_id = random.randint(1, 10)  # 10 ДЗО
        employee_id = random.randint(1, employees_count)
        created_by = random.randint(1, users_count)

        # Даты
        created_at = random_date(START_DATE, END_DATE)
        updated_at = created_at + timedelta(days=random.randint(0, 30))

        # Статус
        status = get_status_by_probability()

        # Должность и стек
        target_position = random.choice(TARGET_POSITIONS)
        target_stack = random.choice(TECH_STACKS)

        # Зарплаты
        current_salary, target_salary = generate_salary_data()

        # Назначения (для заявок в работе)
        recruiter_id = 'NULL'
        hr_bp_id = 'NULL'
        borup_id = 'NULL'

        if status not in ['DRAFT', 'AVAILABLE_FOR_REVIEW']:
            recruiter_id = str(random.randint(1, 10))  # Предполагаем 10 рекрутеров

        if status in ['PENDING_HR_BP', 'APPROVED_HR_BP', 'REJECTED_HR_BP',
                      'PENDING_BORUP', 'APPROVED_BORUP', 'REJECTED_BORUP',
                      'PREPARING_TRANSFER', 'TRANSFERRED']:
            hr_bp_id = str(random.randint(1, 10))

        # Если рост ЗП > 30%, нужен БОРУП
        salary_increase_pct = ((target_salary - current_salary) / current_salary) * 100
        if salary_increase_pct > 30 and status in ['PENDING_BORUP', 'APPROVED_BORUP',
                                                     'REJECTED_BORUP', 'PREPARING_TRANSFER',
                                                     'TRANSFERRED']:
            borup_id = str(random.randint(1, 5))  # Предполагаем 5 БОРУПов

        # Комментарий
        comments = [
            'Кандидат показывает хорошие результаты',
            'Рекомендован руководителем',
            'Необходимо усилить команду',
            'Перспективный специалист',
            'Внутренняя ротация',
            'Развитие компетенций',
            None
        ]
        comment = random.choice(comments)
        comment_sql = f"'{comment}'" if comment else 'NULL'

        # Формируем SQL
        sql = f"""INSERT INTO applications (dzo_id, employee_id, created_by, created_at, updated_at, status,
    target_position, target_stack, current_salary, target_salary,
    recruiter_id, hr_bp_id, borup_id, comment)
VALUES ({dzo_id}, {employee_id}, {created_by},
    '{created_at.strftime('%Y-%m-%d %H:%M:%S')}',
    '{updated_at.strftime('%Y-%m-%d %H:%M:%S')}',
    '{status}',
    '{target_position}', '{target_stack}',
    {current_salary}, {target_salary},
    {recruiter_id}, {hr_bp_id}, {borup_id}, {comment_sql});"""

        sql_lines.append(sql)

    return sql_lines

def main():
    """Основная функция"""
    print("=" * 80)
    print("ГЕНЕРАТОР ИСТОРИЧЕСКИХ ДАННЫХ ПО ЗАЯВКАМ")
    print("=" * 80)
    print()

    # Генерируем SQL
    sql_lines = generate_applications_sql()

    # Записываем в файл
    output_file = "insert_applications_history.sql"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("-- Автоматически сгенерированные исторические данные по заявкам\n")
        f.write(f"-- Дата генерации: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"-- Количество заявок: {len(sql_lines)}\n")
        f.write("\n")
        f.write("BEGIN;\n\n")
        f.write("\n".join(sql_lines))
        f.write("\n\nCOMMIT;\n")

    print()
    print("=" * 80)
    print(f"SQL script created: {output_file}")
    print(f"Total applications: {len(sql_lines)}")
    print()
    print("To load into DB run:")
    print(f"   docker-compose exec -T postgres psql -U resourceuser -d resourcedb < {output_file}")
    print("=" * 80)

if __name__ == '__main__':
    main()
