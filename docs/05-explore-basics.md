# 05. Осваиваем Explore

## Результат урока

После урока вы должны уметь через `Explore` без SQL:

- сгруппировать данные по `region`;
- посчитать `SUM(revenue)`;
- применить обычный фильтр;
- задать точный период по `sale_date`;
- сгруппировать даты по месяцам через `Time grain`;
- проверить результат по контрольным значениям.

Chart в этом уроке не сохраняем.

## Перед началом

Должны быть пройдены:

- [урок 02](02-start-training-superset.md);
- [урок 03](03-connect-postgresql.md);
- [урок 04](04-create-dataset.md).

В Superset должен существовать Physical Dataset:

```text
sales
```

с temporal-столбцом:

```text
sale_date
```

## Открываем Explore

Перейдите:

```text
Datasets
```

Нажмите имя:

```text
sales
```

Откроется `Explore`.

Выберите визуализацию:

```text
Table
```

В секции `Query` у Table Superset 6.1.0 используются следующие основные поля:

```text
Query mode
Dimensions
Metrics
Percentage metrics
Filters
Sort query by
Server pagination
Row limit
```

Для временного столбца в `Dimensions` дополнительно становится доступен `Time grain`.

У Physical Dataset Superset 6.1.0 создаёт стандартную сохранённую метрику:

```text
COUNT(*)
```

Стартовое состояние поля `Metrics` может зависеть от того, как именно открыт Explore. Поэтому перед первым упражнением просто приведите его к однозначному состоянию:

```text
если COUNT(*) уже выбрана
→ удалите её из Metrics

если Metrics пусто
→ ничего удалять не нужно
```

Дальше в каждом примере оставляйте только те Metrics, которые прямо указаны в инструкции.

## Первый запрос: выручка по регионам

В `Dimensions` добавьте:

```text
region
```

В `Metrics` добавьте столбец:

```text
revenue
```

и выберите агрегирование:

```text
SUM
```

В `Filters` оставьте temporal-фильтр:

```text
sale_date (No filter)
```

В `Row limit` установите:

```text
100
```

Итоговая конфигурация:

```text
Visualization: Table
Dimensions:    region
Metrics:       SUM(revenue)
Filters:       sale_date (No filter)
Row limit:     100
```

Нажмите:

```text
Create chart
```

Для нового, ещё не сохранённого Chart эта кнопка выполняет текущую конфигурацию Explore. Сохранение объекта Chart выполняется отдельно через `Save` и будет в уроке 07.

## Контрольный результат

Ожидаются две строки:

| region | SUM(revenue) |
|---|---:|
| Север | 1360.00 |
| Юг | 2645.00 |

Порядок строк может отличаться.

Общая сумма:

```text
1360.00 + 2645.00 = 4005.00
```

Настройка соответствует смыслу:

```sql
SELECT
    region,
    SUM(revenue)
FROM training.sales
GROUP BY region;
```

Superset генерирует запрос сам; этот SQL приведён только для понимания результата.

## Сортируем таблицу

Нажмите заголовок столбца `SUM(revenue)` и включите сортировку по убыванию.

Ожидаемый порядок:

```text
Юг    2645.00
Север 1360.00
```

Сортировка отображаемой таблицы меняет порядок строк, но не значения групп.

## Фильтр по региону

В `Filters` добавьте:

```text
region
```

В редакторе фильтра оставьте автоматически выбранный оператор:

```text
IN
```

и выберите значение:

```text
Север
```

Нажмите:

```text
Create chart
```

Ожидается:

| region | SUM(revenue) |
|---|---:|
| Север | 1360.00 |

Теперь замените значение фильтра на:

```text
Юг
```

и снова нажмите `Create chart`.

Ожидается:

```text
Юг = 2645.00
```

После проверки удалите фильтр `region`.

## Фильтр по периоду

Откройте temporal-фильтр:

```text
sale_date (No filter)
```

Выберите пользовательский диапазон `Custom`.

Для всего февраля 2026 года задайте:

```text
Start (inclusive): 2026-02-01
End (exclusive):   2026-03-01
```

Это соответствует условию:

```text
2026-02-01 <= sale_date < 2026-03-01
```

Нажмите `Create chart`.

При сохранённых настройках:

```text
Dimensions = region
Metrics    = SUM(revenue)
```

ожидается:

| region | SUM(revenue) |
|---|---:|
| Север | 450.00 |
| Юг | 730.00 |

Итого:

```text
1180.00
```

`End (exclusive)` не включается в диапазон, поэтому календарный месяц задаём первым днём месяца включительно и первым днём следующего месяца исключительно.

После проверки верните `sale_date` в:

```text
No filter
```

и снова нажмите `Create chart`.

Должны вернуться:

```text
Север = 1360.00
Юг    = 2645.00
```

