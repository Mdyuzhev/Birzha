# GAP-анализ: ТЗ vs Текущая реализация Birzha

## Краткое резюме

**Критический вывод:** Текущая реализация покрывает ~20-25% требований ТЗ. Основной функционал ТЗ — **система заявок на развитие и ротацию сотрудников** с workflow согласования — **полностью отсутствует**.

Текущая система — это база сотрудников с динамическими колонками и 9-Box оценкой. ТЗ требует полноценную HRM-систему внутреннего рекрутинга с workflow заявок, многоуровневой ролевой моделью, мультитенантностью (ДЗО) и интеграциями.

---

## Сравнительная таблица

| Требование ТЗ | Статус | Комментарий |
|---------------|--------|-------------|
| **КРИТИЧЕСКИЕ ФУНКЦИИ** | | |
| Заявки на развитие/ротацию | ❌ НЕТ | Основная функция системы полностью отсутствует |
| Workflow согласования (Руководитель→Рекрутер→HR BP→БОРУП) | ❌ НЕТ | Нет статусной машины заявок |
| 6 ролей (Руководитель, Рекрутер, HR BP, БОРУП, Админ ДЗО, Админ системы) | ❌ НЕТ | Только ADMIN/USER |
| Мультитенантность (ДЗО) | ❌ НЕТ | Нет поддержки нескольких организаций |
| Чёрный список кандидатов | ❌ НЕТ | Модуль отсутствует |
| Email-уведомления | ❌ НЕТ | Нет интеграции с почтой |
| **ИНТЕГРАЦИИ** | | |
| LDAP/AD авторизация | ❌ НЕТ | Только JWT локальная |
| Интеграция с 1С ЗУП | ❌ НЕТ | Нет |
| Интеграция с ATS (IQHR) | ❌ НЕТ | Нет |
| 2FA (пароль + OTP) | ❌ НЕТ | Только базовая авторизация |
| **СПРАВОЧНИКИ** | | |
| Справочник стеков (с workflow запросов) | ⚠️ ЧАСТИЧНО | Есть Dictionary, но без workflow запросов от ДЗО |
| Закрепление HR BP за подразделениями | ❌ НЕТ | Нет связи HR BP ↔ подразделение |
| Иерархия подразделений | ❌ НЕТ | Flat structure |
| **АНАЛИТИКА** | | |
| Аналитика по заявкам | ❌ НЕТ | Нет заявок = нет аналитики |
| Дашборды по статусам/стекам | ❌ НЕТ | AnalyticsView пустой |
| **УЖЕ РЕАЛИЗОВАНО** | | |
| База сотрудников | ✅ ЕСТЬ | Employee entity |
| Динамические колонки (JSONB) | ✅ ЕСТЬ | ColumnDefinition + customFields |
| Справочники значений | ✅ ЕСТЬ | Dictionary |
| История изменений (аудит) | ✅ ЕСТЬ | EmployeeHistory |
| Экспорт в Excel | ✅ ЕСТЬ | ExcelExportService |
| 9-Box оценка | ✅ ЕСТЬ | NineBoxAssessment (НЕ в ТЗ!) |
| Резюме сотрудников + PDF | ✅ ЕСТЬ | EmployeeResume (НЕ в ТЗ!) |
| Фильтрация/пагинация | ✅ ЕСТЬ | Полноценная |
| Пресеты колонок/фильтры | ✅ ЕСТЬ | ColumnPreset, SavedFilter |

---

## Детальный GAP-анализ

### 1. КРИТИЧНО: Модуль заявок (Application/Request)

**Требуется создать с нуля:**

#### 1.1 Entity: Application (Заявка)
```
Поля:
- id (PK)
- employee_id (FK → employees) - кандидат на ротацию
- created_by (FK → users) - кто создал (Руководитель/HR BP)
- created_at (timestamp)
- dzo_id (FK → dzos) - ДЗО
- target_position (varchar) - целевая должность
- target_stack_id (FK → stacks) - целевой стек
- resume_file (varchar/binary) - прикреплённое резюме
- current_salary (decimal) - текущая ЗП
- target_salary (decimal) - целевая ЗП
- salary_increase_percent (computed) - % увеличения
- requires_borup_approval (boolean) - нужно ли согласование БОРУП (>30%)
- status (enum) - статус заявки
- recruiter_id (FK → users) - назначенный рекрутер
- hr_bp_id (FK → users) - HR BP отдающей стороны
- hr_bp_decision (enum: PENDING/APPROVED/REJECTED)
- hr_bp_comment (text)
- hr_bp_decision_at (timestamp)
- borup_id (FK → users) - БОРУП (если требуется)
- borup_decision (enum)
- borup_comment (text)
- borup_decision_at (timestamp)
- final_decision (enum)
- final_comment (text)
- transfer_date (date) - дата перевода
```

