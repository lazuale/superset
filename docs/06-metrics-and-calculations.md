# 06. Метрики и расчёты

## Что научимся делать

После этого урока вы должны уметь:

- отличать физический столбец, `Calculated column`, временную `ad hoc metric` и сохранённую `Metric`;
- использовать основные агрегирования `SUM`, `COUNT`, `COUNT_DISTINCT` и `AVG`;
- понимать, как `NULL` влияет на `COUNT`;
- создать вычисляемый столбец на уровне строки;
- создать сохранённую метрику на уровне группы строк;
- понимать, что замок `Source` не требуется для работы с `Metrics` и `Calculated columns`;
- повторно использовать сохранённую Metric в `Explore`;
- проверить расчёты по известным контрольным значениям;
- объяснить, почему агрегатные функции относятся к Metric, а не к Calculated column.

Главная задача урока — не выучить кнопки, а жёстко разделить два уровня расчёта:

```text
revenue - cost
        ↓
расчёт одной строки
        ↓
Calculated column
```

и:

```text
SUM(revenue) - SUM(cost)
        ↓
расчёт по набору строк
        ↓
Metric
```

В этом уроке мы **не строим и не сохраняем новые Chart**. Визуализации будут отдельной темой урока 07.

## Что нужно до начала

Должны быть полностью пройдены:

- [урок 02](02-start-training-superset.md) — стенд запущен;
- [урок 03](03-connect-postgresql.md) — создано подключение `Training PostgreSQL`;
- [урок 04](04-create-dataset.md) — создан Dataset `sales`;
- [урок 05](05-explore-basics.md) — вы уже умеете выполнять простой агрегированный запрос через `Explore`.

Откройте Superset:

<http://localhost:8088>

Войдите:

```text
логин:  admin
пароль: admin
```

## Четыре разных сущности, которые нельзя смешивать

К этому моменту в работе уже встречались физические столбцы и временная метрика в `Explore`. Теперь добавятся ещё два объекта.

| Объект | Где определяется | Что делает | Пример |
|---|---|---|---|
| физический столбец | PostgreSQL | хранит исходное значение строки | `revenue` |
| Calculated column | Dataset | вычисляет выражение на уровне строки | `revenue - cost` |
| ad hoc metric | Explore | разовый агрегированный расчёт для текущего запроса/Chart | `SUM(revenue)` |
| сохранённая Metric | Dataset | хранит повторно используемое агрегированное выражение | `SUM(revenue) - SUM(cost)` |

Это принципиальное разделение.

### Физический столбец

В таблице `training.sales` реально хранится:

```text
revenue
cost
quantity
...
```

Например, первая строка содержит:

```text
revenue = 200.00
cost    = 120.00
```

### Calculated column

В PostgreSQL столбца `profit` у нас нет.

Но в Dataset можно определить:

```sql
revenue - cost
```

Тогда для первой строки получится:

```text
200.00 - 120.00 = 80.00
```

То есть `Calculated column` отвечает на вопрос:

> что вычислить для каждой строки?

### Ad hoc metric

В уроке 05 мы прямо в `Explore` создавали:

```sql
SUM(revenue)
```

Это была временная, или `ad hoc`, метрика.

Она не становится общей сохранённой Metric Dataset. Если позже сохранить Chart, его конфигурация может сохранить этот разовый расчёт внутри самого Chart, но другие Chart на том же Dataset не получают отдельную общую Metric автоматически.

### Сохранённая Metric

Metric создаётся в настройках Dataset и становится доступна для повторного использования в `Explore` на этом Dataset.

В этом уроке создадим:

```sql
SUM(revenue) - SUM(cost)
```

и сохраним её под техническим ключом:

```text
total_profit
```

с понятной подписью:

```text
Прибыль
```

Metric отвечает на вопрос:

> что посчитать по выбранному набору строк или по каждой группе строк?

## Сначала разбираем основные агрегирования

Откройте:

```text
Datasets
```

Нажмите на Dataset:

```text
sales
```

Откроется `Explore`.

Для упражнений используйте:

```text
Visualization: Table
Dimensions:    пусто
Filters:       без активных ограничений
```

