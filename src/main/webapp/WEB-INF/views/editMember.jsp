<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Edit Member</title>
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
                    <li class="breadcrumb-item active" aria-current="page">Edit Member</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-warning text-dark">
            <h5 class="mb-0">Edit Member</h5>
        </div>
        <div class="card-body">
            <form id="editMemberForm">
                <input type="hidden" id="memberId" name="memberId">

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

                        <div class="form-group">
                            <label for="membershipDate">Membership Date</label>
                            <input type="date" class="form-control" id="membershipDate" name="membershipDate" readonly>
                            <small class="form-text text-muted">Membership date cannot be changed</small>
                        </div>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="card bg-light mb-3">
                            <div class="card-body">
                                <h6 class="card-title">Member Information</h6>
                                <p class="card-text mb-1">
                                    <strong>Membership Status:</strong>
                                    <span id="statusBadge" class="badge badge-success">Active</span>
                                </p>
                                <p class="card-text mb-1">
                                    <strong>Current Borrowings:</strong>
                                    <span id="activeBorrowings">...</span>
                                </p>
                                <p class="card-text mb-0">
                                    <strong>Overdue Books:</strong>
                                    <span id="hasOverdue">...</span>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 text-right">
                        <button type="button" class="btn btn-secondary mr-2" onclick="window.location.href='${pageContext.request.contextPath}/members'">Cancel</button>
                        <button type="submit" class="btn btn-warning">Update Member</button>
                    </div>
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

        // Form submission
        $('#editMemberForm').submit(function(e) {
            e.preventDefault();
            updateMember();
        });
    });

    function loadMemberDetails(memberId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/members/' + memberId,
            type: 'GET',
            success: function(member) {
                // Set form fields
                $('#memberId').val(member.memberId);
                $('#firstName').val(member.firstName);
                $('#lastName').val(member.lastName);
                $('#email').val(member.email);
                $('#phone').val(member.phone);
                $('#address').val(member.address);

                // Format membership date for date input
                if (member.membershipDate) {
                    const date = new Date(member.membershipDate);
                    if (!isNaN(date.getTime())) {
                        const year = date.getFullYear();
                        const month = String(date.getMonth() + 1).padStart(2, '0');
                        const day = String(date.getDate()).padStart(2, '0');
                        $('#membershipDate').val(`${year}-${month}-${day}`);
                    }
                }

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
                    $('#hasOverdue').html('<span class="text-danger">Yes</span>');
                    $('#statusBadge').removeClass('badge-success').addClass('badge-warning').text('Has Overdue');
                } else {
                    $('#hasOverdue').text('None');
                }
            },
            error: function(xhr, status, error) {
                console.error('Error checking overdue books:', error);
                $('#hasOverdue').text('N/A');
            }
        });
    }

    function updateMember() {
        const memberId = $('#memberId').val();

        const memberData = {
            memberId: memberId,
            firstName: $('#firstName').val(),
            lastName: $('#lastName').val(),
            email: $('#email').val(),
            phone: $('#phone').val(),
            address: $('#address').val()
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/api/members/' + memberId,
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify(memberData),
            success: function(response) {
                alert('Member updated successfully!');
                window.location.href = '${pageContext.request.contextPath}/members/view?id=' + memberId;
            },
            error: function(xhr, status, error) {
                console.error('Error updating member:', error);
                alert('Failed to update member. Please try again later.');
            }
        });
    }
</script>
</body>
</html>