-- Общая контрольная строка:
-- rows=12, quantity=31, revenue=4005.00, cost=2475.00, profit=1530.00
SELECT
    COUNT(*) AS rows,
    SUM(quantity) AS quantity,
    SUM(revenue) AS revenue,
    SUM(cost) AS cost,
    SUM(revenue - cost) AS profit
FROM training.sales;

-- По регионам:
-- Север: rows=6, quantity=10, revenue=1360.00
-- Юг:    rows=6, quantity=21, revenue=2645.00
SELECT
    region,
    COUNT(*) AS rows,
    SUM(quantity) AS quantity,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY region
ORDER BY region;

-- По месяцам:
-- 2026-01-01: 1160.00
-- 2026-02-01: 1180.00
-- 2026-03-01: 1665.00
SELECT
    date_trunc('month', sale_date)::date AS month,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY 1
ORDER BY 1;

-- По продуктам:
-- Датчик:        quantity=13, revenue=1210.00
-- Маршрутизатор: quantity=11, revenue=1605.00
-- Терминал:      quantity=7,  revenue=1190.00
SELECT
    product,
    SUM(quantity) AS quantity,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY product
ORDER BY product;

-- Одна строка специально оставлена без менеджера.
-- Ожидаемый результат: 1
SELECT COUNT(*) AS rows_without_manager
FROM training.sales
WHERE manager IS NULL;
