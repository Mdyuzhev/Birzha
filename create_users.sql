-- Создание пользователей из users_list.txt
-- Пароль: pass123
-- BCrypt hash: $2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey

-- ЦОД (dzo_id=1)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('cod_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Иванов Иван Иванович', 1),
('cod_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Петрова Анна Сергеевна', 1),
('cod_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Сидорова Елена Александровна', 1),
('cod_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Козлов Дмитрий Петрович', 1),
('cod_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Морозов Алексей Викторович', 1);

-- Солар (dzo_id=2)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('solar_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Васильев Сергей Николаевич', 2),
('solar_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Федорова Мария Дмитриевна', 2),
('solar_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Михайлова Ольга Ивановна', 2),
('solar_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Новиков Андрей Сергеевич', 2),
('solar_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Волков Максим Александрович', 2);

-- БФТ (dzo_id=3)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('bft_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Соколов Николай Владимирович', 3),
('bft_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Павлова Екатерина Михайловна', 3),
('bft_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Лебедева Наталья Петровна', 3),
('bft_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Семенов Владимир Алексеевич', 3),
('bft_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Егоров Игорь Васильевич', 3);

-- Т2 (dzo_id=4)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('t2_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Попов Денис Андреевич', 4),
('t2_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Романова Светлана Николаевна', 4),
('t2_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Борисова Татьяна Сергеевна', 4),
('t2_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Кузнецов Евгений Дмитриевич', 4),
('t2_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Смирнов Артем Игоревич', 4);

-- Базис (dzo_id=5)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('basis_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Белов Григорий Павлович', 5),
('basis_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Зайцева Юлия Александровна', 5),
('basis_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Матвеева Ирина Викторовна', 5),
('basis_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Николаев Олег Романович', 5),
('basis_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Орлов Виктор Николаевич', 5);

-- РТЛабс (dzo_id=6)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('labs_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Григорьев Станислав Олегович', 6),
('labs_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Тихонова Вероника Дмитриевна', 6),
('labs_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Яковлева Анастасия Андреевна', 6),
('labs_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Захаров Константин Сергеевич', 6),
('labs_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Королев Роман Владимирович', 6);

-- ОМП (dzo_id=7)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('omp_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Крылов Вячеслав Евгеньевич', 7),
('omp_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Комарова Валентина Игоревна', 7),
('omp_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Гусева Лариса Петровна', 7),
('omp_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Соловьев Павел Михайлович', 7),
('omp_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Макаров Кирилл Александрович', 7);

-- ПАО РТК (dzo_id=8)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('paortk_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Медведев Федор Владимирович', 8),
('paortk_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Ковалева Дарья Сергеевна', 8),
('paortk_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Степанова Виктория Николаевна', 8),
('paortk_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Филиппов Георгий Дмитриевич', 8),
('paortk_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Данилов Руслан Андреевич', 8);

-- РТК (dzo_id=9)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('rtk_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Абрамов Тимур Романович', 9),
('rtk_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Антонова Полина Александровна', 9),
('rtk_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Кириллова Марина Владимировна', 9),
('rtk_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Богданов Илья Сергеевич', 9),
('rtk_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Назаров Владислав Игоревич', 9);

-- РТК ИТ+ (dzo_id=10)
INSERT INTO users (username, password_hash, full_name, dzo_id) VALUES
('rtkit_dzo_admin', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Фролов Антон Николаевич', 10),
('rtkit_recruiter', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Никитина Алина Дмитриевна', 10),
('rtkit_hr_bp', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Власова Кристина Андреевна', 10),
('rtkit_borup', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Блинов Максим Петрович', 10),
('rtkit_manager', '$2a$10$rGqH5K8jk/E8qZb1pZvgUOLFxqZQJ.1Y2j6nGHJP7CKLx3vYmK3Ey', 'Беляев Артур Викторович', 10);

-- Назначение ролей
INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 'cod_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 'cod_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 'cod_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 'cod_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 'cod_manager';

INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 'solar_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 'solar_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 'solar_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 'solar_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 'solar_manager';

INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 'bft_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 'bft_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 'bft_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 'bft_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 'bft_manager';

INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 't2_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 't2_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 't2_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 't2_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 't2_manager';

INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 'basis_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 'basis_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 'basis_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 'basis_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 'basis_manager';

INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 'labs_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 'labs_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 'labs_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 'labs_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 'labs_manager';

INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 'omp_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 'omp_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 'omp_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 'omp_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 'omp_manager';

INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 'paortk_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 'paortk_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 'paortk_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 'paortk_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 'paortk_manager';

INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 'rtk_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 'rtk_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 'rtk_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 'rtk_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 'rtk_manager';

INSERT INTO user_roles (user_id, role) SELECT id, 'DZO_ADMIN' FROM users WHERE username = 'rtkit_dzo_admin';
INSERT INTO user_roles (user_id, role) SELECT id, 'RECRUITER' FROM users WHERE username = 'rtkit_recruiter';
INSERT INTO user_roles (user_id, role) SELECT id, 'HR_BP' FROM users WHERE username = 'rtkit_hr_bp';
INSERT INTO user_roles (user_id, role) SELECT id, 'BORUP' FROM users WHERE username = 'rtkit_borup';
INSERT INTO user_roles (user_id, role) SELECT id, 'MANAGER' FROM users WHERE username = 'rtkit_manager';
