# 11. Создаём Virtual Dataset

## Что научимся делать

После этого урока вы должны уметь:

- объяснить разницу между Physical Dataset и Virtual Dataset;
- выполнить SQL в `SQL Lab` и открыть результат в `Explore`;
- отличать временный query datasource от сохранённого Dataset;
- сохранить SQL как Virtual Dataset;
- найти Virtual Dataset в `Datasets` и снова открыть его;
- построить Chart на Virtual Dataset;
- понимать границу между Virtual Dataset, Calculated Column и VIEW в PostgreSQL.

В этом уроке SQL остаётся простым. Новая тема здесь — не синтаксис SQL, а способ превратить результат запроса в постоянный Dataset Superset.

## Что должно быть готово

Пройдены уроки:

- [04. Создаём первый Dataset](04-create-dataset.md);
- [05. Осваиваем Explore](05-explore-basics.md);
- [06. Метрики и расчёты](06-metrics-and-calculations.md);
- [07. Строим и сохраняем Chart](07-create-charts.md);
- [10. SQL Lab с нуля](10-sql-lab.md).

В Superset уже есть подключение:

```text
Training PostgreSQL
```

В PostgreSQL есть таблица:

```text
training.sales
```

Контрольные итоги:

```text
rows    = 12
revenue = 4005.00
cost    = 2475.00
profit  = 1530.00
```

---

# Physical Dataset и Virtual Dataset

В уроке 04 мы создали Dataset прямо на таблице PostgreSQL:

```text
training.sales
      ↓
Physical Dataset sales
```

Источник такого Dataset — таблица или представление базы данных.

Virtual Dataset устроен иначе:

```text
SQL-запрос
    ↓
Virtual Dataset
```

SQL становится определением источника данных внутри Superset.

При этом Superset не создаёт новую физическую таблицу в PostgreSQL и не копирует туда строки.

Для этого урока используем запрос:

```sql
SELECT
    sale_id,
    sale_date,
    region,
    office,
    manager,
    product,
    quantity,
    revenue,
    cost,
    revenue - cost AS profit
FROM training.sales;
```

Исходная таблица содержит девять физических столбцов. Результат этого SQL содержит десять: к исходным полям добавляется `profit`.

```text
sale_id
sale_date
region
office
manager
product
quantity
revenue
cost
profit
```

Одна строка результата по-прежнему соответствует одной продаже. Агрегацию по регионам внутри Virtual Dataset сейчас не делаем — её позже выполнит Explore.

---

# Шаг 1. Выполняем SQL

Откройте:

```text
SQL → SQL Lab
```

Выберите:

```text
Database: Training PostgreSQL
Schema:   training
```

Введите:

```sql
SELECT
    sale_id,
    sale_date,
    region,
    office,
    manager,
    product,
    quantity,
    revenue,
    cost,
    revenue - cost AS profit
FROM training.sales;
```

Нажмите:

```text
Run
```

Результат должен содержать 12 строк и десять столбцов.

Для первой строки:

```text
revenue = 200.00
cost    = 120.00
profit  = 80.00
```

Для `sale_id = 12`:

```text
revenue = 725.00
cost    = 440.00
profit  = 285.00
```

Если нет 12 строк или отсутствует `profit`, сначала исправьте SQL.

---

# Шаг 2. Открываем результат в Explore

У результата SQL Lab есть кнопка с иконкой графика. Её tooltip и `aria-label` в Superset 6.1.0:

```text
Create chart
```

Нажмите её.

Superset откроет `Explore` на результате выполненного SQL.

На этом этапе постоянный Virtual Dataset ещё не создан.

Схема пока такая:

```text
SQL Lab query
      ↓
query datasource
      ↓
Explore
```

Это временный источник, построенный из результата запроса.

---

# Шаг 3. Сохраняем query datasource как Dataset

В левой панели Explore для query datasource Superset 6.1.0 показывает информационный блок:

```text
Create a dataset to edit or add columns and metrics.
```

Нажмите ссылку:

```text
Create a dataset
```

Откроется окно:

```text
Save or Overwrite Dataset
```

В нём есть два режима:

```text
Save as new
Overwrite existing
```

Выберите:

```text
Save as new
```

В поле `Dataset name` укажите:

```text
sales_virtual
```

Нажмите:

```text
Save
```

Для текущей задачи `Overwrite existing` не используем: физический Dataset `sales` должен остаться отдельным объектом.

После сохранения Superset открывает Explore уже на созданном Dataset.

Теперь цепочка выглядит так:

```text
training.sales
      ↓
SQL
      ↓
sales_virtual
      ↓
Explore
```

---

# Шаг 4. Проверяем сохранённый Virtual Dataset

Откройте верхний раздел:

```text
Datasets
```

В списке должны одновременно существовать:

