# Справочник. Каталог Chart Apache Superset 6.1.0

Этот файл — **не обязательный урок** и не список того, что нужно выучить новичку.

Он нужен как контрольный каталог визуализаций версии курса — Apache Superset 6.1.0.

Для выбора визуализации по задаче используйте короткую шпаргалку:

→ [Как выбрать визуализацию](../07a-choose-visualization.md)

## Как читать этот каталог

В колонке `Название в интерфейсе` используются **пользовательские названия из `metadata.name` исходного кода Superset 6.1.0**.

Это важно, потому что внутреннее имя класса и название в галерее выбора визуализации (`chart picker`) могут различаться. Например:

```text
EchartsTimeseriesBarChartPlugin
→ название в интерфейсе: Bar Chart

BigNumberTotalChartPlugin
→ название в интерфейсе: Big Number
```

Не используйте имя класса как инструкцию пользователю, если `metadata.name` отличается.

Обозначения:

- **база** — полезно большинству авторов Dashboard;
- **аналитика** — полезно BI-аналитику;
- **спец.** — изучать под конкретную задачу;
- **осторожно** — применять осознанно;
- **устаревший (`deprecated`)** — плагин явно помечен соответствующей меткой в метаданных;
- **флаг функции (`feature flag`)** — регистрация зависит от настройки Superset.

## Основные Chart: MainPreset

Ниже перечислены 45 плагинов визуализаций, постоянно регистрируемых `MainPreset` Superset 6.1.0. Плагины фильтров и дополнительные настройки графиков в этот счёт не входят.

### KPI и таблицы

| Название в интерфейсе | Уровень | Для чего / примечание |
|---|---|---|
| `Big Number` | база | одно итоговое значение |
| `Big Number with Trendline` | аналитика | KPI вместе с небольшой динамикой |
| `Table` | база | точные строки и агрегаты |
| `Pivot Table` | база | сводная матрица |
| `Time-series Table` | спец. | несколько временных показателей и мини-графики в таблице |
| `Handlebars` | спец. | собственное шаблонное представление данных |

### Время и изменение показателей

| Название в интерфейсе | Уровень | Для чего / примечание |
|---|---|---|
| `Generic Chart` | аналитика | универсальный ECharts-вариант с несколькими способами представления серий |
| `Area Chart` | база | временная динамика с акцентом на площадь / накопление |
| `Bar Chart` | база | сравнение категорий или дискретных периодов |
| `Line Chart` | база | динамика и тренд |
| `Smooth Line` | спец. | сглаженное представление линии |
| `Scatter Plot` | аналитика | связь показателей / точки, в том числе с временной осью |
| `Stepped Line` | спец. | ступенчатое изменение значения |
| `Mixed Chart` | аналитика | две серии на общей оси, например столбцы + линия |
| `Time-series Percent Change` | устаревший | старая реализация NVD3 (`legacy`); метаданные явно помечают Chart как `deprecated` |
| `Time-series Period Pivot` | спец. | сравнение временных периодов |
| `Horizon Chart` | спец. | компактное сравнение временных рядов групп |
| `Calendar Heatmap` | аналитика | интенсивность показателя по дням календаря |
| `Gantt Chart` | спец. | события / интервалы на временной шкале |
| `Waterfall Chart` | аналитика | вклад последовательных положительных и отрицательных изменений в итог |

### Сравнение, структура и KPI

| Название в интерфейсе | Уровень | Для чего / примечание |
|---|---|---|
| `Pie Chart` | база, осторожно | небольшое число частей целого; Donut — настройка этого Chart, не отдельный плагин |
| `Treemap` | база | вклад категорий / иерархия через площадь |
| `Funnel Chart` | аналитика | изменение показателя по последовательным стадиям |
| `Radar Chart` | спец. | сравнение нескольких показателей по нескольким осям |
| `Nightingale Rose Chart` | осторожно | полярное сравнение категорий |
| `Bullet Chart` | спец. | показатель относительно целевого значения |
| `Gauge Chart` | спец. | прогресс показателя относительно диапазона / цели |

### Распределения, связи и иерархии

