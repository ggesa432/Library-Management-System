<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Transactions</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.parameterName}"/>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row mb-3">
        <div class="col-md-6">
            <h2>Book Transactions</h2>
        </div>
        <div class="col-md-6 text-right">
            <sec:authorize access="hasAnyRole('LIBRARIAN', 'ADMIN')">
                <a href="${pageContext.request.contextPath}/transactions/borrow" class="btn btn-primary">
                    <i class="fas fa-book"></i> Borrow Book
                </a>
            </sec:authorize>
        </div>
    </div>

    <!-- Nav tabs -->
    <ul class="nav nav-tabs" id="transactionTabs" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="active-tab" data-toggle="tab" href="#active" role="tab">
                Active Transactions
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="overdue-tab" data-toggle="tab" href="#overdue" role="tab">
                Overdue Books
            </a>
        </li>
    </ul>

    <!-- Tab content -->
    <div class="tab-content">
        <!-- Active Transactions Tab -->
        <div class="tab-pane fade show active" id="active" role="tabpanel">
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="thead-light">
                            <tr>
                                <th>ID</th>
                                <th>Book Title</th>
                                <th>Member</th>
                                <th>Checkout Date</th>
                                <th>Due Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody id="activeTransactionsTableBody">
                            <!-- Transactions will be loaded here -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Overdue Books Tab -->
        <div class="tab-pane fade" id="overdue" role="tabpanel">
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="thead-light">
                            <tr>
                                <th>ID</th>
                                <th>Book Title</th>
                                <th>Member</th>
                                <th>Checkout Date</th>
                                <th>Due Date</th>
                                <th>Days Overdue</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody id="overdueTransactionsTableBody">
                            <!-- Overdue transactions will be loaded here -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Return Book Modal -->
<div class="modal fade" id="returnModal" tabindex="-1" role="dialog" aria-labelledby="returnModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="returnModalLabel">Return Book</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Are you sure you want to return this book?
                <div id="returnBookDetails" class="mt-3"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="confirmReturnBtn">Return Book</button>
            </div>
        </div>
    </div>
</div>

