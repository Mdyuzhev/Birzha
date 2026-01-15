import requests
import random
from datetime import datetime, timedelta

BASE_URL = "http://flomasterserver:31081/api"

USERS = [
    {"username": "admin", "password": "admin123"},
    {"username": "Galya", "password": "admin123"},
    {"username": "Kris", "password": "admin123"},
    {"username": "Irek", "password": "admin123"}
]

POSITIONS = ["Junior Developer", "Middle Developer", "Senior Developer", "Team Lead", "Tech Lead", "Project Manager", "DevOps Engineer", "QA Engineer", "Designer", "Analyst"]
DEPARTMENTS = ["Backend", "Frontend", "Mobile", "DevOps", "QA", "Design", "Analytics", "Management"]
GRADES = ["Junior", "Middle", "Senior", "Lead", "Principal"]
STATUSES = ["На проекте", "На бенче", "В отпуске", "Болеет"]
LOCATIONS = ["Москва", "Санкт-Петербург", "Удалённо", "Гибрид"]

MALE_FIRST = ["Александр", "Дмитрий", "Максим", "Сергей", "Андрей", "Алексей", "Артём", "Илья", "Кирилл", "Михаил", "Никита", "Матвей", "Роман", "Егор", "Арсений", "Иван", "Денис", "Евгений", "Даниил", "Тимофей", "Владислав", "Игорь", "Владимир", "Павел", "Руслан", "Марк", "Константин", "Тимур", "Олег", "Ярослав", "Антон", "Николай", "Глеб", "Данил", "Савелий", "Вадим", "Степан", "Юрий", "Богдан", "Артур"]
MALE_MIDDLE = ["Александрович", "Дмитриевич", "Максимович", "Сергеевич", "Андреевич", "Алексеевич", "Артёмович", "Ильич", "Кириллович", "Михайлович", "Никитич", "Романович", "Егорович", "Иванович", "Денисович", "Евгеньевич", "Владимирович", "Павлович", "Олегович", "Николаевич", "Антонович", "Юрьевич", "Вадимович", "Степанович", "Игоревич", "Константинович", "Тимурович", "Русланович", "Маркович", "Ярославович"]
MALE_LAST = ["Иванов", "Смирнов", "Кузнецов", "Попов", "Васильев", "Петров", "Соколов", "Михайлов", "Новиков", "Федоров", "Морозов", "Волков", "Алексеев", "Лебедев", "Семенов", "Егоров", "Павлов", "Козлов", "Степанов", "Николаев", "Орлов", "Андреев", "Макаров", "Никитин", "Захаров", "Зайцев", "Соловьев", "Борисов", "Яковлев", "Григорьев", "Романов", "Воробьев", "Сергеев", "Кузьмин", "Фролов", "Александров", "Дмитриев", "Королев", "Гусев", "Киселев", "Ильин", "Максимов", "Поляков", "Сорокин", "Виноградов", "Ковалев", "Белов", "Медведев", "Антонов", "Тарасов"]
FEMALE_FIRST = ["Анна", "Мария", "Елена", "Ольга", "Наталья", "Татьяна", "Ирина", "Светлана", "Екатерина", "Анастасия", "Дарья", "Алиса", "Полина", "Виктория", "Александра", "Ксения", "Юлия", "Валерия", "София", "Вероника", "Алина", "Марина", "Евгения", "Кристина", "Диана", "Яна", "Надежда", "Любовь", "Галина", "Людмила"]
FEMALE_MIDDLE = ["Александровна", "Дмитриевна", "Максимовна", "Сергеевна", "Андреевна", "Алексеевна", "Артёмовна", "Ильинична", "Кирилловна", "Михайловна", "Никитична", "Романовна", "Егоровна", "Ивановна", "Денисовна", "Евгеньевна", "Владимировна", "Павловна", "Олеговна", "Николаевна", "Антоновна", "Юрьевна", "Вадимовна", "Степановна", "Игоревна", "Константиновна", "Тимуровна", "Руслановна", "Марковна", "Ярославовна"]
FEMALE_LAST = ["Иванова", "Смирнова", "Кузнецова", "Попова", "Васильева", "Петрова", "Соколова", "Михайлова", "Новикова", "Федорова", "Морозова", "Волкова", "Алексеева", "Лебедева", "Семенова", "Егорова", "Павлова", "Козлова", "Степанова", "Николаева", "Орлова", "Андреева", "Макарова", "Никитина", "Захарова", "Зайцева", "Соловьева", "Борисова", "Яковлева", "Григорьева", "Романова", "Воробьева", "Сергеева", "Кузьмина", "Фролова", "Александрова", "Дмитриева", "Королева", "Гусева", "Киселева", "Ильина", "Максимова", "Полякова", "Сорокина", "Виноградова", "Ковалева", "Белова", "Медведева", "Антонова", "Тарасова"]

