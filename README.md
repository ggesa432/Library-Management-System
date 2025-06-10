# 🏛️ Library Management System

![Java](https://img.shields.io/badge/Java-11+-orange.svg)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.7+-brightgreen.svg)
![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

A comprehensive web-based library management system built with Spring Boot that automates library operations including book management, member registration, transaction processing, and fine collection with email notifications.

## ✨ Features

### 📚 Core Functionality
- **Book Management**: Complete CRUD operations with inventory tracking and search capabilities
- **Member Management**: Automated member registration with fee collection and profile management
- **Transaction Processing**: Seamless book borrowing and return workflow with due date tracking
- **User Authentication**: Role-based access control (Admin, Librarian, Member)

### 🚀 Advanced Features
- **Automated Fine System**: Smart calculation of overdue fines with configurable rates
- **Email Notifications**: Real-time alerts for overdue books and fine notifications
- **Configuration Management**: Admin-configurable system parameters (loan periods, fine rates, etc.)
- **Analytics Dashboard**: Comprehensive reporting and system insights
- **Real-time Availability**: Live book status and availability tracking

## 🛠️ Technology Stack

### Backend
- **Java 11+** - Core programming language
- **Spring Boot 2.7+** - Application framework
- **Spring Security** - Authentication and authorization
- **Spring Data JPA** - Database operations and ORM
- **MySQL 8.0** - Primary database
- **Maven** - Dependency management and build tool
- **JUnit 5** - Testing framework

### Frontend
- **JSP** - Server-side rendering
- **HTML5/CSS3** - Markup and styling
- **Bootstrap 4** - Responsive UI framework
- **jQuery 3** - JavaScript library for dynamic content
- **Ajax** - Asynchronous web requests

### Additional Tools
- **JavaMail API** - Email notifications
- **Jackson** - JSON processing
- **Apache Tomcat 9** - Application server

## 🚀 Getting Started

### Prerequisites
- Java Development Kit (JDK) 11 or higher
- MySQL 8.0 or higher
- Maven 3.6 or higher
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/library-management-system.git
cd library-management-system
```

2. **Set up the database**
```sql
CREATE DATABASE library_management;
CREATE USER 'library_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON library_management.* TO 'library_user'@'localhost';
FLUSH PRIVILEGES;
```

3. **Configure application properties**
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/library_management
spring.datasource.username=library_user
spring.datasource.password=your_password

# Email Configuration (Optional)
spring.mail.host=smtp.gmail.com
spring.mail.username=your_email@gmail.com
spring.mail.password=your_app_password

# Library Settings
library.fine.rate.daily=0.50
library.max.books.per.member=5
library.default.loan.period=14
library.membership.fee=10.00
```

4. **Build and run the application**
```bash
mvn clean install
mvn spring-boot:run
```

5. **Access the application**
- URL: `http://localhost:8080/library`
- Default Admin: `admin` / `admin123`
- Default Librarian: `librarian` / `librarian123`

## 📋 Usage

### For Administrators
- Configure system settings (fine rates, loan periods)
- Manage user accounts and permissions
- View system-wide reports and analytics
- Monitor system health and performance

### For Librarians
- Add and manage book inventory
- Register new members and collect fees
- Process book checkouts and returns
- Handle fine payments and member queries

### For Members
- Browse and search available books
- View personal borrowing history
- Check due dates and outstanding fines
- Update profile information

## 🔧 API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout

### Books
- `GET /api/books` - Get all books
- `POST /api/books` - Add new book
- `PUT /api/books/{id}` - Update book
- `DELETE /api/books/{id}` - Delete book
- `GET /api/books/search?query={query}` - Search books

### Members
- `GET /api/members` - Get all members
- `POST /api/members` - Register new member
- `PUT /api/members/{id}` - Update member
- `GET /api/members/{id}/fines` - Get member fines

### Transactions
- `POST /api/transactions/borrow` - Borrow book
- `PUT /api/transactions/{id}/return` - Return book
- `GET /api/transactions/overdue` - Get overdue transactions

### Fines
- `GET /api/fines/pending` - Get pending fines
- `POST /api/fines/{id}/pay` - Pay fine
- `PUT /api/fines/rate?rate={rate}` - Update fine rate

## 📁 Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/library/
│   │       ├── controller/     # REST controllers
│   │       ├── service/        # Business logic
│   │       ├── repository/     # Data access layer
│   │       ├── entity/         # JPA entities
│   │       ├── dto/           # Data transfer objects
│   │       ├── config/        # Configuration classes
│   │       └── LibraryApplication.java
│   ├── resources/
│   │   ├── static/            # CSS, JS, images
│   │   ├── templates/         # Email templates
│   │   └── application.properties
│   └── webapp/
│       └── WEB-INF/
│           └── views/         # JSP pages
└── test/
    └── java/                  # Test classes
```

## 🧪 Testing

Run tests with Maven:
```bash
# Run unit tests
mvn test

# Run integration tests
mvn verify

# Generate test coverage report
mvn jacoco:report
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Key Highlights

- **Automated Fine Calculation**: Configurable daily fine rates with automatic calculation
- **Email Integration**: Automated notifications for overdue books and fines
- **Role-Based Security**: Multi-level access control for different user types
- **Real-Time Updates**: Live inventory tracking and availability status
- **Comprehensive Reporting**: Detailed analytics and transaction history
- **Responsive Design**: Mobile-friendly interface with Bootstrap

## 🔮 Future Enhancements

- [ ] Mobile application development
- [ ] Barcode scanning integration
- [ ] Advanced reporting with charts
- [ ] SMS notifications
- [ ] Online payment gateway integration
- [ ] Book recommendation system
- [ ] Multi-branch library support

## 📞 Contact

- **Email**: ggesa432@gmail.com
- **LinkedIn**: [LinkedIn Profile](https://linkedin.com/in/gesang-zeren-aaa8392b0)
- **GitHub**: [GitHub Profile](https://github.com/ggesa432)

## 🙏 Acknowledgments

- Spring Boot community for excellent documentation
- Bootstrap team for responsive UI components
- MySQL team for reliable database system
- All contributors who helped improve this project

---

⭐ **If you find this project useful, please give it a star!**
