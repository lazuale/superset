# 07. Строим и сохраняем Chart

## Результат урока

После урока в Superset должны существовать четыре сохранённых Chart:

```text
Продажи по регионам — таблица
Общая прибыль
Выручка по регионам — столбцы
Выручка по месяцам
```

Все они используют Dataset `sales`.

## Перед началом

Должны быть пройдены уроки 02–06.

В Dataset `sales` должны существовать:

```text
Calculated column: profit
Metric Key:         total_profit
Metric Label:       Прибыль
```

Контроль общей прибыли:

```text
1530.00
```

## Create chart, Update chart и Save

В Explore Superset 6.1.0 используются три разных действия.

### Новый Chart

Для нового несохранённого Chart текущая конфигурация выполняется кнопкой:

```text
Create chart
```

### Сохранённый Chart

После сохранения текущая конфигурация выполняется кнопкой:

```text
Update chart
```

### Сохранение объекта

Кнопка:

```text
Save
```

открывает диалог сохранения.

Для нового Chart выбирается:

```text
Save as...
```

Для изменения существующего Chart:

```text
Save (Overwrite)
```

Внизу диалога используем кнопку:

```text
Save
```

## Chart 1. Продажи по регионам — таблица

Откройте:

```text
Datasets → sales
```

Выберите:

```text
Table
```

Настройте:

```text
Dimensions: region
Metrics:    SUM(revenue), Прибыль
Filters:    sale_date (No filter)
```

Выполните:

```text
Create chart
```

Ожидается:

| region | SUM(revenue) | Прибыль |
|---|---:|---:|
| Север | 1360.00 | 520.00 |
| Юг | 2645.00 | 1010.00 |

Нажмите:

```text
Save
```

В диалоге оставьте:

```text
Save as...
```

В поле:

```text
Chart name
```

укажите:

```text
Продажи по регионам — таблица
```

Dashboard не выбирайте.

Нажмите `Save`.

## Chart 2. Общая прибыль

Снова откройте:

```text
Datasets → sales
```

Выберите:

```text
Big Number
```

В `Metric` выберите сохранённую метрику:

```text
Прибыль
```

В `Filters` оставьте:

```text
sale_date (No filter)
```

Нажмите `Create chart`.

Ожидается одно значение:

```text
1530.00
```

Сохраните через:

```text
Save
→ Save as...
→ Chart name: Общая прибыль
→ Save
```

## Chart 3. Выручка по регионам — столбцы

Откройте:

```text
Datasets → sales
```

Выберите отдельную визуализацию:

```text
Bar Chart
```

Настройте:

```text
X Axis:     region
Metrics:    SUM(revenue)
Dimensions: пусто
Filters:    sale_date (No filter)
```

Нажмите `Create chart`.

Ожидаются два столбца:

```text
Север → 1360.00
Юг    → 2645.00
```

В настройках отображения включите:

```text
Show value
```

Снова нажмите `Create chart`.

Сохраните:

```text
Save
→ Save as...
→ Chart name: Выручка по регионам — столбцы
→ Save
```

## Chart 4. Выручка по месяцам

Откройте:

```text
Datasets → sales
```

Выберите:

```text
Line Chart
```

Настройте:

```text
X Axis:     sale_date
Time grain: Month
Metrics:    SUM(revenue)
Dimensions: пусто
Filters:    sale_date (No filter)
```

Нажмите `Create chart`.

Ожидается:

| месяц | SUM(revenue) |
|---|---:|
| 2026-01 | 1160.00 |
| 2026-02 | 1180.00 |
| 2026-03 | 1665.00 |

В настройках отображения включите:

```text
Marker
```

Снова нажмите `Create chart`.

Сохраните:

```text
Save
→ Save as...
→ Chart name: Выручка по месяцам
→ Save
```

## Проверяем список Charts

Откройте верхний раздел:

```text
Charts
```

В списке должны быть:

```text
Продажи по регионам — таблица
Общая прибыль
Выручка по регионам — столбцы
Выручка по месяцам
```

Нажатие имени сохранённого Chart открывает его в `Explore`.

## Редактируем существующий Chart

В `Charts` нажмите:

```text
Выручка по месяцам
```

Откроется Explore с сохранённой конфигурацией:

```text
Visualization: Line Chart
Dataset:       sales
X Axis:        sale_date
Time grain:    Month
Metrics:       SUM(revenue)
Dimensions:    пусто
Filters:       sale_date (No filter)
Marker:        включён
```

Для сохранённого Chart кнопка выполнения называется:

```text
Update chart
```

Отключите `Marker` и нажмите `Update chart`.

Значения должны остаться:

```text
2026-01 = 1160.00
2026-02 = 1180.00
2026-03 = 1665.00
```

Теперь нажмите:

```text
Save
```

Выберите:

```text
Save (Overwrite)
```

и нажмите `Save`.

Вернитесь в `Charts`, снова откройте `Выручка по месяцам` и проверьте, что `Marker` выключен.

## Save as... и Save (Overwrite)

Используйте:

```text
Save as...
```

когда нужен новый самостоятельный Chart.

Используйте:

```text
Save (Overwrite)
```

когда нужно сохранить изменения текущего Chart.

## Выбор визуализации

| Задача | Визуализация |
|---|---|
| точные значения по группам | `Table` |
| одно итоговое значение | `Big Number` |
| сравнение категорий | `Bar Chart` |
| динамика по времени | `Line Chart` |

Тип Chart меняет способ представления результата, но не формулу Metric.

## Типовые ошибки

### Chart пустой

Проверьте:

```text
Filters: sale_date (No filter)
```

Учебные данные находятся в январе–марте 2026 года.

### Table показывает одно число вместо двух регионов

Проверьте:

```text
Dimensions = region
```

### Big Number показывает 4005 вместо 1530

В `Metric` должна быть выбрана:

```text
Прибыль
```

### Line Chart показывает дни вместо месяцев

Проверьте:

```text
X Axis     = sale_date
Time grain = Month
```

### Появилась копия существующего Chart

Для обновления существующего объекта используйте:

```text
Save (Overwrite)
```

а не `Save as...`.

### Chart нет в списке Charts

`Create chart` выполняет конфигурацию Explore, но не сохраняет самостоятельный объект. Для сохранения требуется `Save`.

## Критерий завершения

Через `Charts` должны находиться четыре объекта:

```text
Продажи по регионам — таблица
Общая прибыль
Выручка по регионам — столбцы
Выручка по месяцам
```

Контрольные значения:

```text
Общая прибыль = 1530.00

Север:
выручка = 1360.00
прибыль = 520.00

Юг:
выручка = 2645.00
прибыль = 1010.00

2026-01 = 1160.00
2026-02 = 1180.00
2026-03 = 1665.00
```

Следующий урок — сборка Dashboard из этих Chart.

→ [Урок 08. Собираем Dashboard](08-build-dashboard.md)

## Источники Superset 6.1.0

- `Create chart` / `Update chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/RunQueryButton/index.tsx>
- диалог сохранения `Save as...`, `Save (Overwrite)`, `Chart name`, `Save`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/SaveModal.tsx>
- список Charts и переход по имени Chart: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/pages/ChartList/index.tsx>
- URL сохранённого Chart ведёт в Explore: <https://github.com/apache/superset/blob/6.1.0/superset/models/slice.py>
- Bar Chart: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Bar/index.ts>
- Line Chart: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Line/index.ts>
- Query controls Bar/Line: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/sections/echartsTimeSeriesQuery.tsx>
- `Show value`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Bar/controlPanel.tsx>
- `Marker`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Line/controlPanel.tsx>
