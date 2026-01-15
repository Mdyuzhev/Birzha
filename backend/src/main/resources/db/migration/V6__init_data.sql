-- Create admin user
-- Password: admin123 (BCrypt hash)
INSERT INTO users (username, password_hash, role)
VALUES ('admin', '$2a$10$djI3GzGNAME3s0/TBfNNyOki1bx.UFZASIa0fQDcHUv9C92QjVHN2', 'ADMIN')
ON CONFLICT (username) DO NOTHING;

-- Dictionaries
INSERT INTO dictionaries (name, display_name, values) VALUES
('grades', 'Грейд', '["Junior", "Middle", "Senior", "Lead", "Principal"]'),
('statuses', 'Статус', '["На проекте", "На бенче", "В отпуске", "Болеет", "Уволен"]'),
('positions', 'Должность', '["Developer", "QA Engineer", "DevOps", "Analyst", "Designer", "Manager", "Team Lead"]'),
('locations', 'Локация', '["Москва", "Санкт-Петербург", "Удалённо", "Гибрид"]')
ON CONFLICT (name) DO NOTHING;

-- Column definitions
INSERT INTO column_definitions (name, display_name, field_type, dictionary_id, sort_order, is_required) VALUES
('position', 'Должность', 'SELECT', (SELECT id FROM dictionaries WHERE name = 'positions'), 1, true),
('grade', 'Грейд', 'SELECT', (SELECT id FROM dictionaries WHERE name = 'grades'), 2, true),
('status', 'Статус', 'SELECT', (SELECT id FROM dictionaries WHERE name = 'statuses'), 3, true),
('project', 'Проект', 'TEXT', NULL, 4, false),
('location', 'Локация', 'SELECT', (SELECT id FROM dictionaries WHERE name = 'locations'), 5, false),
('start_date', 'Дата выхода', 'DATE', NULL, 6, false),
('phone', 'Телефон', 'TEXT', NULL, 7, false),
('notes', 'Примечания', 'TEXT', NULL, 100, false)
ON CONFLICT (name) DO NOTHING;

-- Test employees
INSERT INTO employees (full_name, email, custom_fields) VALUES
('Иванов Иван Иванович', 'ivanov@company.ru',
 '{"position": "Developer", "grade": "Senior", "status": "На проекте", "project": "Project Alpha", "location": "Москва"}'),
('Петрова Анна Сергеевна', 'petrova@company.ru',
 '{"position": "QA Engineer", "grade": "Middle", "status": "На бенче", "project": "", "location": "Удалённо"}'),
('Сидоров Пётр Николаевич', 'sidorov@company.ru',
 '{"position": "DevOps", "grade": "Senior", "status": "На проекте", "project": "Project Beta", "location": "Санкт-Петербург"}'),
('Козлова Мария Андреевна', 'kozlova@company.ru',
 '{"position": "Analyst", "grade": "Middle", "status": "На проекте", "project": "Project Alpha", "location": "Гибрид"}'),
('Новиков Алексей Дмитриевич', 'novikov@company.ru',
 '{"position": "Team Lead", "grade": "Lead", "status": "На проекте", "project": "Project Gamma", "location": "Москва"}');
