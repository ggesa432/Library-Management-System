<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Register</title>
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
                    <li class="breadcrumb-item active" aria-current="page">Register User</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">Register New User</h5>
                </div>
                <div class="card-body">
                    <form id="registerForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="username">Username <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username" required>
                                    <small id="usernameHelp" class="form-text text-muted">Username must be unique and at least 5 characters.</small>
                                </div>

                                <div class="form-group">
                                    <label for="password">Password <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                    <small id="passwordHelp" class="form-text text-muted">Password must be at least 8 characters and include letters and numbers.</small>
                                </div>

                                <div class="form-group">
                                    <label for="confirmPassword">Confirm Password <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
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
                            <input type="checkbox" class="form-check-input" id="active" name="active" checked>
                            <label class="form-check-label" for="active">Active Account</label>
                        </div>

                        <div class="text-right mt-3">
                            <button type="button" class="btn btn-secondary mr-2" onclick="window.location.href='${pageContext.request.contextPath}/users'">Cancel</button>
                            <button type="submit" class="btn btn-success">Register User</button>
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
        $('#registerForm').submit(function(e) {
            e.preventDefault();
            registerUser();
        });

        // Real-time validation
        $('#username').blur(function() {
            checkUsernameAvailability();
        });

        $('#email').blur(function() {
            checkEmailAvailability();
        });

        $('#confirmPassword').blur(function() {
            validatePasswordMatch();
        });
    });

    function registerUser() {
        // Validate form
        if (!validateForm()) {
            return;
        }

        // Create user object
        const userData = {
            username: $('#username').val(),
            password: $('#password').val(),
            email: $('#email').val(),
            firstName: $('#firstName').val(),
            lastName: $('#lastName').val(),
            phone: $('#phone').val(),
            address: $('#address').val(),
            dateOfBirth: $('#dateOfBirth').val() || null,
            role: $('#role').val(),
            active: $('#active').is(':checked')
        };

        // Send API request
        $.ajax({
            url: '/api/users/register',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(userData),
            success: function(response) {
                alert('User registered successfully!');
                window.location.href = '${pageContext.request.contextPath}/users';
            },
            error: function(xhr, status, error) {
                console.error('Error registering user:', error);

                let errorMessage = 'Failed to register user.';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMessage += ' ' + xhr.responseJSON.message;
                }

                alert(errorMessage);
            }
        });
    }

    function validateForm() {
        // Username validation
        const username = $('#username').val();
        if (!username || username.length < 5) {
            alert('Username must be at least 5 characters long.');
            $('#username').focus();
            return false;
        }

        // Password validation
        const password = $('#password').val();
        if (!password || password.length < 8 || !(/[a-zA-Z]/.test(password) && /[0-9]/.test(password))) {
            alert('Password must be at least 8 characters and include both letters and numbers.');
            $('#password').focus();
            return false;
        }

        // Password confirmation
        if (password !== $('#confirmPassword').val()) {
            alert('Passwords do not match.');
            $('#confirmPassword').focus();
            return false;
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

    function checkUsernameAvailability() {
        const username = $('#username').val();

        if (!username || username.length < 5) {
            return;
        }

        $.ajax({
            url: '/api/users/check-username?username=' + encodeURIComponent(username),
            type: 'GET',
            success: function(response) {
                if (response.available === false) {
                    $('#usernameHelp').html('<span class="text-danger">Username already taken</span>');
                } else {
                    $('#usernameHelp').html('<span class="text-success">Username available</span>');
                }
            },
            error: function() {
                $('#usernameHelp').text('Username must be unique and at least 5 characters.');
            }
        });
    }

    function checkEmailAvailability() {
        const email = $('#email').val();

        if (!email || !isValidEmail(email)) {
            return;
        }

        $.ajax({
            url: '/api/users/check-email?email=' + encodeURIComponent(email),
            type: 'GET',
            success: function(response) {
                if (response.available === false) {
                    $('#email').next('.invalid-feedback').remove();
                    $('#email').addClass('is-invalid');
                    $('#email').after('<div class="invalid-feedback">Email already registered</div>');
                } else {
                    $('#email').removeClass('is-invalid').addClass('is-valid');
                }
            },
            error: function() {
                $('#email').removeClass('is-invalid is-valid');
            }
        });
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
</script>
</body>
</html>