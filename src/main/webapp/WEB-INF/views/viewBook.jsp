<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - View Book</title>
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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/books">Books</a></li>
                    <li class="breadcrumb-item active" aria-current="page">View Book</li>
                </ol>
            </nav>
        </div>
    </div>

    <div id="bookDetails" class="card">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0" id="bookTitle">Book Details</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-8">
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label font-weight-bold">Title:</label>
                        <div class="col-sm-9">
                            <p class="form-control-plaintext" id="title"></p>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label font-weight-bold">Author:</label>
                        <div class="col-sm-9">
                            <p class="form-control-plaintext" id="authorName"></p>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label font-weight-bold">Publisher:</label>
                        <div class="col-sm-9">
                            <p class="form-control-plaintext" id="publisherName"></p>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label font-weight-bold">ISBN:</label>
                        <div class="col-sm-9">
                            <p class="form-control-plaintext" id="isbn"></p>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label font-weight-bold">Publication Year:</label>
                        <div class="col-sm-9">
                            <p class="form-control-plaintext" id="publicationYear"></p>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label font-weight-bold">Category:</label>
                        <div class="col-sm-9">
                            <p class="form-control-plaintext" id="category"></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card mb-3">
                        <div class="card-header bg-light">
                            <h6 class="mb-0">Status Information</h6>
                        </div>
                        <div class="card-body">
                            <p><strong>Status:</strong> <span id="status" class="badge"></span></p>
                            <p><strong>Available Copies:</strong> <span id="availableCopies"></span></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="card-footer">
            <div class="text-right">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Books
                </a>
                <sec:authorize access="hasAnyRole('LIBRARIAN', 'ADMIN')">
                    <a id="editBookBtn" href="#" class="btn btn-warning">
                        <i class="fas fa-edit"></i> Edit Book
                    </a>
                    <button id="deleteBookBtn" class="btn btn-danger">
                        <i class="fas fa-trash"></i> Delete Book
                    </button>
                </sec:authorize>
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
                Are you sure you want to delete this book?
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
        // Get book ID from URL parameter
        const urlParams = new URLSearchParams(window.location.search);
        const bookId = urlParams.get('id');

        if (!bookId) {
            alert('Book ID is missing!');
            window.location.href = '${pageContext.request.contextPath}/books';
            return;
        }

        // Load book details
        loadBookDetails(bookId);

        // Set up edit button
        $('#editBookBtn').click(function() {
            window.location.href = '${pageContext.request.contextPath}/books/edit?id=' + bookId;
        });

        // Set up delete button
        $('#deleteBookBtn').click(function() {
            $('#deleteModal').modal('show');
        });

        // Set up confirm delete button
        $('#confirmDeleteBtn').click(function() {
            deleteBook(bookId);
        });
    });

    function loadBookDetails(bookId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/books/' + bookId,
            type: 'GET',
            success: function(book) {
                // Update page title
                $('#bookTitle').text(book.title);

                // Fill in book details
                $('#title').text(book.title);
                $('#authorName').text(book.authorName || 'N/A');
                $('#publisherName').text(book.publisherName || 'N/A');
                $('#isbn').text(book.isbn || 'N/A');
                $('#publicationYear').text(book.publicationYear || 'N/A');
                $('#category').text(book.category || 'N/A');

                // Set status information
                $('#status')
                    .text(book.status)
                    .removeClass()
                    .addClass('badge badge-' + (book.status === 'Available' ? 'success' : 'danger'));

                $('#availableCopies').text(book.availableCopies);
            },
            error: function(xhr, status, error) {
                console.error('Error loading book details:', error);
                alert('Failed to load book details. Please try again later.');
                window.location.href = '${pageContext.request.contextPath}/books';
            }
        });
    }

    function deleteBook(bookId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/books/' + bookId,
            type: 'DELETE',
            beforeSend: function(xhr) {
                // Add CSRF token for security
                const token = $("meta[name='_csrf']").attr("content");
                const header = $("meta[name='_csrf_header']").attr("content");
                xhr.setRequestHeader(header, token);
            },
            success: function() {
                $('#deleteModal').modal('hide');
                alert('Book deleted successfully');
                window.location.href = '${pageContext.request.contextPath}/books';
            },
            error: function(xhr, status, error) {
                $('#deleteModal').modal('hide');

                if (xhr.status === 403) {
                    alert('You do not have permission to delete books.');
                } else {
                    console.error('Error deleting book:', error);
                    alert('Failed to delete book. It may have active transactions.');
                }
            }
        });
    }
</script>
</body>
</html>