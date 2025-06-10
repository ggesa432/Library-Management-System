package com.synergisticit.config;

import com.fasterxml.jackson.datatype.hibernate5.jakarta.Hibernate5JakartaModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author GesangZeren
 * @project  LibraryManagementSystem
 * @date  3/4/2025
 */
@Configuration
public class JacksonConfig {
    @Bean
    public Hibernate5JakartaModule hibernateModule() {
        return new Hibernate5JakartaModule();
    }
}
