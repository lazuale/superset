# Шпаргалка к уроку 10. Минимальный SQL для Superset

Эта страница не заменяет учебник SQL.

Она нужна как короткая памятка после урока 10: **какую конструкцию SQL использовать, если нужно быстро проверить данные, повторить расчёт из Explore или подготовить Virtual Dataset**.

Главное правило:

```text
сначала сформулируйте вопрос к данным
        ↓
определите, что является одной строкой результата
        ↓
только потом пишите SELECT
```

Если непонятно, что должна означать одна строка результата, SQL почти наверняка рано писать.

---

## 1. Каркас обычного запроса

Базовый шаблон:

```sql
SELECT
    ...
FROM ...
WHERE ...
GROUP BY ...
HAVING ...
ORDER BY ...;
```

Не каждая часть обязательна.

Самый простой запрос:

```sql
SELECT *
FROM training.sales;
```

---

## 2. Что делает каждая часть

| Конструкция | Смысл |
|---|---|
| `SELECT` | какие столбцы и расчёты вернуть |
| `FROM` | откуда брать данные |
| `JOIN` | какие ещё таблицы присоединить |
| `WHERE` | какие исходные строки оставить |
| `GROUP BY` | по каким признакам собрать строки в группы |
| `HAVING` | какие уже сформированные группы оставить |
| `ORDER BY` | как отсортировать итог |
| `LIMIT` | сколько строк результата вернуть |

Коротко:

```text
FROM / JOIN
→ получаем набор строк

WHERE
→ отбрасываем ненужные строки

GROUP BY
→ формируем группы

агрегаты
→ считаем показатели внутри групп

HAVING
→ отбрасываем ненужные группы

SELECT
→ формируем результат

ORDER BY
→ сортируем результат
```

Это схема для понимания логики запроса, а не полный разбор внутреннего порядка выполнения SQL во всех СУБД.

---

# 3. SELECT

Выберите только нужные поля:

```sql
SELECT
    sale_id,
    sale_date,
    region,
    revenue
FROM training.sales;
```

Для исследования можно использовать:

```sql
SELECT *
FROM training.sales;
```

Но для постоянного Virtual Dataset лучше перечислять нужные столбцы явно.

Почему:

```text
понятна структура результата
меньше лишних данных
изменение исходной таблицы не добавит новый столбец неожиданно
```

---

# 4. WHERE — фильтр исходных строк

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

Один из нескольких вариантов:

```sql
SELECT *
FROM training.sales
WHERE region IN ('Север', 'Юг');
```

---

## Фильтр периода

Для календарного февраля:

```sql
WHERE sale_date >= DATE '2026-02-01'
  AND sale_date <  DATE '2026-03-01'
```

То есть:

```text
2026-02-01 <= sale_date < 2026-03-01
```

Такой полуоткрытый интервал хорошо согласуется с моделью `Start inclusive / End exclusive`, используемой в учебном маршруте.

Не пишите для timestamp без необходимости условие вида:

```sql
... <= '2026-02-28 23:59:59'
```

У данных может быть более высокая точность времени. Граница первым моментом следующего периода обычно надёжнее.

---

# 5. GROUP BY — одна строка на группу

Вопрос:

> сколько выручки у каждого региона?

```sql
SELECT
    region,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY region;
```

Результат:

```text
одна строка = один region
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
одна строка = одна комбинация region + product
```

Это изменение зерна результата.

---

# 6. Основные агрегаты

```sql
SUM(revenue)
COUNT(*)
COUNT(manager)
COUNT(DISTINCT manager)
AVG(revenue)
MIN(revenue)
MAX(revenue)
```

Для учебных данных:

```text
COUNT(*)               = 12
COUNT(manager)          = 11
COUNT(DISTINCT manager) = 4
SUM(revenue)            = 4005.00
AVG(revenue)            = 333.75
```

Подробно выбор агрегата разобран в:

→ [Шпаргалка: как выбрать агрегацию](06a-aggregations.md)

---

# 7. COUNT(*) и COUNT(column) — не одно и то же

```sql
COUNT(*)
```

считает строки.

```sql
COUNT(manager)
```

