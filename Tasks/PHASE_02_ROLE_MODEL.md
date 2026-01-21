# Фаза 2: Расширенная ролевая модель

## Цель

Заменить текущую простую ролевую модель (ADMIN/USER) на 6 специализированных ролей согласно ТЗ "Биржа талантов 3.0". Каждая роль имеет свой набор прав и область видимости данных.

**Расположение проекта:** `E:\Birzha`

**Зависимости:** Фаза 1 (Мультитенантность) должна быть завершена.

---

## Роли согласно ТЗ

| Роль | Код | Описание | Область видимости |
|------|-----|----------|-------------------|
| Администратор системы | `SYSTEM_ADMIN` | Полный доступ ко всем ДЗО | Все ДЗО |
| Администратор ДЗО | `DZO_ADMIN` | Управление в рамках своего ДЗО | Своё ДЗО |
| Рекрутер | `RECRUITER` | Обработка заявок, работа с кандидатами | Своё ДЗО |
| HR BP | `HR_BP` | Согласование заявок, создание заявок | Закреплённые подразделения |
| БОРУП | `BORUP` | Согласование при превышении ЗП >30% | Своё ДЗО |
| Руководитель | `MANAGER` | Подача заявок на своих подчинённых | Свои подчинённые |

---

## Задачи

### 1. Создать enum Role

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/Role.java`

```java
public enum Role {
    SYSTEM_ADMIN("Администратор системы"),
    DZO_ADMIN("Администратор ДЗО"),
    RECRUITER("Рекрутер"),
    HR_BP("HR BP"),
    BORUP("БОРУП"),
    MANAGER("Руководитель");

    private final String displayName;