Если в `Filters` отображается temporal-фильтр `sale_date`, оставьте его в состоянии:

```text
No filter
```

Если после урока 05 в `Dimensions` остался `region` или `sale_date`, удалите его. Сейчас сначала считаем показатели по всем 12 строкам целиком.

Также удалите старые временные метрики, если они остались от предыдущего упражнения.

Пока Chart не сохранён, текущая конфигурация Explore выполняется кнопкой:

```text
Create chart
```

## SUM

`SUM` складывает значения выбранного числового столбца.

Добавьте в `Metrics`:

```text
revenue
```

и выберите агрегирование:

```text
SUM
```

Получится:

```sql
SUM(revenue)
```

Выполните текущую конфигурацию:

```text
Create chart
```

Контрольный результат:

```text
4005.00
```

Теперь замените `revenue` на:

```text
quantity
```

с тем же `SUM` и снова выполните конфигурацию.

Контрольный результат:

```text
31
```

То есть:

```text
SUM(revenue)  = 4005.00
SUM(quantity) = 31
```

## COUNT

`COUNT(column)` считает строки, в которых указанный столбец **не равен `NULL`**.

Удалите предыдущую метрику и добавьте:

```text
sale_id
```

с агрегированием:

```text
COUNT
```

Получится смысловой эквивалент:

```sql
COUNT(sale_id)
```

Выполните конфигурацию кнопкой `Create chart`.

Контрольный результат:

```text
12
```

В таблице 12 строк, а `sale_id` — обязательный первичный ключ и не может быть `NULL`.

Теперь вместо `sale_id` выберите:

```text
manager
```

и снова используйте:

```text
COUNT
```

После выполнения контрольный результат:

```text
11
```

Это не ошибка.

В одной учебной строке `manager` специально равен `NULL`. Поэтому:

```text
строк всего    = 12
COUNT(sale_id) = 12
COUNT(manager) = 11
```

Если интерфейс визуализации предлагает готовую метрику `COUNT(*)`, она считает строки и для нашей таблицы также должна дать:

```text
12
```

Но для понимания различия в этом упражнении используем именно конкретные столбцы.

## COUNT DISTINCT

Теперь для столбца:

```text
manager
```

выберите агрегирование:

```text
COUNT_DISTINCT
```

В Superset 6.1.0 этот вариант в редакторе ad hoc metric называется именно `COUNT_DISTINCT`.

Смысл выражения:

```sql
COUNT(DISTINCT manager)
```

В данных встречаются четыре непустых менеджера:

```text
Анна
Борис
Клара
Денис
```

Поэтому после `Create chart` контрольный результат:

```text
4
```

Сравните:

```text
COUNT(manager)          = 11
COUNT_DISTINCT(manager) = 4
```

Первое выражение отвечает:

> в скольких строках заполнен manager?

Второе:

> сколько разных непустых manager встречается?

## AVG

`AVG` считает среднее арифметическое непустых значений.

Выберите:

```text
revenue
```

и агрегирование:

```text
AVG
```

Смысл:

```sql
AVG(revenue)
```

После выполнения контрольный результат:

```text
333.75
```

Проверка:

```text
4005.00 / 12 = 333.75
```

Теперь у нас есть минимальный набор агрегирований, достаточный для большинства первых аналитических запросов:

```text
SUM            → сумма
COUNT          → количество непустых значений
COUNT_DISTINCT → количество разных непустых значений
AVG            → среднее
```

`MIN` и `MAX` тоже существуют, но отдельно разбирать их сейчас не требуется.

## Замок Source здесь не нужен

Перед созданием Calculated column и Metric важно не повторить ошибочную модель из старых инструкций.

В Dataset Editor Superset 6.1.0 замок находится на вкладке:

```text
Source
```

и защищает смену источника:

```text
Physical / Virtual
Database
Schema
Table
```

Для вкладок:

```text
Calculated columns
Metrics
```

снимать этот замок не требуется.

В этом уроке источник `Training PostgreSQL → training → sales` вообще не меняем.

## Создаём Calculated column

Вернитесь в:

```text
Datasets
```

У Dataset `sales` нажмите значок редактирования.