считает только строки, где `manager` не `NULL`.

```sql
COUNT(DISTINCT manager)
```

считает уникальные непустые значения `manager`.

Поэтому:

```text
12
11
4
```

могут одновременно быть правильными ответами на три разных вопроса.

---

# 8. DISTINCT

Уникальные регионы:

```sql
SELECT DISTINCT region
FROM training.sales
ORDER BY region;
```

Количество уникальных регионов:

```sql
SELECT COUNT(DISTINCT region)
FROM training.sales;
```

Но `DISTINCT` не является универсальным средством удаления «дублей».

Если JOIN размножил строки, сначала исправьте причину размножения.

Не лечите неверное зерно запросом:

```sql
SELECT DISTINCT ...
```

только потому, что визуально стало меньше строк.

→ [Шпаргалка: JOIN и зерно данных](06c-join-and-data-grain.md)

---

# 9. WHERE и HAVING

`WHERE` фильтрует строки **до** группировки.

Например, только февраль:

```sql
SELECT
    region,
    SUM(revenue) AS revenue
FROM training.sales
WHERE sale_date >= DATE '2026-02-01'
  AND sale_date <  DATE '2026-03-01'
GROUP BY region;
```

`HAVING` фильтрует **группы после агрегирования**.

Например, оставить только регионы с выручкой больше 2000:

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
WHERE  → исходные строки
HAVING → агрегированные группы
```

---

# 10. ORDER BY

По убыванию выручки:

```sql
SELECT
    region,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY region
ORDER BY revenue DESC;
```

По возрастанию:

```sql
ORDER BY revenue ASC;
```

Если направление не указано, обычно используется `ASC`.

---

# 11. NULL

`NULL` означает отсутствие значения, а не пустую строку и не ноль.

Проверка:

```sql
WHERE manager IS NULL
```

Обратная проверка:

```sql
WHERE manager IS NOT NULL
```

Не используйте:

```sql
manager = NULL
```

Для `NULL` нужны `IS NULL` и `IS NOT NULL`.

---

# 12. COALESCE

Если для отображения нужно заменить `NULL`:

```sql
SELECT
    COALESCE(manager, 'Не указан') AS manager
FROM training.sales;
```

`COALESCE` возвращает первое непустое (`NOT NULL`) значение из списка.

Но помните: это меняет представление результата, а не восстанавливает отсутствующее исходное значение.

---

# 13. CASE

Построчная классификация:

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

`CASE` полезен для:

```text
категоризации
условных признаков
условных расчётов
```

Если выражение относится к одной строке и должно повторно использоваться внутри Dataset, сравните этот вариант с `Calculated Column`.

→ [Calculated Column, Metric или SQL?](06b-calculated-column-metric-or-sql.md)

---

# 14. JOIN

Базовая форма:

```sql
SELECT
    ...
FROM table_a a
LEFT JOIN table_b b
    ON b.key = a.key;
```

Перед JOIN обязательно задайте вопросы:

```text
что означает одна строка table_a?
что означает одна строка table_b?
сколько строк table_b может соответствовать одной строке table_a?
```

И после JOIN проверьте:

```sql
COUNT(*)
COUNT(DISTINCT ключ_факта)
контрольную SUM(...)
```

Если количество строк или сумма неожиданно выросли — Chart строить рано.

Подробно:

→ [JOIN и зерно данных](06c-join-and-data-grain.md)

---

# 15. LEFT JOIN и INNER JOIN

Упрощённо:

```text
INNER JOIN
→ оставить только строки, для которых найдено соответствие с обеих сторон

LEFT JOIN
→ сохранить все строки левой таблицы, даже если справа соответствия нет
```

Пример:

```sql
FROM sales s
LEFT JOIN managers m
    ON m.manager_id = s.manager_id
