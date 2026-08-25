# Справочник. Следующий уровень SQL после базового курса

Этот материал **не входит в обязательный маршрут 01–12**.

Он нужен после урока 10, когда базовые конструкции уже понятны:

```text
SELECT
FROM
WHERE
GROUP BY
COUNT / SUM
ORDER BY
```

Здесь собраны следующие часто нужные инструменты SQL.

## 1. `HAVING` — фильтр уже сформированных групп

`WHERE` отбирает исходные строки до группировки.

`HAVING` отбирает группы после агрегирования.

```sql
SELECT
    region,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY region
HAVING SUM(revenue) > 2000;
```

Запомнить:

```text
WHERE  → строки
HAVING → группы
```

## 2. `CASE` — условие внутри результата

```sql
SELECT
    sale_id,
    revenue,
    CASE
        WHEN revenue >= 500 THEN 'Крупная'
        WHEN revenue >= 250 THEN 'Средняя'
        ELSE 'Малая'
    END AS revenue_group
FROM training.sales;
```

Если такая классификация относится к каждой строке и нужна повторно в одном Dataset, сравните SQL-вариант с `Calculated Column`.

## 3. `COALESCE` — первое значение, которое не `NULL`

```sql
SELECT
    COALESCE(manager, 'Не указан') AS manager
FROM training.sales;
```

`COALESCE` полезен для представления отсутствующих значений, но не восстанавливает неизвестные исходные данные.

## 4. CTE через `WITH`

CTE помогает разбить запрос на понятные этапы.

```sql
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', sale_date)::date AS month,
        SUM(revenue) AS revenue
    FROM training.sales
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    month,
    revenue
FROM monthly
ORDER BY month;
```

CTE улучшает структуру запроса, но не исправляет неправильное зерно или JOIN.

## 5. JOIN

Базовый синтаксис:

```sql
SELECT
    ...
FROM table_a AS a
LEFT JOIN table_b AS b
    ON b.key = a.key;
```

Для аналитики важнее синтаксиса проверить кардинальность и итоговое зерно.

Подробно:

→ [JOIN без размножения данных](../10b-join-without-duplication.md)

## 6. Оконные функции

Оконная функция рассчитывает значение по набору связанных строк, не сворачивая их обязательно в одну строку группы.

Типовые примеры:

```sql
ROW_NUMBER() OVER (...)
LAG(...) OVER (...)
LEAD(...) OVER (...)
SUM(...) OVER (...)
```

Пример нумерации продаж внутри региона:

```sql
SELECT
    sale_id,
    region,
    sale_date,
    ROW_NUMBER() OVER (
        PARTITION BY region
        ORDER BY sale_date, sale_id
    ) AS row_num
FROM training.sales;
```

Оконные функции полезны для ранжирования, предыдущих/следующих значений и накопительных расчётов.

## 7. Подзапросы и несколько этапов подготовки

Если аналитический вопрос требует сначала получить один набор, а потом считать поверх него, используйте подзапрос или CTE.

Но перед усложнением задайте вопрос:

```text
этот SQL нужен только одной аналитической задаче?
```

Если одна и та же тяжёлая логика используется многими Dashboard и системами, её лучше рассмотреть как часть слоя данных в БД/DWH.

## 8. Когда этого уже недостаточно

Следующий уровень после отдельных SQL-конструкций:

- проектирование фактов и измерений;
- зерно таблиц;
- устойчивые аналитические витрины;
- материализованные представления (`MATERIALIZED VIEW`);
- ETL/ELT;
- производительность запросов;
- индексы и партиционирование;
- единые определения корпоративных показателей.

Это уже не базовый курс Superset.

## Связанные материалы

- [Урок 10. SQL Lab с нуля](../10-sql-lab.md)
- [Минимальный SQL для Superset](../10a-minimal-sql-cheatsheet.md)
- [JOIN без размножения данных](../10b-join-without-duplication.md)
- [Calculated Column, Metric или SQL?](../06b-calculated-column-metric-or-sql.md)
- [Physical Dataset или Virtual Dataset?](../11a-physical-vs-virtual-dataset.md)

## Источники

Примеры рассчитаны на PostgreSQL учебного стенда. SQL Lab Apache Superset 6.1.0 выполняет запросы через подключённый SQL-источник:

- <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/SqlLab>
