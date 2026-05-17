-- =============================================
-- Amazon Products Analysis
-- Analyst: Raneem
-- Date: April 29, 2026
-- =============================================

USE Amazon_Analysis;

-- =============================================
-- Step 1: Verify Data Import
-- =============================================

-- Check total rows
SELECT COUNT(*) AS total_rows 
FROM amazon_products_clean;

-- Preview data
SELECT TOP 5 * 
FROM amazon_products_clean;

-- =============================================
-- Step 2: Fix Data Types
-- =============================================

-- Round price and rating to 2 decimal places
UPDATE amazon_products_clean
SET price = ROUND(price, 2),
    rating = ROUND(rating, 1);


	-- =============================================
-- Step 3: Pricing Analysis
-- =============================================

-- Average, Min, Max price
SELECT 
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(MIN(price), 2) AS min_price,
    ROUND(MAX(price), 2) AS max_price
FROM amazon_products_clean;

-- Price distribution by range
SELECT 
    CASE 
        WHEN price < 25 THEN 'Under $25'
        WHEN price BETWEEN 25 AND 50 THEN '$25 - $50'
        WHEN price BETWEEN 50 AND 100 THEN '$50 - $100'
        WHEN price BETWEEN 100 AND 250 THEN '$100 - $250'
        WHEN price BETWEEN 250 AND 500 THEN '$250 - $500'
        ELSE 'Over $500'
    END AS price_range,
    COUNT(*) AS total_products,
    ROUND(AVG(rating), 1) AS avg_rating
FROM amazon_products_clean
GROUP BY 
    CASE 
        WHEN price < 25 THEN 'Under $25'
        WHEN price BETWEEN 25 AND 50 THEN '$25 - $50'
        WHEN price BETWEEN 50 AND 100 THEN '$50 - $100'
        WHEN price BETWEEN 100 AND 250 THEN '$100 - $250'
        WHEN price BETWEEN 250 AND 500 THEN '$250 - $500'
        ELSE 'Over $500'
    END
ORDER BY MIN(price);

-- Average price by brand (Top 15)
SELECT TOP 15
    brand,
    COUNT(*) AS total_products,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(MIN(price), 2) AS min_price,
    ROUND(MAX(price), 2) AS max_price
FROM amazon_products_clean
WHERE brand != 'Generic'
GROUP BY brand
ORDER BY avg_price DESC;

-- =============================================
-- Step 4: Best Selling Products Analysis
-- =============================================

-- Top 15 best selling brands by units sold
SELECT TOP 15
    brand,
    COUNT(*) AS total_products,
    SUM(sold_past_month) AS total_sold,
    ROUND(AVG(sold_past_month), 0) AS avg_sold
FROM amazon_products_clean
WHERE sold_past_month IS NOT NULL
AND brand != 'Generic'
GROUP BY brand
ORDER BY total_sold DESC;

-- Top 15 best selling individual products
SELECT TOP 15
    title,
    brand,
    price,
    sold_past_month,
    rating
FROM amazon_products_clean
WHERE sold_past_month IS NOT NULL
ORDER BY sold_past_month DESC;


-- =============================================
-- Step 5: Customer Satisfaction Analysis
-- =============================================

-- Average rating by brand (Top 15)
SELECT TOP 15
    brand,
    COUNT(*) AS total_products,
    ROUND(AVG(rating), 1) AS avg_rating,
    SUM(reviews) AS total_reviews
FROM amazon_products_clean
WHERE rating IS NOT NULL
AND brand != 'Generic'
GROUP BY brand
ORDER BY avg_rating DESC;

-- Average rating by brand with more than 5 products
SELECT TOP 15
    brand,
    COUNT(*) AS total_products,
    ROUND(AVG(rating), 1) AS avg_rating,
    SUM(reviews) AS total_reviews
FROM amazon_products_clean
WHERE rating IS NOT NULL
AND brand != 'Generic'
GROUP BY brand
HAVING COUNT(*) > 5
ORDER BY avg_rating DESC;

-- Correlation between reviews and rating
SELECT 
    CASE 
        WHEN reviews < 100 THEN 'Under 100 reviews'
        WHEN reviews BETWEEN 100 AND 1000 THEN '100 - 1000 reviews'
        WHEN reviews BETWEEN 1000 AND 10000 THEN '1K - 10K reviews'
        WHEN reviews BETWEEN 10000 AND 50000 THEN '10K - 50K reviews'
        ELSE 'Over 50K reviews'
    END AS review_range,
    COUNT(*) AS total_products,
    ROUND(AVG(rating), 1) AS avg_rating,
    ROUND(AVG(price), 2) AS avg_price
FROM amazon_products_clean
WHERE reviews IS NOT NULL
AND rating IS NOT NULL
GROUP BY 
    CASE 
        WHEN reviews < 100 THEN 'Under 100 reviews'
        WHEN reviews BETWEEN 100 AND 1000 THEN '100 - 1000 reviews'
        WHEN reviews BETWEEN 1000 AND 10000 THEN '1K - 10K reviews'
        WHEN reviews BETWEEN 10000 AND 50000 THEN '10K - 50K reviews'
        ELSE 'Over 50K reviews'
    END
ORDER BY MIN(reviews);


-- =============================================
-- Summary of Findings
-- =============================================

-- Problem 1: Pricing Strategy
-- Average price: $139.25
-- Most products are under $25 (294 products)
-- Higher price = slightly lower rating

-- Problem 2: Best Selling Products
-- Logitech dominates with 339,100 units sold
-- Cheap products sell more
-- MROCO has highest avg sales per product

-- Problem 3: Customer Satisfaction
-- AOC and LOVEVOOK have highest ratings (4.6)
-- Logitech has most reviews (945,018)
-- Cheaper products get more reviews
