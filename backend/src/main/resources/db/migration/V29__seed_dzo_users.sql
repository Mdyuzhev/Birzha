-- Seed пользователей для всех ДЗО с ролями и ФИО

-- ЦОД
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('cod_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Иванов Иван Иванович', (SELECT id FROM dzos WHERE code = 'rt-dc')),
('cod_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Петрова Анна Сергеевна', (SELECT id FROM dzos WHERE code = 'rt-dc')),
('cod_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Сидорова Елена Александровна', (SELECT id FROM dzos WHERE code = 'rt-dc')),
('cod_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Козлов Дмитрий Петрович', (SELECT id FROM dzos WHERE code = 'rt-dc')),
('cod_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Морозов Алексей Викторович', (SELECT id FROM dzos WHERE code = 'rt-dc'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 'cod_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 'cod_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 'cod_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 'cod_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 'cod_manager'), 'MANAGER');

-- Солар
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('solar_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Васильев Сергей Николаевич', (SELECT id FROM dzos WHERE code = 'rt-solar')),
('solar_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Федорова Мария Дмитриевна', (SELECT id FROM dzos WHERE code = 'rt-solar')),
('solar_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Михайлова Ольга Ивановна', (SELECT id FROM dzos WHERE code = 'rt-solar')),
('solar_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Новиков Андрей Сергеевич', (SELECT id FROM dzos WHERE code = 'rt-solar')),
('solar_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Волков Максим Александрович', (SELECT id FROM dzos WHERE code = 'rt-solar'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 'solar_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 'solar_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 'solar_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 'solar_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 'solar_manager'), 'MANAGER');

-- БФТ
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('bft_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Соколов Николай Владимирович', (SELECT id FROM dzos WHERE code = 'bft')),
('bft_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Павлова Екатерина Михайловна', (SELECT id FROM dzos WHERE code = 'bft')),
('bft_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Лебедева Наталья Петровна', (SELECT id FROM dzos WHERE code = 'bft')),
('bft_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Семенов Владимир Алексеевич', (SELECT id FROM dzos WHERE code = 'bft')),
('bft_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Егоров Игорь Васильевич', (SELECT id FROM dzos WHERE code = 'bft'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 'bft_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 'bft_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 'bft_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 'bft_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 'bft_manager'), 'MANAGER');

-- Т2
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('t2_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Попов Денис Андреевич', (SELECT id FROM dzos WHERE code = 't2')),
('t2_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Романова Светлана Николаевна', (SELECT id FROM dzos WHERE code = 't2')),
('t2_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Борисова Татьяна Сергеевна', (SELECT id FROM dzos WHERE code = 't2')),
('t2_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Кузнецов Евгений Дмитриевич', (SELECT id FROM dzos WHERE code = 't2')),
('t2_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Смирнов Артем Игоревич', (SELECT id FROM dzos WHERE code = 't2'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 't2_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 't2_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 't2_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 't2_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 't2_manager'), 'MANAGER');

-- Базис
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('basis_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Белов Григорий Павлович', (SELECT id FROM dzos WHERE code = 'basistech')),
('basis_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Зайцева Юлия Александровна', (SELECT id FROM dzos WHERE code = 'basistech')),
('basis_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Матвеева Ирина Викторовна', (SELECT id FROM dzos WHERE code = 'basistech')),
('basis_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Николаев Олег Романович', (SELECT id FROM dzos WHERE code = 'basistech')),
('basis_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Орлов Виктор Николаевич', (SELECT id FROM dzos WHERE code = 'basistech'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 'basis_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 'basis_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 'basis_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 'basis_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 'basis_manager'), 'MANAGER');

