# 05. Осваиваем Explore

Теперь начинается собственно работа с данными. До этого мы только готовили стенд, подключение и Dataset. В этом уроке впервые получим аналитический результат без SQL.

Ничего сохранять как Chart пока не будем. Задача — понять механику Explore: что группируем, что считаем и какие строки оставляем.

## Открываем Dataset

Перейдите в:

```text
Datasets
```

и откройте:

```text
sales
```

Откроется `Explore`. Для начала выберите:

```text
Table
```

Основные поля, которые понадобятся в этом уроке:

```text
Dimensions
Metrics
Filters
Row limit
```

Для временного столбца позже появится `Time grain`.

У физического Dataset Superset может сразу подставить стандартную метрику `COUNT(*)`. Если она уже стоит в `Metrics`, удалите её. Если поле пустое — ничего делать не нужно. В каждом упражнении оставляйте только те метрики, которые нужны именно сейчас.

## Первый нормальный вопрос: выручка по регионам

Нам нужно получить ответ на вопрос:

> Сколько выручки дал каждый регион?

Настройка в Explore выглядит так:

```text
Dimensions: region
Metrics:    SUM(revenue)
Filters:    sale_date (No filter)
Row limit:  100
```

То есть `region` определяет группы, а `SUM(revenue)` считает сумму внутри каждой группы.

Нажмите:

```text
Create chart
```

У нового, ещё не сохранённого Chart эта кнопка просто выполняет текущую конфигурацию Explore. Сам объект Chart сохраняется отдельно через `Save`; этим займёмся в уроке 07.

Ожидаемый результат:

| region | SUM(revenue) |
|---|---:|
| Север | 1360.00 |
| Юг | 2645.00 |

Порядок строк не важен. Проверка общей суммы:

```text
1360.00 + 2645.00 = 4005.00
```

Если Superset показывает, например, `1.36k` вместо `1360.00`, расчёт от этого не меняется. Формат числа будем настраивать позже.

По смыслу этот результат соответствует SQL:

```sql
SELECT
    region,
    SUM(revenue)
FROM training.sales
GROUP BY region;
```

Писать этот SQL сейчас не нужно — он приведён только как объяснение того, что делает Explore.

## Сортировка

Нажмите заголовок `SUM(revenue)` и отсортируйте таблицу по убыванию.

Должно получиться:

```text
Юг    2645.00
Север 1360.00
```

Сортировка меняет только порядок отображения. Сами суммы остаются теми же.

## Теперь фильтр

Добавьте в `Filters` поле:

```text
region
```

Оставьте оператор:

```text
IN
```

и выберите:

```text
Север
```

После `Create chart` останется одна строка:

| region | SUM(revenue) |
|---|---:|
| Север | 1360.00 |

Замените Север на Юг и выполните запрос ещё раз:

```text
Юг = 2645.00
```

Обратите внимание на разницу ролей одной и той же колонки. Когда `region` находится в `Dimensions`, мы получаем отдельную группу для каждого региона. Когда `region` находится в `Filters`, мы отбираем строки.

После проверки удалите фильтр `region`.

## Ограничиваем период

Откройте временной фильтр:

```text
sale_date (No filter)
```

Выберите `Custom` и задайте полный февраль 2026 года:

```text
Start (inclusive): 2026-02-01
End (exclusive):   2026-03-01
```

То есть:

```text
2026-02-01 <= sale_date < 2026-03-01
```

При прежних настройках:

```text
Dimensions = region
Metrics    = SUM(revenue)
```

ожидается:

| region | SUM(revenue) |
|---|---:|
| Север | 450.00 |
| Юг | 730.00 |

Всего за февраль:

```text
1180.00
```

Здесь важно понять границу `End (exclusive)`: дата `2026-03-01` уже не входит в выбранный период. Для целого календарного месяца это удобно — берём первое число нужного месяца и первое число следующего.

После проверки верните `sale_date` в:

```text
No filter
```

и убедитесь, что снова получили:

```text
Север = 1360.00
Юг    = 2645.00
```

## Группируем по месяцам

Теперь вопрос другой:

> Как менялась общая выручка по месяцам?

Удалите `region` из `Dimensions` и добавьте:

```text
sale_date
```

Для него установите:

```text
Time grain: Month
```

Оставьте:

```text
Metrics: SUM(revenue)
Filters: sale_date (No filter)
```

После `Create chart` должны появиться три группы:

| месяц | SUM(revenue) |
|---|---:|
| 2026-01 | 1160.00 |
| 2026-02 | 1180.00 |
| 2026-03 | 1665.00 |

Проверка:

```text
1160.00 + 1180.00 + 1665.00 = 4005.00
```

`Time range` отвечает на вопрос «за какой период берём строки», а `Time grain` — «с какой временной детализацией их группируем». Это разные настройки, хотя в интерфейсе они находятся рядом.

## Вернём базовую конфигурацию

Перед завершением урока восстановите:

```text
Visualization: Table
Dimensions:    region
Metrics:       SUM(revenue)
Filters:       sale_date (No filter)
Row limit:     100
```

Контроль:

```text
Север = 1360.00
Юг    = 2645.00
```

## Проверьте себя без пошаговой подсказки

Попробуйте самостоятельно получить выручку по продуктам:

```text
Датчик        = 1210.00
Маршрутизатор = 1605.00
Терминал      = 1190.00
```

Затем общую выручку за февраль:

```text
1180.00
```

И ещё раз выручку по месяцам:

```text
2026-01 = 1160.00
2026-02 = 1180.00
2026-03 = 1665.00
```

Если эти три задачи получаются без копирования готовой конфигурации, базовая логика Explore уже начала складываться.

## Если результат странный

Лишний `COUNT(*)` в таблице почти всегда означает, что он остался в `Metrics`. Для наших упражнений его нужно удалить.

Пустой результат чаще всего связан с `Filters` или периодом. Учебные данные лежат только в январе–марте 2026 года.

Одна строка `4005` вместо двух регионов означает, что `region` не добавлен в `Dimensions`.

Если февраль не даёт `450 + 730`, проверьте границы:

```text
Start (inclusive) = 2026-02-01
End (exclusive)   = 2026-03-01
```

Если `Time grain` не появляется, сначала добавьте `sale_date` как временной столбец в `Dimensions`.

Если `sale_date` вообще не распознаётся как временной, вернитесь в урок 04 и проверьте:

```text
Columns → sale_date → Is temporal
```

## Дальше

К этому моменту нужно уверенно получать без SQL три контрольных результата:

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

Если путаются роли `Dimension`, `Metric` и `Filter`, используйте [короткую шпаргалку](05a-dimension-metric-filter.md). Если проблема именно со временем — [памятку по Time column, Time range и Time grain](05b-time-range-and-grain.md).

Следующий урок — расчёты: Calculated Column и сохранённая Metric.

→ [Урок 06. Метрики и расчёты](06-metrics-and-calculations.md)

## Источники Superset 6.1.0

- панель управления Table: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/controlPanel.tsx>
- `Dimensions`, `Metrics`, `Filters`, `Time grain`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/shared-controls/dndControls.tsx>
- стандартная метрика `COUNT(*)` физического Dataset: <https://github.com/apache/superset/blob/6.1.0/superset/db_engine_specs/base.py>
- автоматический временной фильтр нового Explore: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/shared-controls/mixins.tsx>
- адаптивный числовой формат Table: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/transformProps.ts>
- стандартный форматировщик `SMART_NUMBER`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-core/src/number-format/NumberFormatterRegistry.ts>
- редактор обычного фильтра и оператор `IN`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/FilterControl/AdhocFilterEditPopoverSimpleTabContent/index.tsx>
- пользовательский период `Start (inclusive)` / `End (exclusive)`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/DateFilterControl/components/CustomFrame.tsx>
- `Create chart` / `Update chart`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/RunQueryButton/index.tsx>