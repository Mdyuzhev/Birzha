# Фаза 1: Мультитенантность (ДЗО)

## Цель

Добавить поддержку нескольких организаций (ДЗО — дочерних зависимых обществ) в систему Birzha. Все данные должны быть изолированы по ДЗО. Пользователи видят только данные своего ДЗО (кроме администратора системы).

**Расположение проекта:** `E:\Birzha`

---

## Контекст

**ДЗО из ТЗ (пилот):**
- ЦОД (@rt-dc.ru)
- Солар (@rt-solar.ru)
- БФТ (@bft.ru)
- Т2 (@t2.ru)
- Базис (@basistech.ru)
- РТЛабс (@rtlabs.ru)
- ОМП (@omp.ru)
- ПАО РТК
- РТК
- РТК ИТ+

**Текущее состояние:** Система не поддерживает разделение по организациям. Все данные общие.

---

## Задачи

### 1. Создать entity DZO

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/Dzo.java`

```java
@Entity
@Table(name = "dzos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Dzo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String code;  // Уникальный код: "rt-dc", "rt-solar", "bft"

    @Column(nullable = false, length = 255)
    private String name;  // Полное название: "ЦОД", "Солар"

    @Column(length = 100)
    private String emailDomain;  // Email домен: "rt-dc.ru", "rt-solar.ru"

    @Column(nullable = false)
    private Boolean isActive = true;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
```

### 2. Создать Flyway миграцию для таблицы dzos

**Файл:** `backend/src/main/resources/db/migration/V15__create_dzos_table.sql`

```sql
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
```

### 3. Создать миграцию для добавления dzo_id в существующие таблицы

**Файл:** `backend/src/main/resources/db/migration/V16__add_dzo_id_to_tables.sql`

```sql
-- Добавить dzo_id в таблицу users
ALTER TABLE users ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);
CREATE INDEX idx_users_dzo ON users(dzo_id);

-- Добавить dzo_id в таблицу employees
ALTER TABLE employees ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);
CREATE INDEX idx_employees_dzo ON employees(dzo_id);

-- Добавить dzo_id в таблицу column_presets
ALTER TABLE column_presets ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);

-- Добавить dzo_id в таблицу saved_filters
ALTER TABLE saved_filters ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);

-- Добавить dzo_id в таблицу nine_box_assessments
ALTER TABLE nine_box_assessments ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);

-- Добавить dzo_id в таблицу employee_resumes
ALTER TABLE employee_resumes ADD COLUMN dzo_id BIGINT REFERENCES dzos(id);

-- Привязать существующие данные к первому ДЗО (для миграции)
UPDATE users SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE employees SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE column_presets SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE saved_filters SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE nine_box_assessments SET dzo_id = 1 WHERE dzo_id IS NULL;
UPDATE employee_resumes SET dzo_id = 1 WHERE dzo_id IS NULL;
```

### 4. Создать DzoRepository

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/DzoRepository.java`

```java
public interface DzoRepository extends JpaRepository<Dzo, Long> {
    Optional<Dzo> findByCode(String code);
    List<Dzo> findByIsActiveTrue();
    Optional<Dzo> findByEmailDomain(String emailDomain);
}
```

### 5. Обновить entity User — добавить связь с ДЗО

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/User.java`

Добавить поле:
```java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "dzo_id")
private Dzo dzo;
```

### 6. Обновить entity Employee — добавить связь с ДЗО

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/Employee.java`

Добавить поле:
```java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "dzo_id")
private Dzo dzo;
```

### 7. Обновить остальные entity — добавить dzo_id

Добавить аналогичное поле в:
- `ColumnPreset.java`
- `SavedFilter.java`
- `NineBoxAssessment.java`
- `EmployeeResume.java`

### 8. Создать DzoService

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/DzoService.java`

```java
@Service
@RequiredArgsConstructor
public class DzoService {
    private final DzoRepository dzoRepository;

    public List<Dzo> getAllActive() {
        return dzoRepository.findByIsActiveTrue();
    }

