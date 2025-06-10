package com.synergisticit.service;

import com.synergisticit.domain.*;
import com.synergisticit.exception.ResourceNotFoundException;
import com.synergisticit.repository.FeeConfigurationRepository;
import com.synergisticit.repository.FineRepository;
import com.synergisticit.repository.MemberRepository;
import com.synergisticit.repository.TransactionRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/4/2025
 */
@Service
public class FineService {

    @Autowired
    private FineRepository fineRepository;

    @Autowired
    private FeeConfigurationRepository feeConfigRepository;

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private EmailService emailService;

    @Value("${library.fine.rate.daily:0.50}")
    private double dailyFineRate;

    @Value("${library.max.books.per.member:5}")
    private int maxBooksPerMember;

    @Value("${library.default.loan.period:14}")
    private int defaultLoanPeriod;

    @Value("${library.membership.fee:10.00}")
    private double membershipFee;

    @PostConstruct
    public void init() {
        // Load configuration from database if exists, otherwise use defaults
        Optional<FeeConfiguration> dailyRateConfig = feeConfigRepository.findByConfigKey("DAILY_FINE_RATE");
        if (dailyRateConfig.isPresent()) {
            dailyFineRate = Double.parseDouble(dailyRateConfig.get().getConfigValue());
        } else {
            createDefaultConfig("DAILY_FINE_RATE", String.valueOf(dailyFineRate),
                    "Daily fine rate for overdue books");
        }

        Optional<FeeConfiguration> maxBooksConfig = feeConfigRepository.findByConfigKey("MAX_BOOKS_PER_MEMBER");
        if (maxBooksConfig.isPresent()) {
            maxBooksPerMember = Integer.parseInt(maxBooksConfig.get().getConfigValue());
        } else {
            createDefaultConfig("MAX_BOOKS_PER_MEMBER", String.valueOf(maxBooksPerMember),
                    "Maximum number of books a member can borrow");
        }

        Optional<FeeConfiguration> loanPeriodConfig = feeConfigRepository.findByConfigKey("DEFAULT_LOAN_PERIOD");
        if (loanPeriodConfig.isPresent()) {
            defaultLoanPeriod = Integer.parseInt(loanPeriodConfig.get().getConfigValue());
        } else {
            createDefaultConfig("DEFAULT_LOAN_PERIOD", String.valueOf(defaultLoanPeriod),
                    "Default loan period in days");
        }

        Optional<FeeConfiguration> membershipFeeConfig = feeConfigRepository.findByConfigKey("MEMBERSHIP_FEE");
        if (membershipFeeConfig.isPresent()) {
            membershipFee = Double.parseDouble(membershipFeeConfig.get().getConfigValue());
        } else {
            createDefaultConfig("MEMBERSHIP_FEE", String.valueOf(membershipFee),
                    "Membership fee for new members");
        }
    }

    private void createDefaultConfig(String key, String value, String description) {
        FeeConfiguration config = new FeeConfiguration();
        config.setConfigKey(key);
        config.setConfigValue(value);
        config.setDescription(description);
        feeConfigRepository.save(config);
    }

    @Transactional
    public Fine calculateFineForOverdueBook(Transaction transaction) {
        if (transaction.getReturnDate() == null) {
            throw new IllegalStateException("Book has not been returned yet");
        }

        LocalDate dueDate = transaction.getDueDate();
        LocalDate returnDate = transaction.getReturnDate();

        if (returnDate.isAfter(dueDate)) {
            long daysLate = ChronoUnit.DAYS.between(dueDate, returnDate);
            double fineAmount = daysLate * dailyFineRate;

            Fine fine = new Fine();
            fine.setTransaction(transaction);  // Make sure this is set correctly
            fine.setMember(transaction.getMember());
            fine.setAmount(fineAmount);
            fine.setReason("Book returned " + daysLate + " days late");
            fine.setIssueDate(LocalDate.now());
            fine.setStatus("PENDING");

            Fine savedFine = fineRepository.save(fine);

            // Notify the member and librarian
            notifyAboutFine(savedFine);

            return savedFine;
        }

        return null;
    }

    @Transactional
    public Fine payFine(Integer fineId) {
        Fine fine = fineRepository.findById(fineId)
                .orElseThrow(() -> new ResourceNotFoundException("Fine not found with id: " + fineId));

        if ("PAID".equals(fine.getStatus())) {
            throw new IllegalStateException("Fine has already been paid");
        }

        fine.setStatus("PAID");
        fine.setPaymentDate(LocalDate.now());

        return fineRepository.save(fine);
    }

    @Transactional(readOnly = true)
    public List<Fine> getPendingFinesForMember(Integer memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ResourceNotFoundException("Member not found with id: " + memberId));

