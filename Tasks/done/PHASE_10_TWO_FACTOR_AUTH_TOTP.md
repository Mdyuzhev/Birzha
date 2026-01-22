# Фаза 10: Двухфакторная аутентификация (TOTP)

**Статус:** 📋 Специфицировано
**Приоритет:** P2
**Трудозатраты:** ~15-20 часов
**Тип:** TOTP (Time-based One-Time Password) — совместим с Google Authenticator, Authy, Яндекс.Ключ, Aladdin 2FA

---

## Цель

Реализовать двухфакторную аутентификацию для повышения безопасности. Пользователь после ввода логина/пароля должен ввести 6-значный код из мобильного приложения-аутентификатора.

---

## Пользовательский сценарий

### Настройка 2FA (первый раз)
1. Пользователь заходит в "Настройки" → "Безопасность"
2. Нажимает "Включить 2FA"
3. Система показывает QR-код
4. Пользователь сканирует QR в приложении (Google Authenticator и т.п.)
5. Вводит код из приложения для подтверждения
6. 2FA включена

### Вход с 2FA
1. Пользователь вводит логин/пароль
2. Если 2FA включена — показывается поле "Введите код из приложения"
3. Пользователь вводит 6-значный код
4. Система проверяет код
5. Если верный — выдаёт JWT токен

---

## Backend

### Зависимости

**Файл:** `backend/pom.xml`

Добавить зависимость:

```xml
<!-- TOTP для 2FA -->
<dependency>
    <groupId>com.warrenstrange</groupId>
    <artifactId>googleauth</artifactId>
    <version>1.5.0</version>
</dependency>

<!-- QR-код генерация -->
<dependency>
    <groupId>com.google.zxing</groupId>
    <artifactId>core</artifactId>
    <version>3.5.2</version>
</dependency>
<dependency>
    <groupId>com.google.zxing</groupId>
    <artifactId>javase</artifactId>
    <version>3.5.2</version>
</dependency>
```

---

### Миграция БД

**Файл:** `backend/src/main/resources/db/migration/V25__add_totp_fields.sql`

```sql
-- Добавить поля для TOTP 2FA
ALTER TABLE users ADD COLUMN IF NOT EXISTS totp_secret VARCHAR(64);
ALTER TABLE users ADD COLUMN IF NOT EXISTS totp_enabled BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE users ADD COLUMN IF NOT EXISTS totp_enabled_at TIMESTAMP;

-- Индекс для быстрого поиска
CREATE INDEX IF NOT EXISTS idx_users_totp_enabled ON users(totp_enabled) WHERE totp_enabled = true;

COMMENT ON COLUMN users.totp_secret IS 'Секретный ключ TOTP (Base32)';
COMMENT ON COLUMN users.totp_enabled IS 'Включена ли двухфакторная аутентификация';
COMMENT ON COLUMN users.totp_enabled_at IS 'Когда была включена 2FA';
```

---

### Изменение User Entity

**Файл:** `backend/src/main/java/com/company/resourcemanager/entity/User.java`

Добавить поля:

```java
// === 2FA TOTP ===

@Column(name = "totp_secret", length = 64)
private String totpSecret;

@Column(name = "totp_enabled", nullable = false)
@Builder.Default
private Boolean totpEnabled = false;

@Column(name = "totp_enabled_at")
private LocalDateTime totpEnabledAt;

// Геттеры для удобства
public boolean isTotpEnabled() {
    return Boolean.TRUE.equals(totpEnabled);
}
```

---

### TotpService

**Файл:** `backend/src/main/java/com/company/resourcemanager/service/TotpService.java`

