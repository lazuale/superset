# 07. Строим и сохраняем Chart

До этого момента мы проверяли расчёты в Explore и ничего не сохраняли. Теперь из уже знакомых запросов сделаем четыре нормальных Chart, которые потом соберём на одном Dashboard.

После урока в `Charts` должны быть:

```text
Продажи по регионам — таблица
Общая прибыль
Выручка по регионам — столбцы
Выручка по месяцам
```

Все четыре работают на Dataset `sales`.

## Сначала разберёмся с кнопками

В Explore легко запутаться в трёх похожих действиях.

Для нового, ещё не сохранённого графика запрос выполняется кнопкой:

```text
Create chart
```

После сохранения эта же логика запуска называется:

```text
Update chart
```

А кнопка:

```text
Save
```

открывает отдельный диалог сохранения.

В нём:

```text
Save as...
```

создаёт новый Chart, а:

```text
Save (Overwrite)
```

перезаписывает текущий.

Эту разницу лучше понять сейчас, иначе очень легко плодить копии вместо редактирования существующих графиков.

## 1. Таблица по регионам

Откройте:

```text
Datasets → sales
```

Выберите `Table` и настройте:

```text
Dimensions: region
Metrics:    SUM(revenue), Прибыль
Filters:    sale_date (No filter)
```

Если в `Metrics` остался стандартный `COUNT(*)`, удалите его.

После `Create chart` ожидается:

| region | SUM(revenue) | Прибыль |
|---|---:|---:|
| Север | 1360.00 | 520.00 |
| Юг | 2645.00 | 1010.00 |

Теперь сохраните Chart:

```text
Save
→ Save as...
→ Chart name: Продажи по регионам — таблица
→ Save
```

Dashboard пока не выбирайте.

## 2. Общая прибыль одним числом

Снова откройте `sales` и выберите:

```text
Big Number
```

В `Metric` должна быть только сохранённая метрика:

```text
Прибыль
```

В `Filters` оставьте:

```text
sale_date (No filter)
```

После `Create chart` должно появиться:

```text
1530.00
```

Сохраните:

```text
Save
→ Save as...
→ Chart name: Общая прибыль
→ Save
```

## 3. Сравнение регионов столбцами

Откройте Dataset ещё раз и выберите:

```text
Bar Chart
```

Оставьте только:

```text
X Axis:     region
Metrics:    SUM(revenue)
Dimensions: пусто
Filters:    sale_date (No filter)
```

Результат:

```text
Север → 1360.00
Юг    → 2645.00
```

В настройках отображения включите:

```text
Show value
```

и снова выполните `Create chart`.

Сохраните как:

```text
Выручка по регионам — столбцы
```

## 4. Выручка по месяцам

Для последнего графика выберите:

```text
Line Chart
```

Настройка:

```text
X Axis:     sale_date
Time grain: Month
Metrics:    SUM(revenue)
Dimensions: пусто
Filters:    sale_date (No filter)
```

После выполнения должны получиться три точки:

| месяц | SUM(revenue) |
|---|---:|
| 2026-01 | 1160.00 |
| 2026-02 | 1180.00 |
| 2026-03 | 1665.00 |

Включите:

```text
Marker
```

и сохраните Chart под именем:

```text
Выручка по месяцам
```

## Проверяем, что сохранили именно четыре объекта

Откройте:

```text
Charts
```

В списке должны быть ровно наши четыре основных объекта:

```text
Продажи по регионам — таблица
Общая прибыль
Выручка по регионам — столбцы
Выручка по месяцам
```

Клик по имени открывает сохранённый Chart обратно в Explore.

## Редактируем существующий Chart, не создавая копию

Откройте:

```text
Выручка по месяцам
```

У сохранённого Chart кнопка выполнения теперь называется:

```text
Update chart
```

Отключите `Marker` и нажмите `Update chart`.

Числа не должны измениться:

```text
2026-01 = 1160.00
2026-02 = 1180.00
2026-03 = 1665.00
```

Теперь нажмите `Save`, выберите:

```text
Save (Overwrite)
```

и сохраните.

Снова откройте этот Chart из списка и убедитесь, что `Marker` действительно выключен.

Здесь смысл упражнения не в самом маркере. Нам важно один раз руками пройти разницу между «обновить существующий объект» и «сохранить новый».

## Почему выбраны именно эти четыре визуализации

| Задача | Визуализация |
|---|---|
| точные значения по группам | `Table` |
| одно итоговое значение | `Big Number` |
| сравнение категорий | `Bar Chart` |
| динамика по времени | `Line Chart` |

Тип Chart меняет способ представления результата, но не исправляет и не заменяет сам расчёт. Если `SUM(revenue)` посчитан неправильно, красивый Bar Chart ситуацию не спасёт.

## Если результат отличается

Лишний `COUNT(*)` или лишняя серия почти всегда означает, что в `Metrics` остался ненужный расчёт.

Пустой Chart — сначала проверьте:

```text
Filters: sale_date (No filter)
```

Если Table показывает одно число вместо двух регионов:

```text
Dimensions = region
```

Если Big Number показывает `4005` вместо `1530`, в `Metric` выбрана выручка, а не `Прибыль`.

Если Line Chart показывает дни вместо месяцев, проверьте:

```text
X Axis     = sale_date
Time grain = Month
```

Если после редактирования появился пятый почти одинаковый Chart, скорее всего был выбран `Save as...` вместо `Save (Overwrite)`.

И ещё одна частая ловушка: `Create chart` выполняет конфигурацию Explore, но сам объект не сохраняет. Для появления в списке `Charts` нужен `Save`.

## Перед Dashboard

Проверьте четыре объекта и их числа:

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

Если нужно понять, какой тип Chart выбирать в других задачах, смотрите [шпаргалку по визуализациям](07a-choose-visualization.md). Если график выглядит убедительно, а число нет — [диагностику расчётов](07b-troubleshoot-wrong-numbers.md). Форматы чисел и дат вынесены в [отдельный справочник](07c-formatting.md).

Следующий урок — соберём эти четыре объекта на Dashboard.

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