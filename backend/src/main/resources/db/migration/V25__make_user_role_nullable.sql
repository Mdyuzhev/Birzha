-- Сделать старую колонку role nullable для поддержки новой модели user_roles
ALTER TABLE users ALTER COLUMN role DROP NOT NULL;
