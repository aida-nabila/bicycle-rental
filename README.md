# Bicycle Rental System

![homepage-bicycle-rental](https://github.com/user-attachments/assets/0f1c9cbe-76f1-4619-91c1-2995bc3b27b4)
![map-bicycle-rental](https://github.com/user-attachments/assets/4613a54f-cb48-431e-9290-7b876afd891e)

## Project Overview
The **Bicycle Rental System** is a web-based application developed using **JSP (JavaServer Pages)**, running on **GlassFish Server**, with **MySQL (JDBC)** for database management. It is designed to **streamline the bicycle rental process**, providing a **user-friendly platform** for urban commuters, students, and tourists to rent bicycles conveniently.

## Features
- **User Authentication**: Sign-up, login, and secure user sessions.
- **Bicycle Rental & Return**: Select a bicycle, rent it, and return it at designated bike points.
- **Penalty System**: Automatic penalty calculation for overdue rentals.
- **Issue Reporting**: Report broken bicycles or service concerns.
- **Map Integration**: View bike stations and available bicycles on an interactive map.

## Technologies Used
| **Category**             | **Technology**                     | **Purpose**                                        |
|-------------------------|---------------------------------|---------------------------------------------------|
| **Programming Language** | Java (JSP & Servlets)          | Web application development                      |
| **Web Framework**       | JSP (JavaServer Pages)         | Handles front-end UI components                  |
| **Web Server**          | GlassFish Server               | Supports JSP, Servlets, and Java EE features     |
| **Database**           | MySQL (JDBC)                   | Stores user, rental, and transaction data       |
| **File Handling**       | Java File I/O                  | Manages data storage and retrieval              |

## Project Structure

BicycleRentalSystem/<br>
├── **build/** → Compiled files<br>
├── **dist/** → Distribution folder<br>
├── **lib/** → Libraries and dependencies<br>
├── **nbproject/** → NetBeans project files<br>
├── **src/** → Java source files (Servlets, Database, Models)<br>
├── **test/** → Test files<br>
├── **web/** → Web application files (JSP, CSS, JS)<br>
└── **build.xml** → Apache Ant build file<br>


## Installation & Setup

### **Prerequisites**
- **Java Development Kit (JDK)**
- **Apache NetBeans IDE (or any preferred IDE)**
- **GlassFish Server**
- **MySQL Database**

### **Steps to Set Up**
1. **Clone the Repository**

   ```sh
   git clone https://github.com/aida-nabila/bicycle-rental.git
   cd bicycle-rental
   
2. **Set Up the Database**
  - Import the provided SQL file into MySQL.
  - Update dbconn.java with your MySQL credentials.
  - Deploy on GlassFish

3. **Open NetBeans and load the project.**
  - Configure the GlassFish server.
  - Run the project.

4. **Access the System** <br>
Open a browser and visit: http://localhost:8080/BicycleRental/

## License
This project is for educational purposes and follows university guidelines. Redistribution without permission is prohibited.
