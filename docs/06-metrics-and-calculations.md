# 06. Метрики и расчёты

В Explore мы уже научились группировать и суммировать готовые столбцы. Теперь добавим собственный расчёт прибыли и заодно разберёмся, почему в Superset есть и `Calculated Column`, и `Metric`.

После урока в Dataset `sales` появятся два объекта:

```text
Calculated column: profit
Metric Key:         total_profit
Metric Label:       Прибыль
```

Они дадут одинаковую общую сумму `1530.00`, но работают на разных уровнях данных.

## Сначала — что означает одна строка

У нашего Dataset:

```text
1 строка = 1 продажа
```

Это его зерно данных. Без этого понимания легко получить правдоподобное, но бессмысленное число.

Например:

```text
COUNT(*) = 12
```

здесь можно назвать количеством продаж только потому, что одна продажа представлена одной строкой. Если бы одна строка была позицией документа, тот же `COUNT(*)` считал бы позиции.

То же самое с `SUM`. Складывать `revenue`, `cost` и `quantity` в нашем наборе логично. А вот `sale_id`, процент, температуру или остаток на дату нельзя автоматически суммировать только потому, что поле числовое.

Если с этим местом пока некомфортно, отдельно есть [шпаргалка по зерну Dataset](06c-data-grain.md).

## Несколько базовых агрегирований

Откройте:

```text
Datasets → sales
```

Для упражнений оставьте:

```text
Visualization: Table
Dimensions:    пусто
Filters:       sale_date (No filter)
```

Удалите из `Metrics` старые расчёты.

### SUM

Добавьте `revenue` с агрегированием `SUM`:

```text
SUM(revenue) = 4005.00
```

Затем `quantity`:

```text
SUM(quantity) = 31
```

### COUNT

Стандартная метрика:

```text
COUNT(*)
```

даёт:

```text
12
```

Теперь создайте разовую метрику (`ad hoc metric`):

```text
Column:      sale_id
Aggregation: COUNT
```

Результат снова `12`, потому что `sale_id` заполнен во всех строках.

Замените колонку на `manager`:

```text
COUNT(manager) = 11
```

Одна продажа имеет `manager = NULL`, а `COUNT(column)` пустые значения не считает.

Для количества разных менеджеров выберите:

```text
COUNT_DISTINCT(manager)
```

Ожидается:

```text
4
```

Имена:

```text
Анна
Борис
Клара
Денис
```

### AVG

Для `revenue` выберите `AVG`:

```text
AVG(revenue) = 333.75
```

Проверка простая:

```text
4005.00 / 12 = 333.75
```

Контрольный набор:

| Расчёт | Результат |
|---|---:|
| `SUM(revenue)` | 4005.00 |
| `SUM(quantity)` | 31 |
| `COUNT(*)` | 12 |
| `COUNT(sale_id)` | 12 |
| `COUNT(manager)` | 11 |
| `COUNT_DISTINCT(manager)` | 4 |
| `AVG(revenue)` | 333.75 |

## Calculated Column: прибыль одной продажи

Теперь добавим поле, которого физически нет в PostgreSQL.

Откройте:

```text
Datasets → sales → Edit → Calculated columns
```

Добавьте новую строку и задайте:

```text
Column:         profit
SQL expression: revenue - cost
Data type:      NUMERIC
```

`Label` и `Description` оставьте пустыми. Нажмите `Save`.

Замок на `Source` открывать не нужно: он не относится к Calculated Columns.

Вернитесь в Explore. В списке полей должен появиться `profit`.

Посчитайте:

```text
SUM(profit)
```

без группировки. Ожидается:

```text
1530.00
```

Теперь добавьте:

```text
Dimensions = region
```

Результат:

| region | SUM(profit) |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

`profit` вычисляется для каждой строки, а уже потом `SUM` складывает эти значения внутри выбранных групп.

## Сохранённая Metric: общая прибыль группы

Теперь создадим тот же бизнес-показатель другим способом.

Откройте:

```text
Datasets → sales → Edit → Metrics
```

Добавьте метрику:

```text
Metric Key:     total_profit
Label:          Прибыль
SQL expression: SUM(revenue) - SUM(cost)
Description:    Суммарная выручка минус суммарная себестоимость
```

Нажмите `Save`.

`Metric Key` — технический идентификатор. В Explore пользователь будет видеть `Label`, то есть `Прибыль`.

Вернитесь в `sales` и выберите в `Metrics`:

```text
Прибыль
```

Без `Dimensions` ожидается:

```text
1530.00
```

С `Dimensions = region`:

| region | Прибыль |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

Сохранённая Metric пересчитывается внутри текущих фильтров и групп.

## Почему здесь результаты совпали

В учебном наборе выполняется:

```text
SUM(profit)
=
SUM(revenue - cost)
=
SUM(revenue) - SUM(cost)
=
1530.00
```

Это не означает, что Calculated Column и Metric взаимозаменяемы. Просто формула `revenue - cost` линейная, а оба исходных поля обязательны (`NOT NULL`).

Разница в смысле остаётся:

```text
profit
→ значение одной продажи

Прибыль
→ показатель выбранного набора строк
```

Физического столбца `profit` в PostgreSQL при этом не появляется.

### Где легко ошибиться

Представим две продажи:

```text
Продажа A:
revenue = 100
profit  = 50
маржа строки = 50%

Продажа B:
revenue = 900
profit  = 90
маржа строки = 10%
```

Среднее построчных процентов:

```text
(50% + 10%) / 2 = 30%
```

Но общая маржа:

```text
(50 + 90) / (100 + 900) = 14%
```

То есть расчёт строки можно определить правильно и всё равно испортить итог неправильной агрегацией. Для процентов, коэффициентов, остатков и средних это особенно важно.

## Проверьте себя

Получите самостоятельно:

```text
AVG(cost) = 206.25
COUNT_DISTINCT(office) = 4
```

Затем выберите сохранённую метрику `Прибыль` и сгруппируйте по `product`:

```text
Маршрутизатор = 630.00
Датчик        = 475.00
Терминал      = 425.00
```

И попробуйте словами объяснить две вещи:

- почему `SUM(sale_id)` не становится полезным показателем из-за числового типа;
- почему `COUNT(*)` в `training.sales` можно назвать количеством продаж, а в наборе «одна строка = одна позиция документа» — уже нельзя.

Если ответ понятен без интерфейса, смысл урока усвоен лучше, чем если просто совпали цифры.

## Если расчёт не появился

Если в Explore нет `profit`, проверьте:

```text
Datasets → sales → Edit → Calculated columns
```

Должно быть:

```text
Column:         profit
SQL expression: revenue - cost
Data type:      NUMERIC
```

Для Calculated Column выражение построчное:

```sql
revenue - cost
```

А агрегированная формула:

```sql
SUM(revenue) - SUM(cost)
```

относится уже к Metric.

Если в Explore нет `Прибыль`, проверьте вкладку `Metrics` и значения `Metric Key`, `Label` и `SQL expression`.

`COUNT(manager) = 11` — не ошибка: одна строка действительно содержит `NULL`.

Если расходятся основные суммы, верните Explore к состоянию:

```text
Dimensions = пусто
Filters    = sale_date (No filter)
```

и при необходимости снова проверьте исходные данные:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

## Что должно остаться после урока

В Dataset `sales`:

```text
Calculated column
Column:         profit
SQL expression: revenue - cost
Data type:      NUMERIC

Metric
Metric Key:     total_profit
Label:          Прибыль
SQL expression: SUM(revenue) - SUM(cost)
```

Контроль в Explore:

```text
Прибыль всего = 1530.00
Север         = 520.00
Юг            = 1010.00
```

Дополнительные материалы нужны только если тема ещё плавает: [агрегирования](06a-aggregations.md), [Calculated Column, Metric или SQL](06b-calculated-column-metric-or-sql.md), [зерно Dataset](06c-data-grain.md).

Следующий шаг — превратить уже проверенные расчёты в сохранённые Chart.

→ [Урок 07. Строим и сохраняем Chart](07-create-charts.md)

## Источники Superset 6.1.0

- редактор Dataset: `Metrics`, `Calculated columns`, `Metric Key`, `Label`, `SQL expression`, `Data type`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/components/Datasource/components/DatasourceEditor/DatasourceEditor.tsx>
- отображение сохранённой метрики по `verbose_name` / `Label`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/components/MetricOption.tsx>
- список агрегирований Explore: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/constants.ts>
- редактор разовой метрики (`ad hoc metric`): <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/MetricControl/AdhocMetricEditPopover/index.tsx>
- панель управления Table: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/controlPanel.tsx>
- схема учебной таблицы и `NOT NULL` для `revenue` / `cost`: [`../training/schema.sql`](../training/schema.sql)