```

Если справочника для одной продажи нет, строка `sales` останется, а поля `m` будут `NULL`.

Но `LEFT JOIN` не защищает от размножения строк, если справа найдено несколько совпадений.

---

# 16. CTE — WITH

CTE позволяет дать промежуточному запросу имя:

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

Полезно, когда запрос логично разбивается на последовательные этапы.

Но CTE не делает неправильную модель данных правильной. Сначала зерно и логика, потом красота SQL.

---

# 17. Алиасы через AS

```sql
SUM(revenue) AS revenue
```

```sql
revenue - cost AS profit
```

Хорошее имя результата облегчает работу в Virtual Dataset.

Плохо:

```text
?column?
sum
expr_1
```

Хорошо:

```text
profit
revenue
manager_count
```

---

# 18. Не агрегируйте Virtual Dataset заранее без причины

Если Virtual Dataset нужен как построчный аналитический набор:

```text
одна строка = одна продажа
```

то запрос может быть:

```sql
SELECT
    sale_id,
    sale_date,
    region,
    revenue,
    cost,
    revenue - cost AS profit
FROM training.sales;
```

А уже Chart выполняет:

```text
Dimension = region
Metric    = SUM(profit)
```

Если заранее сделать:

```sql
GROUP BY region
```

зерно Virtual Dataset станет:

```text
одна строка = один регион
```

Это может быть нужно, но это уже другая аналитическая модель.

---

# 19. Минимальный порядок проверки SQL

Перед сохранением результата как Virtual Dataset:

```text
1. Запрос выполняется без ошибки?
2. Понятно, что означает одна строка?
3. Количество строк ожидаемое?
4. Ключевой объект не размножен?
5. Контрольные суммы совпадают?
6. NULL ведут себя ожидаемо?
7. Названия столбцов понятные?
8. Нет ненужного SELECT *?
9. Нет случайной преждевременной агрегации?
```

---

# 20. Если цифры в SQL и Chart разные

Не начинайте менять визуальные настройки.

Сравните одинаковые условия:

```text
Dataset / FROM
период
обычные Filters / WHERE
Dimensions / GROUP BY
Metric / агрегат
```

Например:

Explore:

```text
Dimensions = region
Metrics    = SUM(revenue)
```

контрольный SQL:

```sql
SELECT
    region,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY region;
```

Если результаты различаются, постепенно убирайте дополнительные фильтры и настройки до минимального воспроизводимого запроса.

→ [Почему цифры в Superset не сходятся](07b-troubleshoot-wrong-numbers.md)

---

# 21. Быстрая таблица «что написать»

| Нужно | SQL |
|---|---|
| все строки | `SELECT ... FROM ...` |
| отобрать строки | `WHERE` |
| получить уникальные значения | `DISTINCT` |
| посчитать строки | `COUNT(*)` |
| посчитать объекты | часто `COUNT(DISTINCT id)` |
| сложить значение | `SUM()` |
| получить среднее | `AVG()` |
| сгруппировать | `GROUP BY` |
| отфильтровать агрегаты | `HAVING` |
| отсортировать | `ORDER BY` |
| заменить `NULL` для вывода | `COALESCE()` |
| условие внутри результата | `CASE` |
| связать таблицы | `JOIN` |
| разбить запрос на этапы | `WITH` / CTE |

---

# 22. Главное правило

SQL Lab нужен не для того, чтобы писать максимально сложные запросы.

Для аналитика он особенно полезен как инструмент проверки:

```text
получил цифру в Chart
        ↓
повторил смысл простым SQL
        ↓
цифры совпали
        ↓
можно доверять следующему уровню визуализации
```

Если простой контрольный SQL уже даёт неправильный результат, проблема находится до Chart.

---

## Связанные материалы

- [Урок 10. SQL Lab с нуля](10-sql-lab.md)
- [Шпаргалка: агрегации](06a-aggregations.md)
- [Шпаргалка: Calculated Column, Metric или SQL?](06b-calculated-column-metric-or-sql.md)
- [Шпаргалка: JOIN и зерно данных](06c-join-and-data-grain.md)
- [Урок 11. Создаём Virtual Dataset](11-create-virtual-dataset.md)

## Источники Superset 6.1.0

- SQL Editor: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/SqlEditor/index.tsx>
- `Run` / `Run selection`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/RunQueryActionButton/index.tsx>
- результат SQL Lab: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ResultSet/index.tsx>

Примеры SQL этой шпаргалки используют PostgreSQL учебного стенда курса.