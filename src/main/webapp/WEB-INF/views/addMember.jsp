<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Add Member</title>
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
                    <li class="breadcrumb-item active" aria-current="page">Add Member</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Add New Member</h5>
        </div>
        <div class="card-body">
            <form id="addMemberForm">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="firstName">First Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="firstName" name="firstName" required>
                        </div>

                        <div class="form-group">
                            <label for="lastName">Last Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="lastName" name="lastName" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="text" class="form-control" id="phone" name="phone">
                        </div>

                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea class="form-control" id="address" name="address" rows="4"></textarea>
                        </div>
                    </div>
                </div>

                <div class="text-right mt-3">
                    <button type="button" class="btn btn-secondary mr-2" onclick="window.location.href='${pageContext.request.contextPath}/members'">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Member</button>
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

        // Form submission
        $('#addMemberForm').submit(function(e) {
            e.preventDefault();

            const memberData = {
                firstName: $('#firstName').val(),
                lastName: $('#lastName').val(),
                email: $('#email').val(),
                phone: $('#phone').val(),
                address: $('#address').val()
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/api/members',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(memberData),
                success: function(response) {
                    alert('Member added successfully!');
                    window.location.href = '${pageContext.request.contextPath}/members';
                },
                error: function(xhr, status, error) {
                    console.error('Error adding member:', error);
                    alert('Failed to add member. Please try again later.');
                }
            });
        });
    });
</script>
</body>
</html>