PROJECTS = [
    "Единая биометрическая система", "Госуслуги 2.0", "Умный дом Ростелеком", "Wink платформа",
    "Цифровой офис", "RT Cloud", "Видеонаблюдение", "Кибербезопасность B2B",
    "5G инфраструктура", "IoT платформа", "AI Contact Center", "DataLake",
    "Billing System", "CRM Enterprise", "Mobile App", "API Gateway",
    "Service Mesh", "DevOps Platform", "ML Pipeline", "Monitoring System",
    "Analytics Dashboard", "Партнерский портал", "B2B личный кабинет", "Техподдержка 3.0"
]

BACKEND_SKILLS = ["Java", "Spring Boot", "PostgreSQL", "Redis", "Kafka", "Kubernetes", "Docker", "REST API", "gRPC", "Microservices"]
FRONTEND_SKILLS = ["React", "Vue.js", "TypeScript", "JavaScript", "HTML/CSS", "Redux", "Webpack", "Node.js", "GraphQL", "Next.js"]
MOBILE_SKILLS = ["Kotlin", "Swift", "Flutter", "React Native", "Android SDK", "iOS SDK", "Firebase", "Mobile CI/CD"]
DEVOPS_SKILLS = ["Kubernetes", "Docker", "Terraform", "Ansible", "Jenkins", "GitLab CI", "AWS", "Prometheus", "Grafana", "Linux"]
QA_SKILLS = ["Selenium", "JUnit", "TestNG", "Postman", "JMeter", "Allure", "API Testing", "Performance Testing", "Automation", "Manual Testing"]
DESIGN_SKILLS = ["Figma", "Sketch", "Adobe XD", "UI/UX", "Prototyping", "Design Systems", "User Research", "Wireframing"]
ANALYTICS_SKILLS = ["Python", "SQL", "Tableau", "Power BI", "Excel", "Statistics", "A/B Testing", "Data Visualization", "ETL", "Clickhouse"]
MANAGEMENT_SKILLS = ["Agile", "Scrum", "Kanban", "Jira", "Confluence", "Risk Management", "Budgeting", "Stakeholder Management", "Team Leadership"]

SKILLS_BY_DEPT = {
    "Backend": BACKEND_SKILLS, "Frontend": FRONTEND_SKILLS, "Mobile": MOBILE_SKILLS,
    "DevOps": DEVOPS_SKILLS, "QA": QA_SKILLS, "Design": DESIGN_SKILLS,
    "Analytics": ANALYTICS_SKILLS, "Management": MANAGEMENT_SKILLS
}

def get_token(username, password):
    try:
        r = requests.post(f"{BASE_URL}/auth/login", json={"username": username, "password": password}, timeout=5)
        return r.json().get("token")
    except:
        return None

