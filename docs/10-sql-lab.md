# 10. SQL Lab с нуля

До этого все основные расчёты мы получали через Explore. Теперь сделаем то же самое руками в SQL и увидим, что Superset не изобретает отдельный «свой SQL» — запрос выполняет подключённая СУБД.

В нашем стенде это PostgreSQL 17, поэтому примеры ниже написаны именно для PostgreSQL.

## Открываем SQL Lab

Перейдите:

```text
SQL → SQL Lab
```

В `SQL Editor` выберите:

```text
Database: Training PostgreSQL
Schema:   training
```

В браузере объектов должна быть видна таблица:

```text
sales
```

Исходные контрольные значения нам уже знакомы:

```text
rows     = 12
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

## Важная оговорка про SQL

SQL Lab только отправляет запрос выбранному источнику и показывает ответ.

То есть цепочка такая:

```text
SQL Lab → PostgreSQL → результат → Superset
```

Поэтому синтаксис зависит от конкретной СУБД. Например:

```sql
DATE_TRUNC('month', sale_date)::date
```

нормален для PostgreSQL, но в ClickHouse, Trino или MySQL та же задача может записываться иначе.

Это нужно помнить, когда уйдём от учебного стенда к реальным источникам.

## Первый SELECT

Начнём с самого простого:

```sql
SELECT *
FROM training.sales;
```

Нажмите:

```text
Run
```

Superset откроет вкладку:

```text
Results
```

Ожидается 12 строк и девять физических столбцов.

Теперь выберем только несколько полей:

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

Результат всё ещё содержит 12 строк, но уже только нужные столбцы.

## WHERE: оставляем только часть строк

Получим продажи Севера:

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

Ожидается 6 строк. Их общая выручка нам уже известна:

```text
1360.00
```

Это тот же смысл, что обычный Filter в Explore.

## COUNT: три похожих, но разных вопроса

Количество всех строк:

```sql
SELECT COUNT(*) AS row_count
FROM training.sales;
```

Результат:

```text
12
```

Теперь сравним три варианта:

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

Это ровно та же логика, которую мы уже проходили через Metrics в Explore.

## SUM и прибыль

Общая выручка:

```sql
SELECT SUM(revenue) AS revenue
FROM training.sales;
```

```text
4005.00
```

Общая прибыль:

```sql
SELECT
    SUM(revenue) - SUM(cost) AS profit
FROM training.sales;
```

```text
1530.00
```

Здесь PostgreSQL сам считает выражение. Сохранённая Metric `Прибыль` из Dataset в этот запрос не подставляется.

## GROUP BY: тот же смысл, что Dimension

Выручка по регионам:

```sql
SELECT
    region,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY region
ORDER BY region;
```

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

| region | profit |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

Если в Explore `Dimension = region`, то по смыслу мы делали то же самое.

## Период в SQL

Для полного февраля 2026 года:

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

Границы те же, что мы использовали в Explore:

```text
2026-02-01 <= sale_date < 2026-03-01
```

## Группировка по месяцам

PostgreSQL может сам привести даты к началу месяца:

```sql
SELECT
    DATE_TRUNC('month', sale_date)::date AS month,
    SUM(revenue) AS revenue
FROM training.sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;
```

Результат:

| month | revenue |
|---|---:|
| 2026-01-01 | 1160.00 |
| 2026-02-01 | 1180.00 |
| 2026-03-01 | 1665.00 |

В Explore ту же задачу мы решали через:

```text
Dimensions = sale_date
Time grain = Month
Metrics    = SUM(revenue)
```

## `Run` и `Run selection`

Если выделить часть SQL-текста, кнопка меняется с:

```text
Run
```

на:

```text
Run selection
```

В этом режиме выполняется только выделенный фрагмент. Если неожиданно запускается не весь запрос, первым делом снимите выделение.

Горячая клавиша:

```text
Ctrl + Enter
```

## Попробуйте написать три запроса самостоятельно

Получите выручку по продуктам:

```text
Датчик        = 1210.00
Маршрутизатор = 1605.00
Терминал      = 1190.00
```

Посчитайте количество разных офисов:

```text
4
```

И прибыль по продуктам:

```text
Маршрутизатор = 630.00
Датчик        = 475.00
Терминал      = 425.00
```

Если эти три задачи решаются без копирования готового запроса, базовый SQL уже можно считать освоенным на уровне этого курса.

## SQL Lab и Dataset — не одно и то же

SQL Lab удобен для запроса, проверки и исследования результата.

Dataset нужен, когда эта логика должна стать повторно используемой аналитической моделью Superset: с колонками, Metrics, Explore и Chart.

В следующем уроке мы как раз возьмём результат SQL и сохраним его как `Virtual Dataset`.

## Если запрос не работает

Ошибка `relation does not exist` — сначала проверьте полное имя:

```text
training.sales
```

Если синтаксис кажется правильным, но PostgreSQL его не принимает, убедитесь, что пример вообще написан для PostgreSQL, а не перенесён из другой СУБД.

Если выполняется только часть текста — снимите выделение, чтобы кнопка снова стала `Run`.

Если период возвращает пустой результат, проверьте даты: в учебном наборе есть только январь–март 2026 года.

`COUNT(manager) = 11` — правильный результат, потому что одна строка имеет `NULL`.

Если таблица `sales` не видна в браузере объектов, проверьте:

```text
Database = Training PostgreSQL
Schema   = training
```

## Перед Virtual Dataset

К этому моменту вы должны самостоятельно получать SQL-запросами:

```text
COUNT(*)               = 12
COUNT(manager)          = 11
COUNT(DISTINCT manager) = 4
SUM(revenue)            = 4005.00
profit                  = 1530.00
```

и понимать, что SQL-диалект определяется выбранным источником, а не самим Superset.

Базовые конструкции можно быстро вспомнить по [шпаргалке SQL](10a-minimal-sql-cheatsheet.md). JOIN вынесен отдельно в [справочник о размножении строк](10b-join-without-duplication.md), а `HAVING`, `CASE`, CTE и оконные функции — в [следующий уровень SQL](reference/sql-next-level.md).

Следующий шаг — сохранить SQL-результат как Virtual Dataset.

→ [Урок 11. Создаём Virtual Dataset](11-create-virtual-dataset.md)

## Источники Superset 6.1.0

- верхнее меню `SQL → SQL Lab`: <https://github.com/apache/superset/blob/6.1.0/superset/initialization/__init__.py>
- `SQL Editor` и переход на `Results`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/SqlEditor/index.tsx>
- кнопки `Run`, `Run selection`, `Stop` и Ctrl+Enter: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/RunQueryActionButton/index.tsx>
- результаты SQL Lab: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ResultSet/index.tsx>