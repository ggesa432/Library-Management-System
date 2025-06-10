package com.synergisticit.controller;

import com.synergisticit.domain.FeeConfiguration;
import com.synergisticit.repository.FeeConfigurationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/4/2025
 */
@RestController
@RequestMapping("/api/config")
public class ConfigController {

    @Autowired
    private FeeConfigurationRepository feeConfigRepository;

    @GetMapping
    public ResponseEntity<List<FeeConfiguration>> getAllConfigurations() {
        List<FeeConfiguration> configs = feeConfigRepository.findAll();
        return ResponseEntity.ok(configs);
    }

    @PutMapping("/{configKey}")
    public ResponseEntity<FeeConfiguration> updateConfiguration(
            @PathVariable String configKey,
            @RequestParam String value) {

        Optional<FeeConfiguration> configOpt = feeConfigRepository.findByConfigKey(configKey);
        FeeConfiguration config;

        if (configOpt.isPresent()) {
            config = configOpt.get();
            config.setConfigValue(value);
        } else {
            return ResponseEntity.notFound().build();
        }

        FeeConfiguration updated = feeConfigRepository.save(config);
        return ResponseEntity.ok(updated);
    }
}
