-- Создать таблицу для хранения ролей пользователя (многие-ко-многим)
CREATE TABLE user_roles (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, role)
);

CREATE INDEX idx_user_roles_user ON user_roles(user_id);
CREATE INDEX idx_user_roles_role ON user_roles(role);

-- Мигрировать существующие роли
-- ADMIN → SYSTEM_ADMIN (для существующих админов)
INSERT INTO user_roles (user_id, role)
SELECT id, 'SYSTEM_ADMIN' FROM users WHERE role = 'ADMIN';

-- USER → MANAGER (для существующих пользователей)
INSERT INTO user_roles (user_id, role)
SELECT id, 'MANAGER' FROM users WHERE role = 'USER';

-- Удалить старую колонку role (опционально, можно оставить для обратной совместимости)
-- ALTER TABLE users DROP COLUMN role;
