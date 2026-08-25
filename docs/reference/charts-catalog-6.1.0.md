# Справочник. Каталог Chart Apache Superset 6.1.0

Этот файл — **не обязательный урок** и не список того, что нужно выучить новичку.

Он нужен как контрольный каталог визуализаций версии курса — Apache Superset 6.1.0.

Для выбора визуализации по задаче используйте короткую шпаргалку:

→ [Как выбрать визуализацию](../07a-choose-visualization.md)

## Обозначения

- **база** — полезно большинству авторов Dashboard;
- **аналитика** — полезно BI-аналитику;
- **спец.** — изучать под конкретную задачу;
- **осторожно** — применять осознанно;
- **feature flag** — регистрация зависит от настройки Superset.

## KPI и таблицы

| Chart | Уровень | Для чего |
|---|---|---|
| Big Number | база | KPI одним числом |
| Big Number Total | база | итоговое значение |
| Big Number Period over Period | feature flag | сравнение значения с периодом |
| Table | база | точные строки и агрегаты |
| Pivot Table | база | сводная матрица |
| Time Table | спец. | временные показатели в таблице |
| AG Grid Table | feature flag | альтернативная табличная визуализация |
| Handlebars | спец. | собственное шаблонное представление |

## Временные ряды

| Chart | Уровень |
|---|---|
| Time-series Chart | аналитика |
| Time-series Line Chart | база |
| Time-series Smooth Line Chart | спец. |
| Time-series Step Chart | спец. |
| Time-series Area Chart | база |
| Time-series Bar Chart | база |
| Time-series Scatter Plot | аналитика |
| Mixed Time-series | аналитика |
| Compare | спец. |
| Time Pivot | спец. |
| Horizon Chart | спец. |

## Сравнение, структура и категории

| Chart | Уровень |
|---|---|
| Pie Chart | база, осторожно |
| Bubble Chart | аналитика |
| Bubble Chart (legacy) | спец. |
| Radar Chart | спец. |
| Rose Chart | осторожно |
| Funnel Chart | аналитика |
| Waterfall Chart | аналитика |
| Bullet Chart | спец. |
| Treemap | база |

## Распределения и исследование данных

| Chart | Уровень |
|---|---|
| Histogram | аналитика |
| Box Plot | аналитика |
| Heatmap | база |
| Paired t-test | спец. |
| Parallel Coordinates | спец. |

## Иерархии и связи

| Chart | Уровень |
|---|---|
| Sunburst | спец. |
| Tree | спец. |
| Partition | спец. |
| Sankey Diagram | аналитика |
| Chord Diagram | спец. |
| Graph Chart | спец. |

## Время, календарь и индикаторы

| Chart | Уровень |
|---|---|
| Calendar Heatmap | аналитика |
| Gantt Chart | спец. |
| Gauge Chart | спец. |

## Текст

| Chart | Уровень |
|---|---|
| Word Cloud | осторожно |

## География

| Chart | Уровень |
|---|---|
| Country Map | спец. |
| World Map | спец. |
| MapBox | спец. |
| Cartodiagram | спец. |
| deck.gl Scatterplot | спец. |
| deck.gl Arc | спец. |
| deck.gl Path | спец. |
| deck.gl Polygon | спец. |
| deck.gl GeoJSON | спец. |
| deck.gl Grid | спец. |
| deck.gl Hexagon | спец. |
| deck.gl Heatmap | спец. |
| deck.gl Screen Grid | спец. |
| deck.gl Contour | спец. |
| deck.gl Multiple Layers | спец. |

## Сколько их

В `MainPreset` Superset 6.1.0 постоянно регистрируются 45 основных visualization plugins.

Отдельный preset `deck.gl` регистрирует ещё 11 геовизуализаций.

Итого по регистрации исходного кода:

```text
45 основных
+ 11 deck.gl
= 56 постоянно зарегистрированных visualization plugins
```

Дополнительно два типа зависят от feature flags:

```text
Big Number Period over Period
AG Grid Table
```

Поэтому технически может быть зарегистрировано до 58 типов.

Важно:

```text
registered plugin
≠
обязательно видимый каждому пользователю пункт chart picker
```

Конкретная установка может отличаться из-за feature flags, конфигурации, metadata Chart и других настроек.

## Что означает `legacy`

В Superset 6.1.0 часть визуализаций импортируется из пакетов с `legacy` в названии.

Это не означает автоматически:

```text
сломано
запрещено
нельзя использовать
```

Для нового Dashboard используйте простое правило:

> Если современная и более простая визуализация решает тот же аналитический вопрос, начинайте с неё. Legacy-вариант выбирайте только ради конкретной возможности.

## Какие Chart изучать сначала

Не учите каталог подряд.

### Базовый автор Dashboard

```text
Big Number
Table
Pivot Table
Bar
Line
Time-series Bar
Area
Pie / Donut
Heatmap
Treemap
```

### BI-аналитик

После базы:

```text
Mixed Time-series
Scatter
Histogram
Box Plot
Waterfall
Funnel
Sankey
Calendar Heatmap
```

### Остальные

Изучайте под конкретный аналитический вопрос.

## Источники Superset 6.1.0

- регистрация основных Chart и feature flags: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/visualizations/presets/MainPreset.ts>
- preset `deck.gl`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-deckgl/src/preset.ts>
- Introduction 6.1.0: <https://superset.apache.org/user-docs/6.1.0/intro/>