        return fineRepository.findByMemberAndStatus(member, "PENDING");
    }

    @Transactional(readOnly = true)
    public double getTotalPendingFinesForMember(Integer memberId) {
        List<Fine> pendingFines = getPendingFinesForMember(memberId);
        return pendingFines.stream()
                .mapToDouble(Fine::getAmount)
                .sum();
    }

    @Transactional(readOnly = true)
    public boolean canMemberBorrowBooks(Integer memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ResourceNotFoundException("Member not found with id: " + memberId));

        // Check if member has any pending fines
        double pendingFines = getTotalPendingFinesForMember(memberId);
        if (pendingFines > 0) {
            return false;
        }

        // Check if member has reached the maximum books limit
        long activeLoans = transactionRepository.countByMemberAndReturnDateIsNull(member);
        return activeLoans < maxBooksPerMember;
    }

    @Transactional
    public void collectMembershipFee(Integer memberId) {
        // Find the member
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ResourceNotFoundException("Member not found with id: " + memberId));

        // Create a Fine record for the membership fee
        Fine membershipFee = new Fine();
        membershipFee.setMember(member);
        membershipFee.setAmount(membershipFee.getAmount());
        membershipFee.setReason("Membership Fee");
        membershipFee.setIssueDate(LocalDate.now());
        membershipFee.setStatus("PAID"); // Since it's collected immediately
        membershipFee.setPaymentDate(LocalDate.now());

        // Save the fine record
        fineRepository.save(membershipFee);

        System.out.println("Collected membership fee of $" + membershipFee + " for member " + memberId);
    }

    private void notifyAboutFine(Fine fine) {
        // Send email to member
        Member member = fine.getMember();
        Transaction transaction = fine.getTransaction();
        Book book = transaction.getBook();

        String memberSubject = "Library Fine Notice";
        String memberMessage = String.format(
                "Dear %s %s,\n\n" +
                        "This is to inform you that you have been charged a fine of $%.2f for returning the book '%s' %d days late.\n" +
                        "Please settle this fine during your next visit to the library.\n\n" +
                        "Regards,\n" +
                        "Library Management Team",
                member.getFirstName(), member.getLastName(),
                fine.getAmount(), book.getTitle(),
                ChronoUnit.DAYS.between(transaction.getDueDate(), transaction.getReturnDate())
        );

        // Send notification to member (in a real system, this would send an actual email)
        if (member.getEmail() != null) {
            emailService.sendEmail(member.getEmail(), memberSubject, memberMessage);
        }

        // Send notification to librarian (in a real system, you'd have a list of librarian emails)
        String librarianSubject = "Fine Issued - " + member.getFirstName() + " " + member.getLastName();
        String librarianMessage = String.format(
                "A fine of $%.2f has been issued to %s %s for returning the book '%s' %d days late.\n\n" +
                        "Fine Details:\n" +
                        "- Fine ID: %d\n" +
                        "- Issue Date: %s\n" +
                        "- Status: %s\n",
                fine.getAmount(), member.getFirstName(), member.getLastName(),
                book.getTitle(), ChronoUnit.DAYS.between(transaction.getDueDate(), transaction.getReturnDate()),
                fine.getFineId(), fine.getIssueDate(), fine.getStatus()
        );

        emailService.sendEmail("librarian@library.com", librarianSubject, librarianMessage);
    }

    @Transactional(readOnly = true)
    public List<Fine> getAllFines() {
        return fineRepository.findAll(); // Returns all fines regardless of status
    }

    @Transactional(readOnly = true)
    public List<Fine> getAllPendingFines() {
        return fineRepository.findByStatusWithDetails("PENDING");
    }

    @Transactional
    public void updateFineRate(double newDailyRate) {
        Optional<FeeConfiguration> config = feeConfigRepository.findByConfigKey("DAILY_FINE_RATE");
        if (config.isPresent()) {
            FeeConfiguration feeConfig = config.get();
            feeConfig.setConfigValue(String.valueOf(newDailyRate));
            feeConfigRepository.save(feeConfig);
        } else {
            createDefaultConfig("DAILY_FINE_RATE", String.valueOf(newDailyRate),
                    "Daily fine rate for overdue books");
        }

        dailyFineRate = newDailyRate;
    }

    @Transactional(readOnly = true)
    public List<Fine> getFinesByStatus(String status) {
        return fineRepository.findByStatusWithDetails(status);
    }
    @Transactional(readOnly = true)
    public int getDefaultLoanPeriod() {
        return this.defaultLoanPeriod;
    }

    @Transactional(readOnly = true)
    public double getDailyFineRate() {
        return this.dailyFineRate;
    }

    @Transactional(readOnly = true)
    public int getMaxBooksPerMember() {
        return this.maxBooksPerMember;
    }

    @Transactional(readOnly = true)
    public double getMembershipFee() {
        return this.membershipFee;
    }

}
