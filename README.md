# FoodZone: Online Food Ordering & Management System

> **Architecture:** Pure Jakarta MVC (Model-View-Controller)  
> **Backend:** Java 25 LTS, Jakarta EE 10 (Servlet 6.0), JDBC  
> **Frontend:** JSP, JSTL 3.0, Modern Responsive Vanilla CSS & JavaScript  
> **Server:** Apache Tomcat 10.1 (`http://localhost:8080/foodzone/`)  
> **Database:** MySQL Server 8.0 (`foodzone_db`)

---

## 🛠️ Complete Setup Commands & Installation Guide

Follow these step-by-step terminal commands to set up, build, deploy, and run FoodZone from scratch on your local machine.

### Prerequisites
* **Java:** JDK 17+ or Java 25 LTS installed (`javac -version`, `java -version`)
* **Server:** Apache Tomcat 10.1 installed (e.g. `C:\apache-tomcat-10.1`)
* **Database:** MySQL Server 8.0 installed and running on port 3306

---

### Step 1: Initialize MySQL Database & Seed Data

Ensure the `MySQL80` service is running, then open PowerShell and execute the DDL script:

```powershell
# Navigate to the Foodzone project directory
cd c:\Users\hp\OneDrive\Desktop\Foodzone

# Import schema.sql into MySQL (replace 'vansh2025' with your root password)
Get-Content schema.sql | & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -pvansh2025
```

*Alternative using Windows Command Prompt (cmd.exe):*
```cmd
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -pvansh2025 < schema.sql
```

*Verify database creation in MySQL:*
```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -pvansh2025 -e "USE foodzone_db; SHOW TABLES;"
```

---

### Step 2: Configure Database Connection

Open `src/main/resources/db.properties` and verify your credentials:

```properties
db.url=jdbc:mysql://localhost:3306/foodzone_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.user=root
db.password=vansh2025
db.driver=com.mysql.cj.jdbc.Driver
```

---

### Step 3: Build & Compile the Project

You can compile the Java source files and generate `target/foodzone.war` using any of the following methods:

#### Method A: 1-Click PowerShell Script (Build + Deploy + Launch Server)
```powershell
.\build.ps1
```
> **What this does in 1 click:**
> 1. Compiles all Java source code
> 2. Packages `target/foodzone.war`
> 3. Deploys directly to `C:\apache-tomcat-10.1\webapps\foodzone`
> 4. Starts the Apache Tomcat 10.1 server (if not already running)
> 5. Automatically launches your default browser at `http://localhost:8080/foodzone/home`
>
> *(To compile only without launching the server, pass: `.\build.ps1 -BuildOnly`)*

#### Method B: 1-Click Windows Batch Script
```cmd
build.bat
```

#### Method C: Using Apache Maven (If Maven is installed)
```bash
mvn clean package
```

#### Method D: Manual Compilation with `javac`
```powershell
# 1. Create classes directory
New-Item -ItemType Directory -Force -Path "src\main\webapp\WEB-INF\classes"

# 2. Copy runtime db.properties to classes
Copy-Item "src\main\resources\db.properties" "src\main\webapp\WEB-INF\classes\db.properties" -Force

# 3. Compile all Java source files
$sources = (Get-ChildItem -Recurse -Filter "*.java" -Path "src\main\java").FullName
$cp = "src\main\webapp\WEB-INF\classes;C:\apache-tomcat-10.1\lib\servlet-api.jar;src\main\webapp\WEB-INF\lib\*"
javac -cp $cp -d "src\main\webapp\WEB-INF\classes" $sources

# 4. Package standalone WAR file
New-Item -ItemType Directory -Force -Path "target"
& "C:\Program Files\Java\jdk-25.0.4\bin\jar.exe" -cvf "target\foodzone.war" -C "src\main\webapp" .
```

---

### Step 4: Deploy to Apache Tomcat 10.1

