-- Overall expected result:
-- rows=12, quantity=31, revenue=4005.00, cost=2475.00
SELECT
  COUNT(*) AS rows,
  SUM(quantity) AS quantity,
  SUM(revenue) AS revenue,
  SUM(cost) AS cost
FROM training.sales;

-- Expected by region:
-- North: rows=6, quantity=10, revenue=1360.00
-- South: rows=6, quantity=21, revenue=2645.00
SELECT
  region,
  COUNT(*) AS rows,
  SUM(quantity) AS quantity,
  SUM(revenue) AS revenue
FROM training.sales
GROUP BY region
ORDER BY region;

-- Expected monthly revenue in UTC:
-- 2026-01: 1160.00
-- 2026-02: 1180.00
-- 2026-03: 1665.00
SELECT
  date_trunc('month', sale_ts AT TIME ZONE 'UTC') AS month,
  SUM(revenue) AS revenue
FROM training.sales
GROUP BY 1
ORDER BY 1;

-- Expected by product:
-- Router:   quantity=11, revenue=1605.00
-- Sensor:   quantity=13, revenue=1210.00
-- Terminal: quantity=7,  revenue=1190.00
SELECT
  product,
  SUM(quantity) AS quantity,
  SUM(revenue) AS revenue
FROM training.sales
GROUP BY product
ORDER BY product;

-- Expected: 1
SELECT COUNT(*) AS manager_is_null
FROM training.sales
WHERE manager IS NULL;
