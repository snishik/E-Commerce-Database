-- Query 1: Selects products with weight over 500 grams, includes derived attribute "product_weight_kg" and order by original weight.
SELECT *, (product_weight_g / 1000) AS product_weight_kg
FROM products
WHERE product_weight_g > 500
ORDER BY product_weight_g;


-- Query 2: Retrieves order details with customer information using a LEFT OUTER JOIN and orders by zip code prefix.
SELECT order_id, customer_id, order_status, zip_code_prefix 
FROM orders LEFT OUTER JOIN customers 
USING(customer_id) 
ORDER BY zip_code_prefix;

-- Query 3: Retrieves order details along with the count of order items for orders with more than one item, ordered by item count.
SELECT o.order_id ,COUNT(o.order_item_id) AS order_item_Count, p.customer_id, p.order_status
FROM orders p JOIN order_items o
ON p.order_id = o.order_id
GROUP BY o.order_id
HAVING order_item_Count > 1 
ORDER BY order_item_Count DESC;


-- Query 4: Retrieves customer information along with total orders and average order value, calculated from orders and order_items tables, and orders by total orders in descending order.
SELECT c.customer_id, c.customer_unique_id, c.zip_code_prefix,
       customer_order.total_orders, customer_order.average_order_value
FROM customers c
INNER JOIN (
    -- Subquery in the FROM clause to calculate total orders and average order value for each customer
    SELECT o.customer_id,
           COUNT(o.order_id) AS total_orders,
           AVG(oi.price + oi.freight_value) AS average_order_value
    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) AS customer_order ON c.customer_id = customer_order.customer_id
ORDER BY customer_order.total_orders DESC;



-- Query 5: Creates a view 'customer_order_view' combining customer and order details with the count of order items for each order.
DROP VIEW IF EXISTS customer_order_view;
CREATE VIEW customer_order_view AS(SELECT
    cu.customer_id,
    cu.customer_unique_id,
    cu.zip_code_prefix,
    o.order_id,
    o.order_status,
    COUNT(oi.order_item_id) AS total_order_items
FROM
    customers cu
JOIN
    orders o ON cu.customer_id = o.customer_id
LEFT JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    cu.customer_id, o.order_id
);
-- Run a SELECT query on the created VIEW
SELECT * FROM customer_order_view;
-- Modify one of the underlying tables ('orders' table)
UPDATE orders
SET order_status = "Shipped"
WHERE order_id = "3e27135b0c650634ca397ea4c2943e1e";
-- Re-run the SELECT query on the VIEW to reflect changes in the underlying tables
SELECT * FROM customer_order_view
ORDER BY total_order_items DESC;



