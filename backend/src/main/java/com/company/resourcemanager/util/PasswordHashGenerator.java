package com.company.resourcemanager.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordHashGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String password = "pass123";
        String hash = encoder.encode(password);
        System.out.println("Password: " + password);
        System.out.println("BCrypt Hash: " + hash);

        // Verify
        System.out.println("Verification: " + encoder.matches(password, hash));

        // Test existing hash
        String existingHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu";
        System.out.println("\nTesting existing hash:");
        System.out.println("Hash: " + existingHash);
        System.out.println("Matches 'pass123': " + encoder.matches("pass123", existingHash));
        System.out.println("Matches 'admin123': " + encoder.matches("admin123", existingHash));
        System.out.println("Matches 'user': " + encoder.matches("user", existingHash));
    }
}
