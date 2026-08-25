# 11. Создаём Virtual Dataset

## Результат урока

После урока должен существовать Virtual Dataset:

```text
sales_virtual
```

Он определяется SQL-запросом к `training.sales`, возвращает 12 продаж и дополнительную колонку `profit`.

Также должен быть сохранён Chart:

```text
Прибыль по регионам — Virtual Dataset
```

## Перед началом

Должны быть пройдены уроки 02–10.

В Superset есть подключение:

```text
Training PostgreSQL
```

В PostgreSQL есть:

```text
training.sales
```

Контроль:

```text
rows    = 12
revenue = 4005.00
cost    = 2475.00
profit  = 1530.00
```

---

## Physical Dataset и Virtual Dataset

В уроке 04 мы создали Physical Dataset прямо на таблице:

```text
training.sales
      ↓
Dataset sales
```

Virtual Dataset определяется SQL:

```text
SQL-запрос
    ↓
Virtual Dataset
```

При этом Superset не создаёт новую физическую таблицу PostgreSQL и не копирует туда строки.

В этом уроке SQL будет таким:

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

Исходная таблица содержит девять физических столбцов. Результат запроса содержит десять — добавляется `profit`.

Одна строка результата по-прежнему соответствует одной продаже.

---

## 1. Выполняем SQL

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

Ожидается 12 строк и десять столбцов:

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

Контроль двух строк:

```text
sale_id = 1
revenue = 200.00
cost    = 120.00
profit  = 80.00

sale_id = 12
revenue = 725.00
cost    = 440.00
profit  = 285.00
```

Если результат не совпадает, сначала исправьте SQL.

---

## 2. Открываем результат в Explore

У результата SQL Lab нажмите кнопку с иконкой графика:

```text
Create chart
```

В Superset 6.1.0 это точные tooltip и `aria-label` этой кнопки.

Откроется Explore на результате выполненного SQL.

На этом этапе постоянного Virtual Dataset ещё нет:

```text
SQL Lab query
      ↓
query datasource
      ↓
Explore
```

`query datasource` — временный источник Explore.

---

## 3. Сохраняем SQL как Dataset

В левой панели Explore для query datasource Superset показывает:

```text
Create a dataset to edit or add columns and metrics.
```

Нажмите:

```text
Create a dataset
```

Откроется:

```text
Save or Overwrite Dataset
```

Выберите:

```text
Save as new
```

В `Dataset name` укажите:

```text
sales_virtual
```

Нажмите:

```text
Save
```

`Overwrite existing` здесь не используем: Physical Dataset `sales` должен остаться отдельным объектом.

После сохранения Superset откроет Explore уже на постоянном Dataset `sales_virtual`.

---

## 4. Проверяем Virtual Dataset

Откройте:

```text
Datasets
```

В списке должны одновременно существовать:

```text
sales
sales_virtual
```

В колонке `Type` у `sales_virtual` точная подпись Superset 6.1.0:

```text
Virtual
```

Нажмите имя:

```text
sales_virtual
```

Имя Dataset в списке открывает его `explore_url`, то есть Explore.

В Columns должны быть, в частности:

```text
region
revenue
cost
profit
```

`profit` здесь является колонкой результата SQL Virtual Dataset.

---

## Что сохранено

Physical Dataset:

```text
sales
→ source = training.sales
```

Virtual Dataset:

```text
sales_virtual
→ source = SQL-запрос
```

SQL:

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

Superset хранит определение Virtual Dataset в своей metadata database, а сам запрос выполняется PostgreSQL.

---

## 5. Строим Chart на Virtual Dataset

Откройте `sales_virtual` в Explore и выберите:

```text
Bar Chart
```

Очистите `Metrics` от автоматически добавленных или перенесённых расчётов. В этом Chart должна остаться только:

```text
SUM(profit)
```

Настройте:

```text
X Axis:     region
Metrics:    SUM(profit)
Dimensions: пусто
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

Если результат отличается, проверьте:

```text
Dataset = sales_virtual
X Axis  = region
Metrics = только SUM(profit)
Filters = нет ограничивающего фильтра
```

---

## 6. Сохраняем Chart

Нажмите:

```text
Save
```

Для нового Chart используйте:

```text
Save as...
```

Имя:

```text
Прибыль по регионам — Virtual Dataset
```

Dashboard не выбирайте.

Нажмите `Save`.

Теперь откройте:

```text
Charts
```

Найдите Chart по имени и нажмите его.

В Explore проверьте:

```text
Chart Source = sales_virtual
```

а не `sales`.

---

## Почему результат совпадает с Physical Dataset

Оба Dataset читают одни и те же продажи из `training.sales`.

Разница — место определения `profit`.

В Physical Dataset:

```text
sales
└── Calculated Column
    └── revenue - cost
```

В Virtual Dataset:

```text
sales_virtual
└── SQL
    └── revenue - cost AS profit