| Название в интерфейсе | Уровень | Для чего / примечание |
|---|---|---|
| `Box Plot` | аналитика | распределение, медиана, квартили, диапазон |
| `Histogram` | аналитика | распределение значений по интервалам |
| `Heatmap` | база | интенсивность показателя на пересечении двух групп |
| `Bubble Chart` | аналитика | три измерения через X, Y и размер пузыря |
| `Bubble Chart (legacy)` | устаревший | старая реализация NVD3 (`legacy`); явно помечена как `deprecated` |
| `Paired t-test Table` | спец. | таблица результатов парных t-тестов |
| `Parallel Coordinates` | спец. | сравнение множества показателей по строкам / объектам |
| `Partition Chart` | спец. | сравнение агрегированного показателя по иерархическим группам |
| `Graph Chart` | спец. | сеть связей между сущностями |
| `Sankey Chart` | аналитика | потоки значений между стадиями / узлами |
| `Chord Diagram` | спец. | связи между категориями через хорды |
| `Tree Chart` | спец. | древовидная иерархия |
| `Sunburst Chart` | спец. | круговая многоуровневая иерархия |
| `Word Cloud` | осторожно | частота слов; обычно не лучший выбор для точного сравнения |

### География вне набора deck.gl

| Название в интерфейсе | Уровень | Для чего / примечание |
|---|---|---|
| `Country Map` | спец. | картограмма по административным подразделениям страны |
| `World Map` | спец. | показатели по странам мира |
| `MapBox` | спец. | старая MapBox-визуализация (`legacy`) |
| `Cartodiagram` | спец. | размещение других Chart на карте |

## Набор deck.gl

Отдельный `DeckGLChartPreset` Superset 6.1.0 регистрирует 11 плагинов визуализаций.

| Название в интерфейсе | Ключ регистрации | Уровень |
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

## Chart за флагами функций

Кроме 56 постоянно зарегистрированных плагинов визуализаций, `MainPreset` условно регистрирует ещё два типа.

| Название в интерфейсе | Флаг функции | Примечание |
|---|---|---|
| `Big Number with Time Period Comparison` | `ChartPluginsExperimental` | сравнение KPI между временными периодами |
| `Table V2` | `AgGridTableEnabled` | табличная визуализация на основе AG Grid |

Внутренние названия классов этих типов — `BigNumberPeriodOverPeriodChartPlugin` и `AgGridTableChartPlugin`, но это **не** их пользовательские названия в галерее выбора визуализации.

## Сколько их

В исходном коде Superset 6.1.0:

```text
45 плагинов визуализаций MainPreset
+ 11 плагинов визуализаций deck.gl
= 56 постоянно зарегистрированных плагинов визуализаций
```

Дополнительно:

```text
+ Big Number with Time Period Comparison
+ Table V2
```

могут быть зарегистрированы при соответствующих флагах функций.

То есть технический максимум из этих наборов регистрации:

```text
58 плагинов визуализаций
```

Важно:

```text
зарегистрированный плагин
≠
обязательно видимый каждому пользователю пункт галереи выбора визуализации
```

Конкретная установка может отличаться из-за флагов функций, конфигурации, метаданных и меток Chart, а также других настроек.

## `legacy` и `deprecated` — не одно и то же

Часть Chart импортируется из пакетов с `legacy` в имени. Само по себе это **не доказывает**, что конкретный Chart помечен как `deprecated`.

В этом каталоге статус `deprecated` ставится только там, где исходный код Superset 6.1.0 делает это явно через метаданные / `ChartLabel.Deprecated`.

На проверенных источниках это, в частности:

```text
Bubble Chart (legacy)
Time-series Percent Change
```

Поэтому правило такое:

```text
legacy в имени пакета
→ старая реализация / исторический путь

явная метка deprecated
→ Chart действительно помечен как устаревший
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

Основная регистрация и флаги функций:

- <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/visualizations/presets/MainPreset.ts>

Точные пользовательские названия ECharts:

- `Generic Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/index.ts>
- `Bar Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Bar/index.ts>
- `Line Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Line/index.ts>
- `Big Number with Trendline`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/BigNumber/BigNumberWithTrendline/index.ts>
- `Big Number`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/BigNumber/BigNumberTotal/index.ts>
- `Big Number with Time Period Comparison`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/BigNumber/BigNumberPeriodOverPeriod/index.ts>

Таблицы и отдельные плагины:

- `Table`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/index.ts>
- `Pivot Table`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-pivot-table/src/plugin/index.ts>
- `Time-series Table`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/visualizations/TimeTable/index.ts>
- `Table V2`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-ag-grid-table/src/index.ts>

Примеры явной метки `deprecated`:

- `Bubble Chart (legacy)`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-nvd3/src/Bubble/index.ts>
- `Time-series Percent Change`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-nvd3/src/Compare/index.ts>

`deck.gl`:

- набор регистрации: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-deckgl/src/preset.ts>
- `deck.gl 3D Hexagon`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-deckgl/src/layers/Hex/index.ts>
- `deck.gl Geojson`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-deckgl/src/layers/Geojson/index.ts>

Введение Superset 6.1.0:

- <https://superset.apache.org/user-docs/6.1.0/intro/>
