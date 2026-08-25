# Справочник. Каталог Chart Apache Superset 6.1.0

Этот файл — **не обязательный урок** и не список того, что нужно выучить новичку.

Он нужен как контрольный каталог визуализаций версии курса — Apache Superset 6.1.0.

Для выбора визуализации по задаче используйте короткую шпаргалку:

→ [Как выбрать визуализацию](../07a-choose-visualization.md)

## Как читать этот каталог

В колонке `UI name` используются **пользовательские названия из `metadata.name` исходного кода Superset 6.1.0**.

Это важно, потому что внутреннее имя класса и название в chart picker могут различаться. Например:

```text
EchartsTimeseriesBarChartPlugin
→ UI name: Bar Chart

BigNumberTotalChartPlugin
→ UI name: Big Number
```

Не используйте имя класса как инструкцию пользователю, если `metadata.name` отличается.

Обозначения:

- **база** — полезно большинству авторов Dashboard;
- **аналитика** — полезно BI-аналитику;
- **спец.** — изучать под конкретную задачу;
- **осторожно** — применять осознанно;
- **deprecated** — плагин явно помечен в metadata как deprecated;
- **feature flag** — регистрация зависит от настройки Superset.

## Основные Chart: MainPreset

Ниже перечислены 45 visualization plugins, постоянно регистрируемых `MainPreset` Superset 6.1.0. Filter plugins и chart customizations в этот счёт не входят.

### KPI и таблицы

| UI name | Уровень | Для чего / примечание |
|---|---|---|
| `Big Number` | база | одно итоговое значение |
| `Big Number with Trendline` | аналитика | KPI вместе с небольшой динамикой |
| `Table` | база | точные строки и агрегаты |
| `Pivot Table` | база | сводная матрица |
| `Time-series Table` | спец. | несколько временных показателей и sparklines в таблице |
| `Handlebars` | спец. | собственное шаблонное представление данных |

### Время и изменение показателей

| UI name | Уровень | Для чего / примечание |
|---|---|---|
| `Generic Chart` | аналитика | универсальный ECharts-вариант с несколькими способами представления series |
| `Area Chart` | база | временная динамика с акцентом на площадь / накопление |
| `Bar Chart` | база | сравнение категорий или дискретных периодов |
| `Line Chart` | база | динамика и тренд |
| `Smooth Line` | спец. | сглаженное представление линии |
| `Scatter Plot` | аналитика | связь показателей / точки, в том числе с временной осью |
| `Stepped Line` | спец. | ступенчатое изменение значения |
| `Mixed Chart` | аналитика | две серии на общей оси, например столбцы + линия |
| `Time-series Percent Change` | deprecated | legacy NVD3; metadata помечает Chart как deprecated |
| `Time-series Period Pivot` | спец. | сравнение временных периодов |
| `Horizon Chart` | спец. | компактное сравнение временных рядов групп |
| `Calendar Heatmap` | аналитика | интенсивность показателя по дням календаря |
| `Gantt Chart` | спец. | события / интервалы на временной шкале |
| `Waterfall Chart` | аналитика | вклад последовательных положительных и отрицательных изменений в итог |

### Сравнение, структура и KPI

| UI name | Уровень | Для чего / примечание |
|---|---|---|
| `Pie Chart` | база, осторожно | небольшое число частей целого; Donut — настройка этого Chart, не отдельный plugin |
| `Treemap` | база | вклад категорий / иерархия через площадь |
| `Funnel Chart` | аналитика | изменение показателя по последовательным стадиям |
| `Radar Chart` | спец. | сравнение нескольких показателей по нескольким осям |
| `Nightingale Rose Chart` | осторожно | полярное сравнение категорий |
| `Bullet Chart` | спец. | показатель относительно целевого значения |
| `Gauge Chart` | спец. | прогресс показателя относительно диапазона / цели |

### Распределения, связи и иерархии

| UI name | Уровень | Для чего / примечание |
|---|---|---|
| `Box Plot` | аналитика | распределение, медиана, квартили, диапазон |
| `Histogram` | аналитика | распределение значений по интервалам |
| `Heatmap` | база | интенсивность показателя на пересечении двух групп |
| `Bubble Chart` | аналитика | три измерения через X, Y и размер пузыря |
| `Bubble Chart (legacy)` | deprecated | legacy NVD3; явно помечен как deprecated |
| `Paired t-test Table` | спец. | таблица результатов парных t-тестов |
| `Parallel Coordinates` | спец. | сравнение множества показателей по строкам / объектам |
| `Partition Chart` | спец. | сравнение агрегированного показателя по иерархическим группам |
| `Graph Chart` | спец. | сеть связей между сущностями |
| `Sankey Chart` | аналитика | потоки значений между стадиями / узлами |
| `Chord Diagram` | спец. | связи между категориями через хорды |
| `Tree Chart` | спец. | древовидная иерархия |
| `Sunburst Chart` | спец. | круговая многоуровневая иерархия |
| `Word Cloud` | осторожно | частота слов; обычно не лучший выбор для точного сравнения |

### География вне deck.gl preset

