--find top 10 highest reveue generating products 
SELECT product_id, SUM(sale_price) AS sales
FROM `Order_Info`
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;



--find top 5 highest selling products in each region
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY sales DESC) AS rn
    FROM (
        SELECT region, product_id, SUM(sale_price) AS sales
        FROM `Order_Info`
        GROUP BY region, product_id
    ) AS cte
) AS A
WHERE rn <= 5;



--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
SELECT order_month,
       SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
       SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM (
    SELECT YEAR(order_date) AS order_year,
           MONTH(order_date) AS order_month,
           SUM(sale_price) AS sales
    FROM `Order_Info`
    GROUP BY YEAR(order_date), MONTH(order_date)
) AS cte
GROUP BY order_month
ORDER BY order_month;


--which sub category had highest growth by profit in 2023 compare to 2022
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) AS rn
    FROM (
        SELECT category,
               DATE_FORMAT(order_date, '%Y%m') AS order_year_month,
               SUM(sale_price) AS sales
        FROM `Order_Info`
        GROUP BY category, DATE_FORMAT(order_date, '%Y%m')
    ) AS cte
) AS a
WHERE rn = 1;
