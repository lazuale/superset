# 07. Строим и сохраняем Chart

## Результат урока

После урока в Superset должны существовать четыре сохранённых графика (`Chart`):

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

При новом открытии Dataset в Explore Table может уже содержать стандартную метрику `COUNT(*)`. В каждом упражнении ниже оставляйте только метрики, прямо указанные в конфигурации графика.

## Create chart, Update chart и Save

В Explore Superset 6.1.0 используются три разных действия.

### Новый график

Для нового несохранённого графика текущая конфигурация выполняется кнопкой:

```text
Create chart
```

### Сохранённый график

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

Для нового графика выбирается:

```text
Save as...
```

Для изменения существующего графика:

```text
Save (Overwrite)
```

Внизу диалога используем кнопку:

```text
Save
```

## График 1. Продажи по регионам — таблица

Откройте:

```text
Datasets → sales
```

Выберите:

```text
Table
```

Удалите стандартный `COUNT(*)` из `Metrics`, если он добавлен автоматически.

Настройте:

```text
Dimensions: region
Metrics:    SUM(revenue), Прибыль
Filters:    sale_date (No filter)
```

В `Metrics` должны остаться ровно два расчёта:

```text
SUM(revenue)
Прибыль
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

## График 2. Общая прибыль

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

Если в поле остался другой расчёт, замените его: для этого графика используется только `Прибыль`.

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

## График 3. Выручка по регионам — столбцы

Откройте:

```text
Datasets → sales
```

Выберите:

```text
Bar Chart
```

Удалите из `Metrics` все автоматически перенесённые или добавленные расчёты и оставьте только:

```text
SUM(revenue)
```

Итоговая конфигурация:

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

## График 4. Выручка по месяцам

Откройте:

```text
Datasets → sales
```

Выберите:

```text
Line Chart
```

Удалите лишние метрики и оставьте только:

```text
SUM(revenue)
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

Нажатие имени сохранённого графика открывает его в `Explore`.

## Редактируем существующий график

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

Для сохранённого графика кнопка выполнения называется:

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

когда нужен новый самостоятельный график.

Используйте:

```text
Save (Overwrite)
```

когда нужно сохранить изменения текущего графика.

## Выбор визуализации

| Задача | Визуализация |
|---|---|
| точные значения по группам | `Table` |
| одно итоговое значение | `Big Number` |
| сравнение категорий | `Bar Chart` |
| динамика по времени | `Line Chart` |

Тип Chart меняет представление результата, но не формулу метрики.

## Типовые ошибки

### Появился лишний COUNT(*) или лишняя серия

Очистите `Metrics` и оставьте только расчёты, указанные для текущего графика. Новый Explore может начинаться со стандартного `COUNT(*)`, а при смене типа визуализации часть текущей конфигурации может сохраняться.

### График пустой

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

### Появилась копия существующего графика

Для обновления существующего объекта используйте:

```text
Save (Overwrite)
```

а не `Save as...`.

### Графика нет в списке Charts

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

## Материалы к уроку

Если непонятно, какой тип Chart выбрать:

→ [Шпаргалка: как выбрать визуализацию](07a-choose-visualization.md)

Если график выглядит нормально, но число вызывает сомнение:

→ [Шпаргалка: почему цифры в Superset не сходятся](07b-troubleshoot-wrong-numbers.md)

Если нужно изучить дополнительные настройки отображения чисел, процентов или дат:

→ [Справочник: форматы чисел, процентов и дат](07c-formatting.md)

Если нужен полный перечень визуализаций версии курса:

→ [Справочник: каталог Chart Apache Superset 6.1.0](reference/charts-catalog-6.1.0.md)

Следующий урок — сборка Dashboard из этих графиков.

→ [Урок 08. Собираем Dashboard](08-build-dashboard.md)

## Источники Superset 6.1.0

- `Create chart` / `Update chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/RunQueryButton/index.tsx>
- диалог сохранения `Save as...`, `Save (Overwrite)`, `Chart name`, `Save`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/SaveModal.tsx>
- список `Charts` и переход по имени Chart: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/pages/ChartList/index.tsx>
- URL сохранённого Chart ведёт в Explore: <https://github.com/apache/superset/blob/6.1.0/superset/models/slice.py>
- `Bar Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Bar/index.ts>
- `Line Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Line/index.ts>
- элементы запроса Bar/Line: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/sections/echartsTimeSeriesQuery.tsx>
- `Show value`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Bar/controlPanel.tsx>
- `Marker`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Line/controlPanel.tsx>
