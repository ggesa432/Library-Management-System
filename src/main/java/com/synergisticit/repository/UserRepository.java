package com.synergisticit.repository;

import com.synergisticit.domain.Member;
import com.synergisticit.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    List<User> findByFirstNameContainingOrLastNameContaining(String firstName, String lastName);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    Optional<User> findByMember(Member member);
}
