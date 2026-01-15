CREATE TABLE column_definitions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    field_type VARCHAR(20) NOT NULL CHECK (field_type IN ('TEXT', 'SELECT', 'DATE', 'NUMBER')),
    dictionary_id BIGINT REFERENCES dictionaries(id),
    sort_order INT DEFAULT 0,
    is_required BOOLEAN DEFAULT FALSE
);
