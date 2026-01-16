-- Заполнение резюме для 10 сотрудников
-- Данные похожие на реальные резюме с hh.ru

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'Senior Java Developer',
    'Опытный Java-разработчик с 8+ годами опыта в разработке высоконагруженных систем. Специализируюсь на микросервисной архитектуре, Spring Boot и облачных решениях. Имею опыт руководства командой из 5 разработчиков.',
    '[{"name": "Java", "level": "Эксперт", "years": "8"}, {"name": "Spring Boot", "level": "Эксперт", "years": "6"}, {"name": "PostgreSQL", "level": "Продвинутый", "years": "7"}, {"name": "Docker", "level": "Продвинутый", "years": "4"}, {"name": "Kubernetes", "level": "Средний", "years": "2"}]'::jsonb,
    '[{"company": "Сбер Технологии", "position": "Senior Java Developer", "startDate": "2021-03", "endDate": "", "description": "Разработка и поддержка платежной платформы. Проектирование микросервисной архитектуры. Оптимизация производительности критичных сервисов.", "projects": [{"name": "SberPay", "description": "Платежный шлюз"}, {"name": "Loyalty System", "description": "Система лояльности"}]}, {"company": "Яндекс", "position": "Middle Java Developer", "startDate": "2018-01", "endDate": "2021-02", "description": "Разработка backend-сервисов для Яндекс.Маркета. Интеграция с внешними системами.", "projects": [{"name": "Marketplace API", "description": "REST API для маркетплейса"}]}]'::jsonb,
    '[{"institution": "МГТУ им. Баумана", "degree": "Магистр", "field": "Информатика и вычислительная техника", "year": "2016"}]'::jsonb,
    '[{"name": "Oracle Certified Professional Java SE 11", "issuer": "Oracle", "year": "2020"}, {"name": "AWS Solutions Architect", "issuer": "Amazon", "year": "2022"}]'::jsonb,
    '[{"language": "Английский", "level": "Выше среднего (B2)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 1
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'Frontend Developer (React)',
    'Frontend-разработчик с 5-летним опытом создания современных веб-приложений. Глубокие знания React, TypeScript и современных инструментов фронтенд-разработки. Опыт работы с дизайн-системами.',
    '[{"name": "React", "level": "Эксперт", "years": "5"}, {"name": "TypeScript", "level": "Продвинутый", "years": "4"}, {"name": "Vue.js", "level": "Средний", "years": "2"}, {"name": "CSS/SCSS", "level": "Продвинутый", "years": "5"}, {"name": "Webpack", "level": "Средний", "years": "3"}]'::jsonb,
    '[{"company": "Тинькофф", "position": "Senior Frontend Developer", "startDate": "2022-06", "endDate": "", "description": "Разработка интерфейсов для мобильного банка. Создание и поддержка UI-kit компонентов.", "projects": [{"name": "Tinkoff Business", "description": "Интерфейс для бизнес-клиентов"}, {"name": "Design System", "description": "Внутренняя дизайн-система"}]}, {"company": "Mail.ru Group", "position": "Frontend Developer", "startDate": "2019-03", "endDate": "2022-05", "description": "Разработка веб-интерфейсов для социальных сервисов.", "projects": [{"name": "VK Mini Apps", "description": "Платформа мини-приложений"}]}]'::jsonb,
    '[{"institution": "ИТМО", "degree": "Бакалавр", "field": "Программная инженерия", "year": "2019"}]'::jsonb,
    '[{"name": "Meta Frontend Developer Certificate", "issuer": "Meta", "year": "2023"}]'::jsonb,
    '[{"language": "Английский", "level": "Средний (B1)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 2
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'DevOps Engineer',
    'DevOps-инженер с опытом построения CI/CD pipeline и управления облачной инфраструктурой. Автоматизация процессов развертывания и мониторинга. Опыт работы с Kubernetes в production.',
    '[{"name": "Kubernetes", "level": "Эксперт", "years": "4"}, {"name": "Docker", "level": "Эксперт", "years": "5"}, {"name": "Terraform", "level": "Продвинутый", "years": "3"}, {"name": "Jenkins", "level": "Продвинутый", "years": "4"}, {"name": "Python", "level": "Средний", "years": "3"}]'::jsonb,
    '[{"company": "Авито", "position": "Senior DevOps Engineer", "startDate": "2021-09", "endDate": "", "description": "Управление инфраструктурой на 500+ микросервисов. Оптимизация CI/CD процессов.", "projects": [{"name": "K8s Migration", "description": "Миграция на Kubernetes"}, {"name": "Observability Platform", "description": "Система мониторинга"}]}, {"company": "Lamoda", "position": "DevOps Engineer", "startDate": "2019-02", "endDate": "2021-08", "description": "Построение и поддержка инфраструктуры e-commerce платформы.", "projects": [{"name": "CI/CD Pipeline", "description": "Автоматизация деплоя"}]}]'::jsonb,
    '[{"institution": "МГУ", "degree": "Магистр", "field": "Вычислительная математика", "year": "2018"}]'::jsonb,
    '[{"name": "Certified Kubernetes Administrator", "issuer": "CNCF", "year": "2022"}, {"name": "AWS DevOps Professional", "issuer": "Amazon", "year": "2021"}]'::jsonb,
    '[{"language": "Английский", "level": "Продвинутый (C1)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 3
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'Data Scientist',
    'Data Scientist с опытом в машинном обучении и анализе данных. Разработка рекомендательных систем и моделей прогнозирования. Публикации на международных конференциях.',
    '[{"name": "Python", "level": "Эксперт", "years": "6"}, {"name": "TensorFlow", "level": "Продвинутый", "years": "4"}, {"name": "PyTorch", "level": "Продвинутый", "years": "3"}, {"name": "SQL", "level": "Продвинутый", "years": "5"}, {"name": "Spark", "level": "Средний", "years": "2"}]'::jsonb,
    '[{"company": "Яндекс", "position": "Senior Data Scientist", "startDate": "2020-04", "endDate": "", "description": "Разработка ML-моделей для персонализации поиска. Оптимизация рекомендательных алгоритмов.", "projects": [{"name": "Search Ranking", "description": "Модели ранжирования"}, {"name": "User Profiling", "description": "Профилирование пользователей"}]}, {"company": "X5 Group", "position": "Data Scientist", "startDate": "2018-06", "endDate": "2020-03", "description": "Прогнозирование спроса и оптимизация ценообразования.", "projects": [{"name": "Demand Forecasting", "description": "Прогноз спроса"}]}]'::jsonb,
    '[{"institution": "ВШЭ", "degree": "Магистр", "field": "Анализ данных", "year": "2018"}, {"institution": "МФТИ", "degree": "Бакалавр", "field": "Прикладная математика", "year": "2016"}]'::jsonb,
    '[{"name": "TensorFlow Developer Certificate", "issuer": "Google", "year": "2021"}]'::jsonb,
    '[{"language": "Английский", "level": "Свободный (C2)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 4
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'Project Manager',
    'Project Manager с 7-летним опытом управления IT-проектами. Сертифицированный PMP и Scrum Master. Успешно реализовал более 20 проектов с бюджетом от 5 до 50 млн рублей.',
    '[{"name": "Agile/Scrum", "level": "Эксперт", "years": "6"}, {"name": "Jira", "level": "Эксперт", "years": "7"}, {"name": "MS Project", "level": "Продвинутый", "years": "5"}, {"name": "Confluence", "level": "Продвинутый", "years": "5"}, {"name": "Risk Management", "level": "Продвинутый", "years": "4"}]'::jsonb,
    '[{"company": "Сбербанк", "position": "Senior Project Manager", "startDate": "2020-01", "endDate": "", "description": "Управление портфелем проектов цифровой трансформации. Координация команд до 30 человек.", "projects": [{"name": "Digital Banking", "description": "Цифровизация банковских услуг"}, {"name": "Mobile App 2.0", "description": "Редизайн мобильного приложения"}]}, {"company": "Газпром нефть", "position": "Project Manager", "startDate": "2017-03", "endDate": "2019-12", "description": "Внедрение ERP-систем и автоматизация бизнес-процессов.", "projects": [{"name": "SAP Implementation", "description": "Внедрение SAP"}]}]'::jsonb,
    '[{"institution": "РАНХиГС", "degree": "MBA", "field": "Управление проектами", "year": "2019"}, {"institution": "СПбГУ", "degree": "Специалист", "field": "Экономика", "year": "2015"}]'::jsonb,
    '[{"name": "PMP", "issuer": "PMI", "year": "2020"}, {"name": "Professional Scrum Master I", "issuer": "Scrum.org", "year": "2018"}]'::jsonb,
    '[{"language": "Английский", "level": "Выше среднего (B2)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 5
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'QA Engineer',
    'QA-инженер с опытом автоматизации тестирования и построения QA-процессов. Экспертиза в тестировании веб-приложений и API. Опыт внедрения best practices тестирования.',
    '[{"name": "Selenium", "level": "Эксперт", "years": "5"}, {"name": "Python", "level": "Продвинутый", "years": "4"}, {"name": "Postman", "level": "Эксперт", "years": "5"}, {"name": "SQL", "level": "Продвинутый", "years": "4"}, {"name": "CI/CD", "level": "Средний", "years": "3"}]'::jsonb,
    '[{"company": "Ozon", "position": "Senior QA Engineer", "startDate": "2021-05", "endDate": "", "description": "Построение фреймворка автоматизации тестирования. Менторство junior QA.", "projects": [{"name": "Test Automation Framework", "description": "Фреймворк автотестов"}, {"name": "Performance Testing", "description": "Нагрузочное тестирование"}]}, {"company": "Wildberries", "position": "QA Engineer", "startDate": "2019-01", "endDate": "2021-04", "description": "Тестирование e-commerce платформы. Автоматизация regression тестов.", "projects": [{"name": "Mobile Testing", "description": "Тестирование мобильного приложения"}]}]'::jsonb,
    '[{"institution": "МИРЭА", "degree": "Бакалавр", "field": "Информационные системы", "year": "2018"}]'::jsonb,
    '[{"name": "ISTQB Foundation Level", "issuer": "ISTQB", "year": "2019"}]'::jsonb,
    '[{"language": "Английский", "level": "Средний (B1)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 6
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'Backend Developer (Python)',
    'Python-разработчик с фокусом на высоконагруженные системы и API. Опыт работы с Django, FastAPI и асинхронным программированием. Вклад в open-source проекты.',
    '[{"name": "Python", "level": "Эксперт", "years": "6"}, {"name": "Django", "level": "Эксперт", "years": "5"}, {"name": "FastAPI", "level": "Продвинутый", "years": "3"}, {"name": "PostgreSQL", "level": "Продвинутый", "years": "5"}, {"name": "Redis", "level": "Продвинутый", "years": "4"}]'::jsonb,
    '[{"company": "VK", "position": "Senior Python Developer", "startDate": "2021-02", "endDate": "", "description": "Разработка backend-сервисов для мессенджера. Оптимизация высоконагруженных API.", "projects": [{"name": "Messaging API", "description": "API для сообщений"}, {"name": "Notification Service", "description": "Сервис уведомлений"}]}, {"company": "Kaspersky", "position": "Python Developer", "startDate": "2018-08", "endDate": "2021-01", "description": "Разработка систем анализа угроз и автоматизации.", "projects": [{"name": "Threat Intelligence", "description": "Платформа анализа угроз"}]}]'::jsonb,
    '[{"institution": "МФТИ", "degree": "Магистр", "field": "Компьютерные науки", "year": "2018"}]'::jsonb,
    '[{"name": "Python Institute PCPP", "issuer": "Python Institute", "year": "2020"}]'::jsonb,
    '[{"language": "Английский", "level": "Продвинутый (C1)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 7
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'Mobile Developer (iOS)',
    'iOS-разработчик с 5-летним опытом создания нативных приложений. Глубокие знания Swift, UIKit и SwiftUI. Опыт публикации приложений с миллионами загрузок.',
    '[{"name": "Swift", "level": "Эксперт", "years": "5"}, {"name": "UIKit", "level": "Эксперт", "years": "5"}, {"name": "SwiftUI", "level": "Продвинутый", "years": "2"}, {"name": "Core Data", "level": "Продвинутый", "years": "4"}, {"name": "RxSwift", "level": "Средний", "years": "3"}]'::jsonb,
    '[{"company": "Яндекс", "position": "Senior iOS Developer", "startDate": "2022-01", "endDate": "", "description": "Разработка Яндекс.Карты для iOS. Оптимизация производительности и UX.", "projects": [{"name": "Yandex Maps iOS", "description": "Мобильные карты"}, {"name": "Navigation SDK", "description": "SDK навигации"}]}, {"company": "Сбер", "position": "iOS Developer", "startDate": "2019-04", "endDate": "2021-12", "description": "Разработка мобильного банка СберБанк Онлайн.", "projects": [{"name": "SberBank Online", "description": "Мобильный банк"}]}]'::jsonb,
    '[{"institution": "МГТУ МИРЭА", "degree": "Бакалавр", "field": "Программная инженерия", "year": "2019"}]'::jsonb,
    '[{"name": "Apple Developer Certification", "issuer": "Apple", "year": "2021"}]'::jsonb,
    '[{"language": "Английский", "level": "Выше среднего (B2)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 8
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'System Analyst',
    'Системный аналитик с опытом проектирования сложных информационных систем. Экспертиза в сборе требований, моделировании бизнес-процессов и написании технической документации.',
    '[{"name": "UML", "level": "Эксперт", "years": "6"}, {"name": "BPMN", "level": "Эксперт", "years": "5"}, {"name": "SQL", "level": "Продвинутый", "years": "5"}, {"name": "Confluence", "level": "Продвинутый", "years": "5"}, {"name": "Draw.io", "level": "Продвинутый", "years": "4"}]'::jsonb,
    '[{"company": "Тинькофф", "position": "Senior System Analyst", "startDate": "2020-09", "endDate": "", "description": "Проектирование архитектуры банковских продуктов. Взаимодействие с командами разработки.", "projects": [{"name": "Credit Pipeline", "description": "Кредитный конвейер"}, {"name": "AML System", "description": "Система противодействия отмыванию"}]}, {"company": "Альфа-Банк", "position": "System Analyst", "startDate": "2017-06", "endDate": "2020-08", "description": "Анализ требований и проектирование интеграций.", "projects": [{"name": "Core Banking Integration", "description": "Интеграция с АБС"}]}]'::jsonb,
    '[{"institution": "ВШЭ", "degree": "Магистр", "field": "Бизнес-информатика", "year": "2017"}]'::jsonb,
    '[{"name": "CBAP", "issuer": "IIBA", "year": "2021"}]'::jsonb,
    '[{"language": "Английский", "level": "Средний (B1)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 9
