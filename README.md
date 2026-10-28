# automatic-potato
Commercial Operations & Database Optimization Demo
By **Christian Glakas**

# Portfolio Database Project: MySQL Demonstration

A comprehensive, production-ready SQL portfolio spanning five architectural domains. This repository showcases how targeted database engineering, query optimization, and advanced analytics transform raw relational schemas into highly performant, executive-ready commercial business intelligence.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Database Setup & Installation](#database-setup--installation)
- [Database Schema Overview](#database-schema-overview)
- [Demonstration Queries](#demonstration-queries)

## Prerequisites

Before running this project, ensure you have the following installed:
* **Database Engine:** MySQL 8.0 or higher
* **Interface:** MySQL Command Line Client or a GUI client (e.g., MySQL Workbench, DBeaver, VS Code MySQL Extension)

## Database Setup & Installation

Follow these steps to import the database structure and sample data.

### Option 1: Via the MySQL Command Line Client
1. Open your terminal or command prompt.
2. Connect to your MySQL server:
   ```bash
   mysql -u root -p
   ```
3. Create the target database and exit:
   ```mysql
   CREATE DATABASE classicmodels;
   EXIT;
   ```
4. Import the script file (`01_classicmodels_schema.sql`) into your new database:
   ```bash
   mysql -u root -p classicmodels < 01_classicmodels_schema.sql
   ```

### Option 2: Via MySQL Workbench
1. Open MySQL Workbench and connect to your database instance.
2. Go to the top menu and select **File** ➔ **Open SQL Script...**
3. Select `01_classicmodels_schema.sql` from your local machine.
4. The script contains a `CREATE DATABASE` statement at the top on line 8:
   ```sql
   CREATE DATABASE IF NOT EXISTS classicmodels;
   USE classicmodels;
   ```
5. Click the **Lightning Bolt icon** (Execute) to run the entire script.

## Database Schema Overview

The imported database consists of the following tables, built to demonstrate standard relational database design (including primary and foreign key constraints):

* **`customers`** - Stores data on buyers including contact info, address, credit limits, and sales representatives.
* **`employees`** - Holds staff details, email addresses, job titles, and the internal reporting hierarchy.
* **`offices`** - Contains data on physical office locations, phone numbers, addresses, and territories.
* **`orders`** - Records details of sales transactions like order dates, delivery dates, and shipping status.
* **`orderdetails`** - Stores the specific quantity, pricing, and products for individual sales orders.
* **`payments`** - Tracks monetary transactions, check numbers, payment dates, and outstanding balance credits.
* **`products`** - A catalog of inventory with stock numbers, vendor names, buy prices, and MSRP prices.
* **`product lines`** - Defines product categories alongside text or HTML descriptions and images.

## Demonstration Queries

### Project Architecture & Framework

Below are the queries included in this project, categorized by purpose. They demonstrate proficiency in data query performance engineering, dynamic executive dashboarding, advanced data governance, program performance evaluation, and zero-footprint risk management.

### Category 1: ENVIRONMENT SETUP & LOOKUP ARCHITECTURE

* **Query 1:** System Initialization - Establish workspace
```mysql
USE classicmodels;
```

* **Query 2:** Base structural audit - Verify table presence
```mysql
SHOW TABLES;
```

* **Query 3:** Basic Lookups - Customer profiles
```mysql
SELECT * 
FROM customers
LIMIT 5;
```

* **Query 4:** Product & inventory tracking structure
```mysql
SELECT
    productCode,
    productName,
    productLine,
    productScale,
    productVendor,
    LEFT(productDescription, 30) AS short_description,
    quantityinStock,
    buyPrice,
    MSRP
FROM products
LIMIT 5;
```

* **Query 5:** Order history
```mysql
SELECT *
FROM orders
LIMIT 5;
```

* **Query 6:** Order details
```mysql
SELECT *
FROM orderdetails
LIMIT 5;
```

### Category 2: BUSINESS AGGREGATIONS & DESCRIPTIVE STATISTICS

* **Query 1: Basic Summary Metrics**
```mysql
SELECT 
    COUNT(orderNumber) AS total_orders_processed,
    SUM(quantityOrdered) AS total_items_sold,
    MIN(priceEach) AS cheapest_item_sold,
    MAX(priceEach) AS most_expensive_item_sold,
    AVG(priceEach) AS overall_average_item_price
FROM orderdetails;
```

* **Query 2: Customer Credit Report**
```mysql
SELECT
    country,
    COUNT(customerNumber) AS total_customers,
    MAX(creditLimit) AS max_credit,
    AVG(creditLimit) AS avg_credit
FROM customers
GROUP BY country
HAVING max_credit > 0
ORDER BY total_customers DESC
LIMIT 5;
```

* **Query 3: Customer Order Tracking**
```mysql
SELECT
    c.customerNumber,
    c.customerName,
    o.orderNumber,
    o.orderDate,
    od.productCode,
    od.quantityOrdered
FROM customers c 
	INNER JOIN orders o 
		ON c.customerNumber = o.customerNumber
	INNER JOIN orderdetails od 
		ON o.orderNumber = od.orderNumber
ORDER BY c.customerNumber
LIMIT 10;
```

* **Query 4: Inventory Outlier Filtering**
```mysql
SELECT
    productCode,
    productName,
    productLine,
    quantityinStock
FROM products
WHERE quantityinStock > (SELECT AVG(quantityinStock) FROM products)
ORDER BY quantityinStock DESC
LIMIT 10;
```

* **Query 5: Inventory Outlier Filtering (CEO Variant with Subquery)**
```mysql
SELECT
    productCode,
    productName,
    productLine,
    quantityinStock,
    (SELECT AVG(quantityinStock) FROM products) AS avg_quantityinStock
FROM products
WHERE quantityinStock > (SELECT AVG(quantityinStock) FROM products)
ORDER BY quantityinStock DESC
LIMIT 10;
```

* **Query 6: Customer Peak Payments**
```mysql
SELECT
    c.customerName,
    c.customerNumber,
    (SELECT MAX(p.amount)
     FROM payments p 
     WHERE p.customerNumber = c.customerNumber) AS max_amount_paid
FROM customers c
ORDER BY max_amount_paid DESC
LIMIT 5;
```

*(Tip for the user: Paste your exact SQL query code blocks beneath each bullet point to show off your code directly in the README!)*