    Role(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
```

### 2. Создать Flyway миграцию для обновления ролей

**Файл:** `backend/src/main/resources/db/migration/V17__update_user_roles.sql`

```sql
-- Создать таблицу для хранения ролей пользователя (многие-ко-многим)
CREATE TABLE user_roles (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, role)
);

CREATE INDEX idx_user_roles_user ON user_roles(user_id);
CREATE INDEX idx_user_roles_role ON user_roles(role);

-- Мигрировать существующие роли
-- ADMIN → SYSTEM_ADMIN (для существующих админов)
INSERT INTO user_roles (user_id, role)
SELECT id, 'SYSTEM_ADMIN' FROM users WHERE role = 'ADMIN';

-- USER → MANAGER (для существующих пользователей)
INSERT INTO user_roles (user_id, role)
SELECT id, 'MANAGER' FROM users WHERE role = 'USER';

-- Удалить старую колонку role (опционально, можно оставить для обратной совместимости)
-- ALTER TABLE users DROP COLUMN role;
```

### 3. Создать entity UserRole

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/UserRole.java`

```java
@Entity
@Table(name = "user_roles", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "role"})
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserRole {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private Role role;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
```

### 4. Обновить entity User

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/User.java`

Добавить связь с ролями:

```java
@OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
private Set<UserRole> roles = new HashSet<>();

// Вспомогательные методы
public Set<Role> getRoleSet() {
    return roles.stream()
        .map(UserRole::getRole)
        .collect(Collectors.toSet());
}

public boolean hasRole(Role role) {
    return roles.stream().anyMatch(ur -> ur.getRole() == role);
}

public boolean isSystemAdmin() {
    return hasRole(Role.SYSTEM_ADMIN);
}

public boolean isDzoAdmin() {
    return hasRole(Role.DZO_ADMIN);
}

public boolean isRecruiter() {
    return hasRole(Role.RECRUITER);
}

public boolean isHrBp() {
    return hasRole(Role.HR_BP);
}

public boolean isBorup() {
    return hasRole(Role.BORUP);
}

public boolean isManager() {
    return hasRole(Role.MANAGER);
}

public void addRole(Role role) {
    UserRole userRole = UserRole.builder()
        .user(this)
        .role(role)
        .build();
    roles.add(userRole);
}

public void removeRole(Role role) {
    roles.removeIf(ur -> ur.getRole() == role);
}
```

### 5. Создать UserRoleRepository

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/UserRoleRepository.java`

```java
public interface UserRoleRepository extends JpaRepository<UserRole, Long> {
    List<UserRole> findByUserId(Long userId);
    List<UserRole> findByRole(Role role);
    void deleteByUserIdAndRole(Long userId, Role role);
    boolean existsByUserIdAndRole(Long userId, Role role);
}
```

### 6. Создать таблицу закрепления HR BP за подразделениями

**Файл:** `backend/src/main/resources/db/migration/V18__create_hr_bp_assignments.sql`

```sql
-- Таблица закрепления HR BP за подразделениями/ДЗО
CREATE TABLE hr_bp_assignments (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    dzo_id BIGINT NOT NULL REFERENCES dzos(id) ON DELETE CASCADE,
    department VARCHAR(255),  -- NULL означает весь ДЗО
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT REFERENCES users(id),
    UNIQUE(user_id, dzo_id, department)
);

CREATE INDEX idx_hr_bp_assignments_user ON hr_bp_assignments(user_id);
CREATE INDEX idx_hr_bp_assignments_dzo ON hr_bp_assignments(dzo_id);
CREATE INDEX idx_hr_bp_assignments_department ON hr_bp_assignments(department);
```

### 7. Создать entity HrBpAssignment

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/HrBpAssignment.java`

```java
@Entity
@Table(name = "hr_bp_assignments", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "dzo_id", "department"})
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HrBpAssignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;  // HR BP

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dzo_id", nullable = false)
    private Dzo dzo;

    @Column(length = 255)
    private String department;  // NULL = весь ДЗО

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
```

### 8. Создать HrBpAssignmentRepository

**Файл:** `backend/src/main/java/com/company/resourcemanager/repository/HrBpAssignmentRepository.java`

```java
public interface HrBpAssignmentRepository extends JpaRepository<HrBpAssignment, Long> {
    List<HrBpAssignment> findByUserId(Long userId);
    List<HrBpAssignment> findByDzoId(Long dzoId);
    List<HrBpAssignment> findByDzoIdAndDepartment(Long dzoId, String department);
    Optional<HrBpAssignment> findByDzoIdAndDepartmentIsNull(Long dzoId);
    void deleteByUserId(Long userId);
}
```

### 9. Обновить UserService — управление ролями

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/UserService.java`

Добавить методы:

```java
@Transactional
public void assignRole(Long userId, Role role) {
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    
    if (!user.hasRole(role)) {
        user.addRole(role);
        userRepository.save(user);
    }
}

@Transactional
public void removeRole(Long userId, Role role) {
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    
    user.removeRole(role);
    userRepository.save(user);
}

public List<User> findByRole(Role role) {
    return userRoleRepository.findByRole(role).stream()
        .map(UserRole::getUser)
        .distinct()
        .toList();
}

public List<User> findHrBpByDzo(Long dzoId) {
    return hrBpAssignmentRepository.findByDzoId(dzoId).stream()
        .map(HrBpAssignment::getUser)
        .distinct()
        .toList();
}
```

### 10. Создать RoleService

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/RoleService.java`

```java
@Service
@RequiredArgsConstructor
public class RoleService {
    private final UserRepository userRepository;
    private final UserRoleRepository userRoleRepository;
    private final HrBpAssignmentRepository hrBpAssignmentRepository;
    private final CurrentUserService currentUserService;

    public List<RoleDto> getAllRoles() {
        return Arrays.stream(Role.values())
            .map(r -> new RoleDto(r.name(), r.getDisplayName()))
            .toList();
    }

    public boolean canAccessDzo(User user, Long dzoId) {
        // Системный админ видит всё
        if (user.isSystemAdmin()) {
            return true;
        }
        // Остальные — только своё ДЗО
        return user.getDzo() != null && user.getDzo().getId().equals(dzoId);
    }

