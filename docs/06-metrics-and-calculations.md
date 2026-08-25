# 06. Метрики и расчёты

## Результат урока

После урока в Dataset `sales` должны существовать:

```text
Calculated column: profit
Metric Key:         total_profit
Metric Label:       Прибыль
```

И вы должны уметь различать:

```text
revenue - cost
→ расчёт для одной строки
→ Calculated column

SUM(revenue) - SUM(cost)
→ расчёт для набора строк
→ Metric
```

Chart в этом уроке не сохраняем.

## Перед началом

Должны быть пройдены уроки 02–05.

Откройте:

```text
Datasets → sales
```

Для упражнений в Explore используйте:

```text
Visualization: Table
Dimensions:    пусто
Filters:       sale_date (No filter)
```

Удалите из `Metrics` расчёты, оставшиеся после предыдущего урока.

## Ad hoc metric

Расчёт, созданный непосредственно в `Metrics` панели Explore, является `ad hoc metric`. Он относится к текущей конфигурации Explore или сохранённому Chart.

Сохранённая Metric создаётся в Dataset Editor и затем доступна во всех Chart на этом Dataset.

## SUM

В `Metrics` добавьте:

```text
revenue
```

и выберите:

```text
SUM
```

Нажмите:

```text
Create chart
```

Ожидается:

```text
4005.00
```

Теперь замените столбец на:

```text
quantity
```

с агрегированием `SUM`.

Ожидается:

```text
31
```

## COUNT

У нового Table в списке Metrics доступна стандартная метрика:

```text
COUNT(*)
```

Она считает строки. Для учебного Dataset результат:

```text
12
```

Для проверки поведения `COUNT(column)` создайте ad hoc metric:

```text
Column:      sale_id
Aggregation: COUNT
```

Ожидается:

```text
12
```

Затем замените `sale_id` на:

```text
manager
```

с тем же `COUNT`.

Ожидается:

```text
11
```

В одной строке `manager` равен `NULL`, поэтому `COUNT(manager)` не считает эту строку.

## COUNT_DISTINCT

Для `manager` выберите:

```text
COUNT_DISTINCT
```

Ожидается:

```text
4
```

В данных четыре непустых значения:

```text
Анна
Борис
Клара
Денис
```

## AVG

Для `revenue` выберите:

```text
AVG
```

Ожидается:

```text
333.75
```

Проверка:

```text
4005.00 / 12 = 333.75
```

Контроль набора агрегирований:

| Расчёт | Результат |
|---|---:|
| `SUM(revenue)` | 4005.00 |
| `SUM(quantity)` | 31 |
| `COUNT(*)` | 12 |
| `COUNT(sale_id)` | 12 |
| `COUNT(manager)` | 11 |
| `COUNT_DISTINCT(manager)` | 4 |
| `AVG(revenue)` | 333.75 |

## Создаём Calculated column profit

Перейдите:

```text
Datasets
```

Наведите указатель на строку `sales` и нажмите `Edit`.

Откройте вкладку:

```text
Calculated columns
```

Добавьте новый элемент.

В колонке:

```text
Column
```

появится имя:

```text
<new column>
```

Замените его на:

```text
profit
```

Раскройте строку и заполните:

```text
SQL expression: revenue - cost
Data type:      NUMERIC
```

Поля `Label` и `Description` для этого упражнения оставьте пустыми.

Нажмите:

```text
Save
```

Замок на вкладке `Source` не открываем: он не относится к `Calculated columns`.

## Проверяем profit в Explore

Вернитесь:

```text
Datasets → sales
```

В списке столбцов Explore должен появиться:

```text
profit
```

В `Metrics` создайте:

```text
Column:      profit
Aggregation: SUM
```

При:

```text
Dimensions: пусто
Filters:    sale_date (No filter)
```

нажмите `Create chart`.

Ожидается:

```text
1530.00
```

Теперь добавьте:

```text
Dimensions = region
```

и снова нажмите `Create chart`.

Ожидается:

| region | SUM(profit) |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

## Создаём сохранённую Metric

Вернитесь:

```text
Datasets → sales → Edit
```

Откройте вкладку:

```text
Metrics
```

Добавьте новую строку.

Заполните:

```text
Metric Key:     total_profit
Label:          Прибыль
SQL expression: SUM(revenue) - SUM(cost)
Description:    Суммарная выручка минус суммарная себестоимость
```

