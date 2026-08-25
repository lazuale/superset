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

Кроме механики Superset, после урока нужно понимать три обязательных правила:

```text
сначала определить зерно Dataset
→ затем определить, какой объект считаем
→ затем проверить, имеет ли выбранная агрегация бизнес-смысл
```

График (`Chart`) в этом уроке не сохраняем.

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

---

## Перед любой метрикой: что означает одна строка?

У учебного Dataset:

```text
1 строка = 1 продажа
```

Это его зерно данных.

Поэтому в этом конкретном Dataset:

```text
COUNT(*)
→ число строк
→ одновременно число продаж
```

Но это не универсальное правило.

Если в другом Dataset:

```text
1 строка = 1 позиция документа
```

то `COUNT(*)` посчитает позиции, а не документы.

Перед `COUNT`, `SUM` или `AVG` всегда сначала закончите фразу:

> **Одна строка этого Dataset — это ...**

Подробная памятка остаётся отдельно:

→ [Зерно Dataset: что означает одна строка](06c-data-grain.md)

## Числовой столбец не означает «можно SUM»

В `training.sales` разумно складывать:

```text
quantity
revenue
cost
```

потому что значения отдельных продаж образуют осмысленный общий итог.

Но числовыми могут быть и поля, которые бездумно складывать нельзя:

```text
процент
температура
средняя скорость
тариф
остаток на дату
sale_id
```

Например `sale_id` имеет числовой тип, но:

```text
SUM(sale_id)
```

не отвечает полезному вопросу о продажах.

Поэтому порядок такой:

```text
поле числовое?
→ недостаточно

значения можно складывать по смыслу?
→ только тогда SUM имеет смысл
```

## Сначала определите объект подсчёта

Перед `COUNT` спросите:

```text
что хочу посчитать?
строки?
продажи?
менеджеров?
офисы?
```

Для учебных данных:

```text
COUNT(*)
→ строки / продажи

COUNT(manager)
→ строки с заполненным manager

COUNT_DISTINCT(manager)
→ разные непустые менеджеры
```

Эти три числа отвечают на три разных вопроса.

---

## Разовая метрика

Расчёт, созданный непосредственно в поле `Metrics` панели Explore, в терминологии Superset называется **разовой метрикой (`ad hoc metric`)**. Он относится к текущей конфигурации Explore или сохранённому графику.

Сохранённая метрика создаётся в редакторе Dataset и затем доступна во всех графиках на этом Dataset.

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

У нового Table в списке `Metrics` доступна стандартная метрика:

```text
COUNT(*)
```

Она считает строки. Для учебного Dataset результат:

```text
12
```

Для проверки поведения `COUNT(column)` создайте разовую метрику:

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

---

## Создаём Calculated Column profit

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

---

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

## Используем сохранённую метрику

Откройте:

```text
Datasets → sales
```

В `Metrics` выберите сохранённую метрику:

```text
Прибыль
```

В интерфейсе Explore Superset 6.1.0 сохранённая метрика отображается по `Label`, если он заполнен. Для нашей метрики это `Прибыль`; её технический ключ остаётся `total_profit`.

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

Одна сохранённая метрика применяется к каждой группе, созданной `Dimensions`.

---

## Почему два расчёта здесь дают одинаковый итог

В учебном наборе:

```text
SUM(profit)
=
SUM(revenue - cost)
=
SUM(revenue) - SUM(cost)
=
1530.00
```

Это работает здесь потому, что:

```text
profit = revenue - cost
```

— линейная построчная разность, а `revenue` и `cost` в учебной таблице обязательны (`NOT NULL`).

Но объекты Superset всё равно разные:

```text
profit
→ значение одной строки Dataset

total_profit / Прибыль
→ агрегированный показатель группы строк
```

Физического столбца `profit` в PostgreSQL при этом не появляется.

### Не переносите это равенство на любую формулу

Например, пусть у двух продаж:

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

Если просто усреднить две построчные маржи:

```text
(50% + 10%) / 2 = 30%
```

это **не** общая маржа продаж.

Общая маржа:

```text
общая прибыль / общая выручка
= (50 + 90) / (100 + 900)
= 14%
```

Значит правило:

```text
Calculated Column
→ можно вычислить значение строки

но способ агрегации этого значения
→ нужно выбирать отдельно по смыслу показателя
```

Не всякий процент, коэффициент, остаток или среднее является аддитивным показателем.

---

## Самостоятельная проверка

### AVG(cost)

Создайте разовую метрику:

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

Выберите сохранённую метрику:

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

### Проверка смысла

Ответьте словами без интерфейса:

```text
Почему SUM(sale_id) не становится полезной метрикой только потому,
что sale_id имеет числовой тип?
```

И:

```text
Почему COUNT(*) в training.sales можно назвать количеством продаж,
а в Dataset с одной строкой на позицию документа — уже нельзя?
```

Если ответ требует посмотреть в шпаргалку, перечитайте начало этого урока.

---

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

### Calculated Column выдаёт ошибку

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

---

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

И без подсказки вы должны уметь объяснить:

```text
1 строка training.sales = 1 продажа
COUNT(*) считает строки
COUNT(column) не считает NULL
COUNT_DISTINCT считает разные непустые значения
числовой тип сам по себе не делает показатель аддитивным
Calculated Column и Metric работают на разных уровнях
```

## Шпаргалки к уроку

Если нужно быстро вспомнить агрегирования:

→ [SUM, COUNT, COUNT DISTINCT, AVG, MIN и MAX](06a-aggregations.md)

Если непонятно, где должен жить расчёт:

→ [Calculated Column, Metric или SQL?](06b-calculated-column-metric-or-sql.md)

Если нужно подробнее разобрать зерно:

→ [Зерно Dataset: что означает одна строка](06c-data-grain.md)

Следующий урок — создание и сохранение Chart.

→ [Урок 07. Строим и сохраняем Chart](07-create-charts.md)

## Источники Superset 6.1.0

- редактор Dataset: `Metrics`, `Calculated columns`, `Metric Key`, `Label`, `SQL expression`, `Data type`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/components/Datasource/components/DatasourceEditor/DatasourceEditor.tsx>
- отображение сохранённой метрики по `verbose_name` / `Label`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/components/MetricOption.tsx>
- список агрегирований Explore: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/constants.ts>
- редактор разовой метрики (`ad hoc metric`): <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/MetricControl/AdhocMetricEditPopover/index.tsx>
- панель управления Table: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/controlPanel.tsx>
- схема учебной таблицы и `NOT NULL` для `revenue` / `cost`: [`../training/schema.sql`](../training/schema.sql)
