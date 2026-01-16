-- Таблица для хранения пресетов колонок (борды)
CREATE TABLE column_presets (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    column_config JSONB NOT NULL DEFAULT '[]',
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_column_presets_user_name UNIQUE (user_id, name)
);

CREATE INDEX idx_column_presets_user ON column_presets(user_id);

COMMENT ON TABLE column_presets IS 'Сохранённые пресеты настроек колонок пользователей';
COMMENT ON COLUMN column_presets.column_config IS 'JSON массив с настройками: [{prop, visible}]';
