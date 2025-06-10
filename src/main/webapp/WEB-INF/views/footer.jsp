<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<footer class="bg-dark text-white mt-5 py-3">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5>Library Management System</h5>
                <p class="small">An efficient system for managing books, members, transactions, and fines.</p>
            </div>
            <div class="col-md-3">
                <h6>Quick Links</h6>
                <ul class="list-unstyled small">
                    <li><a href="${pageContext.request.contextPath}/books" class="text-white">Books</a></li>
                    <sec:authorize access="hasAnyRole('LIBRARIAN', 'ADMIN')">
                        <li><a href="${pageContext.request.contextPath}/members" class="text-white">Members</a></li>
                        <li><a href="${pageContext.request.contextPath}/transactions" class="text-white">Transactions</a></li>
                        <li><a href="${pageContext.request.contextPath}/fines" class="text-white">Fines</a></li>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ADMIN')">
                        <li><a href="${pageContext.request.contextPath}/users" class="text-white">Users</a></li>
                    </sec:authorize>
                </ul>
            </div>
            <div class="col-md-3">
                <h6>Contact</h6>
                <address class="small">
                    <i class="fas fa-map-marker-alt"></i> 123 Library Street<br>
                    <i class="fas fa-phone"></i> (123) 456-7890<br>
                    <i class="fas fa-envelope"></i> <a href="mailto:info@library.com" class="text-white">info@library.com</a>
                </address>
            </div>
        </div>
        <hr class="bg-secondary">
        <div class="row">
            <div class="col-md-8">
                <p class="small mb-0">&copy; <span id="currentYear"></span> Library Management System. All rights reserved.</p>
            </div>
            <div class="col-md-4 text-md-right">
                <a href="#" class="text-white mx-1"><i class="fab fa-facebook"></i></a>
                <a href="#" class="text-white mx-1"><i class="fab fa-twitter"></i></a>
                <a href="#" class="text-white mx-1"><i class="fab fa-instagram"></i></a>
                <a href="#" class="text-white mx-1"><i class="fab fa-linkedin"></i></a>
            </div>
        </div>
    </div>
</footer>

<script>
    document.getElementById('currentYear').textContent = new Date().getFullYear();
</script>