# Справочник. Каталог Chart Apache Superset 6.1.0

Это технический каталог визуализаций версии курса. Он нужен для сверки названий и состава Superset 6.1.0, а не как список того, что нужно учить подряд.

Выбор визуализации по аналитической задаче разобран отдельно:

→ [Как выбрать визуализацию](../07a-choose-visualization.md)

## Как читать каталог

В колонке `Название в интерфейсе` используются пользовательские названия из `metadata.name` исходного кода Superset 6.1.0. Внутреннее имя класса может отличаться:

```text
EchartsTimeseriesBarChartPlugin
→ Bar Chart

BigNumberTotalChartPlugin
→ Big Number
```

Поэтому в учебных инструкциях используем пользовательское название, а внутренние имена классов приводим только для проверки исходного кода.

## Основные Chart: MainPreset

`MainPreset` Superset 6.1.0 постоянно регистрирует 45 плагинов визуализаций. Плагины фильтров и дополнительные настройки графиков в этот счёт не входят.

### KPI и таблицы

| Название в интерфейсе | Для чего / примечание |
|---|---|
| `Big Number` | одно итоговое значение |
| `Big Number with Trendline` | KPI вместе с небольшой динамикой |
| `Table` | точные строки и агрегаты |
| `Pivot Table` | сводная матрица |
| `Time-series Table` | несколько временных показателей и мини-графики в таблице |
| `Handlebars` | собственное шаблонное представление данных |

### Время и изменение показателей

| Название в интерфейсе | Для чего / примечание |
|---|---|
| `Generic Chart` | универсальный ECharts-вариант с несколькими способами представления серий |
| `Area Chart` | временная динамика с акцентом на площадь / накопление |
| `Bar Chart` | сравнение категорий или дискретных периодов |
| `Line Chart` | динамика и тренд |
| `Smooth Line` | сглаженное представление линии |
| `Scatter Plot` | связь показателей / точки, в том числе с временной осью |
| `Stepped Line` | ступенчатое изменение значения |
| `Mixed Chart` | две серии на общей оси, например столбцы + линия |
| `Time-series Percent Change` | старая реализация NVD3 (`legacy`); явно помечена как `deprecated` |
| `Time-series Period Pivot` | сравнение временных периодов |
| `Horizon Chart` | компактное сравнение временных рядов групп |
| `Calendar Heatmap` | интенсивность показателя по дням календаря |
| `Gantt Chart` | события / интервалы на временной шкале |
| `Waterfall Chart` | вклад последовательных положительных и отрицательных изменений в итог |

### Сравнение, структура и KPI

| Название в интерфейсе | Для чего / примечание |
|---|---|
| `Pie Chart` | части целого; Donut — настройка этого Chart, а не отдельный плагин |
| `Treemap` | вклад категорий / иерархия через площадь |
| `Funnel Chart` | изменение показателя по последовательным стадиям |
| `Radar Chart` | сравнение нескольких показателей по нескольким осям |
| `Nightingale Rose Chart` | полярное сравнение категорий |
| `Bullet Chart` | показатель относительно целевого значения |
| `Gauge Chart` | показатель относительно диапазона / цели |

### Распределения, связи и иерархии

| Название в интерфейсе | Для чего / примечание |
|---|---|
| `Box Plot` | распределение, медиана, квартили, диапазон |
| `Histogram` | распределение значений по интервалам |
| `Heatmap` | интенсивность показателя на пересечении двух групп |
| `Bubble Chart` | три измерения через X, Y и размер пузыря |
| `Bubble Chart (legacy)` | старая реализация NVD3; явно помечена как `deprecated` |
| `Paired t-test Table` | таблица результатов парных t-тестов |
| `Parallel Coordinates` | сравнение множества показателей по строкам / объектам |
| `Partition Chart` | агрегированный показатель по иерархическим группам |
| `Graph Chart` | сеть связей между сущностями |
| `Sankey Chart` | потоки значений между стадиями / узлами |
| `Chord Diagram` | связи между категориями через хорды |
| `Tree Chart` | древовидная иерархия |
| `Sunburst Chart` | круговая многоуровневая иерархия |
| `Word Cloud` | частота слов |

### География вне набора deck.gl

| Название в интерфейсе | Для чего / примечание |
|---|---|
| `Country Map` | картограмма по административным подразделениям страны |
| `World Map` | показатели по странам мира |
| `MapBox` | старая MapBox-визуализация (`legacy`) |
| `Cartodiagram` | размещение других Chart на карте |

## Набор deck.gl

Отдельный `DeckGLChartPreset` Superset 6.1.0 регистрирует 11 плагинов визуализаций.

| Название в интерфейсе | Ключ регистрации |
|---|---|
| `deck.gl Arc` | `deck_arc` |
| `deck.gl Geojson` | `deck_geojson` |
| `deck.gl Grid` | `deck_grid` |
| `deck.gl 3D Hexagon` | `deck_hex` |
| `deck.gl Heatmap` | `deck_heatmap` |
| `deck.gl Multiple Layers` | `deck_multi` |
| `deck.gl Path` | `deck_path` |
| `deck.gl Polygon` | `deck_polygon` |
| `deck.gl Scatterplot` | `deck_scatter` |
| `deck.gl Screen Grid` | `deck_screengrid` |
| `deck.gl Contour` | `deck_contour` |

Написание `Geojson`, `Scatterplot` и `3D Hexagon` сохранено именно таким, как оно задано в `metadata.name` Superset 6.1.0.

## Chart за флагами функций

Кроме 56 постоянно зарегистрированных плагинов визуализаций, `MainPreset` условно регистрирует ещё два типа.

| Название в интерфейсе | Флаг функции | Примечание |
|---|---|---|
| `Big Number with Time Period Comparison` | `ChartPluginsExperimental` | сравнение KPI между временными периодами |
| `Table V2` | `AgGridTableEnabled` | табличная визуализация на основе AG Grid |

Внутренние названия классов этих типов — `BigNumberPeriodOverPeriodChartPlugin` и `AgGridTableChartPlugin`; в интерфейсе используются названия из таблицы выше.

## Сколько плагинов зарегистрировано

В исходном коде Superset 6.1.0:

```text
45 плагинов визуализаций MainPreset
+ 11 плагинов визуализаций deck.gl
= 56 постоянно зарегистрированных плагинов визуализаций
```

Ещё два могут быть зарегистрированы при соответствующих флагах функций, то есть в рассмотренных наборах регистрации получается максимум 58.

Это число не означает, что каждый пользователь обязательно увидит 58 пунктов в галерее: конкретная установка зависит от флагов функций и конфигурации.

## `legacy` и `deprecated` — не одно и то же

`legacy` в имени пакета указывает на старую реализацию или исторический путь, но само по себе не означает, что Chart помечен как устаревший в интерфейсе.

В этом каталоге `deprecated` указано только там, где исходный код Superset 6.1.0 делает это явно через метаданные / `ChartLabel.Deprecated`. Проверенные примеры:

```text
Bubble Chart (legacy)
Time-series Percent Change
```

Рекомендации по тому, какие визуализации осваивать в первую очередь, намеренно вынесены из технического каталога в [отдельную шпаргалку](../07a-choose-visualization.md).

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
