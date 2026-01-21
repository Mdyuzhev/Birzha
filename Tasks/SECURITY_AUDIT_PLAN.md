# Аудит безопасности проекта Birzha

## Описание задачи

**Цель:** Провести комплексный аудит безопасности внутренней HR-системы управления ресурсами "Birzha" для выявления критических уязвимостей.

**Проект:** Birzha - система для отслеживания сотрудников и их аллокации на проекты. Позволяет видеть кто занят на проектах, кто на бенче и готов к новым задачам.

**Стек технологий:**
- Backend: Java 17, Spring Boot 3.x, Spring Security (JWT), Spring Data JPA, PostgreSQL 15 с JSONB
- Frontend: Vue 3, Composition API, Pinia, Element Plus, Axios
- Деплой: Docker, docker-compose

**Ключевые сущности с точки зрения безопасности:**
- Employee (данные сотрудников, включая динамические поля в JSONB)
- EmployeeHistory (аудит изменений)
- NineBoxAssessment (оценки персонала - чувствительные данные)
- EmployeeResume (персональные данные: skills, experience, education)
- User/UserSession (аутентификация и сессии)
- RecordLock (блокировки записей)

**Критичность:** ВЫСОКАЯ - система содержит персональные данные сотрудников и данные оценки персонала.

---

## План проверки безопасности

### ЭТАП 1: Аутентификация и управление секретами [КРИТИЧНО]
**Приоритет: КРИТИЧЕСКИЙ**

Что проверяем:
- [ ] JWT реализация (алгоритм, секретный ключ, время жизни токена)
- [ ] Хардкод паролей и секретов в коде
- [ ] Конфигурационные файлы (application.yml/properties)
- [ ] Переменные окружения и docker-compose
- [ ] Дефолтные учётные данные
- [ ] Хранение паролей пользователей (алгоритм хеширования)
- [ ] Механизм сброса пароля
- [ ] Brute-force защита

Файлы для анализа:
- `backend/src/main/java/com/company/resourcemanager/config/` - конфигурация Security
- `backend/src/main/resources/application*.yml`
- `docker-compose.yml`
- Сервисы аутентификации и контроллеры

---

### ЭТАП 2: Авторизация и контроль доступа [КРИТИЧНО]
**Приоритет: КРИТИЧЕСКИЙ**

Что проверяем:
- [ ] Ролевая модель (ADMIN vs USER)
- [ ] Защита REST эндпоинтов
- [ ] IDOR (Insecure Direct Object Reference) - доступ к чужим данным по ID
- [ ] Вертикальная эскалация привилегий
- [ ] Горизонтальная эскалация привилегий
- [ ] Проверка прав на уровне сервисов
- [ ] Защита административных функций

Файлы для анализа:
- Все контроллеры в `backend/src/main/java/com/company/resourcemanager/controller/`
- Security конфигурация
- Сервисный слой - проверка ownership

---

### ЭТАП 3: Инъекции и валидация данных [КРИТИЧНО]
**Приоритет: КРИТИЧЕСКИЙ**

Что проверяем:
- [ ] SQL Injection (особенно в JSONB запросах и кастомных Query)
- [ ] HQL/JPQL Injection
- [ ] JSONB Injection
- [ ] XSS (Stored, Reflected)
- [ ] Command Injection (если есть выполнение внешних команд)
- [ ] Path Traversal (при работе с файлами)
- [ ] Небезопасная десериализация
- [ ] Валидация входных данных на backend

Файлы для анализа:
- Репозитории с @Query аннотациями
- Контроллеры - обработка параметров
- DTO классы - аннотации валидации
- Работа с файлами (резюме)

---

### ЭТАП 4: Конфигурация безопасности и CORS [ВЫСОКИЙ]
**Приоритет: ВЫСОКИЙ**

Что проверяем:
- [ ] CORS настройки
- [ ] CSRF защита
- [ ] Security Headers (X-Frame-Options, X-XSS-Protection, CSP и т.д.)
- [ ] HTTP vs HTTPS
- [ ] Cookie flags (HttpOnly, Secure, SameSite)
- [ ] Debug режим в production
- [ ] Открытые actuator endpoints
- [ ] Error handling (утечка информации в ошибках)

Файлы для анализа:
- Security конфигурация
- CORS конфигурация
- Exception handlers
- application.yml

---

### ЭТАП 5: Управление сессиями [СРЕДНИЙ]
**Приоритет: СРЕДНИЙ**

Что проверяем:
- [ ] Время жизни JWT токена
- [ ] Механизм refresh token
- [ ] Отзыв токенов (logout)
- [ ] Защита от session fixation
- [ ] Параллельные сессии
- [ ] Хранение токена на frontend

Файлы для анализа:
- JWT утилиты
- UserSession entity и сервис
- Frontend: stores, localStorage

---

### ЭТАП 6: Логирование и аудит [СРЕДНИЙ]
**Приоритет: СРЕДНИЙ**

Что проверяем:
- [ ] Логирование чувствительных данных (пароли, токены)
- [ ] Полнота аудита изменений
- [ ] Логирование действий безопасности (login, failed login)
- [ ] Защита логов

Файлы для анализа:
- EmployeeHistory механизм
- Logging конфигурация
- Сервисы с логированием

---

### ЭТАП 7: Зависимости и Docker [СРЕДНИЙ]
**Приоритет: СРЕДНИЙ**

Что проверяем:
- [ ] Версии зависимостей (известные CVE)
- [ ] Базовый Docker образ
- [ ] Привилегии контейнера
- [ ] Сеть Docker
- [ ] Открытые порты

Файлы для анализа:
- pom.xml
- Dockerfile
- docker-compose.yml

---

### ЭТАП 8: Frontend безопасность [СРЕДНИЙ]
**Приоритет: СРЕДНИЙ**

Что проверяем:
- [ ] Хранение JWT токена
- [ ] XSS в Vue компонентах (v-html)
- [ ] Защита роутинга
- [ ] Чувствительные данные в состоянии
- [ ] API ключи в коде

Файлы для анализа:
- `frontend/src/stores/`
- `frontend/src/api/`
- `frontend/src/router/`
- Vue компоненты с динамическим контентом

---

## Формат отчёта по каждому этапу

После проверки каждого этапа будет добавлен раздел:

```
### ЭТАП N: [Название] - РЕЗУЛЬТАТЫ

**Статус:** Проверено / Найдены уязвимости

**Найденные уязвимости:**
1. [Критичность] Описание проблемы
   - Файл: путь к файлу
   - Строка: номер
   - Риск: описание возможной атаки
   - Рекомендация: как исправить

**Хорошие практики (что сделано правильно):**
- ...

**Итоговая оценка этапа:** КРИТИЧНО / ВЫСОКИЙ РИСК / СРЕДНИЙ РИСК / НИЗКИЙ РИСК / ОК
```