<!-- Renew Book Modal -->
<div class="modal fade" id="renewModal" tabindex="-1" role="dialog" aria-labelledby="renewModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="renewModalLabel">Renew Book</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div id="renewBookDetails" class="mb-3"></div>
                <div class="form-group">
                    <label for="renewalDays">Renewal Period (Days)</label>
                    <input type="number" class="form-control" id="renewalDays" min="1" max="30" value="14">
                    <small class="form-text text-muted">Default renewal period is 14 days.</small>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="confirmRenewBtn">Renew Book</button>
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

        // Load transactions on page load
        loadActiveTransactions();

        // Load appropriate tab content when tab is clicked
        $('#transactionTabs a').on('click', function (e) {
            e.preventDefault();
            $(this).tab('show');

            if ($(this).attr('id') === 'active-tab') {
                loadActiveTransactions();
            } else if ($(this).attr('id') === 'overdue-tab') {
                loadOverdueTransactions();
            }
        });
    });

    function loadActiveTransactions() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/transactions',
            type: 'GET',
            success: function(transactions) {
                updateActiveTransactionsTable(transactions);
            },
            error: function(xhr, status, error) {
                console.error('Error loading transactions:', error);
                $('#activeTransactionsTableBody').html('<tr><td colspan="7" class="text-center">Failed to load transactions. Please try again later.</td></tr>');
            }
        });
    }

    function loadOverdueTransactions() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/transactions/overdue',
            type: 'GET',
            success: function(transactions) {
                updateOverdueTransactionsTable(transactions);
            },
            error: function(xhr, status, error) {
                console.error('Error loading overdue transactions:', error);
                $('#overdueTransactionsTableBody').html('<tr><td colspan="7" class="text-center">Failed to load overdue transactions. Please try again later.</td></tr>');
            }
        });
    }

    function updateActiveTransactionsTable(transactions) {
        const tableBody = $('#activeTransactionsTableBody');
        tableBody.empty();

        if (transactions.length === 0) {
            tableBody.append('<tr><td colspan="7" class="text-center">No active transactions found</td></tr>');
            return;
        }

        transactions.forEach(function(transaction) {
            const checkoutDate = formatDate(transaction.checkOutDate);
            const dueDate = formatDate(transaction.dueDate);
            const daysLeft = transaction.daysLeft;

            // Escape single quotes in book title
            const escapedTitle = transaction.bookTitle.replace(/'/g, "\\'");

            const row = `
                    <tr>
                        <td>\${transaction.transactionId}</td>
                        <td>\${transaction.bookTitle}</td>
                        <td>\${transaction.memberName}</td>
                        <td>\${checkoutDate}</td>
                        <td>\${dueDate}</td>
                        <td>
                            <span class="badge badge-\${daysLeft <= 3 ? 'warning' : 'info'}">
                                \${daysLeft} days left
                            </span>
                        </td>
                        <td>
                            <div class="btn-group btn-group-sm">
                                <button type="button" class="btn btn-success" onclick="returnBook(\${transaction.transactionId}, '\${escapedTitle}')">
                                     <i class="fas fa-undo"></i> Return
                                </button>
                                <button type="button" class="btn btn-info" onclick="renewBook(\${transaction.transactionId}, '\${escapedTitle}', '\${dueDate}')">
                                    <i class="fas fa-sync"></i> Renew
                                </button>
                            </div>
                        </td>
                    </tr>
                `;
            tableBody.append(row);
        });
    }

    function updateOverdueTransactionsTable(transactions) {
        const tableBody = $('#overdueTransactionsTableBody');
        tableBody.empty();

        if (transactions.length === 0) {
            tableBody.append('<tr><td colspan="7" class="text-center">No overdue transactions found</td></tr>');
            return;
        }

        transactions.forEach(function(transaction) {
            const checkoutDate = formatDate(transaction.checkOutDate);
            const dueDate = formatDate(transaction.dueDate);
            const daysOverdue = transaction.daysOverdue;

            // Escape single quotes in book title
            const escapedTitle = transaction.bookTitle.replace(/'/g, "\\'");

            const row = `
                    <tr>
                        <td>\${transaction.transactionId}</td>
                        <td>\${transaction.bookTitle}</td>
                        <td>\${transaction.memberName}</td>
                        <td>\${checkoutDate}</td>
                        <td>\${dueDate}</td>
                        <td>
                            <span class="badge badge-danger">
                                \${daysOverdue} days overdue
                            </span>
                        </td>
                        <td>
                            <div class="btn-group btn-group-sm">
                                <button type="button" class="btn btn-success" onclick="returnBook(\${transaction.transactionId}, '\${escapedTitle}')">
                                    <i class="fas fa-undo"></i> Return
                                </button>
                            </div>
                        </td>
                    </tr>
                `;
            tableBody.append(row);
        });
    }

    function returnBook(transactionId, bookTitle) {
        $('#returnBookDetails').html(`<strong>Book:</strong> \${bookTitle}`);
        $('#returnModal').modal('show');

        $('#confirmReturnBtn').off('click').on('click', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/transactions/' + transactionId + '/return',
                type: 'POST',
                success: function(response) {
                    $('#returnModal').modal('hide');
                    alert('Book returned successfully!');
                    loadActiveTransactions();
                    loadOverdueTransactions();
                },
                error: function(xhr, status, error) {
                    $('#returnModal').modal('hide');
                    console.error('Error returning book:', error);
                    alert('Failed to return book. Please try again later.');
                }
            });
        });
    }

    function renewBook(transactionId, bookTitle, currentDueDate) {
        $('#renewBookDetails').html(`
                <p><strong>Book:</strong> \${bookTitle}</p>
                <p><strong>Current Due Date:</strong> \${currentDueDate}</p>
            `);
        $('#renewModal').modal('show');

        $('#confirmRenewBtn').off('click').on('click', function() {
            const renewalDays = $('#renewalDays').val();

            $.ajax({
                url: '${pageContext.request.contextPath}/api/transactions/' + transactionId + '/renew',
                type: 'POST',
                data: { additionalDays: renewalDays },
                success: function(response) {
                    $('#renewModal').modal('hide');

                    if (response) {
                        const newDueDate = formatDate(response.dueDate);
                        alert(`Book renewed successfully! New due date: \${newDueDate}`);
                        loadActiveTransactions();
                    } else {
                        alert('Failed to renew book. It may be overdue.');
                    }
                },
                error: function(xhr, status, error) {
                    $('#renewModal').modal('hide');
                    console.error('Error renewing book:', error);
                    alert('Failed to renew book. It may be overdue or already returned.');
                }
            });
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