    public Dzo getById(Long id) {
        return dzoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("DZO not found: " + id));
    }

    public Dzo getByCode(String code) {
        return dzoRepository.findByCode(code)
            .orElseThrow(() -> new ResourceNotFoundException("DZO not found: " + code));
    }

    public Dzo create(CreateDzoRequest request) {
        Dzo dzo = Dzo.builder()
            .code(request.getCode())
            .name(request.getName())
            .emailDomain(request.getEmailDomain())
            .isActive(true)
            .build();
        return dzoRepository.save(dzo);
    }

    public Dzo update(Long id, UpdateDzoRequest request) {
        Dzo dzo = getById(id);
        dzo.setName(request.getName());
        dzo.setEmailDomain(request.getEmailDomain());
        dzo.setIsActive(request.getIsActive());
        return dzoRepository.save(dzo);
    }
}
```

### 9. Создать DzoController

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/DzoController.java`

```java
@RestController
@RequestMapping("/api/dzos")
@RequiredArgsConstructor
public class DzoController {
    private final DzoService dzoService;

    @GetMapping
    public ResponseEntity<List<DzoDto>> getAll() {
        return ResponseEntity.ok(
            dzoService.getAllActive().stream()
                .map(this::toDto)
                .toList()
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<DzoDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(toDto(dzoService.getById(id)));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DzoDto> create(@Valid @RequestBody CreateDzoRequest request) {
        return ResponseEntity.ok(toDto(dzoService.create(request)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DzoDto> update(@PathVariable Long id, @Valid @RequestBody UpdateDzoRequest request) {
        return ResponseEntity.ok(toDto(dzoService.update(id, request)));
    }

    private DzoDto toDto(Dzo dzo) {
        return DzoDto.builder()
            .id(dzo.getId())
            .code(dzo.getCode())
            .name(dzo.getName())
            .emailDomain(dzo.getEmailDomain())
            .isActive(dzo.getIsActive())
            .build();
    }
}
```

### 10. Создать DTO для DZO

**Файлы в** `backend/src/main/java/com/company/resourcemanager/dto/`:

- `DzoDto.java`
- `CreateDzoRequest.java`
- `UpdateDzoRequest.java`

### 11. Обновить EmployeeRepository — фильтрация по ДЗО

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/EmployeeRepository.java`

Добавить методы:
```java
Page<Employee> findByDzoId(Long dzoId, Pageable pageable);
List<Employee> findByDzoId(Long dzoId);
long countByDzoId(Long dzoId);
```

### 12. Обновить EmployeeService — учёт ДЗО

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/EmployeeService.java`

- При создании сотрудника устанавливать `dzo_id` из текущего пользователя
- При выборке фильтровать по `dzo_id` текущего пользователя
- Администратор системы (будущая роль) видит все ДЗО

### 13. Создать утилиту для получения текущего ДЗО

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/CurrentUserService.java`

```java
@Service
@RequiredArgsConstructor
public class CurrentUserService {
    private final UserRepository userRepository;

    public User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        return userRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }

    public Long getCurrentDzoId() {
        User user = getCurrentUser();
        return user.getDzo() != null ? user.getDzo().getId() : null;
    }

    public boolean isSystemAdmin() {
        // Пока используем ADMIN как системного админа
        // В Фазе 2 будет отдельная роль SYSTEM_ADMIN
        return getCurrentUser().getRole().equals("ADMIN");
    }
}
```

### 14. Frontend: Создать API модуль для ДЗО

**Файл:** `frontend/src/api/dzos.js`

```javascript
import client from './client'

export const dzosApi = {
  getAll() {
    return client.get('/dzos')
  },
  getById(id) {
    return client.get(`/dzos/${id}`)
  },
  create(data) {
    return client.post('/dzos', data)
  },
  update(id, data) {
    return client.put(`/dzos/${id}`, data)
  }
}
```

### 15. Frontend: Создать Pinia store для ДЗО

**Файл:** `frontend/src/stores/dzo.js`

```javascript
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { dzosApi } from '@/api/dzos'