```java
package com.company.resourcemanager.service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.warrenstrange.googleauth.GoogleAuthenticator;
import com.warrenstrange.googleauth.GoogleAuthenticatorKey;
import com.warrenstrange.googleauth.GoogleAuthenticatorQRGenerator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.util.Base64;

@Service
@RequiredArgsConstructor
@Slf4j
public class TotpService {

    private final GoogleAuthenticator googleAuthenticator = new GoogleAuthenticator();

    @Value("${app.totp.issuer:Birzha}")
    private String issuer;

    /**
     * Генерирует новый секретный ключ для TOTP
     */
    public String generateSecret() {
        GoogleAuthenticatorKey key = googleAuthenticator.createCredentials();
        return key.getKey();
    }

    /**
     * Проверяет введённый код
     */
    public boolean verifyCode(String secret, int code) {
        return googleAuthenticator.authorize(secret, code);
    }

    /**
     * Проверяет введённый код (строка)
     */
    public boolean verifyCode(String secret, String code) {
        try {
            int numericCode = Integer.parseInt(code.trim());
            return verifyCode(secret, numericCode);
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Генерирует URI для QR-кода (otpauth://...)
     */
    public String generateQrUri(String secret, String username) {
        return GoogleAuthenticatorQRGenerator.getOtpAuthTotpURL(
            issuer,
            username,
            new GoogleAuthenticatorKey.Builder(secret).build()
        );
    }

    /**
     * Генерирует QR-код как Base64 PNG изображение
     */
    public String generateQrCodeBase64(String secret, String username) {
        try {
            String qrUri = generateQrUri(secret, username);
            
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(qrUri, BarcodeFormat.QR_CODE, 256, 256);
            
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", outputStream);
            
            byte[] qrBytes = outputStream.toByteArray();
            return Base64.getEncoder().encodeToString(qrBytes);
        } catch (Exception e) {
            log.error("Failed to generate QR code", e);
            throw new RuntimeException("Failed to generate QR code", e);
        }
    }

    /**
     * Генерирует QR-код как Data URL (для img src)
     */
    public String generateQrCodeDataUrl(String secret, String username) {
        String base64 = generateQrCodeBase64(secret, username);
        return "data:image/png;base64," + base64;
    }
}
```

---