-- РТЛабс
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('labs_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Григорьев Станислав Олегович', (SELECT id FROM dzos WHERE code = 'rtlabs')),
('labs_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Тихонова Вероника Дмитриевна', (SELECT id FROM dzos WHERE code = 'rtlabs')),
('labs_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Яковлева Анастасия Андреевна', (SELECT id FROM dzos WHERE code = 'rtlabs')),
('labs_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Захаров Константин Сергеевич', (SELECT id FROM dzos WHERE code = 'rtlabs')),
('labs_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Королев Роман Владимирович', (SELECT id FROM dzos WHERE code = 'rtlabs'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 'labs_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 'labs_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 'labs_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 'labs_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 'labs_manager'), 'MANAGER');

-- ОМП
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('omp_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Крылов Вячеслав Евгеньевич', (SELECT id FROM dzos WHERE code = 'omp')),
('omp_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Комарова Валентина Игоревна', (SELECT id FROM dzos WHERE code = 'omp')),
('omp_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Гусева Лариса Петровна', (SELECT id FROM dzos WHERE code = 'omp')),
('omp_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Соловьев Павел Михайлович', (SELECT id FROM dzos WHERE code = 'omp')),
('omp_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Макаров Кирилл Александрович', (SELECT id FROM dzos WHERE code = 'omp'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 'omp_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 'omp_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 'omp_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 'omp_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 'omp_manager'), 'MANAGER');

-- ПАО_РТК
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('paortk_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Медведев Федор Владимирович', (SELECT id FROM dzos WHERE code = 'pao-rtk')),
('paortk_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Ковалева Дарья Сергеевна', (SELECT id FROM dzos WHERE code = 'pao-rtk')),
('paortk_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Степанова Виктория Николаевна', (SELECT id FROM dzos WHERE code = 'pao-rtk')),
('paortk_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Филиппов Георгий Дмитриевич', (SELECT id FROM dzos WHERE code = 'pao-rtk')),
('paortk_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Данилов Руслан Андреевич', (SELECT id FROM dzos WHERE code = 'pao-rtk'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 'paortk_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 'paortk_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 'paortk_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 'paortk_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 'paortk_manager'), 'MANAGER');

-- РТК
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('rtk_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Абрамов Тимур Романович', (SELECT id FROM dzos WHERE code = 'rtk')),
('rtk_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Антонова Полина Александровна', (SELECT id FROM dzos WHERE code = 'rtk')),
('rtk_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Кириллова Марина Владимировна', (SELECT id FROM dzos WHERE code = 'rtk')),
('rtk_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Богданов Илья Сергеевич', (SELECT id FROM dzos WHERE code = 'rtk')),
('rtk_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Назаров Владислав Игоревич', (SELECT id FROM dzos WHERE code = 'rtk'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 'rtk_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 'rtk_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 'rtk_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 'rtk_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 'rtk_manager'), 'MANAGER');

-- РТК_ИТ
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('rtkit_dzo_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Фролов Антон Николаевич', (SELECT id FROM dzos WHERE code = 'rtk-it')),
('rtkit_recruiter', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Никитина Алина Дмитриевна', (SELECT id FROM dzos WHERE code = 'rtk-it')),
('rtkit_hr_bp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Власова Кристина Андреевна', (SELECT id FROM dzos WHERE code = 'rtk-it')),
('rtkit_borup', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Блинов Максим Петрович', (SELECT id FROM dzos WHERE code = 'rtk-it')),
('rtkit_manager', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', 'Беляев Артур Викторович', (SELECT id FROM dzos WHERE code = 'rtk-it'));

INSERT INTO user_roles (user_id, role) VALUES
((SELECT id FROM users WHERE username = 'rtkit_dzo_admin'), 'DZO_ADMIN'),
((SELECT id FROM users WHERE username = 'rtkit_recruiter'), 'RECRUITER'),
((SELECT id FROM users WHERE username = 'rtkit_hr_bp'), 'HR_BP'),
((SELECT id FROM users WHERE username = 'rtkit_borup'), 'BORUP'),
((SELECT id FROM users WHERE username = 'rtkit_manager'), 'MANAGER');