    public boolean canManageUsers(User user) {
        return user.isSystemAdmin() || user.isDzoAdmin();
    }

    public boolean canManageColumns(User user) {
        return user.isSystemAdmin() || user.isDzoAdmin();
    }

    public boolean canManageDictionaries(User user) {
        return user.isSystemAdmin() || user.isDzoAdmin();
    }

    public boolean canViewBlacklist(User user) {
        return user.isSystemAdmin() || user.isDzoAdmin() || 
               user.isRecruiter() || user.isBorup();
    }

    public boolean canEditBlacklist(User user) {
        return user.isSystemAdmin() || user.isDzoAdmin() || user.isBorup();
    }

    public boolean canApproveAsHrBp(User user, Long dzoId, String department) {
        if (!user.isHrBp()) {
            return false;
        }
        // Проверить закрепление
        List<HrBpAssignment> assignments = hrBpAssignmentRepository.findByUserId(user.getId());
        return assignments.stream().anyMatch(a -> 
            a.getDzo().getId().equals(dzoId) && 
            (a.getDepartment() == null || a.getDepartment().equals(department))
        );
    }

    public boolean canApproveAsBorup(User user) {
        return user.isBorup();
    }
}
```

### 11. Обновить CurrentUserService

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/CurrentUserService.java`

Добавить методы:

```java
public Set<Role> getCurrentUserRoles() {
    return getCurrentUser().getRoleSet();
}

public boolean hasRole(Role role) {
    return getCurrentUser().hasRole(role);
}

public boolean isSystemAdmin() {
    return hasRole(Role.SYSTEM_ADMIN);
}

public boolean isDzoAdmin() {
    return hasRole(Role.DZO_ADMIN);
}

public boolean canAccessAllDzos() {
    return isSystemAdmin();
}
```

### 12. Обновить SecurityConfig — поддержка множественных ролей

**Файл:** `backend/src/main/java/com/company/resourcemanager/config/SecurityConfig.java`

Обновить UserDetails для Spring Security:

```java
// В JwtAuthenticationFilter или отдельном UserDetailsService
@Override
public UserDetails loadUserByUsername(String username) {
    User user = userRepository.findByUsername(username)
        .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    
    List<GrantedAuthority> authorities = user.getRoleSet().stream()
        .map(role -> new SimpleGrantedAuthority("ROLE_" + role.name()))
        .collect(Collectors.toList());
    
    return new org.springframework.security.core.userdetails.User(
        user.getUsername(),
        user.getPasswordHash(),
        authorities
    );
}
```

### 13. Обновить JwtTokenProvider — включить роли в токен

**Файл:** `backend/src/main/java/com/company/resourcemanager/config/JwtTokenProvider.java`

```java
public String generateToken(User user) {
    Date now = new Date();
    Date expiryDate = new Date(now.getTime() + jwtExpiration);
    
    List<String> roles = user.getRoleSet().stream()
        .map(Role::name)
        .toList();

    return Jwts.builder()
        .setSubject(user.getUsername())
        .claim("roles", roles)
        .claim("dzoId", user.getDzo() != null ? user.getDzo().getId() : null)
        .setIssuedAt(now)
        .setExpiration(expiryDate)
        .signWith(getSigningKey())
        .compact();
}

public List<String> getRolesFromToken(String token) {
    Claims claims = getClaims(token);
    return claims.get("roles", List.class);
}
```

### 14. Обновить контроллеры — проверка ролей

Заменить `@PreAuthorize("hasRole('ADMIN')")` на соответствующие проверки:

**Примеры:**

```java
// Только системный админ
@PreAuthorize("hasRole('SYSTEM_ADMIN')")

// Системный админ или админ ДЗО
@PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN')")

// Все авторизованные
@PreAuthorize("isAuthenticated()")

// Рекрутер, HR BP или админы
@PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN', 'RECRUITER', 'HR_BP')")
```