### DTO классы

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/TotpSetupResponse.java`

```java
package com.company.resourcemanager.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TotpSetupResponse {
    private String secret;
    private String qrCodeDataUrl;
    private String manualEntryKey;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/TotpVerifyRequest.java`

```java
package com.company.resourcemanager.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class TotpVerifyRequest {
    @NotBlank(message = "Код обязателен")
    @Pattern(regexp = "^\\d{6}$", message = "Код должен содержать 6 цифр")
    private String code;
}
```

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/LoginResponse.java`

Изменить существующий или создать:

```java
package com.company.resourcemanager.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    private String token;
    private boolean requiresTwoFactor;
    private String twoFactorToken;  // Временный токен для завершения 2FA
    private UserDto user;
}
```

---

### TwoFactorController

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/TwoFactorController.java`

```java
package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.TotpSetupResponse;
import com.company.resourcemanager.dto.TotpVerifyRequest;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.UserRepository;
import com.company.resourcemanager.service.CurrentUserService;
import com.company.resourcemanager.service.TotpService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/2fa")
@RequiredArgsConstructor
public class TwoFactorController {

    private final TotpService totpService;
    private final CurrentUserService currentUserService;
    private final UserRepository userRepository;

    /**
     * Получить статус 2FA для текущего пользователя
     */
    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getStatus() {
        User user = currentUserService.getCurrentUser();
        return ResponseEntity.ok(Map.of(
            "enabled", user.isTotpEnabled(),
            "enabledAt", user.getTotpEnabledAt() != null ? user.getTotpEnabledAt().toString() : null
        ));
    }

    /**
     * Начать настройку 2FA — получить секрет и QR-код
     */
    @PostMapping("/setup")
    public ResponseEntity<TotpSetupResponse> setupTotp() {
        User user = currentUserService.getCurrentUser();
        
        // Генерируем новый секрет
        String secret = totpService.generateSecret();
        
        // Сохраняем секрет (но пока не включаем 2FA)
        user.setTotpSecret(secret);
        userRepository.save(user);
        
        // Генерируем QR-код
        String qrCodeDataUrl = totpService.generateQrCodeDataUrl(secret, user.getUsername());
        
        // Форматируем секрет для ручного ввода (группы по 4 символа)
        String manualKey = secret.replaceAll("(.{4})", "$1 ").trim();
        
        return ResponseEntity.ok(TotpSetupResponse.builder()
            .secret(secret)
            .qrCodeDataUrl(qrCodeDataUrl)
            .manualEntryKey(manualKey)
            .build());
    }

    /**
     * Подтвердить настройку 2FA — проверить код и включить
     */
    @PostMapping("/enable")
    public ResponseEntity<Map<String, Object>> enableTotp(@Valid @RequestBody TotpVerifyRequest request) {
        User user = currentUserService.getCurrentUser();
        
        if (user.getTotpSecret() == null) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Сначала вызовите /setup для получения секрета"
            ));
        }
        
        // Проверяем код
        if (!totpService.verifyCode(user.getTotpSecret(), request.getCode())) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Неверный код. Проверьте настройку приложения и попробуйте снова."
            ));
        }
        
        // Включаем 2FA
        user.setTotpEnabled(true);
        user.setTotpEnabledAt(LocalDateTime.now());
        userRepository.save(user);
        
        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "Двухфакторная аутентификация успешно включена"
        ));
    }

    /**
     * Отключить 2FA (требует ввода текущего кода)
     */
    @PostMapping("/disable")
    public ResponseEntity<Map<String, Object>> disableTotp(@Valid @RequestBody TotpVerifyRequest request) {
        User user = currentUserService.getCurrentUser();
        
        if (!user.isTotpEnabled()) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "2FA не включена"
            ));
        }
        
        // Проверяем код для подтверждения
        if (!totpService.verifyCode(user.getTotpSecret(), request.getCode())) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Неверный код"
            ));
        }
        
        // Отключаем 2FA
        user.setTotpEnabled(false);
        user.setTotpSecret(null);
        user.setTotpEnabledAt(null);
        userRepository.save(user);
        
        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "Двухфакторная аутентификация отключена"
        ));
    }
}
```

---

### Изменение AuthController

**Файл:** `backend/src/main/java/com/company/resourcemanager/controller/AuthController.java`

Нужно изменить логику логина:

```java
package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.*;
import com.company.resourcemanager.entity.User;
import com.company.resourcemanager.repository.UserRepository;
import com.company.resourcemanager.security.JwtTokenProvider;
import com.company.resourcemanager.service.TotpService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider jwtTokenProvider;
    private final UserRepository userRepository;
    private final TotpService totpService;

    // Временное хранилище для токенов 2FA (в продакшене использовать Redis)
    private final Map<String, PendingTwoFactorAuth> pendingTwoFactorAuths = new ConcurrentHashMap<>();

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        try {
            // Шаг 1: Проверяем логин/пароль
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
            );

            User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

            // Шаг 2: Проверяем, нужна ли 2FA
            if (user.isTotpEnabled()) {
                // Генерируем временный токен
                String twoFactorToken = UUID.randomUUID().toString();
                
                // Сохраняем pending auth (истекает через 5 минут)
                pendingTwoFactorAuths.put(twoFactorToken, new PendingTwoFactorAuth(
                    user.getId(),
                    System.currentTimeMillis() + 5 * 60 * 1000
                ));
                
                // Очистка старых токенов
                cleanupExpiredTokens();
                
                return ResponseEntity.ok(LoginResponse.builder()
                    .requiresTwoFactor(true)
                    .twoFactorToken(twoFactorToken)
                    .build());
            }

            // Шаг 3: 2FA не нужна — выдаём JWT сразу
            String token = jwtTokenProvider.createToken(user);
            
            return ResponseEntity.ok(LoginResponse.builder()
                .token(token)
                .requiresTwoFactor(false)
                .user(toUserDto(user))
                .build());

        } catch (AuthenticationException e) {
            return ResponseEntity.status(401).body(Map.of(
                "message", "Неверный логин или пароль"
            ));
        }
    }

    @PostMapping("/verify-2fa")
    public ResponseEntity<?> verifyTwoFactor(@RequestBody Map<String, String> request) {
        String twoFactorToken = request.get("twoFactorToken");
        String code = request.get("code");
        
        if (twoFactorToken == null || code == null) {
            return ResponseEntity.badRequest().body(Map.of(
                "message", "Требуется twoFactorToken и code"
            ));
        }
        
        // Проверяем pending auth
        PendingTwoFactorAuth pending = pendingTwoFactorAuths.get(twoFactorToken);
        
        if (pending == null) {
            return ResponseEntity.status(401).body(Map.of(
                "message", "Сессия истекла. Войдите заново."
            ));
        }
        
        if (pending.expiresAt < System.currentTimeMillis()) {
            pendingTwoFactorAuths.remove(twoFactorToken);
            return ResponseEntity.status(401).body(Map.of(
                "message", "Сессия истекла. Войдите заново."
            ));
        }
        
        // Получаем пользователя
        User user = userRepository.findById(pending.userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Проверяем TOTP код
        if (!totpService.verifyCode(user.getTotpSecret(), code)) {
            return ResponseEntity.status(401).body(Map.of(
                "message", "Неверный код. Попробуйте снова."
            ));
        }
        
        // Удаляем pending auth
        pendingTwoFactorAuths.remove(twoFactorToken);
        
        // Выдаём JWT
        String token = jwtTokenProvider.createToken(user);
        
        return ResponseEntity.ok(LoginResponse.builder()
            .token(token)
            .requiresTwoFactor(false)
            .user(toUserDto(user))
            .build());
    }

    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser(Authentication authentication) {
        if (authentication == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Not authenticated"));
        }
        
        User user = userRepository.findByUsername(authentication.getName())
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        return ResponseEntity.ok(toUserDto(user));
    }

    private UserDto toUserDto(User user) {
        return UserDto.builder()
            .id(user.getId())
            .username(user.getUsername())
            .email(user.getEmail())
            .roles(user.getRolesList())
            .dzoId(user.getDzo() != null ? user.getDzo().getId() : null)
            .dzoName(user.getDzo() != null ? user.getDzo().getName() : null)
            .totpEnabled(user.isTotpEnabled())
            .build();
    }

    private void cleanupExpiredTokens() {
        long now = System.currentTimeMillis();
        pendingTwoFactorAuths.entrySet().removeIf(e -> e.getValue().expiresAt < now);
    }

    // Внутренний класс для pending auth
    private record PendingTwoFactorAuth(Long userId, long expiresAt) {}
}
```

---

### Обновить UserDto

**Файл:** `backend/src/main/java/com/company/resourcemanager/dto/UserDto.java`

Добавить поле:

```java
private boolean totpEnabled;
```

---

### Security Config

**Файл:** `backend/src/main/java/com/company/resourcemanager/config/SecurityConfig.java`

Добавить в permitAll:

```java
.requestMatchers("/api/auth/login", "/api/auth/verify-2fa").permitAll()
```

---

## Frontend

### API модуль

**Файл:** `frontend/src/api/twoFactor.js`

```javascript
import client from './client'

