# automatic-potato
SQL demo for job applications

# Portfolio Database Project: MySQL Demonstration

This project sets up a multi-table MySQL database designed to showcase core SQL proficiency. It initializes the database schema, populates it with sample data, and provides basic to advanced queries demonstrating essential data manipulation and analysis skills.

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
   ```sql
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
   CREATE DATABASE  IF NOT EXISTS classicmodels;
   USE classicmodels;
   ```
5. Click the **Lightning Bolt icon** (Execute) to run the entire script.

## Database Schema Overview

The imported database consists of the following tables, built to demonstrate standard relational database design (including primary and foreign key constraints):

* **`customers`** - [Stores data on buyers including contact info, address, credit limits, and sales representatives.]
* **`employees`** - [Holds staff details, email addresses, job titles, and the internal reporting hierarchy.]
* **`offices`** - [Contains data on physical office locations, phone numbers, addresses, and territories.]
* **`orders`** - [Records details of sales transactions like order dates, delivery dates, and shipping status.]
* **`orderdetails`** - [Stores the specific quantity, pricing, and products for individual sales orders.]
* **`payments`** - [Tracks monetary transactions, check numbers, payment dates, and outstanding balance credits.]
* **`products`** - [A catalog of inventory with stock numbers, vendor names, buy prices, and MSRP prices.]
* **`product lines`** - [Defines product categories alongside text or HTML descriptions and images.]

## Demonstration Queries

Below are the 10–15 core queries included in this project, categorized by complexity. They demonstrate proficiency in data retrieval, filtering, multi-table joins, and aggregations.

### Basic Data Retrieval (SELECT, WHERE, ORDER BY)
* **Query 1:** [Goal of query, e.g., Retrieve all active customers sorted by registration date.]
* **Query 2:** [Goal of query, e.g., Find all products priced over \$50.]

### Aggregations & Grouping (GROUP BY, HAVING, Aggregate Functions)
* **Query 3:** [Goal of query, e.g., Calculate total sales revenue per product category.]
* **Query 4:** [Goal of query, e.g., Find customers who have placed more than 5 orders.]

### Multi-Table Relations (INNER JOIN, LEFT JOIN)
* **Query 5:** [Goal of query, e.g., Combine order data with customer details to view purchasing behavior.]
* **Query 6:** [Goal of query, e.g., Identify products that have never been ordered using a LEFT JOIN.]

### Text & Date Manipulation (LIKE, Date Functions)
* **Query 7:** [Goal of query, e.g., Filter transactions that occurred strictly within the last quarter.]

*(Tip for the user: Paste your exact SQL query code blocks beneath each bullet point to show off your code directly in the README!)*
