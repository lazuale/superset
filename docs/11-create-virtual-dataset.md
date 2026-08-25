# 11. Создаём Virtual Dataset

## Результат урока

После урока должен существовать Virtual Dataset:

```text
sales_virtual
```

Он определяется SQL-запросом к `training.sales`, возвращает 12 продаж и дополнительную колонку `profit`.

Также должен быть сохранён график (`Chart`):

```text
Прибыль по регионам — Virtual Dataset
```

Главная цель урока — понять рабочую цепочку:

```text
SQL Lab
→ результат SQL
→ временный источник запроса
→ Virtual Dataset
→ Explore
→ Chart
```

Глубокое сравнение Virtual Dataset с VIEW, MATERIALIZED VIEW и витринами вынесено в отдельный справочник после урока.

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

## Physical и Virtual: минимальное различие

В уроке 04 мы создали Physical Dataset прямо на существующей таблице:

```text
PostgreSQL: training.sales
        ↓
Physical Dataset: sales
```

Virtual Dataset определяется SQL-запросом, который хранится в Superset:

```text
SQL-запрос
    ↓
Virtual Dataset
```

В этом уроке запрос будет построчным:

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

Исходная таблица содержит девять физических столбцов. Результат содержит десять — добавляется `profit`.

Зерно не меняется:

```text
1 строка результата = 1 продажа
```

Новой физической таблицы PostgreSQL этот запрос не создаёт.

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

Ожидается:

```text
12 строк
10 столбцов
```

Столбцы:

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

Если результат не совпадает, сначала исправьте SQL. Не сохраняйте неправильный запрос как Dataset.

---

## 2. Открываем результат в Explore

У результата SQL Lab нажмите кнопку с иконкой графика:

```text
Create chart
```

В Superset 6.1.0 всплывающая подсказка и технический `aria-label` этой кнопки — `Create chart`.

Откроется Explore на результате выполненного SQL.

На этом этапе постоянного Dataset ещё нет:

```text
запрос SQL Lab
      ↓
временный источник запроса
      ↓
Explore
```

В исходном коде такой временный источник называется `query datasource`. Здесь это только временный источник Explore для результата SQL Lab.

Не путайте:

```text
Create chart
```

на этом шаге и:

```text
создание постоянного Virtual Dataset
```

Это ещё не одно и то же.

---

## 3. Сохраняем результат как Virtual Dataset

В левой панели Explore для временного источника Superset показывает сообщение:

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

Имя:

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

Должны одновременно существовать:

```text
sales
sales_virtual
```

Для `sales_virtual` в колонке `Type` ожидается:

```text
Virtual
```

Откройте `sales_virtual`.

Проверьте наличие, в частности:

```text
region
revenue
cost
profit
```

Главное различие теперь можно записать так:

```text
sales
→ источник = физическая таблица training.sales

sales_virtual
→ источник = сохранённый SQL-запрос
```

При этом:

```text
таблица PostgreSQL sales_virtual
→ не создаётся
```

---

## 5. Строим график на Virtual Dataset

Откройте `sales_virtual` в Explore и выберите:

```text
Bar Chart
```

Очистите `Metrics` от лишних автоматически добавленных или перенесённых расчётов.

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

Почему результат совпадает с Physical Dataset:

```text
оба Dataset читают те же 12 продаж
и используют тот же построчный смысл profit = revenue - cost
```

Различается место определения `profit`:

```text
Physical sales
→ Calculated Column Superset

Virtual sales_virtual
→ SELECT ... revenue - cost AS profit
```

---

## 6. Сохраняем график

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

Откройте:

```text
Charts
```

Найдите этот график и снова откройте его в Explore.

Проверьте:

```text
Chart Source = sales_virtual
```

а не:

```text
sales
```

---

## Что обязательно понять про Virtual Dataset

### Он хранит определение SQL, а не отдельную копию строк

Упрощённая модель:

```text
метаданные Superset
└── sales_virtual
    └── определение SQL
```

Когда Explore или Chart обращается к Virtual Dataset, его SQL участвует в запросе к подключённому источнику.

Поэтому Virtual Dataset не является сохранённым снимком этих 12 строк.

### Изменение исходных данных может изменить результат