Перейдите прямо на вкладку:

```text
Calculated columns
```

Не используйте для этого вкладку `Metrics`.

Добавьте новый элемент.

Заполните:

```text
Column name:    profit
SQL expression: revenue - cost
Data type:      NUMERIC
```

Если интерфейс показывает дополнительные флаги и описания, для этого урока их можно оставить без изменения.

Смысл нового столбца:

```sql
revenue - cost
```

Никакой `SUM` здесь нет.

Сохраните Dataset кнопкой:

```text
Save
```

## Что теперь означает profit

Для каждой строки Superset может использовать выражение:

```sql
revenue - cost
```

Контрольные значения нескольких строк:

| `sale_id` | `revenue` | `cost` | `profit` |
|---:|---:|---:|---:|
| 1 | 200.00 | 120.00 | 80.00 |
| 2 | 450.00 | 300.00 | 150.00 |
| 3 | 150.00 | 90.00 | 60.00 |
| 12 | 725.00 | 440.00 | 285.00 |

В исходной таблице PostgreSQL новый физический столбец при этом **не появился**.

`profit` существует в метаданных Dataset как вычисляемый столбец.

## Почему нельзя написать SUM в Calculated column

Неправильный вариант:

```sql
SUM(revenue) - SUM(cost)
```

для `Calculated column`.

Calculated column должен вести себя как выражение столбца на уровне строки.

Правильный уровень для него:

```sql
revenue - cost
```

А выражение:

```sql
SUM(revenue) - SUM(cost)
```

уже агрегирует **много строк** и поэтому относится к Metric.

Запомните границу:

```text
одна строка → Calculated column
набор строк → Metric
```

## Проверяем Calculated column в Explore

После сохранения Dataset вернитесь в:

```text
Datasets
```

и снова откройте `sales` по имени.

В списке столбцов `Explore` должен появиться:

```text
profit
```

Если его нет, обновите страницу после сохранения Dataset и снова откройте `sales`.

Теперь в `Metrics` создайте временную метрику:

```text
Column:      profit
Aggregation: SUM
```

То есть нужен смысл:

```sql
SUM(profit)
```

При:

```text
Dimensions: пусто
Filters:    без активных ограничений
```

выполните конфигурацию кнопкой:

```text
Create chart
```

Контрольный результат:

```text
1530.00
```

Теперь добавьте:

```text
Dimensions = region
```

и снова выполните конфигурацию.

Контрольный результат:

| `region` | `SUM(profit)` |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

Итого:

```text
520.00 + 1010.00 = 1530.00
```

Так мы проверили, что Calculated column можно использовать дальше как обычный вычисляемый столбец Dataset.

## Создаём сохранённую Metric

Теперь создадим второй тип расчёта — агрегированный и повторно используемый.

Вернитесь в:

```text
Datasets
```

У `sales` снова нажмите значок редактирования.

Перейдите прямо на вкладку:

```text
Metrics
```

Замок `Source` для этого не снимаем.

Добавьте новую Metric.

Заполните:

```text
Metric Key:     total_profit
Label:          Прибыль
SQL expression: SUM(revenue) - SUM(cost)
Description:    Суммарная выручка минус суммарная себестоимость
```

Главное обязательное выражение:

```sql
SUM(revenue) - SUM(cost)
```

Технический ключ:

```text
total_profit
```

нужен как устойчивый идентификатор Metric.

Подпись:

```text
Прибыль
```

нужна человеку в интерфейсе.

Сохраните Dataset кнопкой `Save`.

## Проверяем сохранённую Metric

Снова откройте `Explore` для Dataset `sales` через раздел `Datasets`.

В списке доступных Metrics должна появиться сохранённая метрика:

```text
Прибыль
```

или её технический ключ:

```text
total_profit
```

в зависимости от того, где именно интерфейс показывает label и key.

Удалите временную `SUM(profit)` и выберите сохранённую Metric:

```text
Прибыль
```

Установите:

```text
Dimensions: пусто
Filters:    без активных ограничений
```

Если отображается `sale_date`, оставьте:

```text
No filter
```

Выполните текущую конфигурацию:

```text
Create chart
```

Контрольный результат:

```text
1530.00
```

Теперь добавьте:

```text
Dimensions = region
```

и снова выполните конфигурацию.

Результат:

| `region` | `Прибыль` |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

Важно: определение Metric мы не переписывали для каждого региона.

Superset применил одну и ту же сохранённую формулу:

```sql
SUM(revenue) - SUM(cost)
```

к каждой группе, сформированной измерением `region`.

Именно в этом смысл сохранённой Metric: один раз определить показатель на уровне Dataset и затем использовать его в разных аналитических запросах.

## Почему SUM(profit) и Metric Прибыль дали одинаковое число

Мы получили:

```text
SUM(profit) = 1530.00
```

и:

```text
SUM(revenue) - SUM(cost) = 1530.00
```

Но это **не означает**, что Calculated column и Metric — одно и то же.

Первый путь:

```text
каждая строка:
profit = revenue - cost

затем:
SUM(profit)
```

Второй путь:

```text
SUM(revenue) - SUM(cost)
```

На наших данных `revenue` и `cost` всегда заполнены, а вычитание линейно, поэтому результаты совпадают.

Смысл объектов остаётся разным:

```text
profit       → значение строки
total_profit → агрегированный показатель
```

## Ad hoc metric и сохранённая Metric

В уроке 05 мы прямо в `Explore` создавали:

```sql
SUM(revenue)
```

Это `ad hoc metric`.

Она удобна, когда нужно быстро проверить гипотезу или один раз собрать расчёт.

Сохранённая Metric создаётся по маршруту:

```text
Datasets → Edit sales → Metrics
```

и затем появляется как готовый показатель при работе с этим Dataset.

Практическое правило базового курса:

```text
разовый эксперимент в Explore
→ ad hoc metric

понятный показатель, который будем использовать повторно
→ сохранённая Metric Dataset
```

Если показатель имеет бизнес-смысл и должен одинаково считаться в нескольких Chart, не стоит каждый раз вручную собирать его заново.

## Проверяем четыре агрегирования ещё раз

Перед завершением урока убедитесь, что можете получить следующие значения без подсказки.

При:

```text
Dimensions: пусто
Filters:    без активных ограничений
```

контрольные результаты:

| Расчёт | Результат |
|---|---:|
| `SUM(revenue)` | 4005.00 |
| `SUM(quantity)` | 31 |
| `COUNT(sale_id)` | 12 |
| `COUNT(manager)` | 11 |
| `COUNT(DISTINCT manager)` | 4 |
| `AVG(revenue)` | 333.75 |
| `SUM(profit)` | 1530.00 |
| сохранённая Metric `Прибыль` | 1530.00 |

Если эти значения совпадают, расчёты настроены правильно.

## Самостоятельная проверка

### Задание 1

Через временную метрику в `Explore` получите:

```text
AVG(cost)
```

Ожидаемый результат:

```text
206.25
```

### Задание 2

Посчитайте количество разных офисов:

```text
Column:      office
Aggregation: COUNT_DISTINCT
```

Ожидаемый результат:

```text
4
```

### Задание 3

Используйте сохранённую Metric:

```text
Прибыль
```

с:

```text
Dimensions = product
```

Не создавайте новую Metric. Используйте уже сохранённую.

### Задание 4

Своими словами ответьте на два вопроса:

1. почему `revenue - cost` является Calculated column;
2. почему `SUM(revenue) - SUM(cost)` является Metric.

Правильный ответ должен сводиться к уровню вычисления:

```text
строка против набора строк
```

## Если что-то не получилось

### `profit` не появился в Explore

Убедитесь, что Dataset был сохранён после добавления Calculated column.

Затем обновите страницу и повторно откройте:

```text
Datasets → sales
```

### Не получается добавить Calculated column или Metric

Для этих вкладок не требуется снимать замок `Source`.

Правильные маршруты:

```text
Datasets → Edit sales → Calculated columns
```

и:

```text
Datasets → Edit sales → Metrics
```

После изменения нажмите:

```text
Save
```

Не меняйте `Source`, если задача этого не требует.

### Calculated column выдаёт ошибку

