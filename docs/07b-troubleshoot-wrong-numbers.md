# Шпаргалка к урокам 05–07. Почему цифры в Superset не сходятся

Эта памятка нужна, когда Chart не показывает ошибку, но результат кажется неправильным.

Главное правило:

> **проверяйте расчёт сверху вниз и меняйте по одной вещи за раз.**

## Аварийный алгоритм

```text
1. Правильный Dataset?
2. Правильный период?
3. Нет лишних Filters?
4. Правильные Dimensions?
5. Metric отвечает на нужный вопрос?
6. Правильная агрегация?
7. Учтены NULL?
8. Понятно зерно Dataset?
9. Если Dataset подготовлен SQL — JOIN не размножил строки?
10. Контрольный SQL даёт тот же результат?
```

## 1. Dataset

Сначала убедитесь, что Explore открыт на нужном Dataset.

Похожие Dataset могут иметь разные:

```text
таблицы
SQL Virtual Dataset
фильтры внутри SQL
колонки
зерно
```

Неправильный источник делает дальнейшую настройку бессмысленной.

## 2. Период

В учебном наборе данные находятся только в январе–марте 2026 года.

Для всего февраля:

```text
2026-02-01 <= sale_date < 2026-03-01
```

Если Chart пустой или показывает только часть данных, `Time range` проверяйте одним из первых.

Подробно:

→ [Time column, Time range и Time grain](05b-time-range-and-grain.md)

## 3. Filters

Проговорите каждый активный Filter словами.

Например:

```text
region = Север
```

при вопросе:

```text
общая выручка всех регионов
```

уже делает результат неправильным для поставленного вопроса, хотя Superset считает корректно.

## 4. Dimensions

Если ожидались две группы:

```text
Север
Юг
```

а получено одно итоговое число, проверьте, добавлен ли `region` как Dimension.

Если групп неожиданно слишком много, ищите лишний Dimension.

## 5. Metric и Aggregation

Проговорите расчёт словами:

```text
COUNT(*)
→ количество строк

COUNT(manager)
→ строки с непустым manager

COUNT_DISTINCT(manager)
→ разные manager

SUM(revenue)
→ сумма revenue
```

Если словесная формулировка не совпадает с бизнес-вопросом, Metric выбрана неправильно.

→ [Как выбрать агрегирование](06a-aggregations.md)

## 6. NULL

В `training.sales`:

```text
COUNT(*)       = 12
COUNT(manager) = 11
```

Это правильный результат: одна строка имеет `manager = NULL`.

## 7. Зерно Dataset

Спросите:

```text
1 строка = что?
```

Для `training.sales`:

```text
1 строка = 1 продажа
```

Если одна строка фактически представляет позицию документа, транзакцию или другой более детальный объект, `COUNT(*)` может считать не то, что вы думаете.

→ [Зерно Dataset](06c-data-grain.md)

## 8. JOIN проверяйте только если Dataset действительно подготовлен SQL

JOIN не является обязательной частью уроков 05–07.

Но если используемый Dataset уже создан SQL-запросом с JOIN и итог стал кратно больше, проверьте размножение строк.

Красные флаги:

```text
COUNT(*) вырос
COUNT(DISTINCT id) не вырос
SUM стала кратно больше
один id неожиданно повторяется
```

Подробный разбор идёт после SQL Lab:

→ [JOIN без размножения данных](10b-join-without-duplication.md)

## 9. Упростите Chart

Для диагностики временно оставьте:

```text
Visualization = Table
Dimension     = одна
Metric        = одна
Filters       = только необходимые
```

Сначала получите правильное число в простой таблице.

После этого возвращайте настройки по одной.

## 10. Сравните с контрольным SQL

Пример:

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

Если SQL и Chart различаются, сравните одинаковые:

```text
FROM      ↔ Dataset
WHERE     ↔ Filters / Time range
GROUP BY  ↔ Dimensions
SUM/COUNT ↔ Metric
```

## Таблица симптомов

| Симптом | Сначала проверить |
|---|---|
| Chart пустой | Time range, Filters, Dataset |
| число меньше ожидаемого | Filters, период, NULL |
| число больше ожидаемого | Aggregation, grain; при SQL-Dataset — JOIN |
| число выросло кратно | JOIN / дублирование строк |
| одна строка вместо нескольких групп | Dimensions |
| слишком много групп | лишние Dimensions |
| считаются строки вместо объектов | `COUNT(*)` vs `COUNT_DISTINCT` |
| вместо месяцев появились дни | Time grain |
| среднее странное | уровень данных, веса, grain |
| SQL и Chart различаются | Dataset, Filters, Dimension, Metric, период |

## Контрольные числа курса

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

По регионам:

```text
Север: revenue = 1360.00, profit = 520.00
Юг:    revenue = 2645.00, profit = 1010.00
```

Февраль:

```text
revenue = 1180.00
```

Менеджеры:

```text
COUNT(*)               = 12
COUNT(manager)          = 11
COUNT_DISTINCT(manager) = 4
```

## Главное

```text
Dataset
+ Filters
+ Dimensions
+ Metric
+ Aggregation
```

должны вместе отвечать **тому же вопросу**, который вы сформулировали словами.

## Связанные материалы

- [Dimension, Metric и Filter](05a-dimension-metric-filter.md)
- [Время](05b-time-range-and-grain.md)
- [Агрегации](06a-aggregations.md)
- [Зерно Dataset](06c-data-grain.md)
- [Как выбрать визуализацию](07a-choose-visualization.md)
- [Минимальный SQL](10a-minimal-sql-cheatsheet.md)

## Источники Superset 6.1.0

- Explore controls: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/shared-controls/dndControls.tsx>
- список агрегирований: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/constants.ts>
- временной диапазон: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/DateFilterControl/components/CustomFrame.tsx>