Если `training.sales` изменится, следующий запрос к `sales_virtual` тоже может вернуть другой результат.

### Изменение SQL Virtual Dataset может повлиять на зависимые графики

Например, если убрать из SQL:

```text
profit
```

график с:

```text
SUM(profit)
```

перестанет иметь нужный столбец.

### Зерно результата нужно контролировать

В этом уроке SQL намеренно остаётся построчным:

```text
1 строка = 1 продажа
```

Не добавляйте `GROUP BY` только потому, что он уже знаком из урока 10. Предварительная агрегация изменила бы зерно Virtual Dataset.

---

## Три состояния, которые не нужно путать

```text
1. SQL в SQL Lab
   → текст и выполненный запрос

2. временный источник после Create chart
   → временный источник Explore

3. sales_virtual после Create a dataset
   → постоянный Virtual Dataset в Datasets
```

Только третий объект является сохранённым Dataset для повторного использования.

---

## Самостоятельная проверка

На `sales_virtual` соберите `Table`:

```text
Dimensions = product
Metrics    = SUM(profit)
```

Если Table содержит лишний `COUNT(*)`, удалите его.

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

После этого ответьте без подсказки:

```text
Где хранится SQL sales_virtual?
→ в метаданных Superset как определение Dataset

Создалась ли таблица sales_virtual в PostgreSQL?
→ нет

Что означает одна строка sales_virtual?
→ одну продажу
```

---

## Типовые ошибки

### Create chart у результата SQL Lab недоступна

Сначала убедитесь, что SQL успешно выполнен.

В Superset 6.1.0 кнопка открытия результата в Explore также отключена, если подключение Database не разрешает подзапросы. В исходном коде эта возможность проверяется через `allows_subquery`. Учебное подключение курса используется для этого сценария.

### После Create chart sales_virtual ещё нет в Datasets

Это ожидаемо.

Сначала появляется временный источник запроса.

Постоянный объект появляется только после:

```text
Create a dataset
→ Save as new
→ Save
```

### В Explore нет Create a dataset

Проверьте, что Explore открыт именно из результата SQL Lab, а не из уже сохранённого Dataset.

### В графике есть лишний COUNT(*)

Для основного графика должен остаться только:

```text
SUM(profit)
```

### Получилось не 12 строк

Проверьте SQL до сохранения.

Для основного упражнения в запросе не должно быть:

```text
GROUP BY
ограничивающего WHERE
```

### sales_virtual уже существует

Не используйте `Overwrite existing` автоматически.

Для чистого повторного прохождения удалите ненужный учебный Virtual Dataset и связанные тестовые графики либо продолжайте только после проверки, что существующий `sales_virtual` соответствует уроку.

---

## Критерий завершения

Должно выполняться:

```text
Physical Dataset = sales
Virtual Dataset  = sales_virtual
```

`sales_virtual`:

```text
12 строк
10 столбцов
1 строка = 1 продажа
profit присутствует
```

График:

```text
Прибыль по регионам — Virtual Dataset
Chart Source = sales_virtual
Север = 520.00
Юг    = 1010.00
```

И вы должны различать:

```text
запрос SQL Lab
временный источник запроса (query datasource)
Virtual Dataset
```

## Справочник к уроку

Если после практики нужно решить:

- когда выбирать Physical или Virtual Dataset;
- когда достаточно Calculated Column;
- когда SQL лучше вынести в VIEW / MATERIALIZED VIEW / витрину;
- почему тяжёлый общий SQL не стоит автоматически держать внутри Superset;

используйте отдельный справочник:

→ [Physical Dataset или Virtual Dataset?](11a-physical-vs-virtual-dataset.md)

Эти архитектурные вопросы не требуются для выполнения механики текущего урока.

Следующий урок — самостоятельная итоговая проверка всего маршрута.

→ [Урок 12. Итоговая проверка](12-next-steps.md)

## Источники Superset 6.1.0

- кнопка результата SQL Lab `Create chart` и проверка `allows_subquery`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ExploreResultsButton/index.tsx>
- SQL Lab: <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/SqlLab>
- модель Dataset SQLAlchemy: <https://github.com/apache/superset/blob/6.1.0/superset/connectors/sqla/models.py>
- Explore: <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/explore>
