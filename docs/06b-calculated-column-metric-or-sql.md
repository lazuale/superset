# Шпаргалка к уроку 06. Calculated Column, Metric или SQL?

Эта памятка отвечает на один вопрос:

> **где должен жить расчёт?**

Самая короткая схема:

```text
значение одной строки
→ Calculated Column

показатель группы строк
→ Metric

нужно изменить сам входной набор данных
→ SQL / Virtual Dataset
```

## 1. Сначала определите уровень расчёта

Главное различие — не синтаксис SQL, а уровень данных.

```text
строка
→ Calculated Column

группа / набор строк
→ Metric

структура Dataset
→ SQL / Virtual Dataset
```

## 2. Calculated Column — атрибут строки

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

Если выражение можно мысленно добавить как ещё один столбец к каждой строке — это хороший кандидат на Calculated Column.

## 3. Metric — показатель группы

Пример курса:

```sql
SUM(revenue) - SUM(cost)
```

Без измерения (`Dimension`):

```text
Прибыль = 1530.00
```

С:

```text
Dimension = region
```

получаем:

```text
Север = 520.00
Юг    = 1010.00
```

Одна и та же метрика пересчитывается внутри текущих групп и фильтров.

## 4. SQL / Virtual Dataset — меняем набор данных

SQL нужен, когда задача уже не сводится к одному атрибуту строки или одной агрегированной метрике.

Типовые причины:

```text
JOIN
CTE
UNION
оконные функции
сложная подготовка полей
изменение зерна результата
```

Такой SQL формирует входной набор для дальнейшего Explore.

Подробно Virtual Dataset изучается позже, в уроке 11.

## 5. Один показатель на трёх уровнях

### Прибыль одной продажи

```sql
revenue - cost
```

→ `Calculated Column`

### Общая прибыль выбранных строк

```sql
SUM(revenue) - SUM(cost)
```

→ `Metric`

### Прибыль после подготовки нескольких таблиц

```text
SQL / Virtual Dataset / слой БД
```

Название показателя может быть одинаковым, а уровень расчёта — разным.

## 6. Calculated Column и Metric могут работать вместе

Нормальный сценарий:

```text
Calculated Column:
profit = revenue - cost
```

затем:

```text
Metric:
SUM(profit)
```

То есть:

```text
сначала значение строки
→ потом агрегирование группы
```

## 7. Когда сохранять Metric в Dataset

Если показатель используется в нескольких графиках (`Chart`), лучше определить одну сохранённую метрику.

Плюсы:

```text
единое определение
единый Label
повторное использование
меньше риска разных формул одного KPI
```

Разовая метрика (`ad hoc metric`) удобна для разовой проверки.

## 8. `CASE` сам по себе ничего не решает

Построчный `CASE`:

```sql
CASE WHEN revenue >= 500 THEN 'Крупная' ELSE 'Обычная' END
```

→ Calculated Column.

`CASE` внутри агрегирования:

```sql
SUM(CASE WHEN region = 'Север' THEN revenue ELSE 0 END)
```

→ Metric.

Смотрите на уровень расчёта, а не на ключевое слово.

## 9. Когда SQL уже нужно вынести из Superset

Если логика:

```text
тяжёлая
общая для многих Dashboard
нужна другим системам
должна материализоваться
является частью общей модели данных
```

разумнее рассмотреть:

```text
VIEW
MATERIALIZED VIEW
таблицу-витрину
DWH / ETL / ELT
```

Это уже архитектурное решение следующего уровня, а не обязательная часть урока 06.

## Быстрая таблица выбора

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

## Главное

```text
Calculated Column
→ атрибут строки

Metric
→ показатель группы

SQL / Virtual Dataset
→ формирует набор данных
```

Это не три случайных места, куда можно вставить похожий SQL. Это разные уровни аналитической модели.

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