export const twoFactorApi = {
  // Получить статус 2FA
  getStatus() {
    return client.get('/2fa/status')
  },

  // Начать настройку — получить QR-код
  setup() {
    return client.post('/2fa/setup')
  },

  // Подтвердить настройку и включить 2FA
  enable(code) {
    return client.post('/2fa/enable', { code })
  },

  // Отключить 2FA
  disable(code) {
    return client.post('/2fa/disable', { code })
  },

  // Проверить код при логине
  verify(twoFactorToken, code) {
    return client.post('/auth/verify-2fa', { twoFactorToken, code })
  }
}
```

---

### Изменение auth store

**Файл:** `frontend/src/stores/auth.js`

Добавить поддержку 2FA:

```javascript
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import client from '@/api/client'
import { twoFactorApi } from '@/api/twoFactor'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const token = ref(localStorage.getItem('token'))
  const loading = ref(false)
  
  // Для 2FA
  const pendingTwoFactor = ref(null)  // { twoFactorToken }

  const isAuthenticated = computed(() => !!token.value && !!user.value)
  const isAdmin = computed(() => user.value?.roles?.some(r => 
    ['SYSTEM_ADMIN', 'DZO_ADMIN'].includes(r)
  ))
  const isSystemAdmin = computed(() => user.value?.roles?.includes('SYSTEM_ADMIN'))
  const isTotpEnabled = computed(() => user.value?.totpEnabled || false)

  async function login(username, password) {
    loading.value = true
    try {
      const response = await client.post('/auth/login', { username, password })
      
      if (response.data.requiresTwoFactor) {
        // Нужна 2FA — сохраняем токен и ждём код
        pendingTwoFactor.value = {
          twoFactorToken: response.data.twoFactorToken
        }
        return { requiresTwoFactor: true }
      }
      
      // 2FA не нужна — сохраняем токен
      token.value = response.data.token
      user.value = response.data.user
      localStorage.setItem('token', response.data.token)
      client.defaults.headers.common['Authorization'] = `Bearer ${response.data.token}`
      
      return { success: true }
    } finally {
      loading.value = false
    }
  }

  async function verifyTwoFactor(code) {
    if (!pendingTwoFactor.value) {
      throw new Error('No pending 2FA')
    }
    
    loading.value = true
    try {
      const response = await twoFactorApi.verify(
        pendingTwoFactor.value.twoFactorToken,
        code
      )
      
      // Успешно — сохраняем токен
      token.value = response.data.token
      user.value = response.data.user
      localStorage.setItem('token', response.data.token)
      client.defaults.headers.common['Authorization'] = `Bearer ${response.data.token}`
      
      pendingTwoFactor.value = null
      
      return { success: true }
    } finally {
      loading.value = false
    }
  }

  function cancelTwoFactor() {
    pendingTwoFactor.value = null
  }

  async function fetchUser() {
    if (!token.value) return
    
    try {
      client.defaults.headers.common['Authorization'] = `Bearer ${token.value}`
      const response = await client.get('/auth/me')
      user.value = response.data
    } catch (error) {
      logout()
    }
  }

  function logout() {
    token.value = null
    user.value = null
    pendingTwoFactor.value = null
    localStorage.removeItem('token')
    delete client.defaults.headers.common['Authorization']
  }

  return {
    user,
    token,
    loading,
    pendingTwoFactor,
    isAuthenticated,
    isAdmin,
    isSystemAdmin,
    isTotpEnabled,
    login,
    verifyTwoFactor,
    cancelTwoFactor,
    fetchUser,
    logout
  }
})
```

---

### Изменение LoginView

**Файл:** `frontend/src/views/LoginView.vue`

Добавить шаг ввода кода 2FA:

```vue
<template>
  <div class="login-view">
    <div class="login-card glass-card">
      <div class="logo">
        <div class="logo-icon">B</div>
        <h1>Birzha</h1>
      </div>

      <!-- Шаг 1: Логин/пароль -->
      <el-form 
        v-if="!showTwoFactor"
        ref="formRef"
        :model="form"
        :rules="rules"
        @submit.prevent="handleLogin"
      >
        <el-form-item prop="username">
          <el-input 
            v-model="form.username" 
            placeholder="Логин"
            prefix-icon="User"
            size="large"
          />
        </el-form-item>

        <el-form-item prop="password">
          <el-input 
            v-model="form.password" 
            type="password" 
            placeholder="Пароль"
            prefix-icon="Lock"
            size="large"
            show-password
          />
        </el-form-item>

        <el-button 
          type="primary" 
          native-type="submit" 
          :loading="authStore.loading"
          size="large"
          class="login-btn"
        >
          Войти
        </el-button>
      </el-form>

      <!-- Шаг 2: Код 2FA -->
      <div v-else class="two-factor-form">
        <div class="two-factor-icon">
          <el-icon :size="48"><Key /></el-icon>
        </div>
        <h2>Двухфакторная аутентификация</h2>
        <p class="two-factor-hint">Введите 6-значный код из приложения-аутентификатора</p>
        
        <el-input
          v-model="twoFactorCode"
          placeholder="000000"
          maxlength="6"
          size="large"
          class="two-factor-input"
          @keyup.enter="handleVerifyTwoFactor"
        />

        <div class="two-factor-actions">
          <el-button 
            type="primary" 
            :loading="authStore.loading"
            :disabled="twoFactorCode.length !== 6"
            size="large"
            class="login-btn"
            @click="handleVerifyTwoFactor"
          >
            Подтвердить
          </el-button>
          <el-button 
            text 
            @click="handleCancelTwoFactor"
          >
            Отмена
          </el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Key } from '@element-plus/icons-vue'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const formRef = ref(null)