Проверьте выражение:

```sql
revenue - cost
```

Не используйте:

```sql
SUM(revenue) - SUM(cost)
```

в Calculated column.

### Сохранённая Metric не появилась

Вернитесь в редактор Dataset и проверьте вкладку:

```text
Metrics
```

Должны быть сохранены:

```text
Metric Key: total_profit
SQL expression: SUM(revenue) - SUM(cost)
```

После сохранения снова откройте `Explore`.

### `COUNT(manager)` показывает 11, а не 12

Это правильный результат.

Одна строка содержит:

```text
manager = NULL
```

`COUNT(manager)` считает только непустые значения.

### Не вижу `Run Query`

Это ожидаемо для Superset 6.1.0.

Новый несохранённый Chart выполняется кнопкой:

```text
Create chart
```

После сохранения Chart эта же область будет использовать подпись:

```text
Update chart
```

### Итоги отличаются от контрольных

Сначала проверьте:

```text
Dimensions = пусто
Filters = нет активных ограничений
```

Если в `Filters` указан `sale_date`, верните его в:

```text
No filter
```

Если сомневаетесь в самих учебных данных, из каталога `training` выполните:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Базовые контрольные суммы должны оставаться:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

## Что должно получиться

К концу урока в Dataset `sales` должны существовать два новых повторно используемых объекта.

### Calculated column

```text
name:       profit
expression: revenue - cost
type:       NUMERIC
```

### Metric

```text
key:        total_profit
label:      Прибыль
expression: SUM(revenue) - SUM(cost)
```

И вы должны уметь получить в `Explore`:

```text
общая прибыль = 1530.00
```

а при:

```text
Dimensions = region
```

получить:

```text
Север = 520.00
Юг    = 1010.00
```

При этом ни нового физического столбца, ни таблицы, ни сохранённого Chart мы не создавали.

## Главное из урока

Если нужно вычислить значение **для каждой строки**, используйте Calculated column:

```sql
revenue - cost
```

Если нужно вычислить **показатель по набору строк**, используйте Metric:

```sql
SUM(revenue) - SUM(cost)
```

Если агрегированный расчёт нужен только для текущего исследования, можно собрать `ad hoc metric` прямо в `Explore`.

Если показатель нужен повторно, сохраните его как Metric Dataset.

Замок `Source` к созданию этих объектов отношения не имеет: он защищает смену источника Dataset.

## Следующий урок

Теперь Dataset содержит исходные столбцы, вычисляемый `profit` и сохранённую Metric `Прибыль`.

В следующем уроке начнём выбирать визуализацию под конкретный вопрос, построим несколько основных Chart, сохраним их и научимся снова открывать для редактирования.

→ [Урок 07. Строим и сохраняем Chart](07-create-charts.md)

## Официальные источники

Материал урока сверяется с документацией и исходным кодом Apache Superset 6.1.0:

- Superset 6.1.0 — общая модель продукта и lightweight semantic layer: <https://superset.apache.org/user-docs/6.1.0/intro/>
- Superset 6.1.0 — Explore и агрегирование данных: <https://superset.apache.org/user-docs/6.1.0/using-superset/exploring-data/>
- Superset 6.1.0 — схема ad hoc metric и поддерживаемые агрегирования: <https://superset.apache.org/developer-docs/6.1.0/api/schemas/chartdataadhocmetricschema/>
- Superset 6.1.0 — Dataset API: <https://superset.apache.org/developer-docs/6.1.0/api/datasets/>
- список агрегирований Explore в Superset 6.1.0 (`COUNT_DISTINCT`): <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/constants.ts>
- отображение этих агрегирований в редакторе ad hoc metric: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/MetricControl/AdhocMetricEditPopover/index.tsx>
- Dataset Editor 6.1.0: вкладки `Source`, `Metrics`, `Columns`, `Calculated columns`, `Settings` и область действия замка Source: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/components/Datasource/components/DatasourceEditor/DatasourceEditor.tsx>
- реальный control panel `Table`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/controlPanel.tsx>
- кнопка выполнения Explore (`Create chart` / `Update chart`): <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/RunQueryButton/index.tsx>
