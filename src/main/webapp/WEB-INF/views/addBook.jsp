<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System - Add Book</title>
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
                    <li class="breadcrumb-item active" aria-current="page">Add Book</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Add New Book</h5>
        </div>
        <div class="card-body">
            <form id="addBookForm">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="title">Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>

                        <div class="form-group">
                            <label for="isbn">ISBN</label>
                            <input type="text" class="form-control" id="isbn" name="isbn">
                            <small class="form-text text-muted">International Standard Book Number</small>
                        </div>

                        <div class="form-group">
                            <label for="publicationYear">Publication Year</label>
                            <input type="number" class="form-control" id="publicationYear" name="publicationYear" min="1000" max="2099">
                        </div>

                        <div class="form-group">
                            <label for="category">Category <span class="text-danger">*</span></label>
                            <select class="form-control" id="category" name="category" required>
                                <option value="">-- Select Category --</option>
                                <option value="Fiction">Fiction</option>
                                <option value="Non-Fiction">Non-Fiction</option>
                                <option value="Science">Science</option>
                                <option value="History">History</option>
                                <option value="Biography">Biography</option>
                                <option value="Children">Children</option>
                                <option value="Fantasy">Fantasy</option>
                                <option value="Mystery">Mystery</option>
                                <option value="Thriller">Thriller</option>
                                <option value="Romance">Romance</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="authorId">Author <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <select class="form-control" id="authorId" name="authorId" required>
                                    <option value="">-- Select Author --</option>
                                    <!-- Authors will be loaded dynamically -->
                                </select>
                                <div class="input-group-append">
                                    <button class="btn btn-outline-secondary" type="button" data-toggle="modal" data-target="#addAuthorModal">
                                        <i class="fas fa-plus"></i> New
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="publisherId">Publisher <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <select class="form-control" id="publisherId" name="publisherId" required>
                                    <option value="">-- Select Publisher --</option>
                                    <!-- Publishers will be loaded dynamically -->
                                </select>
                                <div class="input-group-append">
                                    <button class="btn btn-outline-secondary" type="button" data-toggle="modal" data-target="#addPublisherModal">
                                        <i class="fas fa-plus"></i> New
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-right mt-3">
                    <button type="button" class="btn btn-secondary mr-2" onclick="window.location.href='${pageContext.request.contextPath}/books'">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Book</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add Author Modal -->
<div class="modal fade" id="addAuthorModal" tabindex="-1" role="dialog" aria-labelledby="addAuthorModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addAuthorModalLabel">Add New Author</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="addAuthorForm">
                    <div class="form-group">
                        <label for="firstName">First Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="authorFirstName" name="firstName" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="authorLastName" name="lastName" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveAuthorBtn">Save Author</button>
            </div>
        </div>
    </div>
</div>

<!-- Add Publisher Modal -->
<div class="modal fade" id="addPublisherModal" tabindex="-1" role="dialog" aria-labelledby="addPublisherModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addPublisherModalLabel">Add New Publisher</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="addPublisherForm">
                    <div class="form-group">
                        <label for="name">Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="publisherName" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="address">Address</label>
                        <input type="text" class="form-control" id="publisherAddress" name="address">
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="text" class="form-control" id="publisherPhone" name="phone">
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="publisherEmail" name="email">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="savePublisherBtn">Save Publisher</button>
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
        loadAuthors();
        loadPublishers();

        $('#addBookForm').submit(function(e) {
            e.preventDefault();
            saveBook();
        });

        $('#saveAuthorBtn').click(function() {
            saveAuthor();
        });

        $('#savePublisherBtn').click(function() {
            savePublisher();
        });
    });

    function loadAuthors() {
        $.ajax({
            url: '/api/authors',
            type: 'GET',
            success: function(response) {
                console.log("Authors loaded:", response);

                var select = document.getElementById('authorId');
                var length = select.options.length;
                for (i = length-1; i > 0; i--) {
                    select.options[i] = null;
                }

                if (response && response.length > 0) {
                    response.forEach(function(author) {
                        var option = document.createElement("option");
                        option.text = author.firstName + " " + author.lastName;
                        option.value = author.authorId;
                        select.add(option);
                    });

                    console.log("Added " + response.length + " authors to dropdown");
                }
            },
            error: function(xhr, status, error) {
                console.error('Error loading authors:', error);
            }
        });
    }

    function loadPublishers() {
        $.ajax({
            url: '/api/publishers',
            type: 'GET',
            success: function(response) {
                console.log("Publishers loaded:", response);

                // Clear existing options except the first one
                var select = document.getElementById('publisherId');
                var length = select.options.length;
                for (i = length-1; i > 0; i--) {
                    select.options[i] = null;
                }

                // Add new options
                if (response && response.length > 0) {
                    response.forEach(function(publisher) {
                        var option = document.createElement("option");
                        option.text = publisher.name;
                        option.value = publisher.publisherId;
                        select.add(option);
                    });

                    console.log("Added " + response.length + " publishers to dropdown");
                }
            },
            error: function(xhr, status, error) {
                console.error('Error loading publishers:', error);
            }
        });
    }

    function saveAuthor() {
        const firstName = $('#authorFirstName').val();
        const lastName = $('#authorLastName').val();

        if (!firstName || !lastName) {
            alert('Both first name and last name are required.');
            return;
        }

        const authorData = {
            firstName: firstName,
            lastName: lastName
        };

        $.ajax({
            url: '/api/authors',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(authorData),
            success: function(response) {
                $('#addAuthorModal').modal('hide');
                $('#authorFirstName').val('');
                $('#authorLastName').val('');

                // Reload authors and select the new one
                loadAuthors();
                setTimeout(function() {
                    $('#authorId').val(response.authorId);
                }, 500);

                alert('Author added successfully!');
            },
            error: function(xhr, status, error) {
                console.error('Error adding author:', error);
                alert('Failed to add author. Please try again.');
            }
        });
    }

    function savePublisher() {
        const name = $('#publisherName').val();
        const address = $('#publisherAddress').val();
        const phone = $('#publisherPhone').val();
        const email = $('#publisherEmail').val();

        if (!name) {
            alert('Publisher name is required.');
            return;
        }

        const publisherData = {
            name: name,
            address: address,
            phone: phone,
            email: email
        };

        $.ajax({
            url: '/api/publishers',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(publisherData),
            success: function(response) {
                $('#addPublisherModal').modal('hide');
                $('#publisherName').val('');
                $('#publisherAddress').val('');
                $('#publisherPhone').val('');
                $('#publisherEmail').val('');

                // Reload publishers and select the new one
                loadPublishers();
                setTimeout(function() {
                    $('#publisherId').val(response.publisherId);
                }, 500);

                alert('Publisher added successfully!');
            },
            error: function(xhr, status, error) {
                console.error('Error adding publisher:', error);
                alert('Failed to add publisher. Please try again.');
            }
        });
    }

    function saveBook() {
        const bookData = {
            title: $('#title').val(),
            isbn: $('#isbn').val(),
            publicationYear: $('#publicationYear').val(),
            category: $('#category').val(),
            authorId: $('#authorId').val(),
            publisherId: $('#publisherId').val()
        };

        $.ajax({
            url: '/api/books',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(bookData),
            success: function(response) {
                alert('Book added successfully!');
                window.location.href = '${pageContext.request.contextPath}/books';
            },
            error: function(xhr, status, error) {
                console.error('Error adding book:', error);
                alert('Failed to add book. Please check your input and try again.');
            }
        });
    }
</script>
</body>
</html>