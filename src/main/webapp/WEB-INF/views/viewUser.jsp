<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - View User</title>
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
                    <li class="breadcrumb-item active" aria-current="page">View User</li>
                </ol>
            </nav>
        </div>
    </div>

    <div id="userDetails" class="card">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0">User Details</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <h6 class="border-bottom pb-2 mb-3">Account Information</h6>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Username:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="username"></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Email:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="email"></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Role:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext"><span id="role" class="badge badge-info"></span></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Status:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext"><span id="status" class="badge"></span></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Registration Date:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="registrationDate"></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Last Login:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="lastLoginDate"></p>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <h6 class="border-bottom pb-2 mb-3">Personal Information</h6>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">First Name:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="firstName"></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Last Name:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="lastName"></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Phone:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="phone"></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Address:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="address"></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Date of Birth:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="dateOfBirth"></p>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label font-weight-bold">Member ID:</label>
                        <div class="col-sm-8">
                            <p class="form-control-plaintext" id="memberId"></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="card-footer">
            <div class="text-right">
                <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Users
                </a>
                <a id="editUserBtn" href="#" class="btn btn-warning">
                    <i class="fas fa-edit"></i> Edit User
                </a>
                <button id="deleteUserBtn" class="btn btn-danger">
                    <i class="fas fa-trash"></i> Delete User
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
                Are you sure you want to delete this user? This action cannot be undone.
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

        // Set up edit button
        $('#editUserBtn').click(function() {
            window.location.href = '${pageContext.request.contextPath}/users/edit?id=' + userId;
        });

        // Set up delete button
        $('#deleteUserBtn').click(function() {
            $('#deleteModal').modal('show');
        });

        // Set up confirm delete button
        $('#confirmDeleteBtn').click(function() {
            deleteUser(userId);
        });
    });

    function loadUserDetails(userId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/users/' + userId,
            type: 'GET',
            success: function(user) {
                // Fill in user details
                $('#username').text(user.username);
                $('#email').text(user.email || 'N/A');
                $('#role').text(user.role || 'USER');

                // Set status
                $('#status')
                    .text(user.active ? 'Active' : 'Inactive')
                    .removeClass()
                    .addClass('badge badge-' + (user.active ? 'success' : 'danger'));

                // Format and display dates
                $('#registrationDate').text(formatDate(user.registrationDate) || 'N/A');
                $('#lastLoginDate').text(user.lastLoginDate || 'Never');

                // Personal info
                $('#firstName').text(user.firstName || 'N/A');
                $('#lastName').text(user.lastName || 'N/A');
                $('#phone').text(user.phone || 'N/A');
                $('#address').text(user.address || 'N/A');
                $('#dateOfBirth').text(user.dateOfBirth || 'N/A');
                $('#memberId').text(user.memberId || 'N/A');
            },
            error: function(xhr, status, error) {
                console.error('Error loading user details:', error);
                alert('Failed to load user details. Please try again later.');
                window.location.href = '${pageContext.request.contextPath}/users';
            }
        });
    }

    function deleteUser(userId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/users/' + userId,
            type: 'DELETE',
            beforeSend: function(xhr) {
                // Add CSRF token for security
                const token = $("meta[name='_csrf']").attr("content");
                const header = $("meta[name='_csrf_header']").attr("content");
                xhr.setRequestHeader(header, token);
            },
            success: function() {
                $('#deleteModal').modal('hide');
                alert('User deleted successfully');
                window.location.href = '${pageContext.request.contextPath}/users';
            },
            error: function(xhr, status, error) {
                $('#deleteModal').modal('hide');
                console.error('Error deleting user:', error);
                alert('Failed to delete user. The user may have associated library data.');
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