#### 1.2 Enum: ApplicationStatus
```java
enum ApplicationStatus {
    AVAILABLE_FOR_REVIEW,     // Свободен для рассмотрения
    IN_PROGRESS,              // В работе (на рассмотрении)
    INTERVIEW,                // На собеседовании
    PENDING_HR_BP_APPROVAL,   // Ожидает согласования HR BP
    HR_BP_APPROVED,           // Согласован HR BP
    HR_BP_REJECTED,           // Отклонён HR BP
    PENDING_BORUP_APPROVAL,   // Ожидает согласования БОРУП
    BORUP_APPROVED,           // Согласован БОРУП
    BORUP_REJECTED,           // Отклонён БОРУП
    PREPARING_TRANSFER,       // Готовится к переводу
    TRANSFERRED,              // Переведён
    DISMISSED                 // Увольнение
}
```

#### 1.3 Workflow Service
```java
ApplicationWorkflowService {
    createApplication(CreateApplicationRequest) // Руководитель/HR BP
    assignRecruiter(applicationId, recruiterId) // Рекрутер берёт в работу
    sendToHrBpApproval(applicationId)           // Рекрутер → HR BP
    approveByHrBp(applicationId, comment)       // HR BP согласует
    rejectByHrBp(applicationId, comment)        // HR BP отклоняет
    sendToBorupApproval(applicationId)          // → БОРУП (если >30%)
    approveByBorup(applicationId, comment)      // БОРУП согласует
    rejectByBorup(applicationId, comment)       // БОРУП отклоняет
    markAsTransferred(applicationId, date)      // Переведён
    markAsDismissed(applicationId, reason)      // Увольнение
}
```

**Трудозатраты:** ~40-60 часов

---

### 2. КРИТИЧНО: Расширенная ролевая модель

**Текущее состояние:** ADMIN, USER
**Требуется:**

```java
enum Role {
    SYSTEM_ADMIN,    // Администратор системы (все ДЗО)
    DZO_ADMIN,       // Администратор ДЗО (своё ДЗО)
    RECRUITER,       // Рекрутер
    HR_BP,           // HR BP
    BORUP,           // БОРУП
    MANAGER          // Руководитель (подаёт заявки)
}
```

**Изменения:**
- Таблица `users`: добавить `role` как массив (пользователь может иметь несколько ролей)
- Таблица `user_dzo_assignments`: связь user ↔ DZO для админов ДЗО
- Таблица `hr_bp_department_assignments`: связь HR BP ↔ подразделения
- Spring Security: расширить @PreAuthorize логику

**Трудозатраты:** ~20-30 часов

---

### 3. КРИТИЧНО: Мультитенантность (ДЗО)

**Требуется создать:**

#### 3.1 Entity: DZO (Дочернее зависимое общество)
```
Поля:
- id (PK)
- code (varchar) - код (rt-dc.ru, rt-solar.ru и т.д.)
- name (varchar) - название
- domain (varchar) - email домен
- is_active (boolean)
- created_at (timestamp)
```

#### 3.2 Изменения в существующих таблицах
```sql
ALTER TABLE employees ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);
ALTER TABLE users ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);
ALTER TABLE applications ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);
-- и т.д. для всех таблиц
```

#### 3.3 Фильтрация по ДЗО
- Все запросы должны фильтроваться по dzo_id текущего пользователя
- Админ системы видит все ДЗО
- Админ ДЗО видит только своё ДЗО

**Трудозатраты:** ~30-40 часов

---

### 4. КРИТИЧНО: Чёрный список кандидатов (Blacklist)

**Требуется создать с нуля:**

#### 4.1 Entity: BlacklistEntry
```
Поля:
- id (PK)
- full_name (varchar) - ФИО
- email (varchar)
- position (varchar) - должность
- department (varchar) - подразделение
- manager_name (varchar) - руководитель
- hr_bp_name (varchar) - закреплённый HR BP
- dismissal_date (date) - дата увольнения
- entry_date (date) - дата внесения в список
- dismissal_reason (enum) - основание увольнения
- severance_months (int) - количество окладов
- severance_date (date) - дата выплаты
- comment (text) - комментарий
- initiator_name (varchar) - кто внёс
- initiator_contact (varchar) - контакт инициатора
- dzo_id (FK → dzos)
- created_by (FK → users)
- created_at (timestamp)
```

#### 4.2 Enum: DismissalReason
```java
enum DismissalReason {
    WITH_SEVERANCE,      // Уход с выплатами
    DIFFICULT_EMPLOYEE,  // Сложный сотрудник
    PERFORMANCE_ISSUES,  // Проблемы с производительностью
    POLICY_VIOLATION,    // Нарушение политик
    OTHER                // Другое
}
```

