-- Таблица для назначения HR BP на ДЗО
CREATE TABLE hr_bp_assignments (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    dzo_id BIGINT NOT NULL REFERENCES dzos(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by BIGINT REFERENCES users(id),
    UNIQUE(user_id, dzo_id)
);

CREATE INDEX idx_hr_bp_assignments_user ON hr_bp_assignments(user_id);
CREATE INDEX idx_hr_bp_assignments_dzo ON hr_bp_assignments(dzo_id);
