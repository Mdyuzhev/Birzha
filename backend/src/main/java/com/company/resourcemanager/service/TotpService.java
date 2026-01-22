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
