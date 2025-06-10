<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="jumbotron">
        <h1 class="display-4">Welcome to the Library Management System</h1>
        <p class="lead">Manage your library resources efficiently.</p>
        <hr class="my-4">
        <p>Use the navigation menu to access different parts of the system.</p>
        <div class="mt-4">
            <a href="books" class="btn btn-primary mr-2">
                <i class="fas fa-book mr-1"></i> Manage Books
            </a>
            <a href="users" class="btn btn-success mr-2">
                <i class="fas fa-users mr-1"></i> Manage Users
            </a>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>