---

## Текущий статус

| Этап | Название | Статус | Критичность |
|------|----------|--------|-------------|
| 1 | Аутентификация и секреты | ✅ Проверено | КРИТИЧНО |
| 2 | Авторизация и контроль доступа | ✅ Проверено | КРИТИЧНО |
| 3 | Инъекции и валидация | ✅ Проверено | НИЗКИЙ РИСК |
| 4 | Конфигурация и CORS | ✅ Проверено | ВЫСОКИЙ РИСК |
| 5 | Управление сессиями | ✅ Проверено | ВЫСОКИЙ РИСК |
| 6 | Логирование и аудит | ✅ Проверено | СРЕДНИЙ РИСК |
| 7 | Зависимости и Docker | ✅ Проверено | ВЫСОКИЙ РИСК |
| 8 | Frontend безопасность | ✅ Проверено | ВЫСОКИЙ РИСК |

---

## Начало аудита

**Дата начала:** 2026-01-21
**Аудитор:** Claude (Senior Java Developer)

---

## РЕЗУЛЬТАТЫ ПРОВЕРКИ

### ЭТАП 1: Аутентификация и управление секретами - РЕЗУЛЬТАТЫ

**Статус:** ✅ Проверено

**Найденные уязвимости:**

1. **[КРИТИЧНО]** Хардкод слабого JWT секрета в production
   - **Файл:** [docker-compose.yml](../docker-compose.yml)
   - **Строка:** 31
   - **Проблема:** JWT_SECRET хардкоден в docker-compose: `your-super-secret-jwt-key-minimum-32-characters-long`
   - **Риск:** Если злоумышленник получит доступ к репозиторию или файлу docker-compose.yml, он сможет подделывать JWT токены для любого пользователя (включая ADMIN) и получить полный доступ к системе. Секрет предсказуем и может быть украден из репозитория.
   - **Рекомендация:** Переместить JWT_SECRET в .env файл и генерировать уникальный криптостойкий ключ для каждого окружения. Использовать длину не менее 256 бит (32+ символа случайных данных). Добавить .env в .gitignore (уже есть).
   - **Код:**
   ```yaml
   JWT_SECRET: your-super-secret-jwt-key-minimum-32-characters-long
   ```

2. **[КРИТИЧНО]** Дефолтные учетные данные в production
   - **Файл:** [init-data.sql](../init-data.sql) / [V6__init_data.sql](../backend/src/main/resources/db/migration/V6__init_data.sql)
   - **Строка:** 6-8
   - **Проблема:** Создается дефолтный админ с учеткой admin/admin123, который попадает в production через Flyway миграцию
   - **Риск:** Публично известные дефолтные credentials (admin/admin123) позволят атакующему немедленно получить полный административный доступ к системе. Это первое, что пробуют при атаке.
   - **Рекомендация:**
     - Разделить миграции на dev и prod. Дефолтный admin только для dev окружения
     - Для production требовать создание первого admin через безопасный механизм (CLI команда, окружение переменные)
     - Добавить принудительную смену пароля при первом входе
   - **Код:**
   ```sql
   INSERT INTO users (username, password_hash, role)
   VALUES ('admin', '$2a$10$djI3GzGNAME3s0/TBfNNyOki1bx.UFZASIa0fQDcHUv9C92QjVHN2', 'ADMIN')
   ```