| UI name | Уровень | Для чего / примечание |
|---|---|---|
| `Country Map` | спец. | choropleth по административным подразделениям страны |
| `World Map` | спец. | показатели по странам мира |
| `MapBox` | спец. | legacy MapBox-визуализация |
| `Cartodiagram` | спец. | размещение других Chart на карте |

## deck.gl preset

Отдельный `DeckGLChartPreset` Superset 6.1.0 регистрирует 11 visualization plugins.

| UI name | Registration key | Уровень |
|---|---|---|
| `deck.gl Arc` | `deck_arc` | спец. |
| `deck.gl Geojson` | `deck_geojson` | спец. |
| `deck.gl Grid` | `deck_grid` | спец. |
| `deck.gl 3D Hexagon` | `deck_hex` | спец. |
| `deck.gl Heatmap` | `deck_heatmap` | спец. |
| `deck.gl Multiple Layers` | `deck_multi` | спец. |
| `deck.gl Path` | `deck_path` | спец. |
| `deck.gl Polygon` | `deck_polygon` | спец. |
| `deck.gl Scatterplot` | `deck_scatter` | спец. |
| `deck.gl Screen Grid` | `deck_screengrid` | спец. |
| `deck.gl Contour` | `deck_contour` | спец. |

Написание `Geojson`, `Scatterplot` и `3D Hexagon` здесь сохранено именно таким, как оно задано в `metadata.name` Superset 6.1.0.

## Chart под feature flags

Кроме 56 постоянно зарегистрированных visualization plugins, `MainPreset` условно регистрирует ещё два типа.

| UI name | Feature flag | Примечание |
|---|---|---|
| `Big Number with Time Period Comparison` | `ChartPluginsExperimental` | сравнение KPI между временными периодами |
| `Table V2` | `AgGridTableEnabled` | AG Grid-based табличная визуализация |

Внутренние названия классов этих типов — `BigNumberPeriodOverPeriodChartPlugin` и `AgGridTableChartPlugin`, но это **не** их пользовательские названия в chart picker.

## Сколько их

В исходном коде Superset 6.1.0:

```text
45 MainPreset visualization plugins
+ 11 deck.gl visualization plugins
= 56 постоянно зарегистрированных visualization plugins
```

Дополнительно:

```text
+ Big Number with Time Period Comparison
+ Table V2
```

могут быть зарегистрированы при соответствующих feature flags.

То есть технический максимум из этих preset:

```text
58 visualization plugins
```

Важно:

```text
registered plugin
≠
обязательно видимый каждому пользователю пункт chart picker
```

Конкретная установка может отличаться из-за feature flags, конфигурации, metadata/labels Chart и других настроек.

## `legacy` и `deprecated` — не одно и то же

Часть Chart импортируется из пакетов с `legacy` в имени. Само по себе это **не доказывает**, что конкретный Chart помечен как deprecated.

В этом каталоге `deprecated` ставится только там, где исходный код Superset 6.1.0 делает это явно через metadata / `ChartLabel.Deprecated`.

На проверенных источниках это, в частности:

```text
Bubble Chart (legacy)
Time-series Percent Change
```

Поэтому правило такое:

```text
legacy package
→ старая реализация / исторический путь

explicit deprecated label
→ Chart действительно помечен deprecated
```

Не смешивайте эти понятия.

## Какие Chart изучать сначала

Не учите каталог подряд.

### Базовый автор Dashboard

```text
Big Number
Table
Pivot Table
Bar Chart
Line Chart
Area Chart
Pie Chart
Heatmap
Treemap
```

### BI-аналитик

После базы:

```text
Big Number with Trendline
Mixed Chart
Scatter Plot
Histogram
Box Plot
Waterfall Chart
Funnel Chart
Sankey Chart
Calendar Heatmap
```

### Остальные

Изучайте под конкретный аналитический вопрос.

## Источники Superset 6.1.0

Основная регистрация и feature flags:

- <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/visualizations/presets/MainPreset.ts>

Точные UI names ECharts:

- `Generic Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/index.ts>
- `Bar Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Bar/index.ts>
- `Line Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Line/index.ts>
- `Big Number with Trendline`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/BigNumber/BigNumberWithTrendline/index.ts>
- `Big Number`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/BigNumber/BigNumberTotal/index.ts>
- `Big Number with Time Period Comparison`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/BigNumber/BigNumberPeriodOverPeriod/index.ts>

Таблицы и отдельные plugins:

- `Table`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/index.ts>
- `Pivot Table`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-pivot-table/src/plugin/index.ts>
- `Time-series Table`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/visualizations/TimeTable/index.ts>
- `Table V2`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-ag-grid-table/src/index.ts>

Explicit deprecated examples:

- `Bubble Chart (legacy)`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-nvd3/src/Bubble/index.ts>
- `Time-series Percent Change`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-nvd3/src/Compare/index.ts>

`deck.gl`:

- preset: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-deckgl/src/preset.ts>
- `deck.gl 3D Hexagon`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-deckgl/src/layers/Hex/index.ts>
- `deck.gl Geojson`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-deckgl/src/layers/Geojson/index.ts>

Introduction 6.1.0:

- <https://superset.apache.org/user-docs/6.1.0/intro/>