## Группировка по месяцам

Теперь ответим на вопрос:

> Как менялась общая выручка по месяцам?

Оставьте визуализацию `Table`.

Удалите `region` из `Dimensions` и добавьте:

```text
sale_date
```

После выбора temporal-столбца установите:

```text
Time grain: Month
```

Оставьте:

```text
Metrics: SUM(revenue)
Filters: sale_date (No filter)
```

Итог:

```text
Visualization: Table
Dimensions:    sale_date
Time grain:    Month
Metrics:       SUM(revenue)
Filters:       sale_date (No filter)
```

Нажмите `Create chart`.

Ожидаются три месячные группы:

| месяц | SUM(revenue) |
|---|---:|
| 2026-01 | 1160.00 |
| 2026-02 | 1180.00 |
| 2026-03 | 1665.00 |

Проверка:

```text
1160.00 + 1180.00 + 1665.00 = 4005.00
```

`Filters` отвечает за отбор периода, а `Time grain` — за временную детализацию группировки.

## Возвращаем исходную конфигурацию

Перед завершением урока восстановите:

```text
Visualization: Table
Dimensions:    region
Metrics:       SUM(revenue)
Filters:       sale_date (No filter)
Row limit:     100
```

Нажмите `Create chart` и проверьте:

```text
Север = 1360.00
Юг    = 2645.00
```

## Самостоятельная проверка

### Выручка по продуктам

Настройте:

```text
Dimensions = product
Metrics    = SUM(revenue)
Filters    = sale_date (No filter)
```

Ожидается:

```text
Датчик        = 1210.00
Маршрутизатор = 1605.00
Терминал      = 1190.00
```

### Выручка за февраль

Используйте:

```text
Start (inclusive) = 2026-02-01
End (exclusive)   = 2026-03-01
```

Ожидаемая общая выручка:

```text
1180.00
```

### Выручка по месяцам

Используйте:

```text
Dimensions = sale_date
Time grain = Month
Metrics    = SUM(revenue)
```

Ожидается:

```text
2026-01 = 1160.00
2026-02 = 1180.00
2026-03 = 1665.00
```

## Типовые ошибки

### В результате есть лишний COUNT(*)

Удалите `COUNT(*)` из `Metrics`. Для основного упражнения там должен остаться только:

```text
SUM(revenue)
```

Если `COUNT(*)` изначально не была выбрана, это не ошибка — просто добавьте нужную Metric по инструкции.

### Пустой результат

Проверьте `Filters`. Учебные данные находятся в январе–марте 2026 года. Для базовой конфигурации `sale_date` должен быть:

```text
No filter
```

### Получилась одна строка 4005 вместо двух регионов

Проверьте:

```text
Dimensions = region
```

### Результаты по регионам отличаются

Проверьте одновременно:

```text
Dataset    = sales
Dimensions = region
Metrics    = SUM(revenue)
Filters    = sale_date (No filter)
```

### Февраль даёт неверный результат

Проверьте границы:

```text
Start (inclusive) = 2026-02-01
End (exclusive)   = 2026-03-01
```

### Time grain не отображается

Сначала добавьте temporal-столбец:

```text
Dimensions = sale_date
```

После этого `Time grain` применяется к временной группировке.

### sale_date не определяется как temporal

Вернитесь к [уроку 04](04-create-dataset.md) и проверьте `Columns → sale_date → Is temporal`.

## Критерий завершения

Вы должны без SQL получить:

```text
по регионам:
Север = 1360.00
Юг    = 2645.00

февраль:
Север = 450.00
Юг    = 730.00

по месяцам:
2026-01 = 1160.00
2026-02 = 1180.00
2026-03 = 1665.00
```

## Шпаргалки к уроку

Если путаются роли полей Explore:

→ [Dimension, Metric и Filter без путаницы](05a-dimension-metric-filter.md)

Если путаются настройки времени:

→ [Time column, Time range и Time grain](05b-time-range-and-grain.md)

Следующий урок — Calculated Column и сохранённая Metric.

→ [Урок 06. Метрики и расчёты](06-metrics-and-calculations.md)

## Источники Superset 6.1.0

- Table control panel: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/controlPanel.tsx>
- `Dimensions`, `Metrics`, `Filters`, `Time grain`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/shared-controls/dndControls.tsx>
- стандартная Metric `COUNT(*)` Physical Dataset: <https://github.com/apache/superset/blob/6.1.0/superset/db_engine_specs/base.py>
- редактор обычного Filter и оператор `IN`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/FilterControl/AdhocFilterEditPopoverSimpleTabContent/index.tsx>
- пользовательский период `Start (inclusive)` / `End (exclusive)`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/DateFilterControl/components/CustomFrame.tsx>
- `Create chart` / `Update chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/RunQueryButton/index.tsx>
