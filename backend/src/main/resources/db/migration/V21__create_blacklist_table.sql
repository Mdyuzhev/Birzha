-- Таблица чёрного списка
CREATE TABLE blacklist (
    id BIGSERIAL PRIMARY KEY,
    dzo_id BIGINT NOT NULL REFERENCES dzos(id) ON DELETE CASCADE,
    employee_id BIGINT REFERENCES employees(id) ON DELETE SET NULL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    reason TEXT NOT NULL,
    reason_category VARCHAR(50) NOT NULL,
    source VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT true,
    added_by BIGINT NOT NULL REFERENCES users(id),
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    removed_by BIGINT REFERENCES users(id),
    removed_at TIMESTAMP,
    removal_reason TEXT,
    metadata TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Индексы
CREATE INDEX idx_blacklist_dzo ON blacklist(dzo_id);
CREATE INDEX idx_blacklist_email ON blacklist(email);
CREATE INDEX idx_blacklist_full_name ON blacklist(full_name);
CREATE INDEX idx_blacklist_is_active ON blacklist(is_active);
CREATE INDEX idx_blacklist_employee ON blacklist(employee_id);
CREATE INDEX idx_blacklist_reason_category ON blacklist(reason_category);
CREATE INDEX idx_blacklist_added_at ON blacklist(added_at);

-- Полнотекстовый поиск
CREATE INDEX idx_blacklist_fulltext ON blacklist
    USING gin(to_tsvector('russian', full_name || ' ' || COALESCE(email, '') || ' ' || COALESCE(reason, '')));

COMMENT ON TABLE blacklist IS 'Чёрный список кандидатов';
COMMENT ON COLUMN blacklist.employee_id IS 'Ссылка на сотрудника (если есть в системе)';
COMMENT ON COLUMN blacklist.reason_category IS 'Категория причины: FRAUD, THEFT, MISCONDUCT и др.';
COMMENT ON COLUMN blacklist.expires_at IS 'Срок действия записи (NULL = бессрочно)';