#### 4.3 API endpoints
```
GET    /api/blacklist          - список (с фильтрацией)
POST   /api/blacklist          - добавить
PUT    /api/blacklist/{id}     - редактировать
DELETE /api/blacklist/{id}     - удалить
GET    /api/blacklist/check?email=... - проверка (для интеграции с ATS)
```

#### 4.4 Frontend: BlacklistView.vue
- Таблица с поиском и фильтрацией
- Модальное окно создания/редактирования
- Доступ: Админ системы, Админ ДЗО, БОРУП (полный), Рекрутер (только просмотр)

**Трудозатраты:** ~25-35 часов

---

### 5. ВАЖНО: Email-уведомления

**Требуется:**

#### 5.1 Интеграция с SMTP
```yaml
# application.yml
spring:
  mail:
    host: smtp.company.ru
    port: 587
    username: ${MAIL_USERNAME}
    password: ${MAIL_PASSWORD}
```

#### 5.2 NotificationService
```java
NotificationService {
    sendStatusChangeNotification(Application, User manager)
    sendApprovalRequestNotification(Application, User approver)
    sendApprovalResultNotification(Application, User requester)
}
```

#### 5.3 Шаблоны писем (Thymeleaf)
- `application-status-change.html` - изменение статуса
- `approval-request.html` - запрос на согласование
- `approval-result.html` - результат согласования

#### 5.4 Настройки уведомлений
```sql
ALTER TABLE users ADD COLUMN email_notifications_enabled BOOLEAN DEFAULT true;
```

**Трудозатраты:** ~15-20 часов

---

### 6. ВАЖНО: LDAP/AD интеграция

**Требуется:**

```java
@Configuration
public class LdapSecurityConfig {
    @Bean
    public LdapAuthenticationProvider ldapAuthProvider() {
        // AD/LDAP конфигурация
    }
}
```

**Конфигурация:**
```yaml
ldap:
  enabled: ${LDAP_ENABLED:false}
  url: ldap://ad.company.ru:389
  base-dn: dc=company,dc=ru
  user-search-filter: (sAMAccountName={0})
```

**Fallback:** Если LDAP недоступен → локальная авторизация с 2FA

**Трудозатраты:** ~15-25 часов

---

### 7. ВАЖНО: 2FA (двухфакторная аутентификация)

**Требуется при отсутствии LDAP:**

#### 7.1 OTP Service
```java
OtpService {
    generateOtp(userId) → String (6 цифр)
    validateOtp(userId, otp) → boolean
    sendOtpEmail(userId)
}
```

#### 7.2 Таблица OTP
```sql
CREATE TABLE otp_codes (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    code VARCHAR(6),
    expires_at TIMESTAMP,
    used BOOLEAN DEFAULT false
);
```

#### 7.3 Flow авторизации
1. POST /api/auth/login {username, password} → {requiresOtp: true}
2. Email с OTP кодом
3. POST /api/auth/verify-otp {userId, otp} → {token}

**Трудозатраты:** ~10-15 часов

---

### 8. СРЕДНЕ: Справочник стеков с workflow

**Текущее:** Dictionary — простой справочник
**Требуется:** Справочник стеков с запросами на изменение от ДЗО

#### 8.1 Entity: Stack
```
Поля:
- id (PK)
- name (varchar)
- description (text)
- is_active (boolean)
- created_by (FK → users)
- dzo_id (FK → dzos) - NULL = общий для всех
```

#### 8.2 Entity: StackChangeRequest
```
Поля:
- id (PK)
- stack_id (FK → stacks, nullable для создания)
- requested_by (FK → users) - админ ДЗО
- dzo_id (FK → dzos)
- change_type (enum: CREATE/UPDATE/ARCHIVE)
- new_name (varchar)
- new_description (text)
- status (enum: PENDING/APPROVED/REJECTED)
- reviewed_by (FK → users) - админ системы
- review_comment (text)
- created_at, reviewed_at (timestamps)
```

**Трудозатраты:** ~15-20 часов

---

### 9. СРЕДНЕ: Аналитика по заявкам

**Требуется:**

#### 9.1 Метрики
- Количество заявок по статусам
- Количество заявок по стекам
- Среднее время согласования
- % одобренных/отклонённых
- Топ рекрутеров по количеству закрытых заявок

#### 9.2 API
```
GET /api/analytics/applications/by-status
GET /api/analytics/applications/by-stack
GET /api/analytics/applications/approval-time
GET /api/analytics/applications/approval-rate
```

#### 9.3 Frontend: AnalyticsView.vue
- Графики (Chart.js / ECharts)
- Фильтры по периоду и ДЗО

