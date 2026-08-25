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
-- Север: rows=6, quantity=10, revenue=1360.00, cost=840.00, profit=520.00
-- Юг:    rows=6, quantity=21, revenue=2645.00, cost=1635.00, profit=1010.00
SELECT
    region,
    COUNT(*) AS rows,
    SUM(quantity) AS quantity,
    SUM(revenue) AS revenue,
    SUM(cost) AS cost,
    SUM(revenue - cost) AS profit
FROM training.sales
GROUP BY region
ORDER BY region;

-- По месяцам:
-- 2026-01-01: revenue=1160.00, cost=730.00,  profit=430.00
-- 2026-02-01: revenue=1180.00, cost=720.00,  profit=460.00
-- 2026-03-01: revenue=1665.00, cost=1025.00, profit=640.00
SELECT
    date_trunc('month', sale_date)::date AS month,
    SUM(revenue) AS revenue,
    SUM(cost) AS cost,
    SUM(revenue - cost) AS profit
FROM training.sales
GROUP BY 1
ORDER BY 1;

-- По продуктам:
-- Датчик:        quantity=13, revenue=1210.00, cost=735.00, profit=475.00
-- Маршрутизатор: quantity=11, revenue=1605.00, cost=975.00, profit=630.00
-- Терминал:      quantity=7,  revenue=1190.00, cost=765.00, profit=425.00
SELECT
    product,
    SUM(quantity) AS quantity,
    SUM(revenue) AS revenue,
    SUM(cost) AS cost,
    SUM(revenue - cost) AS profit
FROM training.sales
GROUP BY product
ORDER BY product;

-- NULL и количество менеджеров:
-- rows=12, rows_with_manager=11, distinct_managers=4, rows_without_manager=1
SELECT
    COUNT(*) AS rows,
    COUNT(manager) AS rows_with_manager,
    COUNT(DISTINCT manager) AS distinct_managers,
    COUNT(*) FILTER (WHERE manager IS NULL) AS rows_without_manager
FROM training.sales;

-- По непустым менеджерам:
-- Анна:  rows=3, revenue=750.00,  cost=465.00, profit=285.00
-- Борис: rows=3, revenue=610.00,  cost=375.00, profit=235.00
-- Денис: rows=2, revenue=1035.00, cost=630.00, profit=405.00
-- Клара: rows=3, revenue=1250.00, cost=785.00, profit=465.00
SELECT
    manager,
    COUNT(*) AS rows,
    SUM(quantity) AS quantity,
    SUM(revenue) AS revenue,
    SUM(cost) AS cost,
    SUM(revenue - cost) AS profit
FROM training.sales
WHERE manager IS NOT NULL
GROUP BY manager
ORDER BY manager;