ON CONFLICT (employee_id) DO NOTHING;

INSERT INTO employee_resumes (employee_id, position, summary, skills, experience, education, certifications, languages)
SELECT
    e.id,
    'Team Lead',
    'Team Lead с опытом управления командами разработки до 12 человек. Сочетаю технические навыки с управленческими компетенциями. Фокус на развитие команды и delivery.',
    '[{"name": "Java", "level": "Эксперт", "years": "10"}, {"name": "Spring", "level": "Эксперт", "years": "8"}, {"name": "Team Management", "level": "Продвинутый", "years": "4"}, {"name": "Architecture", "level": "Продвинутый", "years": "5"}, {"name": "Mentoring", "level": "Продвинутый", "years": "4"}]'::jsonb,
    '[{"company": "МТС", "position": "Team Lead", "startDate": "2021-03", "endDate": "", "description": "Руководство командой backend-разработки. Техническое планирование и архитектурные решения.", "projects": [{"name": "MTS Music", "description": "Стриминговый сервис"}, {"name": "Platform Services", "description": "Платформенные сервисы"}]}, {"company": "Ростелеком", "position": "Senior Java Developer", "startDate": "2017-01", "endDate": "2021-02", "description": "Разработка телеком-решений. Наставничество junior разработчиков.", "projects": [{"name": "Billing System", "description": "Биллинговая система"}]}]'::jsonb,
    '[{"institution": "МГТУ им. Баумана", "degree": "Магистр", "field": "Информационные системы", "year": "2016"}, {"institution": "Skolkovo", "degree": "Executive MBA", "field": "Технологический менеджмент", "year": "2022"}]'::jsonb,
    '[{"name": "AWS Solutions Architect Professional", "issuer": "Amazon", "year": "2021"}, {"name": "Management 3.0", "issuer": "Management 3.0", "year": "2022"}]'::jsonb,
    '[{"language": "Английский", "level": "Продвинутый (C1)"}, {"language": "Немецкий", "level": "Базовый (A2)"}, {"language": "Русский", "level": "Родной"}]'::jsonb
FROM employees e WHERE e.id = 10
ON CONFLICT (employee_id) DO NOTHING;