const form = ref({
  username: '',
  password: ''
})

const twoFactorCode = ref('')

const showTwoFactor = computed(() => !!authStore.pendingTwoFactor)

const rules = {
  username: [{ required: true, message: 'Введите логин', trigger: 'blur' }],
  password: [{ required: true, message: 'Введите пароль', trigger: 'blur' }]
}

async function handleLogin() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  try {
    const result = await authStore.login(form.value.username, form.value.password)
    
    if (result.requiresTwoFactor) {
      // Нужна 2FA — форма переключится автоматически
      twoFactorCode.value = ''
      return
    }
    
    if (result.success) {
      router.push('/')
    }
  } catch (error) {
    ElMessage.error(error.response?.data?.message || 'Ошибка авторизации')
  }
}

async function handleVerifyTwoFactor() {
  if (twoFactorCode.value.length !== 6) return

  try {
    const result = await authStore.verifyTwoFactor(twoFactorCode.value)
    
    if (result.success) {
      router.push('/')
    }
  } catch (error) {
    ElMessage.error(error.response?.data?.message || 'Неверный код')
    twoFactorCode.value = ''
  }
}

function handleCancelTwoFactor() {
  authStore.cancelTwoFactor()
  twoFactorCode.value = ''
  form.value.password = ''
}
</script>