**Трудозатраты:** ~20-25 часов

---

### 10. НИЗКО: Интеграция с 1С ЗУП

**Требуется:** API для получения данных о сотрудниках

**Варианты:**
1. REST API интеграция с 1С
2. Импорт через Excel (fallback) — уже можно реализовать

**Трудозатраты:** ~30-50 часов (зависит от API 1С)

---

### 11. НИЗКО: Интеграция с ATS (IQHR)

**Требуется:** Передача метки "в чёрном списке" в ATS

**API endpoint:**
```
GET /api/blacklist/check?email=candidate@email.com
Response: { inBlacklist: true/false, reason: "..." }
```

**Трудозатраты:** ~10-15 часов (зависит от API IQHR)

---

## Приоритезированный план доработок

### Фаза 1: MVP заявок (КРИТИЧНО) — 2-3 недели
| # | Задача | Трудозатраты | Приоритет |
|---|--------|--------------|-----------|
| 1.1 | Создать entity DZO + миграция | 4ч | P0 |
| 1.2 | Добавить dzo_id во все таблицы | 8ч | P0 |
| 1.3 | Создать расширенную ролевую модель | 20ч | P0 |
| 1.4 | Создать entity Application + миграции | 16ч | P0 |
| 1.5 | ApplicationService + Workflow | 24ч | P0 |
| 1.6 | ApplicationController + API | 12ч | P0 |
| 1.7 | Frontend: ApplicationsView | 24ч | P0 |
| 1.8 | Frontend: ApplicationDetailView | 16ч | P0 |
| **Итого Фаза 1** | **~124ч (~3 недели)** | |

### Фаза 2: Чёрный список + Уведомления — 1-2 недели
| # | Задача | Трудозатраты | Приоритет |
|---|--------|--------------|-----------|
| 2.1 | Entity BlacklistEntry + миграция | 8ч | P1 |
| 2.2 | BlacklistService + Controller | 12ч | P1 |
| 2.3 | Frontend: BlacklistView | 16ч | P1 |
| 2.4 | Интеграция с SMTP | 8ч | P1 |
| 2.5 | NotificationService + шаблоны | 12ч | P1 |
| 2.6 | Настройки уведомлений в UI | 4ч | P1 |
| **Итого Фаза 2** | **~60ч (~1.5 недели)** | |

### Фаза 3: Аутентификация + Аналитика — 1-2 недели
| # | Задача | Трудозатраты | Приоритет |
|---|--------|--------------|-----------|
| 3.1 | LDAP интеграция (опционально) | 20ч | P2 |
| 3.2 | 2FA с OTP | 12ч | P2 |
| 3.3 | Справочник стеков с workflow | 16ч | P2 |
| 3.4 | Аналитика по заявкам | 20ч | P2 |
| **Итого Фаза 3** | **~68ч (~1.5 недели)** | |

### Фаза 4: Интеграции — по запросу
| # | Задача | Трудозатраты | Приоритет |
|---|--------|--------------|-----------|
| 4.1 | Интеграция с 1С ЗУП | 40ч | P3 |
| 4.2 | Интеграция с ATS (IQHR) | 12ч | P3 |
| **Итого Фаза 4** | **~52ч** | |

---

## Общая оценка трудозатрат

| Фаза | Задачи | Трудозатраты | Срок |
|------|--------|--------------|------|
| Фаза 1 | MVP заявок | ~124ч | 3 недели |
| Фаза 2 | Чёрный список + Email | ~60ч | 1.5 недели |
| Фаза 3 | Auth + Аналитика | ~68ч | 1.5 недели |
| Фаза 4 | Интеграции | ~52ч | по запросу |
| **ИТОГО** | | **~304ч** | **~6-8 недель** |

---

## Что НЕ требуется по ТЗ, но уже реализовано

Эти модули **можно оставить** как дополнительный функционал:

1. **9-Box Grid оценка** — полезно для Talent Management, но не в ТЗ
2. **Резюме с PDF генерацией** — полезно для рекрутеров
3. **Пресеты колонок/фильтры** — UX улучшение
4. **Блокировки записей** — техническая фича

---

## Рекомендации

1. **Начать с Фазы 1** — без модуля заявок система не соответствует ТЗ
2. **Параллельно с Фазой 1** проработать архитектуру мультитенантности (ДЗО)
3. **Согласовать с заказчиком** приоритеты интеграций (1С, IQHR, LDAP)
4. **Сохранить 9-Box и Резюме** как дополнительный функционал
5. **Тестирование:** добавить автотесты для workflow заявок (критичный функционал)

---

**Дата анализа:** 2026-01-21
**Автор:** Claude
