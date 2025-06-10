<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Books</title>
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
            <h2>Book Management</h2>
        </div>
        <div class="col-md-6 text-right">
            <button type="button" class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/books/add'">
                <i class="fas fa-plus"></i> Add New Book
            </button>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-light">
            <form id="searchForm" class="form-inline">
                <div class="form-group mr-2 flex-grow-1">
                    <input type="text" class="form-control w-100" id="searchTerm" name="searchTerm" placeholder="Search by title, author, ISBN...">
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Search
                </button>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-light">
            <h5 class="mb-0">Books List</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0">
                    <thead class="thead-light">
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Publisher</th>
                        <th>ISBN</th>
                        <th>Publication Year</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="booksTableBody">
                    <c:forEach var="book" items="${books}">
                        <tr>
                            <td>${book.bookId}</td>
                            <td>${book.title}</td>
                            <td>${book.authorName}</td>
                            <td>${book.publisherName}</td>
                            <td>${book.isbn}</td>
                            <td>${book.publicationYear}</td>
                            <td>${book.category}</td>
                            <td>
                                        <span class="badge ${book.status == 'Available' ? 'badge-success' : 'badge-danger'}">
                                        </span>
                                <small>(${book.availableCopies} copies)</small>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button type="button" class="btn btn-info" onclick="viewBook(${book.bookId})">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-warning" onclick="editBook(${book.bookId})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-danger" onclick="deleteBook(${book.bookId})">
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
        // Get CSRF token and header
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");

        // Configure jQuery AJAX globally to send CSRF token with all requests
        $(document).ajaxSend(function(e, xhr, options) {
            if (token && header) {
                xhr.setRequestHeader(header, token);
            }
        });

        loadBooks();

        $('#searchForm').submit(function(e) {
            e.preventDefault();
            searchBooks();
        });
    });

        function loadBooks() {
        $.ajax({
            url: '/api/books',
            type: 'GET',
            success: function(response) {
                updateBooksTable(response);
            },
            error: function(xhr, status, error) {
                console.error('Error loading books:', error);
                alert('Failed to load books. Please try again later.');
            }
        });
    }


    function searchBooks() {
        const searchTerm = $('#searchTerm').val();


        $.ajax({
            url: '${pageContext.request.contextPath}/api/books/search?term=' + encodeURIComponent(searchTerm),
            type: 'GET',
            success: function(response) {
                updateBooksTable(response);
            },
            error: function(xhr, status, error) {
                console.error('Error searching books:', error);
                console.error('Status:', status);
                console.error('Response:', xhr.responseText);
                alert('Failed to search books. Please try again later.');
            }
        });
    }

    function updateBooksTable(books) {
        const tableBody = $('#booksTableBody');
        tableBody.empty();

        if (!books || books.length === 0) {
            tableBody.append('<tr><td colspan="9" class="text-center">No books found</td></tr>');
            return;
        }

        books.forEach(function(book) {

            const bookId = book.bookId || '';
            const title = book.title || '';
            const authorName = book.authorName || 'N/A';
            const publisherName = book.publisherName || 'N/A';
            const isbn = book.isbn || 'N/A';
            const publicationYear = book.publicationYear || 'N/A';
            const category = book.category || 'N/A';
            const status = book.status || 'Unknown';
            const availableCopies = book.availableCopies || 0;


            const row = `
            <tr>
                <td>\${bookId}</td>
                <td>\${title}</td>
                <td>\${authorName}</td>
                <td>\${publisherName}</td>
                <td>\${isbn}</td>
                <td>\${publicationYear}</td>
                <td>\${category}</td>
                <td>
                    <span class="badge badge-\${status == 'Available' ? 'success' : 'danger'}">
                        \${status}
                    </span>
                    <small>(\${availableCopies} copies)</small>
                </td>
                <td>
                    <div class="btn-group btn-group-sm">
                         <button type="button" class="btn btn-info" onclick="viewBook(\${book.bookId})">
                            <i class="fas fa-eye"></i>
                        </button>
                        <sec:authorize access="hasAnyRole('LIBRARIAN', 'ADMIN')">
                            <button type="button" class="btn btn-warning" onclick="editBook(\${book.bookId})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-danger" onclick="deleteBook(\${book.bookId})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </sec:authorize>
                    </div>
                </td>
            </tr>
        `;
            tableBody.append(row);
        });
    }

    function viewBook(bookId) {
        window.location.href = '${pageContext.request.contextPath}/books/view?id=' + bookId;
    }

    function editBook(bookId) {
        window.location.href = '${pageContext.request.contextPath}/books/edit?id=' + bookId;
    }

    function deleteBook(bookId) {
        $('#deleteModal').modal('show');

        $('#confirmDeleteBtn').off('click').on('click', function() {
            $.ajax({
                url: '/api/books/' + bookId,
                type: 'DELETE',
                success: function() {
                    $('#deleteModal').modal('hide');
                    loadBooks();
                    alert('Book deleted successfully');
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
        });
    }

</script>
</body>
</html>