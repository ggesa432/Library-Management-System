package com.synergisticit.service;

import com.synergisticit.domain.Fine;
import com.synergisticit.domain.Member;
import com.synergisticit.domain.User;
import com.synergisticit.exception.ResourceNotFoundException;
import com.synergisticit.repository.FineRepository;
import com.synergisticit.repository.MemberRepository;
import com.synergisticit.repository.TransactionRepository;
import com.synergisticit.repository.UserRepository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/24/2025
 */
@Service
public class MemberService {

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FineRepository fineRepository;

    @Autowired
    private FineService fineService;

    @Transactional(readOnly = true)
    public List<Member> getAllMembers() {
        return memberRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Member getMemberById(Integer memberId) {
        return memberRepository.findById(memberId)
                .orElseThrow(() -> new ResourceNotFoundException("Member not found with id: " + memberId));
    }

    @Transactional(readOnly = true)
    public List<Member> searchMembers(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return getAllMembers();
        }

        return memberRepository.findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCase(
                searchTerm, searchTerm);
    }

    @Transactional(readOnly = true)
    public boolean hasMemberOverdueBooks(Integer memberId) {
        Member member = getMemberById(memberId);
        LocalDate today = LocalDate.now();

        return transactionRepository.existsByMemberAndDueDateBeforeAndReturnDateIsNull(member, today);
    }

    @Transactional(readOnly = true)
    public int getActiveBorrowingsCount(Integer memberId) {
        Member member = getMemberById(memberId);
        return transactionRepository.countByMemberAndReturnDateIsNull(member);
    }

    @Transactional
    public Member createMember(Member member) {
        // Set membership date if not provided
        if (member.getMembershipDate() == null) {
            member.setMembershipDate(LocalDate.now());
        }

        Member savedMember = memberRepository.save(member);

        // Collect membership fee
        fineService.collectMembershipFee(savedMember.getMemberId());

        return savedMember;
    }

    @Transactional
    public Member updateMember(Integer memberId, Member memberDetails) {
        Member existingMember = getMemberById(memberId);

        existingMember.setFirstName(memberDetails.getFirstName());
        existingMember.setLastName(memberDetails.getLastName());
        existingMember.setEmail(memberDetails.getEmail());
        existingMember.setPhone(memberDetails.getPhone());
        existingMember.setAddress(memberDetails.getAddress());

        return memberRepository.save(existingMember);
    }

    @Transactional
    public void deleteMember(Integer memberId) {
        Member member = getMemberById(memberId);

        // Check if member has active borrowings
        int activeBorrowings = getActiveBorrowingsCount(memberId);
        if (activeBorrowings > 0) {
            throw new IllegalStateException(
                    "Cannot delete member with active borrowings. Member has " +
                            activeBorrowings + " books checked out.");
        }

        // Delete all fines associated with this member
        List<Fine> memberFines = fineRepository.findByMember(member);
        if (!memberFines.isEmpty()) {
            fineRepository.deleteAll(memberFines);
        }

        // Finally delete the member
        memberRepository.delete(member);
    }
}
