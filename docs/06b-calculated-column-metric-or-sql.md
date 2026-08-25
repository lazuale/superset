# Шпаргалка к уроку 06. Calculated Column, Metric или SQL?

Вопрос здесь один: **на каком уровне должен жить расчёт?**

```text
значение одной строки
→ Calculated Column

показатель группы строк
→ Metric

нужно изменить сам входной набор данных
→ SQL / Virtual Dataset
```

Главное различие — не синтаксис SQL, а уровень данных.

## 1. Calculated Column — атрибут строки

Пример:

```sql
revenue - cost
```

Для каждой продажи появляется собственный `profit`.

Другие примеры:

```sql
quantity * unit_price
```

```sql
CASE
  WHEN revenue >= 500 THEN 'Крупная'
  ELSE 'Обычная'
END
```

```sql
COALESCE(manager, 'Не указан')
```

Если выражение можно мысленно добавить как ещё один столбец к каждой строке, это хороший кандидат на Calculated Column.

## 2. Metric — показатель группы

Пример курса:

```sql
SUM(revenue) - SUM(cost)
```

Без измерения:

```text
Прибыль = 1530.00
```

С `Dimension = region`:

```text
Север = 520.00
Юг    = 1010.00
```

Одна и та же метрика пересчитывается внутри текущих групп и фильтров.

## 3. SQL / Virtual Dataset — меняем набор данных

SQL нужен, когда задача уже не сводится к одному атрибуту строки или одной агрегированной метрике: например, требуется JOIN, CTE, UNION, оконная функция, сложная подготовка полей или изменение зерна результата.

Такой запрос формирует входной набор для дальнейшего Explore. Механику Virtual Dataset разбираем в уроке 11.

## Один показатель на разных уровнях

Прибыль одной продажи:

```sql
revenue - cost
```

→ `Calculated Column`

Общая прибыль выбранных строк:

```sql
SUM(revenue) - SUM(cost)
```

→ `Metric`

Если прибыль считается уже после подготовки нескольких таблиц, расчёт может находиться в SQL, Virtual Dataset или слое БД.

Название показателя может быть одинаковым, а уровень расчёта — разным.

## Calculated Column и Metric могут работать вместе

Нормальный вариант:

```text
Calculated Column:
profit = revenue - cost

Metric:
SUM(profit)
```

Сначала получаем значение строки, затем агрегируем его по выбранным группам.

## Когда сохранять Metric в Dataset

Если показатель используется в нескольких графиках, сохранённая метрика удобнее разовых копий формулы: у неё одно определение, одно отображаемое имя и меньше риска получить несколько вариантов одного KPI.

Разовая метрика (`ad hoc metric`) остаётся удобной для проверки и эксперимента.

## `CASE` сам по себе не определяет уровень расчёта

Построчный вариант:

```sql
CASE WHEN revenue >= 500 THEN 'Крупная' ELSE 'Обычная' END
```

→ Calculated Column.

`CASE` внутри агрегирования:

```sql
SUM(CASE WHEN region = 'Север' THEN revenue ELSE 0 END)
```

→ Metric.

Смотрите на то, что рассчитывается, а не на наличие конкретного SQL-слова.

## Когда SQL лучше вынести из Superset

Если логика тяжёлая, нужна многим Dashboard, используется другими системами или является общей моделью данных, стоит рассмотреть слой БД:

```text
VIEW
MATERIALIZED VIEW
таблица-витрина
DWH / ETL / ELT
```

Это уже архитектурное решение, а не обязательная часть урока 06.

## Таблица выбора

| Задача | Где делать |
|---|---|
| `revenue - cost` для каждой строки | Calculated Column |
| категория строки через `CASE` | Calculated Column |
| `SUM(revenue)` | Metric |
| `COUNT(DISTINCT manager)` | Metric |
| маржа выбранной группы | Metric |
| JOIN таблиц | SQL / Virtual Dataset |
| CTE / UNION / оконная функция | SQL / Virtual Dataset |
| тяжёлая общая витрина | чаще слой БД |

## Связанные материалы

- [Урок 06. Метрики и расчёты](06-metrics-and-calculations.md)
- [Агрегации](06a-aggregations.md)
- [Зерно Dataset](06c-data-grain.md)
- [Урок 10. SQL Lab](10-sql-lab.md)
- [Урок 11. Virtual Dataset](11-create-virtual-dataset.md)
- [Physical Dataset или Virtual Dataset](11a-physical-vs-virtual-dataset.md)

## Источники Superset 6.1.0

- редактор Dataset: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/components/Datasource/components/DatasourceEditor/DatasourceEditor.tsx>
- редактор разовой метрики (`ad hoc metric`): <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/MetricControl/AdhocMetricEditPopover/index.tsx>
- SQL Lab: <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/SqlLab>
