<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Fines</title>
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
            <h2>Fine Management</h2>
        </div>
        <div class="col-md-6 text-right">
            <sec:authorize access="hasRole('ADMIN')">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#configModal">
                    <i class="fas fa-cog"></i> Fee Configuration
                </button>
            </sec:authorize>
        </div>
    </div>

    <!-- Tab Navigation -->
    <ul class="nav nav-tabs" id="finesTabs" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="all-tab" data-toggle="tab" href="#all" role="tab" aria-controls="all" aria-selected="true" onclick="loadAllFines()">
                All Fines
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="pending-tab" data-toggle="tab" href="#pending" role="tab" aria-controls="pending" aria-selected="false" onclick="loadPendingFines()">
                Pending Fines
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="paid-tab" data-toggle="tab" href="#paid" role="tab" aria-controls="paid" aria-selected="false" onclick="loadPaidFines()">
                Paid Fines
            </a>
        </li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content">
        <!-- Fine List -->
        <div class="tab-pane fade show active" id="all" role="tabpanel" aria-labelledby="all-tab">
            <div class="card">
                <div class="card-header bg-light">
                    <h5 class="mb-0">All Fines</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="thead-light">
                            <tr>
                                <th>ID</th>
                                <th>Member</th>
                                <th>Book</th>
                                <th>Amount</th>
                                <th>Reason</th>
                                <th>Issue Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody id="allFinesTableBody">
                            <!-- All fines will be loaded here -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="pending" role="tabpanel" aria-labelledby="pending-tab">
            <div class="card">
                <div class="card-header bg-light">
                    <h5 class="mb-0">Pending Fines</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="thead-light">
                            <tr>
                                <th>ID</th>
                                <th>Member</th>
                                <th>Book</th>
                                <th>Amount</th>
                                <th>Reason</th>
                                <th>Issue Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody id="pendingFinesTableBody">
                            <!-- Pending fines will be loaded here -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="paid" role="tabpanel" aria-labelledby="paid-tab">
            <div class="card">
                <div class="card-header bg-light">
                    <h5 class="mb-0">Paid Fines</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="thead-light">
                            <tr>
                                <th>ID</th>
                                <th>Member</th>
                                <th>Book</th>
                                <th>Amount</th>
                                <th>Reason</th>
                                <th>Issue Date</th>
                                <th>Payment Date</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody id="paidFinesTableBody">
                            <!-- Paid fines will be loaded here -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Fee Configuration Modal -->
<div class="modal fade" id="configModal" tabindex="-1" role="dialog" aria-labelledby="configModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="configModalLabel">Fee Configuration</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead class="thead-light">
                        <tr>
                            <th>Setting</th>
                            <th>Value</th>
                            <th>Description</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody id="configTableBody">
                        <!-- Config will be loaded here -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Edit Config Modal -->
<div class="modal fade" id="editConfigModal" tabindex="-1" role="dialog" aria-labelledby="editConfigModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editConfigModalLabel">Edit Configuration</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="editConfigForm">
                    <input type="hidden" id="configKey" name="configKey">
                    <div class="form-group">
                        <label for="configValue">Value</label>
                        <input type="text" class="form-control" id="configValue" name="configValue">
                    </div>
                    <div class="form-group">
                        <label for="configDescription">Description</label>
                        <textarea class="form-control" id="configDescription" name="configDescription" readonly></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveConfigBtn">Save Changes</button>
            </div>
        </div>
    </div>
</div>