Нажмите:

```text
Save
```

`Metric Key` — технический идентификатор. `Label` — отображаемое имя метрики в Explore.

## Используем сохранённую Metric

Откройте:

```text
Datasets → sales
```

В `Metrics` выберите сохранённую метрику:

```text
Прибыль
```

В интерфейсе Explore Superset 6.1.0 сохранённая Metric отображается по `Label`, если он заполнен. Для нашей метрики это `Прибыль`; её технический ключ остаётся `total_profit`.

При:

```text
Dimensions: пусто
Filters:    sale_date (No filter)
```

нажмите `Create chart`.

Ожидается:

```text
1530.00
```

Добавьте:

```text
Dimensions = region
```

и снова выполните конфигурацию.

Ожидается:

| region | Прибыль |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

Одна сохранённая Metric применяется к каждой группе, созданной `Dimensions`.

## Почему два расчёта дают одинаковый итог

В этом наборе данных:

```text
SUM(profit)
=
SUM(revenue - cost)
=
SUM(revenue) - SUM(cost)
=
1530.00
```

Но объекты разные:

```text
profit
→ значение одной строки Dataset

total_profit / Прибыль
→ агрегированный показатель
```

Физического столбца `profit` в PostgreSQL при этом не появляется.

## Самостоятельная проверка

### AVG(cost)

Создайте ad hoc metric:

```text
AVG(cost)
```

Ожидается:

```text
206.25
```

### Количество офисов

Используйте:

```text
Column:      office
Aggregation: COUNT_DISTINCT
```

Ожидается:

```text
4
```

### Прибыль по продуктам

Выберите сохранённую Metric:

```text
Прибыль
```

и:

```text
Dimensions = product
```

Ожидается:

```text
Маршрутизатор = 630.00
Датчик        = 475.00
Терминал      = 425.00
```

## Типовые ошибки

### profit не появился

Проверьте:

```text
Datasets → sales → Edit → Calculated columns
```

Должно быть:

```text
Column:         profit
SQL expression: revenue - cost
Data type:      NUMERIC
```

После изменения нажмите `Save` и заново откройте Explore.

### Calculated column выдаёт ошибку

Для `profit` выражение должно быть построчным:

```sql
revenue - cost
```

Агрегированное выражение:

```sql
SUM(revenue) - SUM(cost)
```

используется в Metric.

### В Explore нет Прибыль

Проверьте:

```text
Datasets → sales → Edit → Metrics
```

Должно быть:

```text
Metric Key:     total_profit
Label:          Прибыль
SQL expression: SUM(revenue) - SUM(cost)
```

Сохраните Dataset и заново откройте Explore.

### COUNT(manager) = 11

Это правильный результат: одна строка содержит `manager = NULL`.

### Итоги отличаются

Проверьте:

```text
Dimensions = пусто
Filters    = sale_date (No filter)
```

Контроль исходных данных:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Ожидается:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

## Критерий завершения

В Dataset `sales` должны существовать:

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

В Explore:

```text
Прибыль всего = 1530.00
Север         = 520.00
Юг            = 1010.00
```

## Шпаргалки к уроку

Если непонятно, какое агрегирование выбрать:

→ [SUM, COUNT, COUNT DISTINCT, AVG, MIN и MAX](06a-aggregations.md)

Если непонятно, где должен жить расчёт:

→ [Calculated Column, Metric или SQL?](06b-calculated-column-metric-or-sql.md)

Если `COUNT(*)` или `SUM` имеют неясный смысл:

→ [Зерно Dataset: что означает одна строка](06c-data-grain.md)

Следующий урок — создание и сохранение Chart.

→ [Урок 07. Строим и сохраняем Chart](07-create-charts.md)

## Источники Superset 6.1.0

- Dataset Editor: `Metrics`, `Calculated columns`, `Metric Key`, `Label`, `SQL expression`, `Data type`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/components/Datasource/components/DatasourceEditor/DatasourceEditor.tsx>
- отображение сохранённой Metric по `verbose_name` / Label: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/components/MetricOption.tsx>
- список агрегирований Explore: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/constants.ts>
- редактор ad hoc metric: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/MetricControl/AdhocMetricEditPopover/index.tsx>
- Table control panel: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/controlPanel.tsx>
