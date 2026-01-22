-- Добавить поля для TOTP 2FA
ALTER TABLE users ADD COLUMN IF NOT EXISTS totp_secret VARCHAR(64);
ALTER TABLE users ADD COLUMN IF NOT EXISTS totp_enabled BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE users ADD COLUMN IF NOT EXISTS totp_enabled_at TIMESTAMP;

-- Индекс для быстрого поиска
CREATE INDEX IF NOT EXISTS idx_users_totp_enabled ON users(totp_enabled) WHERE totp_enabled = true;

COMMENT ON COLUMN users.totp_secret IS 'Секретный ключ TOTP (Base32)';
COMMENT ON COLUMN users.totp_enabled IS 'Включена ли двухфакторная аутентификация';
COMMENT ON COLUMN users.totp_enabled_at IS 'Когда была включена 2FA';