#### Option 1: Exploded Directory Deployment (Instant Updates)
```powershell
# Copy the entire webapp directory into Tomcat's webapps folder
Copy-Item -Recurse -Force "src\main\webapp" "C:\apache-tomcat-10.1\webapps\foodzone"
```

#### Option 2: Standalone WAR Deployment
```powershell
# Copy target\foodzone.war to Tomcat webapps
Copy-Item -Force "target\foodzone.war" "C:\apache-tomcat-10.1\webapps\"
```

---

### Step 5: Start & Stop Tomcat Server

#### Start Tomcat (Foreground with real-time logs):
```powershell
$env:CATALINA_HOME = "C:\apache-tomcat-10.1"
$env:CATALINA_BASE = "C:\apache-tomcat-10.1"
& "C:\apache-tomcat-10.1\bin\catalina.bat" run
```

#### Start Tomcat (Background standalone window):
```powershell
$env:CATALINA_HOME = "C:\apache-tomcat-10.1"
$env:CATALINA_BASE = "C:\apache-tomcat-10.1"
& "C:\apache-tomcat-10.1\bin\startup.bat"
```

#### Stop Tomcat:
```powershell
& "C:\apache-tomcat-10.1\bin\shutdown.bat"
```

---

### Step 6: Launch & Verify in Browser

Run in PowerShell to automatically open the home page in your default browser:
```powershell
Start-Process "http://localhost:8080/foodzone/home"
```

