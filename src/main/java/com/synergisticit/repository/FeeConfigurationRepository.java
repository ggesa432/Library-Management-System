package com.synergisticit.repository;

import com.synergisticit.domain.FeeConfiguration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/4/2025
 */
@Repository
public interface FeeConfigurationRepository extends JpaRepository<FeeConfiguration, Integer> {
    Optional<FeeConfiguration> findByConfigKey(String configKey);
}
