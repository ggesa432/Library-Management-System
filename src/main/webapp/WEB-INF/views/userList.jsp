<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Users</title>
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
            <h2>User Management</h2>
        </div>
        <div class="col-md-6 text-right">
            <button type="button" class="btn btn-success" onclick="window.location.href='${pageContext.request.contextPath}/users/register'">
                <i class="fas fa-user-plus"></i> Register New User
            </button>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-light">
            <form id="searchForm" class="form-inline">
                <div class="form-group mr-2 flex-grow-1">
                    <input type="text" class="form-control w-100" id="searchTerm" name="searchTerm" placeholder="Search by name, email, username...">
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Search
                </button>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-light">
            <h5 class="mb-0">Users List</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0">
                    <thead class="thead-light">
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Registration Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="usersTableBody">
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.userId}</td>
                            <td>${user.username}</td>
                            <td>${user.firstName} ${user.lastName}</td>
                            <td>${user.email}</td>
                            <td><span class="badge badge-info">${user.role}</span></td>
                            <td>${formattedDate}</td>
                            <td>
                                        <span class="badge ${user.active ? 'badge-success' : 'badge-danger'}">
                                                ${user.active ? 'Active' : 'Inactive'}
                                        </span>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button type="button" class="btn btn-info" onclick="viewUser(${user.userId})">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-warning" onclick="editUser(${user.userId})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-danger" onclick="deleteUser(${user.userId})">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer bg-light">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center mb-0">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#">Next</a>
                    </li>
                </ul>
            </nav>
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
        // Get CSRF token and header
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");

        // Configure jQuery AJAX globally to send CSRF token with all requests
        $(document).ajaxSend(function(e, xhr, options) {
            if (token && header) {
                xhr.setRequestHeader(header, token);
            }
        });
        loadUsers();

        $('#searchForm').submit(function(e) {
            e.preventDefault();
            searchUsers();
        });
    });

    function loadUsers() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/users',
            type: 'GET',
            beforeSend: function(xhr) {
                // Add CSRF token
                var token = $("meta[name='_csrf']").attr("content");
                var header = $("meta[name='_csrf_header']").attr("content");
                if (token && header) {
                    xhr.setRequestHeader(header, token);
                }
            },
            success: function(response) {
                updateUsersTable(response);
            },
            error: function(xhr, status, error) {
                console.error('Error loading users:', error);
                console.error('Status:', status);
                console.error('Response:', xhr.responseText);
                alert('Failed to load users. Please try again later.');
            }
        });
    }

    function searchUsers() {
        const searchTerm = $('#searchTerm').val();

        if (!searchTerm) {
            loadUsers();
            return;
        }

        // Note: This is a simplified implementation. In a real application,
        // you would have a proper search endpoint on the backend.
        $.ajax({
            url: '/api/users',
            type: 'GET',
            success: function(response) {
                const filteredUsers = response.filter(user =>
                    user.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
                    (user.firstName && user.firstName.toLowerCase().includes(searchTerm.toLowerCase())) ||
                    (user.lastName && user.lastName.toLowerCase().includes(searchTerm.toLowerCase())) ||
                    user.email.toLowerCase().includes(searchTerm.toLowerCase())
                );

                updateUsersTable(filteredUsers);
            },
            error: function(xhr, status, error) {
                console.error('Error searching users:', error);
                alert('Failed to search users. Please try again later.');
            }
        });
    }

    function updateUsersTable(users) {
        const tableBody = $('#usersTableBody');
        tableBody.empty();

        if (users.length === 0) {
            tableBody.append('<tr><td colspan="8" class="text-center">No users found</td></tr>');
            return;
        }

        users.forEach(function(user) {
            const formattedDate = formatDate(user.registrationDate);

            const row = `
            <tr>
                <td>\${user.userId || 'N/A'}</td>
                <td>\${user.username || 'N/A'}</td>
                <td>\${(user.firstName || '')} \${(user.lastName || '')}</td>
                <td>\${user.email || 'N/A'}</td>
                <td><span class="badge badge-info">\${user.role || 'USER'}</span></td>
                <td>\${formattedDate}</td> <!-- Use formatted date here -->
                <td>
                    <span class="badge \${user.active ? 'badge-success' : 'badge-danger'}">
                        \${user.active ? 'Active' : 'Inactive'}
                    </span>
                </td>
                <td>
                    <div class="btn-group btn-group-sm">
                                <button type="button" class="btn btn-info" onclick="viewUser(\${user.userId})">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button type="button" class="btn btn-warning" onclick="editUser(\${user.userId})">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-danger" onclick="deleteUser(\${user.userId})">
                                    <i class="fas fa-trash"></i>
                                </button>
                </td>
            </tr>
        `;
            tableBody.append(row);
        });
    }

    function formatDate(dateString) {
        // Check if the dateString is empty or null
        if (!dateString) return 'N/A';

        // Check if the date string contains '//' (which might be part of the issue)
        if (dateString === '//') return 'N/A';

        try {
            // Create a date object
            const date = new Date(dateString);

            // Check if the date is valid
            if (isNaN(date.getTime())) {
                console.log("Invalid date format:", dateString);
                return 'N/A';
            }

            // Format using toLocaleDateString
            const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
            return date.toLocaleDateString('en-US', options);
        } catch (e) {
            console.error("Error formatting date:", e);
            return 'N/A';
        }
    }

    function viewUser(userId) {
        window.location.href = '${pageContext.request.contextPath}/users/view?id=' + userId;
    }

    function editUser(userId) {
        window.location.href = '${pageContext.request.contextPath}/users/edit?id=' + userId;
    }

    function deleteUser(userId) {
        $('#deleteModal').modal('show');

        $('#confirmDeleteBtn').off('click').on('click', function() {
            $.ajax({
                url: '/api/users/' + userId,
                type: 'DELETE',
                success: function() {
                    $('#deleteModal').modal('hide');
                    loadUsers();
                    alert('User deleted successfully');
                },
                error: function(xhr, status, error) {
                    $('#deleteModal').modal('hide');
                    console.error('Error deleting user:', error);
                    alert('Failed to delete user. It may have associated library data.');
                }
            });
        });
    }
</script>
</body>
</html>