```text
sales
sales_virtual
```

В колонке `Type` для `sales_virtual` Superset показывает тип Virtual Dataset.

Нажмите имя:

```text
sales_virtual
```

Имя Dataset в списке ведёт по его `explore_url`, поэтому откроется Explore.

В списке Columns должны присутствовать:

```text
region
revenue
cost
profit
```

`profit` здесь уже является колонкой результата SQL Virtual Dataset.

---

# Что именно сохранено

Physical Dataset:

```text
sales
→ источник: training.sales
```

Virtual Dataset:

```text
sales_virtual
→ источник: сохранённый SQL
```

SQL Virtual Dataset:

```sql
SELECT
    sale_id,
    sale_date,
    region,
    office,
    manager,
    product,
    quantity,
    revenue,
    cost,
    revenue - cost AS profit
FROM training.sales;
```

В PostgreSQL таблица `sales_virtual` не появляется.

Superset хранит определение Dataset в своей metadata database, а аналитические запросы продолжают выполняться PostgreSQL по исходным данным.

---

# Шаг 5. Строим Chart на Virtual Dataset

Откройте `sales_virtual` в Explore и выберите:

```text
Bar Chart
```

Настройте:

```text
X Axis:  region
Metrics: SUM(profit)
```

Не оставляйте активных фильтров, ограничивающих данные.

Нажмите:

```text
Create chart
```

Ожидается:

| region | profit |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

Проверка:

```text
520.00 + 1010.00 = 1530.00
```

Если числа отличаются, проверьте три вещи:

```text
Dataset = sales_virtual
X Axis  = region
Metrics = SUM(profit)
```

и убедитесь, что нет активного фильтра.

---

# Шаг 6. Сохраняем Chart

Нажмите:

```text
Save
```

В окне сохранения задайте имя:

```text
Прибыль по регионам — Virtual Dataset
```

Сохраните Chart без создания нового Dashboard.

Откройте:

```text
Charts
```

Найдите Chart по имени и нажмите его. Имя сохранённого Chart открывает его в Explore.

В `Chart Source` должен быть:

```text
sales_virtual
```

а не:

```text
sales
```

---

# Почему цифры совпадают с Physical Dataset

Оба Dataset читают одни и те же продажи из `training.sales`.

Разница только в том, где появился `profit`.

В Physical Dataset из урока 06:

```text
Dataset sales
└── Calculated Column profit
    └── revenue - cost
```

В Virtual Dataset:

```text
Dataset sales_virtual
└── SQL
    └── revenue - cost AS profit
```

Поэтому при одинаковой группировке и агрегации результат обязан совпасть:

```text
Север = 520.00
Юг    = 1010.00
```

---

# Calculated Column и Virtual Dataset

Calculated Column удобен, когда Dataset уже имеет нужный набор строк, а требуется добавить простой row-level расчёт.

Пример:

```text
revenue - cost
```

Virtual Dataset нужен, когда сам аналитический набор данных должен определяться SQL. В SQL можно:

- выбрать только нужные столбцы;
- переименовать их;
- добавить выражения;
- отфильтровать строки;
- на следующем уровне обучения — объединять таблицы и выполнять более сложные преобразования.

Если задача решается одной Calculated Column, переводить ради неё весь Dataset на SQL не требуется.

В этом уроке `profit` намеренно реализован вторым способом только для демонстрации механизма Virtual Dataset.

---

# Virtual Dataset и VIEW в PostgreSQL

Это тоже разные уровни.

Virtual Dataset хранится в metadata Superset:

```text
Superset
└── Dataset
    └── SQL
```

VIEW создаётся в самой PostgreSQL:

```text
PostgreSQL
└── VIEW
```

VIEW может использоваться любыми приложениями, которым доступна база. Virtual Dataset — объект аналитической модели Superset.

Если одна и та же SQL-логика нужна многим системам, должна централизованно управляться в базе или слишком тяжела для постоянного выполнения как вложенный запрос, её разумнее вынести из Superset в подготовленную модель данных, VIEW, materialized view или таблицу-витрину.

Virtual Dataset сам по себе не ускоряет тяжёлый SQL.

---

# Что выполняет PostgreSQL при работе Chart

Упрощённо, если Virtual Dataset определён как:

```sql
SELECT
    region,
    revenue - cost AS profit
FROM training.sales
```

а Chart просит:

```text
X Axis  = region
Metrics = SUM(profit)
```

итоговый запрос концептуально похож на:

```sql
SELECT
    region,
    SUM(profit)
FROM (
    -- SQL Virtual Dataset
) AS virtual_dataset
GROUP BY region;
```

Это схема для понимания, а не дословный SQL, который Superset обязан генерировать во всех случаях.

Главное: SQL Virtual Dataset становится входным набором для следующего запроса Explore.

