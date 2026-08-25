# 10. SQL Lab с нуля

## Результат урока

После урока вы должны уметь:

- открыть `SQL Lab`;
- выбрать `Training PostgreSQL` и схему `training`;
- выполнить обычный `SELECT`;
- использовать `WHERE`, `GROUP BY`, `ORDER BY`, `COUNT`, `SUM`;
- читать результат во вкладке `Results`;
- понимать разницу между `Run` и `Run selection`;
- понимать, что SQL-диалект определяется подключённой СУБД, а не Superset.

## Перед началом

Должны быть пройдены уроки 02–09.

Подключение:

```text
Training PostgreSQL
```

должно работать с таблицей:

```text
training.sales
```

Контроль исходных данных:

```text
rows     = 12
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

## Открываем SQL Lab

В верхнем меню выберите:

```text
SQL → SQL Lab
```

Откроется `SQL Editor`.

Выберите:

```text
Database: Training PostgreSQL
Schema:   training
```

В браузере объектов найдите таблицу:

```text
sales
```

## Важно: у SQL Lab нет отдельного «универсального SQL Superset»

SQL Lab отправляет запрос выбранному SQL-источнику.

В этом курсе источник:

```text
PostgreSQL 17
```

поэтому все SQL-примеры уроков 10–11 написаны для PostgreSQL.

Упрощённо:

```text
SQL Lab
→ текст запроса PostgreSQL
→ Training PostgreSQL
→ PostgreSQL разбирает и выполняет SQL
→ Superset показывает результат
```

Базовые конструкции вроде `SELECT`, `WHERE` и `GROUP BY` встречаются во многих SQL-системах, но конкретный синтаксис функций и типов может различаться.

Например используемый ниже фрагмент:

```sql
DATE_TRUNC('month', sale_date)::date
```

является PostgreSQL-ориентированным примером. В ClickHouse, Trino, MySQL и других движках эквивалентная задача может записываться иначе.

Поэтому при работе с реальной системой всегда сначала определяйте:

```text
к какому подключению Database относится SQL Lab
→ какой SQL-диалект поддерживает этот источник
```

## Первый SELECT

Введите:

```sql
SELECT *
FROM training.sales;
```

Нажмите:

```text
Run
```

После запуска Superset активирует вкладку:

```text
Results
```

Ожидается 12 строк и девять физических столбцов:

```text
sale_id
sale_date
region
office
manager
product
quantity
revenue
cost
```

## Выбираем конкретные столбцы

Выполните:

```sql
SELECT
    sale_id,
    sale_date,
    region,
    product,
    revenue
FROM training.sales
ORDER BY sale_id;
```

Ожидается 12 строк, отсортированных по `sale_id`.

## WHERE

Получим только Север:

```sql
SELECT
    sale_id,
    sale_date,
    region,
    product,
    revenue
FROM training.sales
WHERE region = 'Север'
ORDER BY sale_id;
```

Ожидается 6 строк.

Суммарная выручка этих строк:

```text
1360.00
```

## COUNT

Посчитайте все строки:

```sql
SELECT COUNT(*) AS row_count
FROM training.sales;
```

Ожидается:

```text
row_count = 12
```

Сравните с `manager`:

```sql
SELECT
    COUNT(*) AS row_count,
    COUNT(manager) AS manager_count,
    COUNT(DISTINCT manager) AS manager_distinct_count
FROM training.sales;
```

Ожидается:

```text
row_count              = 12
manager_count          = 11
manager_distinct_count = 4
```

## SUM

Общая выручка:

```sql
SELECT SUM(revenue) AS revenue
FROM training.sales;
```

Ожидается:

```text
4005.00
```

Общая прибыль без Calculated Column Superset:

```sql
SELECT
    SUM(revenue) - SUM(cost) AS profit
FROM training.sales;
```

Ожидается:

```text
1530.00
```

Здесь выражение выполняет PostgreSQL. Сохранённая метрика `Прибыль` из урока 06 для этого SQL не используется.

## GROUP BY

Выручка по регионам:

```sql
SELECT
    region,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY region
ORDER BY region;
```

Ожидается:

| region | revenue |
|---|---:|
| Север | 1360.00 |
| Юг | 2645.00 |

Прибыль по регионам:

```sql
SELECT
    region,
    SUM(revenue) - SUM(cost) AS profit
FROM training.sales
GROUP BY region
ORDER BY region;
```

Ожидается:

| region | profit |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

## Фильтр периода в SQL

Для февраля 2026 года выполните:

```sql
SELECT
    region,
    SUM(revenue) AS revenue,
    SUM(revenue) - SUM(cost) AS profit