<!-- Pay Fine Modal -->
<div class="modal fade" id="payFineModal" tabindex="-1" role="dialog" aria-labelledby="payFineModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="payFineModalLabel">Pay Fine</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to mark this fine as paid?</p>
                <div id="fineDetails"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-success" id="confirmPayBtn">Mark as Paid</button>
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

        // Load all fines on page load
        loadAllFines();

        // Load configuration on modal show
        $('#configModal').on('show.bs.modal', function() {
            loadConfigurations();
        });

        // Save config button
        $('#saveConfigBtn').click(function() {
            updateConfiguration();
        });

        // Confirm pay button
        $('#confirmPayBtn').click(function() {
            const fineId = $(this).data('fineId');
            payFine(fineId);
        });
    });

    function loadAllFines() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/fines/all',
            type: 'GET',
            success: function(fines) {
                console.log('Received all fines data:', JSON.stringify(fines, null, 2));
                updateAllFinesTable(fines);
            },
            error: function(xhr, status, error) {
                console.error('Error loading all fines:', error);
                alert('Failed to load fines. Please try again later.');
            }
        });
    }

    function loadPendingFines() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/fines/pending',
            type: 'GET',
            success: function(fines) {
                console.log('Received pending fines data:', JSON.stringify(fines, null, 2));
                updatePendingFinesTable(fines);
            },
            error: function(xhr, status, error) {
                console.error('Error loading pending fines:', error);
                alert('Failed to load pending fines. Please try again later.');
            }
        });
    }

    function loadPaidFines() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/fines/paid',
            type: 'GET',
            success: function(fines) {
                console.log('Received paid fines data:', JSON.stringify(fines, null, 2));
                updatePaidFinesTable(fines);
            },
            error: function(xhr, status, error) {
                console.error('Error loading paid fines:', error);
                alert('Failed to load paid fines. Please try again later.');
            }
        });
    }

    function updateAllFinesTable(fines) {
        const tableBody = $('#allFinesTableBody');
        tableBody.empty();

        if (fines.length === 0) {
            tableBody.append('<tr><td colspan="8" class="text-center">No fines found</td></tr>');
            return;
        }

        fines.forEach(function(fine) {
            const issueDate = formatDate(fine.issueDate);

            // Handle potential null values
            const memberName = fine.member ? `\${fine.member.firstName} \${fine.member.lastName}` : 'N/A';
            let bookTitle = 'N/A';

            if (fine.transaction && fine.transaction.book) {
                bookTitle = `\${fine.transaction.book.title}`;
            } else if (fine.reason && fine.reason.includes("Membership Fee")) {
                bookTitle = 'N/A (Membership Fee)';
            }

            const statusBadge = fine.status === 'PENDING'
                ? '<span class="badge badge-warning">PENDING</span>'
                : '<span class="badge badge-success">PAID</span>';

            const actions = fine.status === 'PENDING'
                ? `<button type="button" class="btn btn-sm btn-success" onclick="showPayFineModal(\${fine.fineId}, \${fine.amount})">
                     <i class="fas fa-money-bill-wave"></i> Pay
                   </button>`
                : '<span class="text-muted">Paid</span>';

            const row = `
            <tr>
                <td>\${fine.fineId}</td>
                <td>\${memberName}</td>
                <td>\${bookTitle}</td>
                <td>$\${fine.amount.toFixed(2)}</td>
                <td>\${fine.reason}</td>
                <td>\${issueDate}</td>
                <td>\${statusBadge}</td>
                <td>\${actions}</td>
            </tr>
        `;
            tableBody.append(row);
        });
    }

    function updatePendingFinesTable(fines) {
        const tableBody = $('#pendingFinesTableBody');
        tableBody.empty();

        if (fines.length === 0) {
            tableBody.append('<tr><td colspan="8" class="text-center">No pending fines found</td></tr>');
            return;
        }

        fines.forEach(function(fine) {
            const issueDate = formatDate(fine.issueDate);

            // Handle potential null values
            const memberName = fine.member ? `\${fine.member.firstName} \${fine.member.lastName}` : 'N/A';
            let bookTitle = 'N/A';

            if (fine.transaction && fine.transaction.book) {
                bookTitle = `\${fine.transaction.book.title}`;
            } else if (fine.reason && fine.reason.includes("Membership Fee")) {
                bookTitle = 'N/A (Membership Fee)';
            }

            const row = `
            <tr>
                <td>\${fine.fineId}</td>
                <td>\${memberName}</td>
                <td>\${bookTitle}</td>
                <td>$\${fine.amount.toFixed(2)}</td>
                <td>\${fine.reason}</td>
                <td>\${issueDate}</td>
                <td><span class="badge badge-warning">\${fine.status}</span></td>
                <td>
                    <button type="button" class="btn btn-sm btn-success" onclick="showPayFineModal(\${fine.fineId}, \${fine.amount})">
                        <i class="fas fa-money-bill-wave"></i> Pay
                    </button>
                </td>
            </tr>
        `;
            tableBody.append(row);
        });
    }

    function updatePaidFinesTable(fines) {
        const tableBody = $('#paidFinesTableBody');
        tableBody.empty();

        if (fines.length === 0) {
            tableBody.append('<tr><td colspan="8" class="text-center">No paid fines found</td></tr>');
            return;
        }

        fines.forEach(function(fine) {
            const issueDate = formatDate(fine.issueDate);
            const paymentDate = formatDate(fine.paymentDate);

            // Handle potential null values
            const memberName = fine.member ? `\${fine.member.firstName} \${fine.member.lastName}` : 'N/A';
            let bookTitle = 'N/A';

            if (fine.transaction && fine.transaction.book) {
                bookTitle = `\${fine.transaction.book.title}`;
            } else if (fine.reason && fine.reason.includes("Membership Fee")) {
                bookTitle = 'N/A (Membership Fee)';
            }

            const row = `
            <tr>
                <td>\${fine.fineId}</td>
                <td>\${memberName}</td>
                <td>\${bookTitle}</td>
                <td>$\${fine.amount.toFixed(2)}</td>
                <td>\${fine.reason}</td>
                <td>\${issueDate}</td>
                <td>\${paymentDate}</td>
                <td><span class="badge badge-success">\${fine.status}</span></td>
            </tr>
        `;
            tableBody.append(row);
        });
    }

    function loadConfigurations() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/config',
            type: 'GET',
            success: function(configs) {
                updateConfigTable(configs);
            },
            error: function(xhr, status, error) {
                console.error('Error loading configurations:', error);
                alert('Failed to load configurations. Please try again later.');
            }
        });
    }

    function updateConfigTable(configs) {
        const tableBody = $('#configTableBody');
        tableBody.empty();

        if (configs.length === 0) {
            tableBody.append('<tr><td colspan="4" class="text-center">No configurations found</td></tr>');
            return;
        }

        configs.forEach(function(config) {
            let displayValue = config.configValue;

            // Format monetary values
            if (config.configKey === 'DAILY_FINE_RATE' || config.configKey === 'MEMBERSHIP_FEE') {
                displayValue = '$' + parseFloat(config.configValue).toFixed(2);
            }

            const row = `
                    <tr>
                        <td>\${config.configKey}</td>
                        <td>\${displayValue}</td>
                        <td>\${config.description}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-warning"
                                    onclick="showEditConfigModal('\${config.configKey}', '\${config.configValue}', '\${config.description}')">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                        </td>
                    </tr>
                `;
            tableBody.append(row);
        });
    }

    function showEditConfigModal(key, value, description) {
        $('#configKey').val(key);
        $('#configValue').val(value);
        $('#configDescription').val(description);
        $('#editConfigModal').modal('show');
    }

    function updateConfiguration() {
        const configKey = $('#configKey').val();
        const configValue = $('#configValue').val();

        $.ajax({
            url: '${pageContext.request.contextPath}/api/config/' + configKey,
            type: 'PUT',
            data: { value: configValue },
            success: function(response) {
                $('#editConfigModal').modal('hide');
                loadConfigurations();
                showSuccessMessage('Configuration updated successfully');
            },
            error: function(xhr, status, error) {
                console.error('Error updating configuration:', error);
                showErrorMessage('Failed to update configuration. Please try again later.');
                $('#editConfigModal').modal('hide');
            }
        });
    }

    function formatDate(dateString) {
        if (!dateString) return 'N/A';

        const date = new Date(dateString);
        const options = { year: 'numeric', month: 'short', day: 'numeric' };
        return date.toLocaleDateString('en-US', options);
    }

    function showPayFineModal(fineId, amount) {
        // Set the fine ID for the confirm button
        $('#confirmPayBtn').data('fineId', fineId);

        // Show fine details in the modal
        $('#fineDetails').html(`
            <div class="alert alert-info mt-3">
                <strong>Fine ID:</strong> \${fineId}<br>
                <strong>Amount:</strong> $\${amount.toFixed(2)}
            </div>
        `);

        // Show the modal
        $('#payFineModal').modal('show');
    }

    function payFine(fineId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/fines/' + fineId + '/pay',
            type: 'POST',
            success: function(response) {
                $('#payFineModal').modal('hide');
                loadAllFines(); // Reload all fines
                showSuccessMessage('Fine has been successfully marked as paid');
            },
            error: function(xhr, status, error) {
                console.error('Error paying fine:', error);
                showErrorMessage('Failed to pay fine. Please try again later.');
                $('#payFineModal').modal('hide');
            }
        });
    }

    function showSuccessMessage(message) {
        const alertHtml = `
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                \${message}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        `;

        const container = $('.container').first();
        container.prepend(alertHtml);

        // Auto-dismiss after 5 seconds
        setTimeout(function() {
            $('.alert-success').alert('close');
        }, 5000);
    }

    function showErrorMessage(message) {
        const alertHtml = `
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                \${message}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        `;

        const container = $('.container').first();
        container.prepend(alertHtml);

        // Auto-dismiss after 5 seconds
        setTimeout(function() {
            $('.alert-danger').alert('close');
        }, 5000);
    }

    function calculateOverdueDays(dueDate, returnDate) {
        const due = new Date(dueDate);
        const returned = returnDate ? new Date(returnDate) : new Date();

        // Get time difference in milliseconds
        const diffTime = Math.abs(returned - due);

        // Convert to days and return if greater than 0
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return due < returned ? diffDays : 0;
    }
</script>
</body>
</html>