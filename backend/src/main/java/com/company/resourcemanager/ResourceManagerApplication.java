package com.company.resourcemanager;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import jakarta.annotation.PostConstruct;
import java.util.TimeZone;

@SpringBootApplication
public class ResourceManagerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ResourceManagerApplication.class, args);
    }

    @PostConstruct
    void setTimeZone() {
        TimeZone.setDefault(TimeZone.getTimeZone("Europe/Moscow"));
    }
}