export const useDzoStore = defineStore('dzo', () => {
  const dzos = ref([])
  const currentDzo = ref(null)
  const loading = ref(false)

  async function fetchDzos() {
    loading.value = true
    try {
      const response = await dzosApi.getAll()
      dzos.value = response.data
    } finally {
      loading.value = false
    }
  }

  function setCurrentDzo(dzo) {
    currentDzo.value = dzo
  }

  return { dzos, currentDzo, loading, fetchDzos, setCurrentDzo }
})
```

### 16. Frontend: Добавить выбор ДЗО в AdminView

**Файл:** `frontend/src/views/AdminView.vue`

Добавить вкладку "ДЗО" с таблицей и CRUD операциями (только для ADMIN).

### 17. Frontend: Отображать текущее ДЗО в шапке

В `App.vue` или навигационном компоненте показывать название текущего ДЗО пользователя.

---

## Критерии приёмки

### Backend

- [ ] **Миграции применяются без ошибок**
  - `V15__create_dzos_table.sql` создаёт таблицу `dzos` с 10 записями
  - `V16__add_dzo_id_to_tables.sql` добавляет `dzo_id` во все нужные таблицы

- [ ] **API ДЗО работает**
  - `GET /api/dzos` возвращает список активных ДЗО
  - `GET /api/dzos/{id}` возвращает конкретное ДЗО
  - `POST /api/dzos` создаёт новое ДЗО (только ADMIN)
  - `PUT /api/dzos/{id}` обновляет ДЗО (только ADMIN)

- [ ] **Сотрудники привязаны к ДЗО**
  - При создании сотрудника автоматически проставляется `dzo_id` текущего пользователя
  - `GET /api/employees` возвращает только сотрудников текущего ДЗО
  - ADMIN видит сотрудников всех ДЗО

- [ ] **Пользователи привязаны к ДЗО**
  - У каждого пользователя есть `dzo_id`
  - При создании пользователя указывается ДЗО

### Frontend

- [ ] **Вкладка "ДЗО" в AdminView**
  - Отображается таблица с колонками: Код, Название, Email домен, Активно
  - Работает создание/редактирование ДЗО

- [ ] **Текущее ДЗО отображается в интерфейсе**
  - В шапке или sidebar видно название ДЗО текущего пользователя

- [ ] **Pinia store работает**
  - `useDzoStore` загружает и хранит список ДЗО

### Тестирование (curl)

```bash
# Получить список ДЗО
curl -X GET http://localhost:31081/api/dzos \
  -H "Authorization: Bearer $TOKEN"

# Ожидаемый ответ: массив из 10 ДЗО

# Создать сотрудника (должен привязаться к ДЗО пользователя)
curl -X POST http://localhost:31081/api/employees \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"fullName": "Тест Тестов", "email": "test@test.ru", "customFields": {}}'

# Проверить что у созданного сотрудника есть dzo_id
curl -X GET http://localhost:31081/api/employees/{id} \
  -H "Authorization: Bearer $TOKEN"
```

---

## Файлы для создания/изменения

### Создать новые файлы:
```
backend/src/main/java/com/company/resourcemanager/entity/Dzo.java
backend/src/main/java/com/company/resourcemanager/repository/DzoRepository.java
backend/src/main/java/com/company/resourcemanager/service/DzoService.java
backend/src/main/java/com/company/resourcemanager/service/CurrentUserService.java
backend/src/main/java/com/company/resourcemanager/controller/DzoController.java
backend/src/main/java/com/company/resourcemanager/dto/DzoDto.java
backend/src/main/java/com/company/resourcemanager/dto/CreateDzoRequest.java
backend/src/main/java/com/company/resourcemanager/dto/UpdateDzoRequest.java
backend/src/main/resources/db/migration/V15__create_dzos_table.sql
backend/src/main/resources/db/migration/V16__add_dzo_id_to_tables.sql
frontend/src/api/dzos.js
frontend/src/stores/dzo.js
```

### Изменить существующие файлы:
```
backend/src/main/java/com/company/resourcemanager/entity/User.java
backend/src/main/java/com/company/resourcemanager/entity/Employee.java
backend/src/main/java/com/company/resourcemanager/entity/ColumnPreset.java
backend/src/main/java/com/company/resourcemanager/entity/SavedFilter.java
backend/src/main/java/com/company/resourcemanager/entity/NineBoxAssessment.java
backend/src/main/java/com/company/resourcemanager/entity/EmployeeResume.java
backend/src/main/java/com/company/resourcemanager/repository/EmployeeRepository.java
backend/src/main/java/com/company/resourcemanager/service/EmployeeService.java
frontend/src/views/AdminView.vue
frontend/src/App.vue (или навигационный компонент)
```

---

## Команда для запуска

```bash
# Пересобрать и запустить
cd E:\Birzha
docker-compose down
docker-compose up --build -d

# Проверить миграции
docker logs resource-manager-backend 2>&1 | grep -i flyway

# Проверить API
curl http://localhost:31081/api/dzos
```

---

## После завершения

1. Обновить статус Фазы 1 в `E:\Birzha\.claude\DEVELOPMENT_PLAN.md` на ✅ Завершено
2. Записать найденные проблемы/решения
3. Перейти к Фазе 2 (Расширенная ролевая модель)
