# Шпаргалка к уроку 07. Как выбрать визуализацию

Начинайте не с галереи Chart, а с вопроса к данным. Сначала решите, какой ответ нужен, и только потом выбирайте форму.

| Что нужно понять | Обычно выбирать |
|---|---|
| одно итоговое значение | `Big Number` |
| KPI вместе с небольшой динамикой | `Big Number with Trendline` |
| точные строки или группы | `Table` |
| сводная матрица | `Pivot Table` |
| сравнить категории | `Bar Chart` |
| показать динамику | `Line Chart` |
| показать объём по периодам | `Bar Chart` с временной осью |
| показать структуру во времени | `Area Chart` |
| совместить два временных представления | `Mixed Chart` |
| показать несколько частей целого | `Pie Chart` |
| показать вклад многих категорий | `Treemap` |
| увидеть распределение значений | `Histogram` |
| увидеть выбросы и диапазон | `Box Plot` |
| проверить связь двух показателей | `Scatter Plot` |
| показать концентрацию по двум измерениям | `Heatmap` |
| объяснить изменение итога | `Waterfall Chart` |
| показать последовательные стадии | `Funnel Chart` |
| показать потоки между состояниями | `Sankey Chart` |
| показать активность по дням календаря | `Calendar Heatmap` |
| показать начало и конец интервалов | `Gantt Chart` |
| показать географию | карты / `deck.gl` |

Если простой Chart уже отвечает на вопрос, более сложный обычно ничего не улучшает.

## Что освоить в базовом курсе

Для текущего маршрута важнее всего уверенно работать с:

```text
Big Number
Table
Bar Chart
Line Chart
```

После этого полезно познакомиться с `Pivot Table`, `Area Chart`, `Pie Chart`, `Heatmap` и `Treemap`.

`Bar Chart` и `Line Chart` умеют работать с временной осью. В Superset 6.1.0 именно эти названия используются для соответствующих ECharts-визуализаций — отдельные обязательные `Time-series Bar Chart` и `Time-series Line Chart` искать не нужно.

## Когда базы мало

Для исследования распределений, выбросов, зависимостей и потоков могут понадобиться:

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

Их имеет смысл изучать под конкретную задачу, а не подряд по списку.

## Четыре вопроса перед выбором

### Что именно нужно увидеть?

Если вопрос звучит «на каком участке больше всего ошибок?», первым кандидатом будет `Bar Chart`.

### Нужны точные значения или быстрое сравнение?

```text
точные строки и суммы → Table
сравнить категории    → Bar Chart
```

### Есть ли время?

```text
тренд                    → Line Chart
объём каждого периода    → Bar Chart + временная ось
активность по дням       → Calendar Heatmap
интервалы начала/окончания → Gantt Chart
```

### Не усложняю ли я ответ?

Если задачу нормально решает `Bar Chart`, `Radar Chart`, `Chord Diagram` или `Graph Chart` только ради необычного вида не нужны.

## Pie и Donut

В Superset 6.1.0 пользователь выбирает `Pie Chart`. Donut — режим отображения этого Chart, а не отдельный зарегистрированный тип.

Хороший случай:

```text
ОК         82%
Ошибка     12%
Нет данных  6%
```

Плохой — круг из двадцати плохо различимых категорий. Для большого числа категорий обычно удобнее `Bar Chart` или `Treemap`.

## Gauge Chart — не автоматический выбор для KPI

Если нужно просто показать «Выполнение плана = 76%», `Big Number` часто компактнее и понятнее.

`Gauge Chart` имеет смысл, когда для чтения показателя действительно важны шкала, диапазон или пороги.

## Table полезна и для проверки

Когда число вызывает сомнение, временно переключитесь на `Table`. В таблице проще увидеть измерения, метрики, лишние группы и точные значения.

Сначала добейтесь правильного результата, потом возвращайтесь к представлению.

## Пример рабочего Dashboard

Задача: контроль обработки документов.

| Вопрос | Тип Chart |
|---|---|
| сколько документов | `Big Number` |
| сколько ошибок | `Big Number` |
| доля ошибок | `Big Number` |
| как ошибки меняются по дням | `Line Chart` |
| где ошибок больше | `Bar Chart` |
| где концентрируются типы ошибок | `Heatmap` |
| какие записи проблемные | `Table` |

Здесь не нужны `Sankey Chart`, `Radar Chart`, `Gauge Chart`, `Word Cloud` или карта, пока для них нет отдельного вопроса.

## Остальные визуализации

В Superset есть иерархические, сетевые, статистические, географические и другие специализированные типы Chart. Полный перечень версии курса вынесен отдельно:

→ [Справочник: каталог Chart Apache Superset 6.1.0](reference/charts-catalog-6.1.0.md)

Названия Chart в этой шпаргалке сверены с пользовательскими `metadata.name` Superset 6.1.0; внутренние имена классов в учебные инструкции не подставляются.

## Связанные материалы

- [Урок 07. Строим и сохраняем Chart](07-create-charts.md)
- [Почему цифры в Superset не сходятся](07b-troubleshoot-wrong-numbers.md)
- [Форматы чисел, процентов и дат](07c-formatting.md)
- [Как спроектировать нормальный Dashboard](08a-dashboard-design.md)
- [Каталог Chart 6.1.0](reference/charts-catalog-6.1.0.md)

## Источники Superset 6.1.0

- регистрация основных Chart: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/visualizations/presets/MainPreset.ts>
- `Bar Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Bar/index.ts>
- `Line Chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-echarts/src/Timeseries/Regular/Line/index.ts>
- набор регистрации `deck.gl`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/legacy-preset-chart-deckgl/src/preset.ts>
- Introduction 6.1.0: <https://superset.apache.org/user-docs/6.1.0/intro/>
