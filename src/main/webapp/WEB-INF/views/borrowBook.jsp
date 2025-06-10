<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Borrow Book</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.parameterName}"/>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row mb-3">
        <div class="col">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/transactions">Transactions</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Borrow Book</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Borrow Book</h5>
        </div>
        <div class="card-body">
            <form id="borrowBookForm">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="bookId">Select Book <span class="text-danger">*</span></label>
                            <select class="form-control" id="bookId" name="bookId" required>
                                <option value="">-- Select Book --</option>
                                <!-- Will be populated dynamically -->
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="durationDays">Loan Duration (Days) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="durationDays" name="durationDays" value="14" min="1" max="30" required>
                            <small class="form-text text-muted">Standard loan period is 14 days</small>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="memberId">Select Member <span class="text-danger">*</span></label>
                            <select class="form-control" id="memberId" name="memberId" required>
                                <option value="">-- Select Member --</option>
                                <!-- Will be populated dynamically -->
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Due Date</label>
                            <input type="text" class="form-control" id="dueDate" readonly>
                            <small class="form-text text-muted">Calculated based on loan duration</small>
                        </div>
                    </div>
                </div>

                <div id="bookInfo" class="alert alert-info mt-3" style="display: none;">
                    <!-- Book information will be displayed here -->
                </div>

                <div id="memberInfo" class="alert alert-info mt-3" style="display: none;">
                    <!-- Member information will be displayed here -->
                </div>

                <div class="text-right mt-3">
                    <button type="button" class="btn btn-secondary mr-2" onclick="window.location.href='${pageContext.request.contextPath}/transactions'">Cancel</button>
                    <button type="submit" class="btn btn-primary">Borrow Book</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    $(document).ready(function() {
        // CSRF token setup
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");

        // Configure jQuery AJAX globally to send CSRF token with all requests
        $(document).ajaxSend(function(e, xhr, options) {
            if (token && header && header.trim() !== '') {
                xhr.setRequestHeader(header, token);
            }
        });

        // Load available books and members
        loadAvailableBooks();
        loadMembers();

        // Calculate due date when duration changes
        $('#durationDays').on('change', function() {
            calculateDueDate();
        });

        // Show book details when a book is selected
        $('#bookId').on('change', function() {
            const bookId = $(this).val();
            if (bookId) {
                loadBookDetails(bookId);
            } else {
                $('#bookInfo').hide();
            }
        });

        // Show member details when a member is selected
        $('#memberId').on('change', function() {
            const memberId = $(this).val();
            if (memberId) {
                loadMemberDetails(memberId);
            } else {
                $('#memberInfo').hide();
            }
        });

        // Form submission
        $('#borrowBookForm').submit(function(e) {
            e.preventDefault();
            borrowBook();
        });

        // Calculate initial due date
        calculateDueDate();
    });

    function loadAvailableBooks() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/books',
            type: 'GET',
            success: function(books) {
                const bookSelect = $('#bookId');
                bookSelect.find('option:not(:first)').remove();

                // Filter only available books
                const availableBooks = books.filter(book => book.availableCopies > 0);

                if (availableBooks.length === 0) {
                    bookSelect.append('<option disabled>No available books</option>');
                    return;
                }

                availableBooks.forEach(function(book) {
                    bookSelect.append(`<option value="\${book.bookId}">\${book.title}</option>`);
                });
            },
            error: function(xhr, status, error) {
                console.error('Error loading books:', error);
                alert('Failed to load available books. Please try again later.');
            }
        });
    }

    function loadMembers() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/members',
            type: 'GET',
            success: function(members) {
                const memberSelect = $('#memberId');
                memberSelect.find('option:not(:first)').remove();

                if (members.length === 0) {
                    memberSelect.append('<option disabled>No members found</option>');
                    return;
                }

                members.forEach(function(member) {
                    memberSelect.append(`<option value="\${member.memberId}">\${member.firstName} \${member.lastName}</option>`);
                });
            },
            error: function(xhr, status, error) {
                console.error('Error loading members:', error);
                alert('Failed to load members. Please try again later.');
            }
        });
    }

    function loadBookDetails(bookId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/books/' + bookId,
            type: 'GET',
            success: function(book) {
                $('#bookInfo').html(`
                        <h5>Book Information</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Title:</strong> \${book.title}</p>
                                <p><strong>Author:</strong> \${book.authorName || 'N/A'}</p>
                                <p><strong>ISBN:</strong> \${book.isbn || 'N/A'}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Publisher:</strong> \${book.publisherName || 'N/A'}</p>
                                <p><strong>Category:</strong> \${book.category || 'N/A'}</p>
                                <p><strong>Available Copies:</strong> \${book.availableCopies}</p>
                            </div>
                        </div>
                    `).show();
            },
            error: function(xhr, status, error) {
                console.error('Error loading book details:', error);
                $('#bookInfo').html('<p class="text-danger">Failed to load book details</p>').show();
            }
        });
    }

    function loadMemberDetails(memberId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/members/' + memberId,
            type: 'GET',
            success: function(member) {
                $('#memberInfo').html(`
                        <h5>Member Information</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Name:</strong> \${member.firstName} \${member.lastName}</p>
                                <p><strong>Email:</strong> \${member.email || 'N/A'}</p>
                                <p><strong>Phone:</strong> \${member.phone || 'N/A'}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Address:</strong> \${member.address || 'N/A'}</p>
                                <p><strong>Member Since:</strong> \${member.membershipDate}</p>
                            </div>
                        </div>
                    `).show();

                // Check for overdue books
                checkOverdueBooks(memberId);
            },
            error: function(xhr, status, error) {
                console.error('Error loading member details:', error);
                $('#memberInfo').html('<p class="text-danger">Failed to load member details</p>').show();
            }
        });
    }

    function checkOverdueBooks(memberId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/transactions/member/' + memberId,
            type: 'GET',
            success: function(transactions) {
                const overdueBooks = transactions.filter(t => t.overdue);

                if (overdueBooks.length > 0) {
                    let overdueHtml = `
                            <div class="alert alert-danger mt-2">
                                <h6><i class="fas fa-exclamation-triangle"></i> Warning: Member has overdue books</h6>
                                <ul>
                        `;

                    overdueBooks.forEach(function(transaction) {
                        overdueHtml += `<li>\${transaction.bookTitle} (\${transaction.daysOverdue} days overdue)</li>`;
                    });

                    overdueHtml += `
                                </ul>
                                <p class="mb-0">Member should return overdue books first.</p>
                            </div>
                        `;

                    $('#memberInfo').append(overdueHtml);
                }
            },
            error: function(xhr, status, error) {
                console.error('Error checking overdue books:', error);
            }
        });
    }

    function calculateDueDate() {
        const durationDays = parseInt($('#durationDays').val()) || 14;
        const today = new Date();
        const dueDate = new Date(today);
        dueDate.setDate(today.getDate() + durationDays);

        $('#dueDate').val(formatDate(dueDate));
    }

    function borrowBook() {
        const bookId = $('#bookId').val();
        const memberId = $('#memberId').val();
        const durationDays = $('#durationDays').val();

        if (!bookId || !memberId || !durationDays) {
            alert('Please fill in all required fields.');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/api/transactions/borrow',
            type: 'POST',
            data: {
                bookId: bookId,
                memberId: memberId,
                durationDays: durationDays
            },
            success: function(response) {
                alert('Book borrowed successfully!');
                window.location.href = '${pageContext.request.contextPath}/transactions';
            },
            error: function(xhr, status, error) {
                console.error('Error borrowing book:', error);
                if (xhr.status === 400) {
                    alert('Failed to borrow book. The member may have overdue books or the book is not available.');
                } else {
                    alert('Failed to borrow book. Please try again later.');
                }
            }
        });
    }


    function formatDate(dateString) {
        if (!dateString) return 'N/A';

        const date = new Date(dateString);
        const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
        return date.toLocaleDateString('en-US', options);
    }
</script>
</body>
</html>