-- ecommerce_analysis.sql
-- Sample schema and data for Ecommerce SQL Analysis

-- 1. Create tables
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. Insert sample data
INSERT INTO users VALUES
(1,'Alice','alice@example.com'),
(2,'Bob','bob@example.com'),
(3,'Charlie','charlie@example.com');

INSERT INTO products VALUES
(101,'Laptop',80000),
(102,'Headphones',2000),
(103,'Mouse',500);

INSERT INTO orders VALUES
(1001,1,'2025-09-01'),
(1002,2,'2025-09-02'),
(1003,1,'2025-09-03');

INSERT INTO order_items VALUES
(1,1001,101,1),
(2,1001,102,2),
(3,1002,103,3),
(4,1003,102,1);

-- 3. Interview Question Examples
-- Difference between WHERE and HAVING
-- WHERE filters rows before aggregation; HAVING filters groups after aggregation.

-- Types of joins: INNER, LEFT, RIGHT, FULL OUTER (if supported)

-- 4. Queries

-- a) Average revenue per user
SELECT u.user_id, u.name,
       SUM(oi.quantity * p.price) / COUNT(DISTINCT u.user_id) AS avg_revenue
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.name;

-- b) Subquery: Top 2 spenders
SELECT user_id, total_spent FROM (
    SELECT u.user_id,
           SUM(oi.quantity * p.price) AS total_spent
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY u.user_id
) AS spend
ORDER BY total_spent DESC
LIMIT 2;

-- c) View for monthly revenue
CREATE VIEW monthly_revenue AS
SELECT DATE_TRUNC('month', o.order_date) AS month,
       SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY DATE_TRUNC('month', o.order_date);

-- d) Index optimization
CREATE INDEX idx_orders_user_id ON orders(user_id);