FROM training.sales
WHERE sale_date >= DATE '2026-02-01'
  AND sale_date <  DATE '2026-03-01'
GROUP BY region
ORDER BY region;
```

Ожидается:

| region | revenue | profit |
|---|---:|---:|
| Север | 450.00 | 175.00 |
| Юг | 730.00 | 285.00 |

Итого:

```text
revenue = 1180.00
profit  = 460.00
```

Границы совпадают с моделью периода из Explore:

```text
2026-02-01 <= sale_date < 2026-03-01
```

## Выручка по месяцам

PostgreSQL может сгруппировать даты самостоятельно:

```sql
SELECT
    DATE_TRUNC('month', sale_date)::date AS month,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;
```

Ожидается:

| month | revenue |
|---|---:|
| 2026-01-01 | 1160.00 |
| 2026-02-01 | 1180.00 |
| 2026-03-01 | 1665.00 |

В Explore аналогичную задачу мы решали через:

```text
Dimensions = sale_date
Time grain = Month
Metrics    = SUM(revenue)
```

## Run selection

Если в `SQL Editor` выделить часть SQL-текста, подпись кнопки меняется с:

```text
Run
```

на:

```text
Run selection
```

`Run selection` выполняет выделенный фрагмент.

Снимите выделение, чтобы снова выполнить весь текст кнопкой `Run`.

Горячая клавиша запуска:

```text
Ctrl + Enter
```

## Самостоятельная проверка

### Выручка по продуктам

Напишите запрос, который вернёт:

```text
Датчик        = 1210.00
Маршрутизатор = 1605.00
Терминал      = 1190.00
```

### Количество разных офисов

Ожидается:

```text
4
```

### Прибыль по продуктам

Ожидается:

```text
Маршрутизатор = 630.00
Датчик        = 475.00
Терминал      = 425.00
```

## SQL Lab и Dataset

SQL Lab выполняет SQL непосредственно через выбранное подключение Database.

Dataset нужен для повторно используемой аналитической модели Superset: столбцов, Calculated Columns, Metrics, Explore и Chart.

В следующем уроке результат SQL Lab будет сохранён как `Virtual Dataset`.

## Типовые ошибки

### Relation does not exist

Проверьте полное имя:

```text
training.sales
```

### Синтаксис из другого SQL-движка не работает

Сначала проверьте, какое подключение Database выбрано в SQL Lab.

Примеры курса рассчитаны на PostgreSQL. Не переносите функции и особенности синтаксиса дословно в другую СУБД без проверки её документации.

### Выполнился только фрагмент

Снимите выделение текста. При выделении кнопка называется:

```text
Run selection
```

### Пустой результат по периоду

Проверьте даты. Учебный набор содержит январь–март 2026 года.

### COUNT(manager) = 11

Это правильный результат: одна строка содержит `manager = NULL`.

### Нет таблицы sales в браузере объектов

Проверьте:

```text
Database = Training PostgreSQL
Schema   = training
```

## Критерий завершения

Вы должны самостоятельно получить SQL-запросами:

```text
COUNT(*)                = 12
COUNT(manager)           = 11
COUNT(DISTINCT manager)  = 4
SUM(revenue)             = 4005.00
profit                   = 1530.00
```

и результаты по регионам и месяцам из контрольных таблиц выше.

Также вы должны понимать:

```text
SQL Lab не создаёт отдельный SQL-диалект Superset;
синтаксис определяется выбранным SQL-источником.
```

## Материалы после урока

Чтобы быстро вспомнить **только базовый SQL этого урока**:

→ [Шпаргалка: минимальный SQL для Superset](10a-minimal-sql-cheatsheet.md)

Когда появится задача соединить таблицы:

→ [Справочник: JOIN без размножения данных](10b-join-without-duplication.md)

`JOIN` не требуется для завершения урока 10; он вынесен после базового SQL специально, чтобы не ломать последовательность.

Для `HAVING`, `CASE`, `COALESCE`, CTE и оконных функций:

→ [Справочник: следующий уровень SQL](reference/sql-next-level.md)

Этот справочник также не входит в обязательный маршрут 01–12.

Следующий урок — сохранение SQL как Virtual Dataset.

→ [Урок 11. Создаём Virtual Dataset](11-create-virtual-dataset.md)

## Источники Superset 6.1.0

- верхнее меню `SQL → SQL Lab`: <https://github.com/apache/superset/blob/6.1.0/superset/initialization/__init__.py>
- `SQL Editor` и переход на `Results`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/SqlEditor/index.tsx>
- кнопки `Run`, `Run selection`, `Stop` и Ctrl+Enter: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/RunQueryActionButton/index.tsx>
- результаты SQL Lab: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ResultSet/index.tsx>
