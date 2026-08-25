# Шпаргалка к уроку 10. Минимальный SQL для Superset

Эта страница не заменяет учебник SQL.

Она нужна, чтобы быстро вспомнить конструкции, которые уже используются в базовом уроке 10 и при контрольной проверке Chart.

## Самый короткий каркас

```sql
SELECT
    ...
FROM ...
WHERE ...
GROUP BY ...
ORDER BY ...;
```

Не каждая часть обязательна.

## 1. `SELECT` и `FROM`

Все строки:

```sql
SELECT *
FROM training.sales;
```

Только нужные поля:

```sql
SELECT
    sale_id,
    sale_date,
    region,
    revenue
FROM training.sales;
```

Для постоянного `Virtual Dataset` лучше перечислять нужные столбцы явно, если структура результата уже известна.

## 2. `WHERE` — какие исходные строки оставить

Только Север:

```sql
SELECT *
FROM training.sales
WHERE region = 'Север';
```

Несколько условий:

```sql
SELECT *
FROM training.sales
WHERE region = 'Север'
  AND revenue >= 200;
```

Несколько допустимых значений:

```sql
WHERE region IN ('Север', 'Юг')
```

## 3. Период

Полный февраль 2026 года:

```sql
WHERE sale_date >= DATE '2026-02-01'
  AND sale_date <  DATE '2026-03-01'
```

Модель:

```text
начало включительно
конец исключительно
```

Она совпадает с логикой периода, используемой в учебных упражнениях Superset.

## 4. `COUNT` и `SUM`

```sql
COUNT(*)
→ количество строк

COUNT(manager)
→ количество строк, где manager не NULL

COUNT(DISTINCT manager)
→ количество разных непустых manager

SUM(revenue)
→ сумма revenue
```

Для `training.sales`:

```text
COUNT(*)               = 12
COUNT(manager)          = 11
COUNT(DISTINCT manager) = 4
SUM(revenue)            = 4005.00
```

Подробно:

→ [Как выбрать агрегирование](06a-aggregations.md)

## 5. `GROUP BY` — одна строка на группу

Выручка по регионам:

```sql
SELECT
    region,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY region;
```

Результат имеет зерно:

```text
1 строка = 1 region
```

Если добавить `product`:

```sql
SELECT
    region,
    product,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY
    region,
    product;
```

Теперь:

```text
1 строка = 1 комбинация region + product
```

## 6. `ORDER BY`

По убыванию результата:

```sql
ORDER BY revenue DESC;
```

По возрастанию:

```sql
ORDER BY revenue ASC;
```

## 7. `DISTINCT`

Уникальные регионы:

```sql
SELECT DISTINCT region
FROM training.sales
ORDER BY region;
```

Количество уникальных значений:

```sql
SELECT COUNT(DISTINCT region)
FROM training.sales;
```

`DISTINCT` не является универсальным способом «починить дубли» после неправильного JOIN.

## 8. `NULL`

`NULL` — отсутствие значения.

Правильно:

```sql
WHERE manager IS NULL
```

или:

```sql
WHERE manager IS NOT NULL
```

Неправильно:

```sql
manager = NULL
```

## 9. `LIMIT` для быстрого просмотра

Когда нужно посмотреть небольшой образец строк:

```sql
SELECT *
FROM training.sales
ORDER BY sale_id
LIMIT 10;
```

`LIMIT` ограничивает количество строк результата, но сам по себе не определяет, какие строки считать «первыми». Для воспроизводимого примера обычно добавляйте `ORDER BY`.

## 10. Контрольный SQL для Explore

Explore:

```text
Dimension = region
Metric    = SUM(revenue)
```

Контрольный SQL:

```sql
SELECT
    region,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY region
ORDER BY region;
```

Ожидается:

```text
Север = 1360.00
Юг    = 2645.00
```

Если Chart и SQL не совпадают, сравнивайте одинаковые:

```text
Dataset / FROM
Filters / WHERE
Dimension / GROUP BY
Metric / агрегат
период
```

## 11. Перед `Virtual Dataset`

Проверьте:

```text
[ ] Запрос выполняется без ошибки.
[ ] Понятно, что означает одна строка результата.
[ ] Количество строк ожидаемое.
[ ] Контрольные суммы совпадают.
[ ] Названия столбцов понятные.
[ ] Нет случайной преждевременной агрегации.
```

## 12. Что не входит в эту шпаргалку

Следующие конструкции относятся уже к следующему уровню SQL:

```text
HAVING
CASE
COALESCE
JOIN
CTE / WITH
оконные функции
```

Они специально вынесены из базовой памятки, чтобы урок 10 оставался последовательным.

- JOIN: [JOIN без размножения данных](10b-join-without-duplication.md)
- остальной следующий уровень: [справочник по продвинутому SQL](reference/sql-next-level.md)

## Главное

```text
SQL Lab полезен не только для сложных запросов,
но и как контроль правильности аналитического расчёта.
```

## Связанные материалы

- [Урок 10. SQL Lab с нуля](10-sql-lab.md)
- [Как выбрать агрегирование](06a-aggregations.md)
- [Зерно Dataset](06c-data-grain.md)
- [Почему цифры в Superset не сходятся](07b-troubleshoot-wrong-numbers.md)
- [Урок 11. Создаём Virtual Dataset](11-create-virtual-dataset.md)

## Источники Superset 6.1.0

- SQL Editor: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/SqlEditor/index.tsx>
- `Run` / `Run selection`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/RunQueryActionButton/index.tsx>
- результаты SQL Lab: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ResultSet/index.tsx>

Примеры SQL рассчитаны на PostgreSQL учебного стенда курса.