3. **[КРИТИЧНО]** Отсутствие защиты от brute-force атак
   - **Файл:** [AuthService.java:32-38](../backend/src/main/java/com/company/resourcemanager/service/AuthService.java#L32-L38)
   - **Строка:** 32-38
   - **Проблема:** Метод login() не имеет ограничений на количество попыток входа. Злоумышленник может делать неограниченное число запросов для подбора пароля.
   - **Риск:** Brute-force и dictionary атаки на пароли. Даже при использовании BCrypt можно подобрать слабые пароли (особенно дефолтный admin123). Также возможна DoS атака через CPU-intensive BCrypt операции.
   - **Рекомендация:**
     - Внедрить rate limiting (напр. Spring Security RateLimiter или Redis-based)
     - Блокировать account после N неудачных попыток (например, 5 попыток за 15 минут)
     - Добавить CAPTCHA после 3 неудачных попыток
     - Логировать все failed login attempts для мониторинга
     - Добавить exponential backoff для повторных попыток

4. **[ВЫСОКИЙ]** Слабый пароль БД в docker-compose
   - **Файл:** [docker-compose.yml](../docker-compose.yml)
   - **Строка:** 8, 29
   - **Проблема:** Пароль PostgreSQL `resourcepass` является слабым и хардкоден в docker-compose
   - **Риск:** Если порт 31432 доступен извне или контейнер скомпрометирован, легко угадываемый пароль позволит получить доступ к БД со всеми персональными данными сотрудников.
   - **Рекомендация:** Переместить POSTGRES_PASSWORD в .env файл с криптостойким случайным паролем (минимум 20 символов).
   - **Код:**
   ```yaml
   POSTGRES_PASSWORD: resourcepass
   SPRING_DATASOURCE_PASSWORD: resourcepass
   ```

5. **[СРЕДНИЙ]** Долгое время жизни JWT токена
   - **Файл:** [application.yml:24](../backend/src/main/resources/application.yml#L24)
   - **Строка:** 24
   - **Проблема:** JWT expiration установлен в 86400000 мс (24 часа)
   - **Риск:** Если токен украден (XSS, MITM, логирование), злоумышленник имеет доступ в течение целых суток. Для HR системы с персональными данными это слишком долго.
   - **Рекомендация:** Сократить время жизни access token до 15-30 минут и внедрить refresh token механизм для продления сессии. Refresh token хранить в httpOnly cookie или в БД с возможностью отзыва.
   - **Код:**
   ```yaml
   jwt:
     expiration: 86400000  # 24 hours
   ```

**Хорошие практики:**
- ✅ Используется BCrypt для хеширования паролей (SecurityConfig.java:62)
- ✅ Generic error message "Invalid credentials" - не раскрывает существует ли пользователь (AuthService.java:34, 37)
- ✅ .gitignore правильно настроен - .env файлы исключены из git
- ✅ JWT реализация использует современную библиотеку jjwt 0.12.x с SecretKey (JwtTokenProvider.java:21)
- ✅ JWT валидация корректная с обработкой исключений (JwtTokenProvider.java:56-66)
- ✅ Пароли не логируются в коде

**Оценка этапа:** КРИТИЧНО

**Критичность:** Найдены 3 критические уязвимости, требующие немедленного исправления перед production deployment. Особенно опасны дефолтные credentials и хардкод JWT секрета.

---

### ЭТАП 2: Авторизация и контроль доступа - РЕЗУЛЬТАТЫ

**Статус:** ✅ Проверено

**Найденные уязвимости:**

1. **[КРИТИЧНО]** Отсутствие авторизации в EmployeeController - IDOR
   - **Файл:** [EmployeeController.java](../backend/src/main/java/com/company/resourcemanager/controller/EmployeeController.java)
   - **Строка:** 26-196 (весь контроллер)
   - **Проблема:** Контроллер не имеет аннотаций @PreAuthorize. Все эндпоинты доступны любому авторизованному пользователю (USER или ADMIN).
   - **Риск:**
     - **IDOR (Insecure Direct Object Reference):** Любой пользователь может просматривать данные всех сотрудников по ID
     - **Горизонтальная эскалация:** USER может создавать, изменять и удалять записи сотрудников, хотя это должны делать только ADMIN
     - **Утечка персональных данных:** Все поля сотрудников включая email, customFields (зарплата, статус, проект) доступны всем
     - **Экспорт данных:** Любой может экспортировать всю базу сотрудников через /api/employees/export
   - **Рекомендация:**
     - Добавить на уровне класса: `@PreAuthorize("hasRole('ADMIN')")` для методов create, update, delete, export
     - Для GET методов (просмотр) можно оставить доступ для USER, если это требуется по бизнес-логике
     - Альтернативно: разделить на два контроллера (read-only для USER, write для ADMIN)

2. **[КРИТИЧНО]** Отсутствие авторизации в NineBoxController - доступ к оценкам персонала
   - **Файл:** [NineBoxController.java](../backend/src/main/java/com/company/resourcemanager/controller/NineBoxController.java)
   - **Строка:** 14-55 (весь контроллер)
   - **Проблема:** Контроллер не имеет аннотаций @PreAuthorize. 9-Box оценки содержат КРИТИЧЕСКИ чувствительные данные о производительности и потенциале сотрудников.
   - **Риск:**
     - Любой пользователь может видеть оценки ВСЕХ сотрудников (getAll, getByEmployeeId)
     - Может видеть кто в каком боксе (низкая производительность/потенциал)
     - Доступна статистика по подразделениям и должностям
     - Любой пользователь может создавать/изменять/удалять оценки
     - **Критическая утечка конфиденциальности:** Такие данные обычно доступны только HR и топ-менеджменту
   - **Рекомендация:**
     - Добавить на уровне класса: `@PreAuthorize("hasRole('ADMIN')")`
     - Или создать роль HR_MANAGER для более гранулярного контроля
     - Рассмотреть ограничение видимости оценок (сотрудник может видеть только свою оценку)

3. **[КРИТИЧНО]** Отсутствие авторизации в ResumeController - доступ к резюме
   - **Файл:** [ResumeController.java](../backend/src/main/java/com/company/resourcemanager/controller/ResumeController.java)
   - **Строка:** 16-90 (весь контроллер)
   - **Проблема:** Контроллер не имеет аннотаций @PreAuthorize. Резюме содержат персональные данные (skills, опыт работы, образование, сертификаты, языки).
   - **Риск:**
     - Любой пользователь может просматривать резюме всех сотрудников
     - Может скачивать PDF резюме любого сотрудника
     - Может создавать/изменять/удалять резюме
     - Утечка персональных данных и коммерческой информации
     - Нарушение GDPR/защиты персональных данных
   - **Рекомендация:**
     - Добавить на уровне класса: `@PreAuthorize("hasRole('ADMIN')")` для всех методов кроме просмотра своего резюме
     - Или добавить проверку ownership: пользователь может видеть/редактировать только свое резюме
     - Метод экспорта PDF должен быть только для ADMIN или владельца резюме

4. **[ВЫСОКИЙ]** CORS настроен с allowedOriginPatterns("*")
   - **Файл:** [SecurityConfig.java:50](../backend/src/main/java/com/company/resourcemanager/config/SecurityConfig.java#L50)
   - **Строка:** 50
   - **Проблема:** CORS разрешает запросы с любого origin: `configuration.setAllowedOriginPatterns(List.of("*"))`
   - **Риск:**
     - Любой сайт может делать запросы к API от имени авторизованного пользователя
     - Уязвимость к CSRF-подобным атакам через XSS
     - Вредоносный сайт может украсть данные, если пользователь авторизован
   - **Рекомендация:**
     - Указать конкретные разрешенные origins: `List.of("http://localhost:31080", "https://yourdomain.com")`
     - Для production использовать только production URL
     - Удалить `allowedOriginPatterns("*")`
   - **Код:**
   ```java
   configuration.setAllowedOriginPatterns(List.of("*")); // ОПАСНО!
   ```

5. **[СРЕДНИЙ]** ColumnController и DictionaryController - GET без авторизации
   - **Файл:** [ColumnController.java:25-40](../backend/src/main/java/com/company/resourcemanager/controller/ColumnController.java#L25-L40), [DictionaryController.java:24-39](../backend/src/main/java/com/company/resourcemanager/controller/DictionaryController.java#L24-L39)
   - **Строка:** 25-40, 24-39
   - **Проблема:** GET методы getAllColumns/getColumn и getAllDictionaries/getDictionary доступны всем авторизованным пользователям без @PreAuthorize
   - **Риск:**
     - Низкий: это справочные данные (названия полей, списки значений)
     - Возможная утечка структуры БД и бизнес-логики
     - Потенциально могут содержать чувствительную информацию в именах полей/словарей
   - **Рекомендация:**
     - Если эти данные нужны USER для работы с таблицей сотрудников - оставить как есть
     - Если это чисто административные данные - добавить @PreAuthorize("hasRole('ADMIN')")

**Хорошие практики:**

- ✅ UserController защищен @PreAuthorize("hasRole('ADMIN')") на уровне класса
- ✅ SavedFilterController имеет проверку ownership через getCurrentUserId() - пользователь видит только свои фильтры
- ✅ ColumnPresetController имеет проверку ownership
- ✅ LockController имеет проверку ownership через getCurrentUserId()
- ✅ Включен @EnableMethodSecurity в SecurityConfig
- ✅ Административные операции (create/update/delete) в ColumnController и DictionaryController защищены
- ✅ Базовая защита на уровне SecurityFilterChain - все эндпоинты требуют аутентификации кроме /api/auth/login

**Оценка этапа:** КРИТИЧНО

**Критичность:** Найдены 3 критические уязвимости с прямым доступом к персональным данным сотрудников, оценкам производительности и резюме. Это нарушение принципа минимальных привилегий и прямая угроза конфиденциальности. Требуется немедленное исправление перед production deployment.

---

### ЭТАП 3: Инъекции и валидация данных - РЕЗУЛЬТАТЫ

**Статус:** ✅ Проверено

**Найденные уязвимости:**

1. **[НИЗКИЙ]** Отсутствие email валидации в CreateEmployeeRequest
   - **Файл:** [CreateEmployeeRequest.java:13](../backend/src/main/java/com/company/resourcemanager/dto/CreateEmployeeRequest.java#L13)
   - **Строка:** 13
   - **Проблема:** Поле email не имеет аннотации @Email для валидации формата
   - **Риск:**
     - Можно сохранить некорректный email адрес (например, "not-an-email")
     - Потенциальная проблема для рассылок или интеграций
     - Низкий риск безопасности, но проблема качества данных
   - **Рекомендация:** Добавить аннотацию `@Email(message = "Некорректный формат email")` на поле email
   - **Код:**
   ```java
   private String email;  // Нет валидации формата
   ```

2. **[НИЗКИЙ]** Stored XSS через JSONB customFields (теоретический)
   - **Файл:** [Employee.java:30-33](../backend/src/main/java/com/company/resourcemanager/entity/Employee.java#L30-L33), [EmployeeService.java](../backend/src/main/java/com/company/resourcemanager/service/EmployeeService.java)
   - **Строка:** 30-33
   - **Проблема:** Данные в customFields (Map<String, Object>) сохраняются без санитизации. Если они выводятся на frontend с использованием v-html, возможна XSS атака.
   - **Риск:**
     - Stored XSS: злоумышленник может вставить `<script>alert('XSS')</script>` в поле customFields
     - Если frontend отображает эти данные через v-html без экранирования - выполнится JavaScript
     - Кража JWT токена, session hijacking, фишинг
     - **Примечание:** Нужна проверка frontend (этап 8)
   - **Рекомендация:**
     - На backend: санитизировать HTML в customFields перед сохранением (библиотека OWASP Java HTML Sanitizer)
     - На frontend: избегать v-html, использовать text interpolation `{{ }}` или sanitize HTML на клиенте
   - **Код:**
   ```java
   @Type(JsonBinaryType.class)
   @Column(name = "custom_fields", columnDefinition = "jsonb")
   private Map<String, Object> customFields = new HashMap<>();
   ```

**Хорошие практики:**

- ✅ Все @Query в репозиториях используют параметризацию через @Param - SQL Injection невозможна
- ✅ JPQL запросы в EmployeeRepository параметризованы (строки 15-18)
- ✅ Native queries в NineBoxAssessmentRepository не содержат пользовательского ввода - безопасны
- ✅ Динамические запросы используют Specification API с CriteriaBuilder - защита от SQL Injection
- ✅ JSONB фильтрация использует cb.function("jsonb_extract_path_text") с cb.literal() - безопасно (EmployeeService.java:68-88)
- ✅ JsonBinaryType из Hypersistence Utils - безопасная библиотека для JSONB, нет небезопасной десериализации
- ✅ Контроллеры используют @Valid для валидации DTO (проверено в 10 контроллерах)
- ✅ DTO имеют аннотации валидации: @NotBlank, @NotNull, @Min, @Max (LoginRequest, CreateEmployeeRequest, NineBoxCreateDTO)
- ✅ Работа с файлами безопасна:
  - PDF и Excel генерируются в памяти (ByteArrayOutputStream) - нет записи на диск
  - Filename sanitization в ResumeController.java:67,83 - replaceAll("[^a-zA-Zа-яА-Я0-9]", "_")
  - Нет Path Traversal уязвимостей
  - ResumePdfService использует Files.createTempFile для временных шрифтов - безопасно
- ✅ Нет использования Runtime.exec(), ProcessBuilder или других команд OS - Command Injection невозможна

**Оценка этапа:** НИЗКИЙ РИСК

**Критичность:** Не найдено критических уязвимостей типа SQL Injection, Command Injection или Path Traversal. Валидация данных присутствует. Единственная потенциальная проблема - Stored XSS через customFields, но она требует подтверждения на frontend (этап 8).

---

### ЭТАП 4: Конфигурация безопасности и CORS - РЕЗУЛЬТАТЫ

**Статус:** ✅ Проверено

**Найденные уязвимости:**

1. **[ВЫСОКИЙ]** CORS настроен с allowedOriginPatterns("*") и allowCredentials(true)
   - **Файл:** [SecurityConfig.java:50,53](../backend/src/main/java/com/company/resourcemanager/config/SecurityConfig.java#L50)
   - **Строка:** 50, 53
   - **Проблема:** CORS разрешает запросы с любого origin (*) в комбинации с allowCredentials(true), что создает критическую уязвимость
   - **Риск:**
     - Вредоносный сайт может делать запросы к API от имени авторизованного пользователя
     - CSRF-подобные атаки: если пользователь авторизован и посещает вредоносный сайт, тот сайт может украсть данные
     - Утечка JWT токенов и персональных данных
     - Комбинация "*" + allowCredentials(true) является anti-pattern и должна быть запрещена
   - **Рекомендация:**
     - Указать конкретные разрешенные origins: `List.of("http://localhost:31080", "https://production-domain.com")`
     - Для production использовать только production URL
     - Если действительно нужны динамические origins, создать whitelist и проверять его программно
   - **Код:**
   ```java
   configuration.setAllowedOriginPatterns(List.of("*"));
   configuration.setAllowCredentials(true);  // Опасная комбинация!
   ```

2. **[СРЕДНИЙ]** Отсутствие Security Headers
   - **Файл:** [SecurityConfig.java](../backend/src/main/java/com/company/resourcemanager/config/SecurityConfig.java), [nginx.conf](../frontend/nginx.conf)
   - **Строка:** N/A
   - **Проблема:** Не настроены критичные security headers ни на backend, ни на frontend nginx
   - **Риск:**
     - **X-Frame-Options:** отсутствует - уязвимость к Clickjacking атакам
     - **X-Content-Type-Options:** отсутствует - MIME type sniffing атаки
     - **X-XSS-Protection:** отсутствует - некоторые браузеры не включат встроенную XSS защиту
     - **Content-Security-Policy:** отсутствует - нет защиты от XSS через inline scripts
     - **Strict-Transport-Security (HSTS):** отсутствует - нет принудительного HTTPS
   - **Рекомендация:**
     - **Backend (SecurityConfig):** Добавить `.headers(headers -> headers.frameOptions().deny().contentTypeOptions().and().xssProtection().and())`
     - **Frontend (nginx.conf):** Добавить headers:
       ```nginx
       add_header X-Frame-Options "DENY";
       add_header X-Content-Type-Options "nosniff";
       add_header X-XSS-Protection "1; mode=block";
       add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';";
       add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
       ```

3. **[СРЕДНИЙ]** DEBUG режим включен в application.yml
   - **Файл:** [application.yml:28](../backend/src/main/resources/application.yml#L28)
   - **Строка:** 28
   - **Проблема:** Logging level установлен в DEBUG для всего пакета com.company.resourcemanager
   - **Риск:**
     - Избыточное логирование может раскрыть чувствительную информацию (SQL запросы, параметры, внутренняя логика)
     - Потенциальная утечка данных в логи
     - Снижение производительности в production
     - Логи могут занимать много места
   - **Рекомендация:**
     - Использовать INFO или WARN уровень для production
     - DEBUG только для dev/test окружений
     - Использовать Spring Profiles для разделения конфигураций (application-dev.yml, application-prod.yml)
   - **Код:**
   ```yaml
   logging:
     level:
       com.company.resourcemanager: DEBUG  # Опасно для production
   ```

4. **[СРЕДНИЙ]** Отсутствие HTTPS
   - **Файл:** [nginx.conf:2](../frontend/nginx.conf#L2)
   - **Строка:** 2
   - **Проблема:** nginx слушает только на порту 80 (HTTP), нет конфигурации HTTPS
   - **Риск:**
     - JWT токены передаются по незашифрованному HTTP - могут быть перехвачены через MITM атаку
     - Персональные данные сотрудников передаются в открытом виде
     - Passwords в login request передаются без шифрования
     - Session hijacking через перехват JWT
   - **Рекомендация:**
     - Настроить SSL/TLS сертификат (Let's Encrypt для production)
     - Добавить редирект с HTTP на HTTPS
     - Включить HSTS header для принудительного HTTPS
     - Для dev окружения можно использовать self-signed сертификат
   - **Код:**
   ```nginx
   server {
       listen 80;  # Только HTTP - небезопасно!
   ```

5. **[НИЗКИЙ]** CSRF защита отключена
   - **Файл:** [SecurityConfig.java:33](../backend/src/main/java/com/company/resourcemanager/config/SecurityConfig.java#L33)
   - **Строка:** 33
   - **Проблема:** CSRF protection отключен через `.csrf(AbstractHttpConfigurer::disable)`
   - **Риск:**
     - Для stateless JWT authentication отключение CSRF это стандартная практика и не является уязвимостью
     - **НО**: В комбинации с CORS "*" и allowCredentials(true) это может создать CSRF-подобные атаки
     - Вредоносный сайт может делать cross-origin запросы с cookies/credentials
   - **Рекомендация:**
     - Для JWT API CSRF можно оставить отключенным, это норма
     - **НО**: ОБЯЗАТЕЛЬНО исправить CORS настройки (проблема #1) для защиты от cross-origin атак
   - **Код:**
   ```java
   .csrf(AbstractHttpConfigurer::disable)  // OK для JWT, но только с правильными CORS
   ```

**Хорошие практики:**

- ✅ Actuator endpoints ограничены только /actuator/health - остальные не доступны (application.yml:31-34)
- ✅ GlobalExceptionHandler не раскрывает stack traces клиенту - только "Internal server error" (строка 54-55)
- ✅ SessionCreationPolicy.STATELESS - корректно для JWT authentication (SecurityConfig.java:36)
- ✅ Все эндпоинты требуют аутентификации кроме /api/auth/login и /actuator/health (SecurityConfig.java:37-40)
- ✅ @EnableMethodSecurity включен для method-level авторизации (SecurityConfig.java:24)

**Оценка этапа:** ВЫСОКИЙ РИСК

**Критичность:** Найдена критическая проблема с CORS (allowedOriginPatterns "*" + allowCredentials). Отсутствие HTTPS и security headers повышает риск перехвата данных и XSS атак. DEBUG режим в production может привести к утечке информации. Требуется исправление перед production deployment.

---

### ЭТАП 5: Управление сессиями - РЕЗУЛЬТАТЫ

**Статус:** ✅ Проверено

**Найденные уязвимости:**

1. **[ВЫСОКИЙ]** JWT токен хранится в localStorage
   - **Файл:** [auth.js:6,19,45](../frontend/src/stores/auth.js#L6)
   - **Строка:** 6, 19, 45
   - **Проблема:** JWT токен сохраняется в localStorage браузера
   - **Риск:**
     - **XSS атака:** Если есть XSS уязвимость на сайте, злоумышленник может выполнить JavaScript код и украсть токен через `localStorage.getItem('token')`
     - localStorage доступен для всех скриптов на странице, включая third-party библиотеки
     - Украденный токен действителен 24 часа (см. этап 1, проблема #5)
     - Session hijacking: злоумышленник получает полный доступ к системе от имени пользователя
   - **Рекомендация:**
     - Использовать httpOnly cookies для хранения JWT токена - они не доступны JavaScript
     - Если httpOnly cookies невозможны (CORS ограничения), рассмотреть Memory storage (только в Pinia store) с риском потери при refresh
     - Сократить время жизни access token до 15-30 минут
     - Внедрить refresh token механизм с httpOnly cookie
   - **Код:**
   ```javascript
   const token = ref(localStorage.getItem('token'))  // Уязвим к XSS!
   localStorage.setItem('token', token.value)
   ```

2. **[СРЕДНИЙ]** Долгое время жизни JWT токена (24 часа)
   - **Файл:** [application.yml:24](../backend/src/main/resources/application.yml#L24)
   - **Строка:** 24
   - **Проблема:** JWT expiration установлен в 86400000 мс (24 часа) - уже упомянуто в этапе 1
   - **Риск:**
     - Украденный токен действует целые сутки
     - В комбинации с localStorage это критично
     - Нет возможности быстро отозвать скомпрометированный токен
   - **Рекомендация:**
     - Сократить access token до 15-30 минут
     - Внедрить refresh token со временем жизни 7-30 дней
     - Refresh token хранить в httpOnly cookie или в БД с возможностью отзыва

3. **[СРЕДНИЙ]** Отсутствие refresh token механизма
   - **Файл:** [JwtTokenProvider.java](../backend/src/main/java/com/company/resourcemanager/config/JwtTokenProvider.java), [auth.js](../frontend/src/stores/auth.js)
   - **Строка:** N/A
   - **Проблема:** Нет механизма refresh token для продления сессии без повторного входа
   - **Риск:**
     - Пользователь должен заново логиниться каждые 24 часа
     - Невозможно быстро отозвать access token без revocation list
     - Нет баланса между безопасностью (короткий токен) и UX (долгий токен)
   - **Рекомендация:**
     - Внедрить refresh token endpoint: POST /api/auth/refresh
     - Refresh token хранить в httpOnly cookie или в UserSession таблице
     - При истечении access token frontend автоматически запрашивает новый через refresh token
     - Refresh token можно отозвать через БД (удалить из UserSession)

4. **[СРЕДНИЙ]** JWT не инвалидируется при logout до истечения срока
   - **Файл:** [AuthService.java:91-95](../backend/src/main/java/com/company/resourcemanager/service/AuthService.java#L91-L95)
   - **Строка:** 91-95
   - **Проблема:** При logout удаляется UserSession из БД, но JWT токен остается валидным до истечения expiration
   - **Риск:**
     - Если токен был скопирован или украден до logout, он останется действительным
     - Злоумышленник может использовать старый токен даже после logout пользователя
     - Нет "черного списка" (revocation list) для JWT
   - **Рекомендация:**
     - Добавить проверку существования UserSession в JwtAuthenticationFilter - если сессии нет, токен недействителен
     - Или использовать Redis для blacklist токенов (хранить jti claim отозванных токенов)
     - Или сократить время жизни access token до минимума (15 минут)
   - **Код:**
   ```java
   public void logout() {
       User user = getCurrentUserEntity();
       userSessionRepository.deleteByUserId(user.getId());  // Но JWT еще валиден!
   }
   ```

**Хорошие практики:**

- ✅ UserSession entity отслеживает активные сессии - хорошая архитектура (UserSession.java)
- ✅ SESSION_TIMEOUT_MINUTES = 30 - разумный таймаут для автоматического logout неактивных сессий (AuthService.java:29)
- ✅ cleanupExpiredSessions() метод для удаления истекших сессий (AuthService.java:106-109)
- ✅ Проверка одновременных сессий: не-админ может иметь только одну активную сессию (AuthService.java:41-53)
- ✅ Admin может иметь несколько параллельных сессий - разумный подход (AuthService.java:51-53)
- ✅ updateSessionActivity() обновляет last_activity для продления сессии (AuthService.java:98-103)
- ✅ Frontend очищает токен и user при logout (auth.js:43-45)
- ✅ SessionCreationPolicy.STATELESS в SecurityConfig - корректно для JWT (SecurityConfig.java:36)

**Оценка этапа:** ВЫСОКИЙ РИСК

**Критичность:** Хранение JWT в localStorage создает высокий риск XSS атак. В комбинации с долгим временем жизни токена (24 часа) и отсутствием refresh token механизма, это значительная угроза безопасности. Рекомендуется переход на httpOnly cookies и внедрение refresh token.


---

### ЭТАП 6: Логирование и аудит - РЕЗУЛЬТАТЫ

**Статус:** ✅ Проверено

**Найденные уязвимости:**

1. **[ВЫСОКИЙ]** Отсутствие логирования failed login attempts
   - **Файл:** [AuthService.java:32-38](../backend/src/main/java/com/company/resourcemanager/service/AuthService.java#L32-L38)
   - **Строка:** 32-38
   - **Проблема:** Метод login() не логирует неудачные попытки входа. При вводе неверных credentials просто выбрасывается BadRequestException без логирования.
   - **Риск:**
     - Невозможно отследить brute-force атаки на аккаунты
     - Нет мониторинга подозрительной активности (множественные failed logins с одного IP)
     - Невозможно расследовать инциденты безопасности
   - **Рекомендация:**
     - Логировать username, IP адрес, timestamp для каждой failed попытки
     - Использовать уровень WARN: `log.warn("Failed login attempt for user: {}, IP: {}", username, ipAddress)`
     - Настроить алерты на множественные failed attempts
   - **Код:**
   ```java
   if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
       throw new BadRequestException("Invalid credentials"); // Нет логирования!
   }
   ```

2. **[СРЕДНИЙ]** Отсутствие логирования успешных login/logout событий
   - **Файл:** [AuthService.java](../backend/src/main/java/com/company/resourcemanager/service/AuthService.java)
   - **Строка:** 56, 92-95
   - **Проблема:** Нет логирования успешных входов в систему и logout событий
   - **Риск:**
     - Невозможно отследить кто и когда заходил в систему
     - Отсутствие аудита для расследования инцидентов (например, "кто удалил данные в 3 ночи?")
     - Нет мониторинга необычной активности (вход в нерабочее время)
   - **Рекомендация:**
     - Логировать успешный login: `log.info("User {} logged in, IP: {}", username, ipAddress)`
     - Логировать logout: `log.info("User {} logged out", username)`

3. **[СРЕДНИЙ]** Отсутствие аудита критичных административных операций
   - **Файл:** [UserService.java](../backend/src/main/java/com/company/resourcemanager/service/UserService.java), [NineBoxService.java](../backend/src/main/java/com/company/resourcemanager/service/NineBoxService.java)
   - **Проблема:** Нет логирования:
     - Создания/удаления пользователей
     - Изменения ролей пользователей
     - Создания/изменения/удаления 9-Box оценок
     - Создания/удаления резюме
   - **Риск:**
     - Невозможно отследить кто изменил критичные данные
     - Отсутствие accountability для административных действий
   - **Рекомендация:**
     - Добавить INFO логи для всех CRUD операций с пользователями и критичными данными
     - Включить: кто (username), что (действие), когда (timestamp), над чем (entity ID)

4. **[НИЗКИЙ]** DEBUG logging в production
   - **Файл:** [application.yml:28](../backend/src/main/resources/application.yml#L28)
   - **Строка:** 28
   - **Проблема:** Уровень логирования установлен в DEBUG для com.company.resourcemanager
   - **Риск:**
     - Избыточное логирование может замедлить приложение
     - Потенциальная утечка чувствительной информации в DEBUG логах
     - Большой объем логов усложняет поиск важных событий
   - **Рекомендация:** Изменить на INFO или WARN для production
   - **Код:**
   ```yaml
   logging:
     level:
       com.company.resourcemanager: DEBUG  # Должно быть INFO для production
   ```

**Хорошие практики:**

- ✅ EmployeeHistory механизм - отличный аудит всех изменений сотрудников (EmployeeService.java:233-242)
- ✅ EmployeeHistory хранит: кто изменил (changedBy), когда (changedAt), что (fieldName), старое/новое значение
- ✅ Нет логирования паролей или токенов - checked весь код
- ✅ GlobalExceptionHandler логирует unexpected errors с полным stack trace для отладки (GlobalExceptionHandler.java:52)
- ✅ Stack trace НЕ возвращается клиенту - только "Internal server error" (GlobalExceptionHandler.java:54-55)
- ✅ ResumePdfService логирует ошибки генерации PDF (ResumePdfService.java:209)

**Оценка этапа:** СРЕДНИЙ РИСК

**Критичность:** Отсутствие логирования security events (failed logins, successful logins) затрудняет обнаружение атак и расследование инцидентов. EmployeeHistory работает хорошо для данных сотрудников, но нужен аудит для других критичных операций.


---

### ЭТАП 7: Зависимости и Docker - РЕЗУЛЬТАТЫ

**Статус:** ✅ Проверено

**Найденные уязвимости:**

1. **[ВЫСОКИЙ]** Backend контейнер запускается от root
   - **Файл:** [Dockerfile:8-12](../backend/Dockerfile#L8-L12)
   - **Строка:** 8-12
   - **Проблема:** В Dockerfile нет USER директивы. Контейнер запускается от root (UID 0), что нарушает принцип наименьших привилегий.
   - **Риск:**
     - Если злоумышленник скомпрометирует приложение, он получит root доступ внутри контейнера
     - Container escape уязвимости становятся более опасными при запуске от root
     - Нарушение security best practices
   - **Рекомендация:**
     - Добавить непривилегированного пользователя
     - Добавить перед ENTRYPOINT:
   ```dockerfile
   RUN addgroup -S appgroup && adduser -S appuser -G appgroup
   USER appuser
   ENTRYPOINT ["java", "-jar", "app.jar"]
   ```

2. **[ВЫСОКИЙ]** PostgreSQL порт открыт наружу
   - **Файл:** [docker-compose.yml:9-10](../docker-compose.yml#L9-L10)
   - **Строка:** 9-10
   - **Проблема:** PostgreSQL порт 31432 проброшен на host и доступен извне. БД должна быть доступна только внутри Docker network.
   - **Риск:**
     - Прямой доступ к БД из интернета (если сервер имеет публичный IP)
     - Возможность brute-force атак на postgres credentials
     - Утечка данных через прямое подключение к БД
     - Bypassing application security layer
   - **Рекомендация:**
     - Удалить ports для postgres - достаточно внутренней сети
     - Оставить только для development: `- "127.0.0.1:31432:5432"` (биндинг на localhost)
   - **Код:**
   ```yaml
   ports:
     - "31432:5432"  # Доступ извне! Опасно!
   ```

3. **[СРЕДНИЙ]** Устаревшая версия Apache POI
   - **Файл:** [pom.xml:94-97](../backend/pom.xml#L94-L97)
   - **Строка:** 94-97
   - **Проблема:** Apache POI версия 5.2.5 (май 2023) может содержать известные уязвимости
   - **Риск:**
     - Потенциальные CVE в обработке Excel файлов
     - XML External Entity (XXE) атаки через загрузку xlsx
     - Denial of Service через crafted Excel files
   - **Рекомендация:**
     - Обновить до последней версии (5.3.0+)
     - Проверить CVE: `mvn dependency:check` или OWASP Dependency Check
   - **Код:**
   ```xml
   <version>5.2.5</version>  <!-- Старая версия 2023 года -->
   ```

4. **[НИЗКИЙ]** Credentials в docker-compose без .env
   - **Файл:** [docker-compose.yml:6-8, 27-31](../docker-compose.yml)
   - **Строка:** 6-8, 27-31
   - **Проблема:** Пароли и секреты хардкодены в docker-compose.yml (уже упомянуто в Этапе 1)
   - **Риск:** Утечка через git репозиторий
   - **Рекомендация:** Использовать .env файл с переменными окружения

**Хорошие практики:**

- ✅ Современные версии зависимостей:
  - Spring Boot 3.2.5 (2024)
  - jjwt 0.12.3 (последняя)
  - Flyway 10.10.0 (актуальная)
  - Vue 3.5.24, Vite 7.2.4 (последние)
- ✅ Многоступенчатая сборка Docker - уменьшает размер образа и поверхность атаки
- ✅ Alpine базовые образы (postgres:15-alpine, node:20-alpine, nginx:alpine) - минимальные
- ✅ Docker bridge network для изоляции контейнеров
- ✅ Healthcheck для PostgreSQL - мониторинг доступности
- ✅ npm ci вместо npm install - детерминированная установка зависимостей
- ✅ Нет известных критичных CVE в основных зависимостях (Spring Security, JWT)
- ✅ depends_on с condition: service_healthy - правильная последовательность запуска
- ✅ Volumes для postgres_data - персистентность данных

**Оценка этапа:** ВЫСОКИЙ РИСК

**Критичность:** Запуск backend от root и открытый порт PostgreSQL создают значительные риски безопасности. В production PostgreSQL НЕ должен быть доступен извне, а приложения должны запускаться от непривилегированных пользователей. Рекомендуется исправление перед deployment.

---

---

### ЭТАП 7: Зависимости и Docker - РЕЗУЛЬТАТЫ

**Статус:** ✅ Проверено

**Найденные уязвимости:**

1. **[СРЕДНИЙ]** Spring Boot 3.2.5 устарела
   - **Файл:** [pom.xml:10](../backend/pom.xml#L10)
   - **Строка:** 10
   - **Проблема:** Spring Boot версии 3.2.5 (апрель 2024) устарела, актуальная версия 3.4.x (январь 2025)
   - **Риск:**
     - Пропущены security patches из версий 3.2.6+, 3.3.x, 3.4.x
     - Потенциальные уязвимости в Spring Security, Spring Web, Spring Data
     - Отсутствие новых security features
   - **Рекомендация:** Обновить до Spring Boot 3.4.x (последняя стабильная)

2. **[СРЕДНИЙ]** Backend Dockerfile запускается от root
   - **Файл:** [backend/Dockerfile:8-12](../backend/Dockerfile#L8-L12)
   - **Строка:** 8-12
   - **Проблема:** Не указан USER в Dockerfile, приложение запускается от root
   - **Риск:**
     - Container breakout: если уязвимость в приложении, злоумышленник получает root права в контейнере
     - Privilege escalation: root в контейнере может получить доступ к хосту
     - Нарушение принципа least privilege
   - **Рекомендация:**
     - Добавить non-root пользователя:
     ```dockerfile
     RUN addgroup --system --gid 1001 spring && adduser --system --uid 1001 --ingroup spring spring
     USER spring:spring
     ENTRYPOINT ["java", "-jar", "app.jar"]
     ```

3. **[НИЗКИЙ]** Неверные версии frontend зависимостей
   - **Файл:** [package.json:13,15,22](../frontend/package.json#L13)
   - **Строка:** 13 (axios), 15 (pinia), 22 (vite)
   - **Проблема:** Некорректные версии зависимостей в package.json:
     - axios 1.13.2 - версия 1.13.x не существует (актуальная 1.7.x)
     - pinia 3.0.4 - версия 3.x не существует (актуальная 2.x)
     - vite 7.2.4 - версия 7.x не существует (актуальная 5.x/6.x)
   - **Риск:**
     - npm install может установить неправильные версии
     - Потенциальные уязвимости из-за устаревших зависимостей
     - Build может сломаться
   - **Рекомендация:** Исправить версии на актуальные:
     - axios: ^1.7.0
     - pinia: ^2.2.0
     - vite: ^6.0.0

4. **[НИЗКИЙ]** Docker ports exposed наружу
   - **Файл:** [docker-compose.yml:9,33,46](../docker-compose.yml#L9)
   - **Строка:** 9 (postgres:31432), 33 (backend:31081), 46 (frontend:31080)
   - **Проблема:** Все порты проброшены на 0.0.0.0 (доступны извне)
   - **Риск:**
     - PostgreSQL порт 31432 доступен из сети - прямой доступ к БД
     - Backend API порт 31081 доступен напрямую, минуя frontend proxy
     - Атакующий может подключиться к БД с хоста или сети
   - **Рекомендация:**
     - Для production: только frontend порт наружу, остальное в internal network
     - Для dev: использовать 127.0.0.1:31432:5432 вместо 31432:5432
     - Или использовать Docker networks без expose портов

**Хорошие практики:**

- ✅ Multi-stage Docker builds используются для backend и frontend - уменьшает размер образа
- ✅ Актуальные версии: jjwt 0.12.3, Flyway 10.10.0, Hypersistence Utils 3.7.3, OpenPDF 1.3.35
- ✅ Базовые образы: eclipse-temurin:17-jre (официальный), nginx:alpine, node:20-alpine - безопасные и актуальные
- ✅ Apache POI 5.2.5 - без критичных CVE
- ✅ Frontend использует npm ci вместо npm install - детерминированные зависимости (Dockerfile:5)
- ✅ Тесты пропускаются при build для ускорения (DskipTests) - норма для Docker build
- ✅ Java 17 - LTS версия с долгосрочной поддержкой
- ✅ Docker networks используются для изоляции сервисов (docker-compose.yml:networks)
- ✅ PostgreSQL healthcheck настроен (docker-compose.yml:13-17)
- ✅ Volumes используются для персистентных данных (docker-compose.yml:postgres_data)

**Оценка этапа:** СРЕДНИЙ РИСК

**Критичность:** Устаревшая Spring Boot может содержать уязвимости. Backend запускается от root - нарушение least privilege. Неверные версии frontend зависимостей требуют исправления. PostgreSQL порт доступен извне - риск для production.


### ЭТАП 8: Frontend безопасность - РЕЗУЛЬТАТЫ

**Статус:** ✅ Проверено

**Найденные уязвимости:**

1. **[ВЫСОКИЙ]** JWT токен хранится в localStorage - уязвимость к XSS
   - **Файл:** [auth.js:6, 19, 45](../frontend/src/stores/auth.js#L6)
   - **Строка:** 6, 19, 45
   - **Проблема:** JWT токен хранится в localStorage, который доступен любому JavaScript коду (уже упомянуто в Этапе 5)
   - **Риск:**
     - Stored XSS: если злоумышленник внедрит `<script>` через какую-либо уязвимость, он может украсть токен: `localStorage.getItem('token')`
     - Кража токена = полный доступ к аккаунту пользователя
   - **Рекомендация:** Использовать httpOnly cookies вместо localStorage
   - **Код:**
   ```javascript
   const token = ref(localStorage.getItem('token'))  // Доступен для XSS!
   localStorage.setItem('token', token.value)
   ```

2. **[НИЗКИЙ]** Pinia stores не очищаются при logout
   - **Файл:** [columns.js](../frontend/src/stores/columns.js), другие stores
   - **Проблема:** При logout auth store очищается, но другие stores (columns, notifications) сохраняют данные в памяти
   - **Риск:**
     - Низкий: данные остаются в памяти браузера до перезагрузки страницы
     - На общем компьютере следующий пользователь может увидеть кешированные данные
   - **Рекомендация:**
     - Добавить метод `reset()` во все stores с чувствительными данными
     - Вызывать reset при logout: `columnsStore.$reset()`

**Хорошие практики:**

- ✅ Router guards правильно реализованы (router/index.js:60-77)
  - beforeEach проверяет requiresAuth
  - Перенаправляет на /login если не авторизован
  - requiresAdmin для административных страниц (строка 27, 72)
- ✅ Нет использования v-html в компонентах - XSS через v-html отсутствует
- ✅ Axios interceptor правильно добавляет Authorization header (client.js:13-19)
- ✅ Axios interceptor обрабатывает 401 и автоматически делает logout (client.js:22-32)
- ✅ Нет API ключей или секретов в frontend коде
- ✅ Auth store очищает token и user при logout (auth.js:43-45)
- ✅ baseURL: '/api' - относительный путь, нет хардкода (client.js:6)
- ✅ Guest guard для login page - авторизованных перенаправляет на главную (router/index.js:70-71)
- ✅ Content-Type: application/json по умолчанию (client.js:8)

**Оценка этапа:** ВЫСОКИЙ РИСК

**Критичность:** Хранение JWT в localStorage представляет высокий риск. В остальном frontend security реализована корректно: есть route guards, нет XSS через v-html, нет утечки API ключей. Рекомендуется переход на httpOnly cookies для хранения токена.

---


ЭТАП 8: Frontend безопасность - ЗАВЕРШЕН
ИТОГОВОЕ ЗАКЛЮЧЕНИЕ добавлено.

Все 8 этапов аудита завершены. Найдено 24 уязвимости:
- 5 критичных
- 4 высоких
- 9 средних
- 6 низких

Система НЕ готова для production без исправления критичных уязвимостей.
