<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-book-reader mr-2"></i>
                Library Management System
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-home"></i> Home
                        </a>
                    </li>

                    <sec:authorize access="hasAnyRole('USER', 'LIBRARIAN', 'ADMIN')">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="booksDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-book"></i> Books
                            </a>
                            <div class="dropdown-menu" aria-labelledby="booksDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/books">View All Books</a>
                                <sec:authorize access="hasAnyRole('LIBRARIAN', 'ADMIN')">
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/books/add">Add New Book</a>
                                </sec:authorize>
                            </div>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="hasAnyRole('LIBRARIAN', 'ADMIN')">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="membersDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-users"></i> Members
                            </a>
                            <div class="dropdown-menu" aria-labelledby="membersDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/members">View All Members</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/members/add">Add New Member</a>
                            </div>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="hasAnyRole('LIBRARIAN', 'ADMIN')">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/transactions">
                                <i class="fas fa-exchange-alt"></i> Transactions
                            </a>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="hasAnyRole('LIBRARIAN', 'ADMIN')">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/fines">
                                <i class="fas fa-dollar-sign"></i> Fines
                            </a>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="hasRole('ADMIN')">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="usersDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-user-cog"></i> Users
                            </a>
                            <div class="dropdown-menu" aria-labelledby="usersDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/users">Manage Users</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/users/register">Register New User</a>
                            </div>
                        </li>
                    </sec:authorize>
                </ul>

                <ul class="navbar-nav">
                    <sec:authorize access="isAuthenticated()">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="profileDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-user-circle"></i> <sec:authentication property="principal.username" />
                            </a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="profileDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">My Profile</a>
                                <div class="dropdown-divider"></div>
                                <form action="${pageContext.request.contextPath}/logout" method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="dropdown-item">Logout</button>
                                </form>
                            </div>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="!isAuthenticated()">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                <i class="fas fa-sign-in-alt"></i> Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/register">
                                <i class="fas fa-user-plus"></i> Register
                            </a>
                        </li>
                    </sec:authorize>
                </ul>
            </div>
        </div>
    </nav>
</header>