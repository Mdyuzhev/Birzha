-- Таблица заявок на развитие и ротацию
CREATE TABLE applications (
    id BIGSERIAL PRIMARY KEY,

    -- Связи
    dzo_id BIGINT NOT NULL REFERENCES dzos(id),
    employee_id BIGINT NOT NULL REFERENCES employees(id),
    created_by BIGINT NOT NULL REFERENCES users(id),

    -- Временные метки
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Статус
    status VARCHAR(50) NOT NULL DEFAULT 'DRAFT',

    -- Данные заявки
    target_position VARCHAR(255),
    target_stack VARCHAR(100),
    current_salary DECIMAL(12, 2),
    target_salary DECIMAL(12, 2),
    salary_increase_percent DECIMAL(5, 2),
    requires_borup_approval BOOLEAN NOT NULL DEFAULT false,
    resume_file_path VARCHAR(500),
    comment TEXT,

    -- Назначенные участники
    recruiter_id BIGINT REFERENCES users(id),
    assigned_to_recruiter_at TIMESTAMP,
    hr_bp_id BIGINT REFERENCES users(id),
    borup_id BIGINT REFERENCES users(id),

    -- Решение HR BP
    hr_bp_decision VARCHAR(20),
    hr_bp_comment TEXT,
    hr_bp_decision_at TIMESTAMP,

    -- Решение БОРУП
    borup_decision VARCHAR(20),
    borup_comment TEXT,
    borup_decision_at TIMESTAMP,

    -- Итог
    final_comment TEXT,
    transfer_date DATE,
    completed_at TIMESTAMP
);

-- Индексы
CREATE INDEX idx_applications_dzo ON applications(dzo_id);
CREATE INDEX idx_applications_employee ON applications(employee_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_created_by ON applications(created_by);
CREATE INDEX idx_applications_recruiter ON applications(recruiter_id);
CREATE INDEX idx_applications_hr_bp ON applications(hr_bp_id);
CREATE INDEX idx_applications_created_at ON applications(created_at DESC);

-- Составной индекс для фильтрации
CREATE INDEX idx_applications_dzo_status ON applications(dzo_id, status);
