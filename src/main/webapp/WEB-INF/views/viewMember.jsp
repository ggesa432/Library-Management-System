<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - View Member</title>
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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/members">Members</a></li>
                    <li class="breadcrumb-item active" aria-current="page">View Member</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0">Member Details</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <div class="text-center mb-4">
                        <div class="display-1 text-info">
                            <i class="fas fa-user-circle"></i>
                        </div>
                        <h4 id="memberName">Loading...</h4>
                        <p id="memberEmail" class="text-muted mb-0"></p>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="border-bottom pb-2 mb-3">Personal Information</h6>
                            <p><strong>First Name:</strong> <span id="firstName"></span></p>
                            <p><strong>Last Name:</strong> <span id="lastName"></span></p>
                            <p><strong>Email:</strong> <span id="email"></span></p>
                            <p><strong>Phone:</strong> <span id="phone"></span></p>
                            <p><strong>Address:</strong> <span id="address"></span></p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="border-bottom pb-2 mb-3">Membership Information</h6>
                            <p><strong>Member ID:</strong> <span id="memberId"></span></p>
                            <p><strong>Membership Date:</strong> <span id="membershipDate"></span></p>
                            <p><strong>Status:</strong> <span id="status" class="badge badge-success">Active</span></p>
                            <p><strong>Current Borrowings:</strong> <span id="activeBorrowings"></span></p>
                            <p><strong>Overdue Books:</strong> <span id="overdueBooks"></span></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Borrowing History -->
            <div class="mt-4">
                <h5 class="border-bottom pb-2">Borrowing History</h5>
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead class="thead-light">
                        <tr>
                            <th>Book Title</th>
                            <th>Checkout Date</th>
                            <th>Due Date</th>
                            <th>Return Date</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody id="borrowingHistoryTable">
                        <!-- Will be populated dynamically -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="card-footer">
            <div class="text-right">
                <a href="${pageContext.request.contextPath}/members" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Members
                </a>
                <a id="editMemberBtn" href="#" class="btn btn-warning">
                    <i class="fas fa-edit"></i> Edit Member
                </a>
                <button id="deleteMemberBtn" class="btn btn-danger">
                    <i class="fas fa-trash"></i> Delete Member
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this member? This action cannot be undone.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
            </div>
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

        // Get member ID from URL parameter
        const urlParams = new URLSearchParams(window.location.search);
        const memberId = urlParams.get('id');

        if (!memberId) {
            alert('Member ID is missing!');
            window.location.href = '${pageContext.request.contextPath}/members';
            return;
        }

        // Load member details
        loadMemberDetails(memberId);

        // Load borrowing history
        loadBorrowingHistory(memberId);

        // Set up edit button
        $('#editMemberBtn').click(function() {
            window.location.href = '${pageContext.request.contextPath}/members/edit?id=' + memberId;
        });

        // Set up delete button
        $('#deleteMemberBtn').click(function() {
            $('#deleteModal').modal('show');
        });

        // Setup confirm delete button
        $('#confirmDeleteBtn').click(function() {
            deleteMember(memberId);
        });
    });

    function loadMemberDetails(memberId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/members/' + memberId,
            type: 'GET',
            success: function(member) {
                // Set member details
                $('#memberName').text(member.firstName + ' ' + member.lastName);
                $('#memberEmail').text(member.email || 'No email provided');
                $('#firstName').text(member.firstName || 'N/A');
                $('#lastName').text(member.lastName || 'N/A');
                $('#email').text(member.email || 'N/A');
                $('#phone').text(member.phone || 'N/A');
                $('#address').text(member.address || 'N/A');
                $('#memberId').text(member.memberId);

                // Format and display membership date
                const membershipDate = formatDate(member.membershipDate);
                $('#membershipDate').text(membershipDate || 'N/A');

                // Check for active borrowings and overdue books
                checkActiveBorrowings(memberId);
                checkOverdueBooks(memberId);
            },
            error: function(xhr, status, error) {
                console.error('Error loading member details:', error);
                alert('Failed to load member details. Please try again later.');
                window.location.href = '${pageContext.request.contextPath}/members';
            }
        });
    }

    function checkActiveBorrowings(memberId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/members/' + memberId + '/active-borrowings',
            type: 'GET',
            success: function(response) {
                $('#activeBorrowings').text(response.activeBorrowings || 0);
            },
            error: function(xhr, status, error) {
                console.error('Error checking active borrowings:', error);
                $('#activeBorrowings').text('N/A');
            }
        });
    }

    function checkOverdueBooks(memberId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/members/' + memberId + '/overdue',
            type: 'GET',
            success: function(response) {
                const hasOverdue = response.hasOverdueBooks;

                if (hasOverdue) {
                    $('#overdueBooks').html('<span class="text-danger">Yes</span>');
                    $('#status').removeClass('badge-success').addClass('badge-warning').text('Has Overdue');
                } else {
                    $('#overdueBooks').text('None');
                }
            },
            error: function(xhr, status, error) {
                console.error('Error checking overdue books:', error);
                $('#overdueBooks').text('N/A');
            }
        });
    }

    function loadBorrowingHistory(memberId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/transactions/member/' + memberId,
            type: 'GET',
            success: function(transactions) {
                updateBorrowingHistoryTable(transactions);
            },
            error: function(xhr, status, error) {
                console.error('Error loading borrowing history:', error);
                $('#borrowingHistoryTable').html('<tr><td colspan="5" class="text-center">Failed to load borrowing history</td></tr>');
            }
        });
    }

    function updateBorrowingHistoryTable(transactions) {
        const tableBody = $('#borrowingHistoryTable');
        tableBody.empty();

        if (transactions.length === 0) {
            tableBody.append('<tr><td colspan="5" class="text-center">No borrowing history found</td></tr>');
            return;
        }

        transactions.forEach(function(transaction) {
            const checkoutDate = formatDate(transaction.checkOutDate);
            const dueDate = formatDate(transaction.dueDate);
            const returnDate = formatDate(transaction.returnDate);

            let status;
            let statusClass;

            if (transaction.returnDate) {
                status = 'Returned';
                statusClass = 'badge-success';
            } else if (transaction.overdue) {
                status = 'Overdue';
                statusClass = 'badge-danger';
            } else {
                status = 'Borrowed';
                statusClass = 'badge-info';
            }

            const row = `
                    <tr>
                        <td>\${transaction.bookTitle}</td>
                        <td>\${checkoutDate}</td>
                        <td>\${dueDate}</td>
                        <td>\${returnDate || 'Not returned'}</td>
                        <td><span class="badge \${statusClass}">\${status}</span></td>
                    </tr>
                `;
            tableBody.append(row);
        });
    }

    function deleteMember(memberId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/members/' + memberId,
            type: 'DELETE',
            success: function() {
                $('#deleteModal').modal('hide');
                alert('Member deleted successfully');
                window.location.href = '${pageContext.request.contextPath}/members';
            },
            error: function(xhr, status, error) {
                $('#deleteModal').modal('hide');
                console.error('Error deleting member:', error);

                if (xhr.responseJSON && xhr.responseJSON.error) {
                    alert(xhr.responseJSON.error);
                } else {
                    alert('Failed to delete member. Please try again later.');
                }
            }
        });
    }

    function formatDate(dateString) {
        if (!dateString) return null;

        const date = new Date(dateString);
        if (isNaN(date.getTime())) return null;

        const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
        return date.toLocaleDateString('en-US', options);
    }
</script>
</body>
</html>