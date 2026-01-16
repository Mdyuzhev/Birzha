-- Таблица для хранения резюме сотрудников
CREATE TABLE employee_resumes (
    id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    position VARCHAR(255),
    summary TEXT,
    skills JSONB DEFAULT '[]',
    experience JSONB DEFAULT '[]',
    education JSONB DEFAULT '[]',
    certifications JSONB DEFAULT '[]',
    languages JSONB DEFAULT '[]',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_employee_resume UNIQUE (employee_id)
);

CREATE INDEX idx_resumes_employee ON employee_resumes(employee_id);

COMMENT ON TABLE employee_resumes IS 'Проектные резюме сотрудников';
COMMENT ON COLUMN employee_resumes.skills IS 'Навыки: [{name, level, years}]';
COMMENT ON COLUMN employee_resumes.experience IS 'Опыт работы: [{company, position, startDate, endDate, description, projects}]';
COMMENT ON COLUMN employee_resumes.education IS 'Образование: [{institution, degree, field, year}]';
COMMENT ON COLUMN employee_resumes.certifications IS 'Сертификаты: [{name, issuer, year}]';
COMMENT ON COLUMN employee_resumes.languages IS 'Языки: [{language, level}]';