```

Поэтому одинаковая группировка и агрегация дают одинаковый результат:

```text
Север = 520.00
Юг    = 1010.00
```

---

## Calculated Column и Virtual Dataset

Calculated Column подходит, когда набор строк уже правильный, а внутри Dataset нужно добавить простой row-level расчёт.

Пример:

```sql
revenue - cost
```

Virtual Dataset нужен, когда SQL должен определить сам набор данных: выбрать столбцы, переименовать их, добавить выражения, отфильтровать строки или выполнить более сложную подготовку для анализа.

Если задача решается одной Calculated Column, переводить весь Dataset на SQL только ради неё не требуется.

В этом уроке `profit` специально реализован вторым способом, чтобы показать механизм Virtual Dataset.

---

## Virtual Dataset и VIEW PostgreSQL

Virtual Dataset хранится в metadata Superset:

```text
Superset
└── Dataset
    └── SQL
```

VIEW создаётся в PostgreSQL:

```text
PostgreSQL
└── VIEW
```

VIEW доступен другим приложениям, которым разрешён доступ к базе. Virtual Dataset — часть аналитической модели Superset.

Если одна SQL-логика нужна многим системам, централизованно управляется в базе или слишком тяжела для постоянного выполнения как вложенный запрос, её разумнее вынести в VIEW, materialized view или подготовленную таблицу-витрину.

Virtual Dataset сам по себе не ускоряет тяжёлый SQL.

---

## Как выполняется запрос Chart

Упрощённо, если Virtual Dataset определён как:

```sql
SELECT
    region,
    revenue - cost AS profit
FROM training.sales
```

а Chart использует:

```text
X Axis  = region
Metrics = SUM(profit)
```

PostgreSQL получает запрос, концептуально похожий на:

```sql
SELECT
    region,
    SUM(profit)
FROM (
    -- SQL Virtual Dataset
) AS virtual_dataset
GROUP BY region;
```

Это схема для понимания, а не обещание дословного SQL во всех конфигурациях Superset.

SQL Virtual Dataset становится входным набором для запроса Explore. Поэтому на базовом уровне не агрегируем данные внутри Virtual Dataset заранее, если следующая агрегация должна выполняться в Chart.

---

## Virtual Dataset не является снимком данных

Сохранение Virtual Dataset не фиксирует текущие 12 строк навсегда.

При следующем запросе его SQL снова обращается к `training.sales`.

Если исходная таблица изменится, результат Virtual Dataset тоже может измениться. В реальной эксплуатации на момент отображения дополнительно может влиять настроенный кэш Superset; кэширование в этом курсе не настраиваем.

Если изменить SQL самого Virtual Dataset, изменение затронет Chart, которые от него зависят.

Например, удаление `profit` из SQL сломает Chart с:

```text
SUM(profit)
```

---

## Три состояния SQL

```text
1. SQL в SQL Lab
   → текст запроса

2. query datasource
   → временный источник после Create chart

3. Virtual Dataset
   → постоянный объект после
     Create a dataset → Save as new → Save
```

Только третий объект находится в `Datasets` и предназначен для повторного использования.

---

## Самостоятельная проверка

На `sales_virtual` соберите `Table`:

```text
Dimensions = product
Metrics    = SUM(profit)
```

Если Table автоматически содержит `COUNT(*)`, удалите его.

Ожидается:

```text
Маршрутизатор = 630.00
Датчик        = 475.00
Терминал      = 425.00
```

Сумма:

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

## Типовые ошибки

### Create chart у результата SQL Lab недоступна

Сначала убедитесь, что SQL успешно выполнен. В Superset 6.1.0 кнопка также отключается, если Database connection не разрешает subquery. Учебное подключение PostgreSQL этот сценарий поддерживает.

### После Create chart sales_virtual ещё нет в Datasets

Это ожидаемо. `Create chart` создаёт временный query datasource для Explore.

Постоянный объект появляется только после:

```text
Create a dataset
→ Save as new
→ Save
```

### В Explore нет Create a dataset

Проверьте, что Explore открыт именно из результата SQL Lab, а не из уже сохранённого Dataset.

### В Chart есть лишняя серия COUNT(*)

Удалите её из `Metrics`. Для основного Chart урока нужна только:

```text
SUM(profit)
```

### sales_virtual уже существует

Не выбирайте `Overwrite existing` автоматически. Для повторного чистого прохождения удалите ненужный учебный Virtual Dataset и связанные с ним тестовые Chart либо продолжайте работу с уже корректным `sales_virtual`.

---

## Критерий завершения

Должно выполняться:

```text
Physical Dataset = sales
Virtual Dataset  = sales_virtual
```

Запрос `sales_virtual` возвращает:

```text
12 строк
10 столбцов
profit присутствует
```

Chart:

```text
Прибыль по регионам — Virtual Dataset
Chart Source = sales_virtual
Север = 520.00
Юг    = 1010.00
```

Следующий урок — самостоятельная итоговая проверка всего маршрута.

→ [Урок 12. Итоговая проверка и что изучать дальше](12-next-steps.md)

## Источники Superset 6.1.0

- `Create chart` для результата SQL Lab: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ExploreResultsButton/index.tsx>
- `Create a dataset` в Explore: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/DatasourcePanel/index.tsx>
- `Save or Overwrite Dataset`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/SaveDatasetModal/index.tsx>
- список Datasets и переход по `explore_url`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/pages/DatasetList/index.tsx>
- точные подписи `Physical` / `Virtual`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-core/src/components/Label/reusable/DatasetTypeLabel.tsx>
- структура учебной таблицы: [`../training/schema.sql`](../training/schema.sql)
- учебные данные: [`../training/data.sql`](../training/data.sql)
