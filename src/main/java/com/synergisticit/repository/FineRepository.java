package com.synergisticit.repository;

import com.synergisticit.domain.Fine;
import com.synergisticit.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/4/2025
 */
@Repository
public interface FineRepository extends JpaRepository<Fine, Integer> {
    List<Fine> findByMember(Member member);
    @Query("SELECT f FROM Fine f LEFT JOIN FETCH f.transaction t LEFT JOIN FETCH t.book WHERE f.status = :status")
    List<Fine> findByStatusWithDetails(String status);
    List<Fine> findByMemberAndStatus(Member member, String status);
}