#### Application Endpoints:
* **Customer Home:** [http://localhost:8080/foodzone/home](http://localhost:8080/foodzone/home)
* **Food Menu & Ordering:** [http://localhost:8080/foodzone/menu](http://localhost:8080/foodzone/menu)
* **Shopping Cart & Coupons:** [http://localhost:8080/foodzone/cart](http://localhost:8080/foodzone/cart)
* **Checkout (Structured Address & Domino's Presets):** [http://localhost:8080/foodzone/checkout](http://localhost:8080/foodzone/checkout)
* **Domino's Live Tracker & 30-Min Guarantee:** [http://localhost:8080/foodzone/order-details?id=1](http://localhost:8080/foodzone/order-details)
* **Customer Order History & 5-Star Reviews:** [http://localhost:8080/foodzone/orders](http://localhost:8080/foodzone/orders)
* **👤 Customer Profile View:** [http://localhost:8080/foodzone/profile](http://localhost:8080/foodzone/profile)
* **🛵 Delivery Partner Hub & Progressive Trips:** [http://localhost:8080/foodzone/delivery/dashboard](http://localhost:8080/foodzone/delivery/dashboard)
* **🛵 Delivery Partner Profile & Fleet Credentials:** [http://localhost:8080/foodzone/delivery/profile](http://localhost:8080/foodzone/delivery/profile)
* **Admin Dashboard:** [http://localhost:8080/foodzone/admin/dashboard](http://localhost:8080/foodzone/admin/dashboard)
* **Admin Order Pipeline & Rider Dispatch:** [http://localhost:8080/foodzone/admin/orders](http://localhost:8080/foodzone/admin/orders)
* **Admin Menu Catalog:** [http://localhost:8080/foodzone/admin/menu](http://localhost:8080/foodzone/admin/menu)
* **👨‍🍳 System Administrator Profile:** [http://localhost:8080/foodzone/admin/profile](http://localhost:8080/foodzone/admin/profile)

---

## 🔑 Demo Credentials (3-Entity Commercial Architecture)

| Entity Role | Email | Password | Access Privileges |
| :--- | :--- | :--- | :--- |
| **System Administrator** | `admin@foodzone.com` | `admin123` | Full Admin Portal (`/admin/*`), live orders, menu CRUD, customer records, **Rider dispatch assignment** |
| **Delivery Partner** | `rider@foodzone.com` | `rider123` | Dedicated Mobile-first Rider Dashboard (`/delivery/dashboard`), navigation maps, customer call links, **4-Digit Doorstep Delivery OTP verification** |
| **Customer** | `customer@gmail.com` | `user123` | Menu catalog, shopping cart, promo coupons, takeaway toggle, checkout, **Domino's 4-stage visual order tracker**, OTP card, self-cancellation |

> **Tip:** On the [Sign In page](http://localhost:8080/foodzone/login), click **Customer**, **Admin**, or **Rider Demo** to auto-fill credentials with a single click.

### 🎟️ Active Demo Promo Codes
| Coupon Code | Discount | Minimum Order | Description |
| :--- | :--- | :--- | :--- |
| `WELCOME50` | **₹50 OFF** | ₹200 | Flat ₹50 off on first order |
| `DOM100` | **₹100 OFF** | ₹400 | Domino's party special discount |
| `FREEDEL` | **Free Delivery** | ₹150 | Waives ₹40 delivery fee |

---

## 📂 Project Architecture

```
Foodzone/
├── pom.xml                                  <-- Maven build descriptor
├── build.ps1                                <-- 1-Click PowerShell build & packaging script
├── build.bat                                <-- 1-Click Windows batch builder
├── README.md                                <-- Project documentation & setup manual
├── schema.sql                               <-- MySQL schema & initial seed data
├── FOODZONE_IMPLEMENTATION_PLAN.md          <-- Master architectural blueprint
├── Foodzone_SYNOPSIS.docx                   <-- Academic project synopsis
├── target/
│   └── foodzone.war                         <-- 5.84 MB Standalone deployable WAR package
│
└── src
    └── main
        ├── java/com/foodzone
        │   ├── config/DBConnection.java     <-- Thread-safe JDBC Connection Provider
        │   ├── model/                       <-- Entity POJOs (User, Category, FoodItem, Cart...)
        │   ├── dao/                         <-- JDBC PreparedStatements & ACID Transactions
        │   ├── filter/                      <-- Security, Role Authorization & Encoding Guards
        │   ├── util/                        <-- Password hashing (SHA-256) & Validation utils
        │   └── controller/                  <-- Jakarta Servlets
        │       ├── (Home, Menu, Cart, Checkout, Order, Auth)
        │       └── admin/ (Dashboard, Menu, Order, User Servlets)
        │
        ├── resources/db.properties          <-- JDBC database credentials
        └── webapp/
            ├── WEB-INF
            │   ├── web.xml                  <-- Jakarta EE 10 Deployment Descriptor
            │   ├── lib/                     <-- MySQL & Jakarta JSTL 3.0 JARs
            │   ├── classes/                 <-- Compiled Java Bytecode (.class)
            │   └── views/                   <-- Protected JSP templates (common, customer, admin, auth)
            └── static/
                ├── css/ (main.css, customer.css, admin.css)
                └── js/ (main.js, cart.js, admin.js)
```

---

## 🎓 Academic Viva Defense Cheat Sheet

1. **Why Pure MVC over JSP Scriptlets?**  
   *Separates presentation from data and business logic. JSP acts purely as the View, Servlets as Controllers, and DAOs as Models, preventing spaghetti code and SQL injection.*

2. **How does FoodZone guarantee ACID transaction during checkout?**  
   *In `OrderDAO.placeOrder(...)`, auto-commit is disabled (`conn.setAutoCommit(false)`). The master record is inserted into `orders`, its generated key is captured, and line items are batch-inserted into `order_items`. If any operation fails, `conn.rollback()` executes, preventing orphaned records.*

3. **Why `jakarta.*` packages instead of `javax.*`?**  
   *Tomcat 10.1 implements Jakarta EE 10 (Servlet 6.0). In Jakarta EE 9+, the namespace transitioned from legacy `javax.*` to `jakarta.*` following Oracle's transition to the Eclipse Foundation.*

4. **How is SQL Injection prevented?**  
   *All database interactions strictly use JDBC `PreparedStatement` with parameterized placeholders (`?`). User inputs are treated strictly as typed data rather than executable query fragments.*
