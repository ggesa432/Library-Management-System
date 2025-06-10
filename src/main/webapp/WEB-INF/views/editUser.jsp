<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Edit User</title>
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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/users">Users</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Edit User</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0">Edit User Profile</h5>
                </div>
                <div class="card-body">
                    <form id="editUserForm">
                        <input type="hidden" id="userId" name="userId">

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="username">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" readonly>
                                    <small class="form-text text-muted">Username cannot be changed</small>
                                </div>

                                <div class="form-group">
                                    <label for="password">New Password</label>
                                    <input type="password" class="form-control" id="password" name="password">
                                    <small id="passwordHelp" class="form-text text-muted">Leave blank to keep current password</small>
                                </div>

                                <div class="form-group">
                                    <label for="confirmPassword">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                                </div>

                                <div class="form-group">
                                    <label for="email">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>

                                <div class="form-group">
                                    <label for="role">Role <span class="text-danger">*</span></label>
                                    <select class="form-control" id="role" name="role" required>
                                        <option value="USER">Regular User</option>
                                        <option value="LIBRARIAN">Librarian</option>
                                        <option value="ADMIN">Administrator</option>
                                    </select>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="firstName">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName">
                                </div>

                                <div class="form-group">
                                    <label for="lastName">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName">
                                </div>

                                <div class="form-group">
                                    <label for="phone">Phone</label>
                                    <input type="text" class="form-control" id="phone" name="phone">
                                </div>

                                <div class="form-group">
                                    <label for="address">Address</label>
                                    <textarea class="form-control" id="address" name="address" rows="3"></textarea>
                                </div>

                                <div class="form-group">
                                    <label for="dateOfBirth">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth">
                                </div>
                            </div>
                        </div>

                        <div class="form-group form-check">
                            <input type="checkbox" class="form-check-input" id="active" name="active">
                            <label class="form-check-label" for="active">Active Account</label>
                        </div>

                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="card bg-light mb-3">
                                    <div class="card-body">
                                        <h6 class="card-title">Account Information</h6>
                                        <p class="card-text mb-1"><strong>Registration Date:</strong> <span id="registrationDate"></span></p>
                                        <p class="card-text mb-1"><strong>Last Login:</strong> <span id="lastLoginDate"></span></p>
                                        <p class="card-text mb-0"><strong>Member ID:</strong> <span id="memberId"></span></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 text-right">
                                <button type="button" class="btn btn-secondary mr-2" onclick="window.location.href='${pageContext.request.contextPath}/users'">Cancel</button>
                                <button type="submit" class="btn btn-warning">Update User</button>
                            </div>
                        </div>
                    </form>
                </div>
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
        // Get CSRF token and header
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");

        // Configure jQuery AJAX globally to send CSRF token with all requests
        $(document).ajaxSend(function(e, xhr, options) {
            if (token && header) {
                xhr.setRequestHeader(header, token);
            }
        });
        // Get user ID from URL parameter
        const urlParams = new URLSearchParams(window.location.search);
        const userId = urlParams.get('id');

        if (!userId) {
            alert('User ID is missing!');
            window.location.href = '${pageContext.request.contextPath}/users';
            return;
        }

        // Load user details
        loadUserDetails(userId);

        $('#editUserForm').submit(function(e) {
            e.preventDefault();
            updateUser();
        });

        $('#confirmPassword').blur(function() {
            validatePasswordMatch();
        });
    });

    function loadUserDetails(userId) {
        $.ajax({
            url: '/api/users/' + userId,
            type: 'GET',
            success: function(user) {
                // Set form fields
                $('#userId').val(user.userId);
                $('#username').val(user.username);
                $('#email').val(user.email);
                $('#firstName').val(user.firstName);
                $('#lastName').val(user.lastName);
                $('#phone').val(user.phone);
                $('#address').val(user.address);
                $('#role').val(user.role);
                $('#active').prop('checked', user.active);

                // Set date of birth if exists
                if (user.dateOfBirth) {

                    let dateToDisplay = '';

                    // If it's already in YYYY-MM-DD format
                    if (typeof user.dateOfBirth === 'string' && user.dateOfBirth.match(/^\d{4}-\d{2}-\d{2}$/)) {
                        dateToDisplay = user.dateOfBirth;
                    } else {
                        // If it's a date object or other format, try to parse it
                        try {
                            const date = new Date(user.dateOfBirth);

                            if (!isNaN(date.getTime())) {
                                // Valid date - format it for the date input (YYYY-MM-DD)
                                const year = date.getFullYear();
                                const month = String(date.getMonth() + 1).padStart(2, '0');
                                const day = String(date.getDate()).padStart(2, '0');
                                dateToDisplay = `${year}-${month}-${day}`;
                            } else {
                                console.warn("Invalid date received:", user.dateOfBirth);
                            }
                        } catch (e) {
                            console.error("Error parsing date:", user.dateOfBirth, e);
                        }
                    }

                    // Set the value and also log what we're setting
                    $('#dateOfBirth').val(dateToDisplay);

                    // Also set a data attribute to track the original value
                    $('#dateOfBirth').attr('data-original', user.dateOfBirth);
                }

                // Set account information
                if (user.registrationDate) {
                    $('#registrationDate').text(formatDate(user.registrationDate));
                } else {
                    $('#registrationDate').text('N/A');
                }

                if (user.lastLoginDate) {
                    $('#lastLoginDate').text(formatDate(user.lastLoginDate));
                } else {
                    $('#lastLoginDate').text('Never');
                }

                if (user.memberId) {
                    $('#memberId').text(user.memberId);
                } else {
                    $('#memberId').text('N/A');
                }
            },
            error: function(xhr, status, error) {
                console.error('Error loading user details:', error);
                alert('Failed to load user details. Please try again later.');
                window.location.href = '${pageContext.request.contextPath}/users';
            }
        });
    }

    function updateUser() {
        // Format dates properly before sending
        const dateOfBirth = $('#dateOfBirth').val();

        const userData = {
            userId: $('#userId').val(),
            username: $('#username').val(),
            email: $('#email').val(),
            firstName: $('#firstName').val(),
            lastName: $('#lastName').val(),
            phone: $('#phone').val(),
            address: $('#address').val(),
            role: $('#role').val(),
            active: $('#active').is(':checked'),
            // Format the date properly
            dateOfBirth: dateOfBirth ? dateOfBirth : null
        };

        // If password is provided, add it
        const password = $('#password').val();
        if (password) {
            userData.password = password;
        }

        console.log("Sending user data:", userData);

        $.ajax({
            url: '${pageContext.request.contextPath}/api/users/' + $('#userId').val(),
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify(userData),
            beforeSend: function(xhr) {
                const token = $("meta[name='_csrf']").attr("content");
                const header = $("meta[name='_csrf_header']").attr("content");
                if (token && header) {
                    xhr.setRequestHeader(header, token);
                }
            },
            success: function(response) {
                alert('User updated successfully!');
                window.location.href = '${pageContext.request.contextPath}/users';
            },
            error: function(xhr, status, error) {
                console.error('Error updating user:', error);
                console.error('Response:', xhr.responseText);
                alert('Failed to update user. ' + (xhr.responseJSON?.message || error));
            }
        });
    }

    // If dateOfBirth is from a date input field, it should already be in YYYY-MM-DD format
    const dateOfBirth = $('#dateOfBirth').val();

    // If you need to manually format a date
    function formatDateForApi(dateString) {
        if (!dateString) return null;

        try {
            const date = new Date(dateString);
            return date.toISOString().split('T')[0]; // Get YYYY-MM-DD part
        } catch (e) {
            console.error("Error formatting date:", e);
            return null;
        }
    }
    function validateForm() {
        // Password validation if provided
        const password = $('#password').val();
        const confirmPassword = $('#confirmPassword').val();

        if (password) {
            if (password.length < 8 || !(/[a-zA-Z]/.test(password) && /[0-9]/.test(password))) {
                alert('Password must be at least 8 characters and include both letters and numbers.');
                $('#password').focus();
                return false;
            }

            if (password !== confirmPassword) {
                alert('Passwords do not match.');
                $('#confirmPassword').focus();
                return false;
            }
        }

        // Email validation
        const email = $('#email').val();
        if (!email || !isValidEmail(email)) {
            alert('Please enter a valid email address.');
            $('#email').focus();
            return false;
        }

        return true;
    }

    function isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    function validatePasswordMatch() {
        const password = $('#password').val();
        const confirmPassword = $('#confirmPassword').val();

        if (password && confirmPassword) {
            if (password !== confirmPassword) {
                $('#confirmPassword').next('.invalid-feedback').remove();
                $('#confirmPassword').addClass('is-invalid');
                $('#confirmPassword').after('<div class="invalid-feedback">Passwords do not match</div>');
            } else {
                $('#confirmPassword').removeClass('is-invalid').addClass('is-valid');
            }
        }
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