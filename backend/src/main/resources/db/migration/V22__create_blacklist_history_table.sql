-- История изменений чёрного списка
CREATE TABLE blacklist_history (
    id BIGSERIAL PRIMARY KEY,
    blacklist_entry_id BIGINT NOT NULL REFERENCES blacklist(id) ON DELETE CASCADE,
    changed_by BIGINT NOT NULL REFERENCES users(id),
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(50) NOT NULL,
    comment TEXT,
    details TEXT
);

CREATE INDEX idx_blacklist_history_entry ON blacklist_history(blacklist_entry_id);
CREATE INDEX idx_blacklist_history_action ON blacklist_history(action);
CREATE INDEX idx_blacklist_history_changed_at ON blacklist_history(changed_at);

COMMENT ON TABLE blacklist_history IS 'История изменений чёрного списка';
COMMENT ON COLUMN blacklist_history.action IS 'Действие: ADD, UPDATE, REMOVE, REACTIVATE';