**Обновить контроллеры:**

| Контроллер | Старое | Новое |
|------------|--------|-------|
| DzoController (create, update) | ADMIN | SYSTEM_ADMIN |
| ColumnController (create, update, delete) | ADMIN | SYSTEM_ADMIN, DZO_ADMIN |
| DictionaryController (create, update, delete) | ADMIN | SYSTEM_ADMIN, DZO_ADMIN |
| UserController | ADMIN | SYSTEM_ADMIN, DZO_ADMIN |
| EmployeeController | AUTH | AUTH (с фильтрацией по роли) |

### 15. Создать RoleController

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/RoleController.java`

```java
@RestController
@RequestMapping("/api/roles")
@RequiredArgsConstructor
public class RoleController {
    private final RoleService roleService;
    private final UserService userService;

    @GetMapping
    public ResponseEntity<List<RoleDto>> getAllRoles() {
        return ResponseEntity.ok(roleService.getAllRoles());
    }

    @PostMapping("/assign")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN')")
    public ResponseEntity<Void> assignRole(@RequestBody AssignRoleRequest request) {
        userService.assignRole(request.getUserId(), request.getRole());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/remove")
    @PreAuthorize("hasAnyRole('SYSTEM_ADMIN', 'DZO_ADMIN')")
    public ResponseEntity<Void> removeRole(@RequestBody AssignRoleRequest request) {
        userService.removeRole(request.getUserId(), request.getRole());
        return ResponseEntity.ok().build();
    }
}
```

### 16. Создать DTO для ролей

**Файлы в** `backend/src/main/java/com/company/resourcemanager/dto/`:

```java
// RoleDto.java
@Data
@AllArgsConstructor
public class RoleDto {
    private String code;
    private String displayName;
}

// AssignRoleRequest.java
@Data
public class AssignRoleRequest {
    @NotNull
    private Long userId;
    @NotNull
    private Role role;
}
```

### 17. Обновить UserDto — добавить роли

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/UserDto.java`

```java
@Data
@Builder
public class UserDto {
    private Long id;
    private String username;
    private List<String> roles;  // Список кодов ролей
    private Long dzoId;
    private String dzoName;
    private LocalDateTime createdAt;
}
```

### 18. Обновить LoginResponse — добавить роли

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/LoginResponse.java`

```java
@Data
@Builder
public class LoginResponse {
    private String token;
    private String username;
    private List<String> roles;  // Вместо одной роли — список
    private Long dzoId;
    private String dzoName;
}
```

### 19. Frontend: Обновить authStore

**Файл:** `frontend/src/stores/auth.js`

```javascript
// Обновить state
const roles = ref([])  // Массив ролей вместо одной

// Computed
const isSystemAdmin = computed(() => roles.value.includes('SYSTEM_ADMIN'))
const isDzoAdmin = computed(() => roles.value.includes('DZO_ADMIN'))
const isRecruiter = computed(() => roles.value.includes('RECRUITER'))
const isHrBp = computed(() => roles.value.includes('HR_BP'))
const isBorup = computed(() => roles.value.includes('BORUP'))
const isManager = computed(() => roles.value.includes('MANAGER'))

const canManageUsers = computed(() => isSystemAdmin.value || isDzoAdmin.value)
const canManageSettings = computed(() => isSystemAdmin.value || isDzoAdmin.value)
const canViewBlacklist = computed(() => 
    isSystemAdmin.value || isDzoAdmin.value || isRecruiter.value || isBorup.value
)

// Обновить login action
async function login(username, password) {
    const response = await authApi.login(username, password)
    token.value = response.data.token
    user.value = { username: response.data.username }
    roles.value = response.data.roles  // Массив ролей
    dzoId.value = response.data.dzoId
    localStorage.setItem('token', token.value)
}
```

### 20. Frontend: Создать API для ролей

**Файл:** `frontend/src/api/roles.js`

```javascript
import client from './client'

export const rolesApi = {
    getAll() {
        return client.get('/roles')
    },
    assign(userId, role) {
        return client.post('/roles/assign', { userId, role })
    },
    remove(userId, role) {
        return client.post('/roles/remove', { userId, role })
    }
}
```

### 21. Frontend: Обновить AdminView — управление ролями

**Файл:** `frontend/src/views/AdminView.vue`

В вкладке "Пользователи":
- Отображать роли пользователя как теги (el-tag)
- Добавить кнопку "Управление ролями" → диалог с чекбоксами ролей
- Показывать только роли, которые может назначать текущий пользователь

### 22. Frontend: Обновить router guards

**Файл:** `frontend/src/router/index.js`

```javascript
// Обновить meta для маршрутов
{
    path: '/admin',
    name: 'Admin',
    component: AdminView,
    meta: { 
        requiresAuth: true, 
        requiresRoles: ['SYSTEM_ADMIN', 'DZO_ADMIN']  // Любая из ролей
    }
}

// Обновить guard
router.beforeEach(async (to, from, next) => {
    const authStore = useAuthStore()
    
    // ... существующие проверки ...
    
    // Проверка ролей
    if (to.meta.requiresRoles) {
        const hasRequiredRole = to.meta.requiresRoles.some(role => 
            authStore.roles.includes(role)
        )
        if (!hasRequiredRole) {
            return next('/')
        }
    }
    
    next()
})
```

### 23. Frontend: Условное отображение элементов по ролям

В компонентах использовать:

```vue
<template>
    <!-- Только для админов -->
    <el-button v-if="authStore.canManageUsers">
        Управление пользователями
    </el-button>
    
