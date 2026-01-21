-- История изменений заявок
CREATE TABLE application_history (
    id BIGSERIAL PRIMARY KEY,
    application_id BIGINT NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    changed_by BIGINT NOT NULL REFERENCES users(id),
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    action VARCHAR(100) NOT NULL,
    comment TEXT,
    details TEXT  -- JSON
);

-- Индексы
CREATE INDEX idx_app_history_application ON application_history(application_id);
CREATE INDEX idx_app_history_changed_at ON application_history(changed_at DESC);
