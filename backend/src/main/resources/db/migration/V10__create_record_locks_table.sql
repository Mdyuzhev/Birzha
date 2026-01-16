-- Record locks table for pessimistic locking during editing
CREATE TABLE record_locks (
    id BIGSERIAL PRIMARY KEY,
    entity_type VARCHAR(50) NOT NULL,
    entity_id BIGINT NOT NULL,
    locked_by BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    locked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    CONSTRAINT uk_record_lock UNIQUE (entity_type, entity_id)
);

CREATE INDEX idx_record_locks_entity ON record_locks(entity_type, entity_id);
CREATE INDEX idx_record_locks_expires ON record_locks(expires_at);
