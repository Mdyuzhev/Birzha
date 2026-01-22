package com.company.resourcemanager.controller;

import com.company.resourcemanager.dto.LoginRequest;
import com.company.resourcemanager.dto.LoginResponse;
import com.company.resourcemanager.dto.UserDto;
import com.company.resourcemanager.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @PostMapping("/verify-2fa")
    public ResponseEntity<LoginResponse> verifyTwoFactor(@RequestBody java.util.Map<String, String> request) {
        String twoFactorToken = request.get("twoFactorToken");
        String code = request.get("code");
        return ResponseEntity.ok(authService.verifyTwoFactor(twoFactorToken, code));
    }

    @GetMapping("/me")
    public ResponseEntity<UserDto> getCurrentUser() {
        return ResponseEntity.ok(authService.getCurrentUser());
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout() {
        authService.logout();
        return ResponseEntity.ok().build();
    }
}
