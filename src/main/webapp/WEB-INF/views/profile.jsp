<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - My Profile</title>
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
                    <li class="breadcrumb-item active" aria-current="page">My Profile</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4">
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Profile Information</h5>
                </div>
                <div class="card-body text-center">
                    <div class="mb-3">
                        <div class="display-1 text-primary">
                            <i class="fas fa-user-circle"></i>
                        </div>
                    </div>
                    <h4 id="userName">Loading...</h4>
                    <p id="userRole" class="badge badge-info mb-0">Role</p>

                    <hr>

                    <div class="text-left">
                        <p><strong>Username:</strong> <span id="username"></span></p>
                        <p><strong>Email:</strong> <span id="email"></span></p>
                        <p><strong>Registered:</strong> <span id="registrationDate"></span></p>
                        <p><strong>Last Login:</strong> <span id="lastLoginDate"></span></p>
                    </div>

                    <button id="editProfileBtn" class="btn btn-primary btn-block mt-3">
                        <i class="fas fa-edit"></i> Edit Profile
                    </button>
                    <button id="changePasswordBtn" class="btn btn-secondary btn-block">
                        <i class="fas fa-key"></i> Change Password
                    </button>
                </div>
            </div>

            <sec:authorize access="hasRole('USER')">
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Library Activity</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Current Borrowings:</strong> <span id="activeBorrowings">0</span></p>
                        <p><strong>Overdue Books:</strong> <span id="overdueBooks">0</span></p>
                        <p><strong>Member Since:</strong> <span id="memberSince"></span></p>

                        <a href="${pageContext.request.contextPath}/member-borrowings" class="btn btn-info btn-block">
                            <i class="fas fa-book"></i> View My Borrowings
                        </a>
                    </div>
                </div>
            </sec:authorize>
        </div>

        <div class="col-md-8">
            <!-- Profile Information Form -->
            <div id="profileInfo" class="card mb-4">
                <div class="card-header bg-light">
                    <h5 class="mb-0">Personal Information</h5>
                </div>
                <div class="card-body">
                    <form id="profileForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="firstName">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="lastName">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="profileEmail">Email</label>
                            <input type="email" class="form-control" id="profileEmail" name="email" readonly>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="text" class="form-control" id="phone" name="phone" readonly>
                        </div>

                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea class="form-control" id="address" name="address" rows="3" readonly></textarea>
                        </div>

                        <div class="form-group">
                            <label for="dateOfBirth">Date of Birth</label>
                            <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" readonly>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Edit Profile Form (initially hidden) -->
            <div id="editProfileForm" class="card mb-4" style="display: none;">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0">Edit Profile Information</h5>
                </div>
                <div class="card-body">
                    <form id="editForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="editFirstName">First Name</label>
                                    <input type="text" class="form-control" id="editFirstName" name="firstName">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="editLastName">Last Name</label>
                                    <input type="text" class="form-control" id="editLastName" name="lastName">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="editEmail">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="editEmail" name="email" required>
                        </div>

                        <div class="form-group">
                            <label for="editPhone">Phone</label>
                            <input type="text" class="form-control" id="editPhone" name="phone">
                        </div>

                        <div class="form-group">
                            <label for="editAddress">Address</label>
                            <textarea class="form-control" id="editAddress" name="address" rows="3"></textarea>
                        </div>

                        <div class="form-group">
                            <label for="editDateOfBirth">Date of Birth</label>
                            <input type="date" class="form-control" id="editDateOfBirth" name="dateOfBirth">
                        </div>

                        <div class="text-right">
                            <button type="button" id="cancelEditBtn" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-warning">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Change Password Form (initially hidden) -->
            <div id="changePasswordForm" class="card mb-4" style="display: none;">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0">Change Password</h5>
                </div>
                <div class="card-body">
                    <form id="passwordForm">
                        <div class="form-group">
                            <label for="currentPassword">Current Password <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                        </div>

                        <div class="form-group">
                            <label for="newPassword">New Password <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                            <small class="form-text text-muted">Password must be at least 8 characters and include both letters and numbers.</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmNewPassword">Confirm New Password <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
                        </div>

                        <div class="text-right">
                            <button type="button" id="cancelPasswordBtn" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update Password</button>
                        </div>
                    </form>
                </div>
            </div>

            <sec:authorize access="hasRole('USER')">
                <!-- User's Borrowing History -->
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">Recent Borrowings</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead class="thead-light">
                                <tr>
                                    <th>Book Title</th>
                                    <th>Checkout Date</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                </tr>
                                </thead>
                                <tbody id="borrowingHistoryTable">
                                <!-- Will be populated dynamically -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer text-center">
                        <a href="${pageContext.request.contextPath}/member-borrowings" class="btn btn-info">
                            View Full Borrowing History
                        </a>
                    </div>
                </div>
            </sec:authorize>
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

        // Load user profile
        loadUserProfile();

        // For users with the USER role, load their member info
        loadMemberInfo();

        // Button events
        $('#editProfileBtn').click(function() {
            showEditForm();
        });

        $('#cancelEditBtn').click(function() {
            hideEditForm();
        });

        $('#changePasswordBtn').click(function() {
            showPasswordForm();
        });

        $('#cancelPasswordBtn').click(function() {
            hidePasswordForm();
        });

        // Form submissions
        $('#editForm').submit(function(e) {
            e.preventDefault();
            updateProfile();
        });

        $('#passwordForm').submit(function(e) {
            e.preventDefault();
            updatePassword();
        });
    });

    function loadUserProfile() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/users/profile',
            type: 'GET',
            success: function(user) {
                // Update the profile information
                $('#userName').text(user.firstName + ' ' + user.lastName);
                $('#userRole').text(user.role || 'USER');
                $('#username').text(user.username);
                $('#email').text(user.email);
                $('#profileEmail').val(user.email);

                // Set form fields
                $('#firstName').val(user.firstName);
                $('#lastName').val(user.lastName);
                $('#phone').val(user.phone);
                $('#address').val(user.address);

                // Set edit form fields
                $('#editFirstName').val(user.firstName);
                $('#editLastName').val(user.lastName);
                $('#editEmail').val(user.email);
                $('#editPhone').val(user.phone);
                $('#editAddress').val(user.address);

                // Format and display dates
                $('#registrationDate').text(formatDate(user.registrationDate) || 'N/A');
                $('#lastLoginDate').text(user.lastLoginDate || 'Never');

                // Set date of birth if exists
                if (user.dateOfBirth) {
                    const date = new Date(user.dateOfBirth);
                    if (!isNaN(date.getTime())) {
                        const year = date.getFullYear();
                        const month = String(date.getMonth() + 1).padStart(2, '0');
                        const day = String(date.getDate()).padStart(2, '0');

                        $('#dateOfBirth').val(`\${year}-\${month}-\${day}`);
                        $('#editDateOfBirth').val(`\${year}-\${month}-\${day}`);
                    }
                }
            },
            error: function(xhr, status, error) {
                console.error('Error loading user profile:', error);
                alert('Failed to load user profile. Please try again later.');
            }
        });
    }

    function loadMemberInfo() {
        // Only attempt to load member info for users with the USER role
        if ($('#userRole').text() === 'USER') {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/members/current',
                type: 'GET',
                success: function(member) {
                    if (member) {
                        // Set member info
                        $('#memberSince').text(formatDate(member.membershipDate) || 'N/A');

                        // Load borrowing history
                        loadBorrowingHistory(member.memberId);

                        // Check active borrowings and overdue books
                        checkActiveBorrowings(member.memberId);
                        checkOverdueBooks(member.memberId);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading member info:', error);
                }
            });
        }
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
                $('#borrowingHistoryTable').html('<tr><td colspan="4" class="text-center">Failed to load borrowing history</td></tr>');
            }
        });
    }

    function updateBorrowingHistoryTable(transactions) {
        const tableBody = $('#borrowingHistoryTable');
        tableBody.empty();

        if (transactions.length === 0) {
            tableBody.append('<tr><td colspan="4" class="text-center">No borrowing history found</td></tr>');
            return;
        }

        // Only show the most recent 5 transactions
        const recentTransactions = transactions.slice(0, 5);

        recentTransactions.forEach(function(transaction) {
            const checkoutDate = formatDate(transaction.checkOutDate);
            const dueDate = formatDate(transaction.dueDate);

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
                        <td><span class="badge \${statusClass}">\${status}</span></td>
                    </tr>
                `;
            tableBody.append(row);
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

    function showEditForm() {
        $('#profileInfo').hide();
        $('#changePasswordForm').hide();
        $('#editProfileForm').show();
    }

    function hideEditForm() {
        $('#editProfileForm').hide();
        $('#profileInfo').show();
    }

    function showPasswordForm() {
        $('#profileInfo').hide();
        $('#editProfileForm').hide();
        $('#changePasswordForm').show();
    }

    function hidePasswordForm() {
        $('#changePasswordForm').hide();
        $('#profileInfo').show();
    }

    function updateProfile() {
        const userData = {
            firstName: $('#editFirstName').val(),
            lastName: $('#editLastName').val(),
            email: $('#editEmail').val(),
            phone: $('#editPhone').val(),
            address: $('#editAddress').val(),
            dateOfBirth: $('#editDateOfBirth').val() || null
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/api/users/profile',
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify(userData),
            success: function(response) {
                alert('Profile updated successfully!');
                hideEditForm();
                loadUserProfile();
            },
            error: function(xhr, status, error) {
                console.error('Error updating profile:', error);
                alert('Failed to update profile. Please try again later.');
            }
        });
    }

    function updatePassword() {
        const currentPassword = $('#currentPassword').val();
        const newPassword = $('#newPassword').val();
        const confirmNewPassword = $('#confirmNewPassword').val();

        // Validate passwords
        if (!currentPassword || !newPassword || !confirmNewPassword) {
            alert('All fields are required.');
            return;
        }

        if (newPassword !== confirmNewPassword) {
            alert('New passwords do not match.');
            return;
        }

        if (newPassword.length < 8 || !(/[a-zA-Z]/.test(newPassword) && /[0-9]/.test(newPassword))) {
            alert('Password must be at least 8 characters and include both letters and numbers.');
            return;
        }

        const passwordData = {
            currentPassword: currentPassword,
            newPassword: newPassword
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/api/users/change-password',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(passwordData),
            success: function(response) {
                alert('Password updated successfully!');
                hidePasswordForm();

                // Clear password fields
                $('#currentPassword').val('');
                $('#newPassword').val('');
                $('#confirmNewPassword').val('');
            },
            error: function(xhr, status, error) {
                console.error('Error updating password:', error);

                if (xhr.status === 400) {
                    alert('Current password is incorrect.');
                } else {
                    alert('Failed to update password. Please try again later.');
                }
            }
        });
    }

    function formatDate(dateString) {
        if (!dateString) return 'N/A';

        try {
            // For date-only strings (like "2023-11-21"), handle timezone properly
            if (dateString.includes('T')) {
                // If it's a full timestamp, use standard formatting
                const date = new Date(dateString);
                const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
                return date.toLocaleDateString('en-US', options);
            } else {
                // For date-only, split and format manually to avoid timezone issues
                const [year, month, day] = dateString.split('-');
                return `${month}/${day}/${year}`;
            }
        } catch (e) {
            console.error("Error formatting date:", e);
            return 'N/A';
        }
    }
</script>
</body>
</html>