<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Login</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-container {
            margin-top: 100px;
        }
        .card-header {
            background-color: #007bff;
            color: white;
            text-align: center;
            font-weight: bold;
        }
        .login-icon {
            font-size: 80px;
            color: #007bff;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="container login-container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="login-icon">
                <i class="fas fa-book-reader"></i>
            </div>
            <div class="card">
                <div class="card-header">
                    Library Management System - Login
                </div>
                <div class="card-body">
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger" role="alert">
                            Invalid username or password.
                        </div>
                    </c:if>
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-success" role="alert">
                            You have been logged out.
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                </div>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                </div>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                        </div>
                        <div class="form-group form-check">
                            <input type="checkbox" class="form-check-input" id="remember-me" name="remember-me">
                            <label class="form-check-label" for="remember-me">Remember me</label>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">Login</button>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <div>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register</a></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>