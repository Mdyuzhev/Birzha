-- Добавить dzo_id в таблицу users
ALTER TABLE users ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);
CREATE INDEX idx_users_dzo ON users(dzo_id);

-- Добавить dzo_id в таблицу employees
ALTER TABLE employees ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);
CREATE INDEX idx_employees_dzo ON employees(dzo_id);

-- Добавить dzo_id в таблицу column_presets
ALTER TABLE column_presets ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);

-- Добавить dzo_id в таблицу saved_filters
ALTER TABLE saved_filters ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);

-- Добавить dzo_id в таблицу nine_box_assessments
ALTER TABLE nine_box_assessments ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);

-- Добавить dzo_id в таблицу employee_resumes
ALTER TABLE employee_resumes ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);

-- Привязать существующие данные к первому ДЗО (для миграции)
UPDATE users SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE employees SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE column_presets SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE saved_filters SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE nine_box_assessments SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE employee_resumes SET dzo_id = 1 WHERE dzo_id IS NULL;