<style scoped>
/* ... существующие стили ... */

.two-factor-form {
  text-align: center;
}

.two-factor-icon {
  color: var(--accent, #7c3aed);
  margin-bottom: 16px;
}

.two-factor-form h2 {
  font-size: 20px;
  margin: 0 0 8px 0;
  color: var(--text-primary);
}

.two-factor-hint {
  color: var(--text-muted);
  font-size: 14px;
  margin-bottom: 24px;
}

.two-factor-input {
  margin-bottom: 24px;
}

.two-factor-input :deep(.el-input__inner) {
  text-align: center;
  font-size: 24px;
  letter-spacing: 8px;
  font-family: monospace;
}

.two-factor-actions {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
</style>
```

---

### Компонент настройки 2FA

**Файл:** `frontend/src/components/TwoFactorSetup.vue`

```vue
<template>
  <div class="two-factor-setup">
    <!-- Статус -->
    <div class="status-section">
      <div class="status-indicator" :class="{ enabled: authStore.isTotpEnabled }">
        <el-icon><Lock /></el-icon>
      </div>
      <div class="status-text">
        <h3>Двухфакторная аутентификация</h3>
        <p v-if="authStore.isTotpEnabled" class="enabled">Включена</p>
        <p v-else class="disabled">Отключена</p>
      </div>
    </div>

    <!-- Кнопка включения/отключения -->
    <div v-if="!showSetup">
      <el-button 
        v-if="!authStore.isTotpEnabled"
        type="primary"
        @click="startSetup"
      >
        Включить 2FA
      </el-button>
      <el-button 
        v-else
        type="danger"
        @click="showDisableDialog = true"
      >
        Отключить 2FA
      </el-button>
    </div>

    <!-- Настройка -->
    <div v-if="showSetup" class="setup-section">
      <div class="setup-steps">
        <div class="step">
          <div class="step-number">1</div>
          <div class="step-content">
            <h4>Установите приложение</h4>
            <p>Скачайте Google Authenticator, Authy или Яндекс.Ключ на свой телефон</p>
          </div>
        </div>

        <div class="step">
          <div class="step-number">2</div>
          <div class="step-content">
            <h4>Отсканируйте QR-код</h4>
            <div class="qr-container" v-if="setupData">
              <img :src="setupData.qrCodeDataUrl" alt="QR Code" class="qr-code" />
            </div>
            <p class="manual-key" v-if="setupData">
              Или введите ключ вручную: <code>{{ setupData.manualEntryKey }}</code>
            </p>
          </div>
        </div>

        <div class="step">
          <div class="step-number">3</div>
          <div class="step-content">
            <h4>Введите код из приложения</h4>
            <el-input
              v-model="verifyCode"
              placeholder="000000"
              maxlength="6"
              class="verify-input"
            />
            <div class="step-actions">
              <el-button type="primary" :loading="loading" @click="confirmSetup">
                Подтвердить
              </el-button>
              <el-button @click="cancelSetup">Отмена</el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Диалог отключения -->
    <el-dialog v-model="showDisableDialog" title="Отключить 2FA" width="400px">
      <p>Для отключения двухфакторной аутентификации введите код из приложения:</p>
      <el-input
        v-model="disableCode"
        placeholder="000000"
        maxlength="6"
        class="disable-input"
      />
      <template #footer>
        <el-button @click="showDisableDialog = false">Отмена</el-button>
        <el-button type="danger" :loading="loading" @click="confirmDisable">
          Отключить
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { Lock } from '@element-plus/icons-vue'
import { useAuthStore } from '@/stores/auth'
import { twoFactorApi } from '@/api/twoFactor'

const authStore = useAuthStore()

const showSetup = ref(false)
const setupData = ref(null)
const verifyCode = ref('')
const loading = ref(false)

const showDisableDialog = ref(false)
const disableCode = ref('')

async function startSetup() {
  loading.value = true
  try {
    const response = await twoFactorApi.setup()
    setupData.value = response.data
    showSetup.value = true
  } catch (error) {
    ElMessage.error('Ошибка при настройке 2FA')
  } finally {
    loading.value = false
  }
}

async function confirmSetup() {
  if (verifyCode.value.length !== 6) {
    ElMessage.warning('Введите 6-значный код')
    return
  }
  
  loading.value = true
  try {
    const response = await twoFactorApi.enable(verifyCode.value)
    if (response.data.success) {
      ElMessage.success('2FA успешно включена!')
      showSetup.value = false
      setupData.value = null
      verifyCode.value = ''
      // Обновить данные пользователя
      await authStore.fetchUser()
    }
  } catch (error) {
    ElMessage.error(error.response?.data?.message || 'Неверный код')
  } finally {
    loading.value = false
  }
}

function cancelSetup() {
  showSetup.value = false
  setupData.value = null
  verifyCode.value = ''
}

async function confirmDisable() {
  if (disableCode.value.length !== 6) {
    ElMessage.warning('Введите 6-значный код')
    return
  }
  
  loading.value = true
  try {
    const response = await twoFactorApi.disable(disableCode.value)
    if (response.data.success) {
      ElMessage.success('2FA отключена')
      showDisableDialog.value = false
      disableCode.value = ''
      await authStore.fetchUser()
    }
  } catch (error) {
    ElMessage.error(error.response?.data?.message || 'Неверный код')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.two-factor-setup {
  padding: 20px;
}

.status-section {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
}

.status-indicator {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  background: rgba(239, 68, 68, 0.2);
  color: #ef4444;
}

.status-indicator.enabled {
  background: rgba(16, 185, 129, 0.2);
  color: #10b981;
}

.status-text h3 {
  margin: 0;
  font-size: 16px;
  color: var(--text-primary);
}

.status-text p {
  margin: 4px 0 0;
  font-size: 14px;
}

.status-text p.enabled {
  color: #10b981;
}

.status-text p.disabled {
  color: #ef4444;
}

.setup-section {
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.setup-steps {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.step {
  display: flex;
  gap: 16px;
}

.step-number {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--accent, #7c3aed);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  flex-shrink: 0;
}

.step-content h4 {
  margin: 0 0 8px;
  color: var(--text-primary);
}

.step-content p {
  margin: 0;
  color: var(--text-secondary);
  font-size: 14px;
}

.qr-container {
  margin: 16px 0;
}

.qr-code {
  width: 200px;
  height: 200px;
  border-radius: 8px;
  background: white;
  padding: 8px;
}

.manual-key {
  margin-top: 12px;
}

.manual-key code {
  background: rgba(124, 58, 237, 0.2);
  padding: 4px 8px;
  border-radius: 4px;
  font-family: monospace;
  color: var(--accent);
}

.verify-input {
  max-width: 200px;
  margin-bottom: 16px;
}

.verify-input :deep(.el-input__inner) {
  text-align: center;
  font-size: 20px;
  letter-spacing: 4px;
}

.step-actions {
  display: flex;
  gap: 12px;
}

.disable-input {
  margin-top: 16px;
}

.disable-input :deep(.el-input__inner) {
  text-align: center;
  font-size: 20px;
  letter-spacing: 4px;
}
</style>
```

---

### Добавить в настройки профиля

В существующий компонент настроек или создать раздел "Безопасность" и добавить:

```vue
<TwoFactorSetup />
```

---

## API Endpoints

| Метод | URL | Описание | Авторизация |
|-------|-----|----------|-------------|
| POST | `/api/auth/login` | Логин (шаг 1) | Нет |
| POST | `/api/auth/verify-2fa` | Проверка кода 2FA (шаг 2) | Нет |
| GET | `/api/2fa/status` | Статус 2FA | Да |
| POST | `/api/2fa/setup` | Начать настройку (получить QR) | Да |
| POST | `/api/2fa/enable` | Включить 2FA | Да |
| POST | `/api/2fa/disable` | Отключить 2FA | Да |

---

## Файлы для создания/изменения

### Backend (9 файлов)

| # | Файл | Действие |
|---|------|----------|
| 1 | `pom.xml` | Добавить зависимости |
| 2 | `V25__add_totp_fields.sql` | Создать миграцию |
| 3 | `User.java` | Добавить поля |
| 4 | `TotpService.java` | Создать |
| 5 | `TotpSetupResponse.java` | Создать |
| 6 | `TotpVerifyRequest.java` | Создать |
| 7 | `LoginResponse.java` | Изменить/создать |
| 8 | `TwoFactorController.java` | Создать |
| 9 | `AuthController.java` | Изменить |

### Frontend (4 файла)

| # | Файл | Действие |
|---|------|----------|
| 1 | `api/twoFactor.js` | Создать |
| 2 | `stores/auth.js` | Изменить |
| 3 | `views/LoginView.vue` | Изменить |
| 4 | `components/TwoFactorSetup.vue` | Создать |

---

## Тестирование

1. Пересобрать: `docker-compose build`
2. Перезапустить: `docker-compose up -d`
3. Войти под admin/admin123
4. Открыть настройки профиля
5. Включить 2FA:
   - Отсканировать QR-код в Google Authenticator
   - Ввести код из приложения
   - Убедиться что 2FA включена
6. Выйти из системы
7. Войти снова:
   - Ввести логин/пароль
   - Появится поле для кода
   - Ввести код из приложения
   - Успешный вход
8. Проверить отключение 2FA