Поэтому лишняя агрегация внутри Virtual Dataset может затем наложиться на агрегацию Chart. Для первого уровня курса сохраняем построчный набор данных и агрегируем его уже в Explore.

---

# Изменение исходных данных и SQL

Virtual Dataset — не снимок строк на момент сохранения.

Если в `training.sales` появляются новые строки, его SQL при следующем запросе снова обращается к исходной таблице. На видимость свежих результатов при реальной эксплуатации дополнительно может влиять кэш Superset, но кэширование в этом базовом курсе не настраиваем.

Если изменить сам SQL Virtual Dataset, изменится источник всех Chart, которые его используют.

Например, если удалить из SQL:

```text
profit
```

Chart с:

```text
SUM(profit)
```

больше не сможет работать с этим столбцом.

После появления зависимых Chart Virtual Dataset нужно считать частью аналитической модели, а не черновиком из SQL Lab.

---

# Три состояния SQL, которые нельзя путать

```text
1. SQL в SQL Lab
   → текст запроса в редакторе

2. query datasource
   → временный источник после Create chart

3. Virtual Dataset
   → сохранённый Dataset после Create a dataset → Save as new → Save
```

Только третий объект находится в общем разделе `Datasets` и предназначен для повторного использования.

---

# Самостоятельная проверка

Откройте одновременно два Dataset:

```text
sales
sales_virtual
```

Объясните, откуда каждый получает строки и где в каждом случае определяется `profit`.

Затем на `sales_virtual` соберите `Table`:

```text
Dimensions = product
Metrics    = SUM(profit)
```

Сумма всех групп должна дать:

```text
1530.00
```

После этого ответьте на вопрос:

> появилась ли в PostgreSQL физическая таблица `sales_virtual`?

Ответ:

```text
нет
```

---

# Если что-то не работает

Если у результата SQL Lab кнопка `Create chart` недоступна, сначала убедитесь, что запрос успешно выполнен. В Superset 6.1.0 эта кнопка также отключается для Database connection, который не разрешает subquery; учебный PostgreSQL поддерживает этот сценарий.

Если `Create chart` открыл Explore, но `sales_virtual` ещё отсутствует в `Datasets`, это ожидаемо: сначала нужно выполнить `Create a dataset → Save as new → Save`.

Если в Explore нет ссылки `Create a dataset`, убедитесь, что Explore открыт именно из результата SQL Lab, а не из уже сохранённого Physical Dataset `sales`.

Если `sales_virtual` уже существует после предыдущей попытки, не используйте `Overwrite existing` вслепую. Либо продолжайте с существующим корректным Dataset, либо удалите учебный объект вместе с ненужными зависимостями и повторите создание.

---

# Урок завершён, если вы можете без инструкции

- выполнить SQL к `training.sales`;
- открыть результат через `Create chart`;
- объяснить, почему это ещё не постоянный Dataset;
- сохранить его через `Create a dataset → Save as new`;
- найти `sales_virtual` в `Datasets`;
- построить `Bar Chart` с `region` и `SUM(profit)`;
- получить `520.00` и `1010.00`;
- сохранить Chart и снова открыть его из `Charts`;
- объяснить разницу между Physical Dataset, Calculated Column, Virtual Dataset и VIEW.

## Что дальше

Базовая цепочка теперь собрана:

```text
PostgreSQL
→ Dataset
→ Explore
→ Metric / Calculated Column
→ Chart
→ Dashboard
→ Native Filters
→ SQL Lab
→ Virtual Dataset
```

В последнем уроке новых инструментов не будет. Там нужно самостоятельно повторить весь маршрут и определить, что изучать дальше.

→ [Урок 12. Итоговая проверка и что изучать дальше](12-next-steps.md)

## Официальные источники

- Apache Superset 6.1.0 — Introduction: <https://superset.apache.org/user-docs/6.1.0/intro/>
- Apache Superset 6.1.0 — FAQ: <https://superset.apache.org/user-docs/6.1.0/faq/>
- Apache Superset 6.1.0 — SQL templating: <https://superset.apache.org/admin-docs/6.1.0/configuration/sql-templating/>
- Apache Superset 6.1.0 — Dataset API: <https://superset.apache.org/developer-docs/6.1.0/api/datasets/>
- `Create chart` для результата SQL Lab: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ExploreResultsButton/index.tsx>
- `Create a dataset` в Explore: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/DatasourcePanel/index.tsx>
- `Save or Overwrite Dataset`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/SaveDatasetModal/index.tsx>
- список Datasets и переход по `explore_url`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/pages/DatasetList/index.tsx>
- Учебная структура таблицы: [`../training/schema.sql`](../training/schema.sql)
- Учебные данные: [`../training/data.sql`](../training/data.sql)