def generate_name():
    if random.random() < 0.65:
        return f"{random.choice(MALE_LAST)} {random.choice(MALE_FIRST)} {random.choice(MALE_MIDDLE)}"
    else:
        return f"{random.choice(FEMALE_LAST)} {random.choice(FEMALE_FIRST)} {random.choice(FEMALE_MIDDLE)}"

def generate_email(full_name):
    parts = full_name.lower().split()
    translits = {"а":"a","б":"b","в":"v","г":"g","д":"d","е":"e","ё":"e","ж":"zh","з":"z","и":"i","й":"y","к":"k","л":"l","м":"m","н":"n","о":"o","п":"p","р":"r","с":"s","т":"t","у":"u","ф":"f","х":"kh","ц":"ts","ч":"ch","ш":"sh","щ":"sch","ъ":"","ы":"y","ь":"","э":"e","ю":"yu","я":"ya"}
    def translit(s):
        return "".join(translits.get(c, c) for c in s)
    last = translit(parts[0])
    first = translit(parts[1][0]) if len(parts) > 1 else ""
    return f"{first}.{last}@rt.ru"

def generate_hire_date():
    days_ago = random.randint(30, 3650)
    return (datetime.now() - timedelta(days=days_ago)).strftime("%Y-%m-%d")

def get_salary_by_grade(grade):
    base = {"Junior": 800, "Middle": 1500, "Senior": 2500, "Lead": 3500, "Principal": 5000}
    return base.get(grade, 1500) + random.randint(-200, 500)

def get_position_by_dept_and_grade(dept, grade):
    if dept == "Management":
        return "Project Manager"
    elif dept == "Design":
        return "Designer"
    elif dept == "Analytics":
        return "Analyst"
    elif dept == "QA":
        return "QA Engineer"
    elif dept == "DevOps":
        return "DevOps Engineer"
    else:
        if grade == "Junior": return "Junior Developer"
        elif grade == "Middle": return "Middle Developer"
        elif grade == "Senior": return "Senior Developer"
        elif grade == "Lead": return "Team Lead"
        else: return "Tech Lead"

def create_employee(token, data):
    headers = {"Authorization": f"Bearer {token}"}
    try:
        r = requests.post(f"{BASE_URL}/employees", json=data, headers=headers, timeout=10)
        return r.status_code in [200, 201]
    except Exception as e:
        print(f"Error: {e}")
        return False

tokens = {}
for user in USERS:
    t = get_token(user["username"], user["password"])
    if t:
        tokens[user["username"]] = t
        print(f"Got token for {user['username']}")

if not tokens:
    print("No tokens!")
    exit(1)

created = 0
for i in range(300):
    username = random.choice(list(tokens.keys()))
    token = tokens[username]

    dept = random.choice(DEPARTMENTS)
    grade = random.choices(GRADES, weights=[25, 35, 25, 10, 5])[0]
    status = random.choices(STATUSES, weights=[70, 15, 10, 5])[0]
    location = random.choices(LOCATIONS, weights=[40, 20, 25, 15])[0]

    full_name = generate_name()
    position = get_position_by_dept_and_grade(dept, grade)
    skills = ", ".join(random.sample(SKILLS_BY_DEPT[dept], min(4, len(SKILLS_BY_DEPT[dept]))))
    project = random.choice(PROJECTS) if status == "На проекте" else ""
    salary = get_salary_by_grade(grade)
    hire_date = generate_hire_date()

    mentor = ""
    if grade == "Junior" and random.random() > 0.3:
        mentor = generate_name()

    data = {
        "fullName": full_name,
        "email": generate_email(full_name),
        "customFields": {
            "position": position,
            "department": dept,
            "grade": grade,
            "status": status,
            "location": location,
            "hire_date": hire_date,
            "project": project,
            "skills": skills,
            "salary": str(salary),
            "mentor": mentor
        }
    }

    if create_employee(token, data):
        created += 1
        if created % 50 == 0:
            print(f"Created {created}/300 employees...")

print(f"Done! Created {created} employees")
