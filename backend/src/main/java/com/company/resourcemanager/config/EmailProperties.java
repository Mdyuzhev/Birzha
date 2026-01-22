package com.company.resourcemanager.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "app.mail")
public class EmailProperties {

    private boolean enabled = false;
    private String from = "noreply@example.com";
    private String fromName = "Birzha";
    private String baseUrl = "http://localhost:31080";
}
