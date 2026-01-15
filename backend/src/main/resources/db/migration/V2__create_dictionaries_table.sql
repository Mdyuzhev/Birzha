CREATE TABLE dictionaries (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    values JSONB NOT NULL DEFAULT '[]'
);