    <!-- Только для рекрутеров и выше -->
    <el-menu-item v-if="authStore.canViewBlacklist" index="/blacklist">
        Чёрный список
    </el-menu-item>
</template>
```

---

## Критерии приёмки

### Backend

- [ ] **Миграции применяются без ошибок**
  - `V17__update_user_roles.sql` создаёт таблицу `user_roles` и мигрирует существующие роли
  - `V18__create_hr_bp_assignments.sql` создаёт таблицу закрепления HR BP

- [ ] **Enum Role содержит 6 ролей**
  - SYSTEM_ADMIN, DZO_ADMIN, RECRUITER, HR_BP, BORUP, MANAGER

- [ ] **Пользователь может иметь несколько ролей**
  - Entity User имеет Set<UserRole>
  - Методы hasRole(), addRole(), removeRole() работают

- [ ] **JWT токен содержит массив ролей**
  - Поле "roles" в payload токена — массив строк
  - Поле "dzoId" в payload токена

- [ ] **API ролей работает**
  - `GET /api/roles` возвращает список всех ролей
  - `POST /api/roles/assign` назначает роль (SYSTEM_ADMIN, DZO_ADMIN)
  - `POST /api/roles/remove` удаляет роль (SYSTEM_ADMIN, DZO_ADMIN)

- [ ] **Контроллеры защищены правильными ролями**
  - DzoController (CUD) — только SYSTEM_ADMIN
  - ColumnController, DictionaryController (CUD) — SYSTEM_ADMIN или DZO_ADMIN
  - UserController — SYSTEM_ADMIN или DZO_ADMIN (с фильтрацией по ДЗО)

- [ ] **RoleService корректно проверяет права**
  - canAccessDzo() работает для всех ролей
  - canManageUsers(), canManageColumns() и т.д.

### Frontend

- [ ] **authStore поддерживает множественные роли**
  - `roles` — массив
  - Computed: isSystemAdmin, isDzoAdmin, isRecruiter, isHrBp, isBorup, isManager
  - Computed: canManageUsers, canManageSettings, canViewBlacklist

- [ ] **Router guards проверяют роли**
  - meta.requiresRoles работает
  - Редирект при отсутствии нужной роли

- [ ] **AdminView — управление ролями пользователей**
  - Отображаются текущие роли пользователя
  - Можно назначить/удалить роль

- [ ] **Элементы UI скрыты по ролям**
  - Кнопки/меню отображаются в зависимости от ролей

### Тестирование (curl)

```bash
# Получить список ролей
curl -X GET http://localhost:31081/api/roles \
  -H "Authorization: Bearer $TOKEN"

# Ожидаемый ответ: 
# [{"code":"SYSTEM_ADMIN","displayName":"Администратор системы"}, ...]

# Назначить роль пользователю
curl -X POST http://localhost:31081/api/roles/assign \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"userId": 2, "role": "RECRUITER"}'

# Проверить что роль назначена
curl -X GET http://localhost:31081/api/users/2 \
  -H "Authorization: Bearer $ADMIN_TOKEN"

# Ожидаемый ответ содержит: "roles": ["MANAGER", "RECRUITER"]

# Войти под пользователем с новой ролью
curl -X POST http://localhost:31081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "user1", "password": "user"}'

# Ожидаемый ответ содержит: "roles": ["MANAGER", "RECRUITER"]
```

---

## Файлы для создания/изменения

### Создать новые файлы:
```
backend/src/main/java/com/company/resourcemanager/entity/Role.java
backend/src/main/java/com/company/resourcemanager/entity/UserRole.java
backend/src/main/java/com/company/resourcemanager/entity/HrBpAssignment.java
backend/src/main/java/com/company/resourcemanager/repository/UserRoleRepository.java
backend/src/main/java/com/company/resourcemanager/repository/HrBpAssignmentRepository.java
backend/src/main/java/com/company/resourcemanager/service/RoleService.java
backend/src/main/java/com/company/resourcemanager/controller/RoleController.java
backend/src/main/java/com/company/resourcemanager/dto/RoleDto.java
backend/src/main/java/com/company/resourcemanager/dto/AssignRoleRequest.java
backend/src/main/resources/db/migration/V17__update_user_roles.sql
backend/src/main/resources/db/migration/V18__create_hr_bp_assignments.sql
frontend/src/api/roles.js
```

### Изменить существующие файлы:
```
backend/src/main/java/com/company/resourcemanager/entity/User.java
backend/src/main/java/com/company/resourcemanager/service/UserService.java
backend/src/main/java/com/company/resourcemanager/service/CurrentUserService.java
backend/src/main/java/com/company/resourcemanager/config/SecurityConfig.java
backend/src/main/java/com/company/resourcemanager/config/JwtTokenProvider.java
backend/src/main/java/com/company/resourcemanager/config/JwtAuthenticationFilter.java
backend/src/main/java/com/company/resourcemanager/controller/DzoController.java
backend/src/main/java/com/company/resourcemanager/controller/ColumnController.java
backend/src/main/java/com/company/resourcemanager/controller/DictionaryController.java
backend/src/main/java/com/company/resourcemanager/controller/UserController.java
backend/src/main/java/com/company/resourcemanager/dto/UserDto.java
backend/src/main/java/com/company/resourcemanager/dto/LoginResponse.java
frontend/src/stores/auth.js
frontend/src/router/index.js
frontend/src/views/AdminView.vue
```

---

## Маппинг старых ролей на новые

| Старая роль | Новая роль | Примечание |
|-------------|------------|------------|
| ADMIN | SYSTEM_ADMIN | Полный доступ |
| USER | MANAGER | Базовый пользователь |

---

## После завершения

1. Обновить статус Фазы 2 в `E:\Birzha\.claude\DEVELOPMENT_PLAN.md` на ✅ Завершено
2. Обновить `E:\Birzha\.claude\Project_map.md` — секция "Безопасность" и "Ролевая модель"
3. Создать тестовых пользователей с разными ролями для проверки
4. Перейти к Фазе 3 (Заявки — Backend)
