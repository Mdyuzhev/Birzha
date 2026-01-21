-- Таблица ДЗО (дочерних зависимых обществ)
CREATE TABLE dzos (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    email_domain VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Индекс для поиска по коду
CREATE INDEX idx_dzos_code ON dzos(code);

-- Начальные данные (пилотные ДЗО)
INSERT INTO dzos (code, name, email_domain) VALUES
    ('rt-dc', 'ЦОД', 'rt-dc.ru'),
    ('rt-solar', 'Солар', 'rt-solar.ru'),
    ('bft', 'БФТ', 'bft.ru'),
    ('t2', 'Т2', 't2.ru'),
    ('basistech', 'Базис', 'basistech.ru'),
    ('rtlabs', 'РТЛабс', 'rtlabs.ru'),
    ('omp', 'ОМП', 'omp.ru'),
    ('pao-rtk', 'ПАО РТК', NULL),
    ('rtk', 'РТК', NULL),
    ('rtk-it', 'РТК ИТ+', NULL);
