package com.synergisticit.repository;

import com.synergisticit.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface MemberRepository extends JpaRepository<Member, Integer> {

    List<Member> findByFirstNameContainingOrLastNameContaining(String firstName, String lastName);

    Optional<Member> findByEmail(String email);

    @Query("SELECT m FROM Member m JOIN m.transactions t WHERE t.returnDate IS NULL GROUP BY m")
    List<Member> findMembersWithActiveTransactions();

    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.member.memberId = :memberId AND t.returnDate IS NULL")
    long countActiveTransactionsByMemberId(Integer memberId);

    List<Member> findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCase(String searchTerm, String searchTerm1);
}
