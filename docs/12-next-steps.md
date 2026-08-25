# 12. Итоговая проверка и что изучать дальше

## Задача урока

Новых функций здесь нет.

Нужно самостоятельно повторить полный базовый маршрут:

```text
PostgreSQL
    ↓
Database connection
    ↓
Physical Dataset
    ↓
Explore
    ↓
Calculated Column + Metric
    ↓
Chart
    ↓
Dashboard
    ↓
Native Filters
    ↓
SQL Lab
    ↓
Virtual Dataset
    ↓
Chart на Virtual Dataset
```

Если весь путь получается без пошаговой инструкции, базовый курс пройден.

Если застряли на конкретном этапе, возвращайтесь только к соответствующему уроку.

---

# Чистый старт

Итоговую проверку удобнее проходить после полного сброса учебного стенда.

Команда ниже удаляет Docker volumes именно текущего compose-проекта, включая metadata Superset и учебную PostgreSQL.

Используйте её только в каталоге учебного стенда этого курса.

```bash
cd training
docker compose down -v --remove-orphans
docker compose up -d
```

Проверьте контейнеры:

```bash
docker compose ps -a
```

После завершения инициализации ожидается:

```text
db             running / healthy
superset       running / healthy
superset-init  exited (0)
```

Проверьте исходные данные:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Основные контрольные значения:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

После полного сброса в Superset нет объектов, созданных в уроках 03–11. Их нужно восстановить самостоятельно.

---

# Исходные реквизиты

Учебная учётная запись Superset:

```text
login:    admin
password: admin
```

PostgreSQL внутри compose-сети:

```text
host:     db
port:     5432
database: training
user:     superset_reader
password: superset_reader
```

Пользователь `training` используется только для инициализации базы и контрольных команд из терминала.

Исходный объект PostgreSQL:

```text
schema: training
table:  sales
```

Полное имя:

```text
training.sales
```

Физические столбцы:

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
```

Физического столбца `profit` в PostgreSQL нет.

---

# 1. Подключите PostgreSQL

Создайте Database connection:

```text
Training PostgreSQL
```

Используйте `superset_reader`, а не владельца базы `training`.

После сохранения Superset должен видеть:

```text
Schema: training
Table:  sales
```

Если не получилось — [урок 03](03-connect-postgresql.md).

---

# 2. Создайте Physical Dataset

Создайте Dataset на таблице:

```text
training.sales
```

Имя:

```text
sales
```

Проверьте, что доступны все девять столбцов и `sale_date` распознан как temporal column.

После этого закройте Explore, откройте `Datasets` и снова найдите `sales` через общий список.

Если не получилось — [урок 04](04-create-dataset.md).

---

# 3. Получите результат в Explore

На Dataset `sales` ответьте на вопрос:

> какова выручка каждого региона по всем данным?

Ожидается:

| region | revenue |
|---|---:|
| Север | 1360.00 |
| Юг | 2645.00 |

Общая сумма:

```text
4005.00
```

Затем ограничьте данные февралем 2026 года.

Интервал:

```text
2026-02-01 <= sale_date < 2026-03-01
```

Ожидается:

| region | revenue |
|---|---:|
| Север | 450.00 |
| Юг | 730.00 |

Итого:

```text
1180.00
```

Вы должны сами определить Dimension, Metric и Time Range.

Если не получилось — [урок 05](05-explore-basics.md).

---

# 4. Создайте Calculated Column и сохранённую Metric

В Dataset `sales` создайте Calculated Column:

```text
profit
```

Логика одной строки:

```sql
revenue - cost
```

Контроль:

```text
sale_id = 1
200.00 - 120.00 = 80.00

sale_id = 12
725.00 - 440.00 = 285.00
```

Сумма `profit` по всем строкам:

```text
1530.00
```

По регионам:

```text
Север = 520.00
Юг    = 1010.00
```

В том же Dataset создайте сохранённую Metric:

```text
Metric Key: total_profit
Label:      Прибыль
```

Выражение:

```sql
SUM(revenue) - SUM(cost)
```

Она должна возвращать те же агрегированные значения:

```text
все данные = 1530.00
Север      = 520.00
Юг         = 1010.00
```

К этому моменту разница должна быть понятна без подсказки:

```text
Calculated Column
→ расчёт строки

Metric
→ расчёт набора строк после фильтрации и группировки
```

Если граница неясна — [урок 06](06-metrics-and-calculations.md).

---

# 5. Создайте минимум два Chart

На Dataset `sales` нужны два сохранённых Chart.

Первый должен показывать выручку и прибыль по регионам.

Контроль:

```text
Север
revenue = 1360.00
profit  = 520.00

Юг
revenue = 2645.00
profit  = 1010.00
```

Второй должен показывать выручку по месяцам.

Контроль:

```text
2026-01 = 1160.00
2026-02 = 1180.00
2026-03 = 1665.00
```

Сохраните оба Chart, найдите их в `Charts`, откройте снова и измените один из них. Сохраните изменение через режим перезаписи существующего Chart, а не как случайную копию.

Если не получилось — [урок 07](07-create-charts.md).

---

# 6. Соберите Dashboard

Создайте Dashboard и добавьте на него оба Chart.

Разместите их без наложения и сохраните Dashboard.

Переключите статус в:

```text
Published
```

После этого:

1. вернитесь в `Dashboards`;
2. откройте Dashboard снова;
3. нажмите `Edit dashboard`;
4. измените размер или положение одного Chart;
5. сохраните изменения.

Помните:

```text
Save
→ сохраняет содержимое и раскладку Dashboard

Published
→ управляет статусом публикации внутри Superset
```

`Published` не делает Dashboard анонимно доступным в Интернет.

Если не получилось — [урок 08](08-build-dashboard.md).

---

# 7. Добавьте Native Filters

На Dashboard создайте два фильтра:

```text
Период
Регион
```

Оба должны действовать на нужные Chart через `Scope`.

Проверка без фильтров:

```text
revenue = 4005.00
profit  = 1530.00
```

Проверка:

```text
Регион = Север
```

ожидается:

```text
revenue = 1360.00
profit  = 520.00
```

Проверка двух фильтров одновременно:

```text
Период = февраль 2026
Регион = Север
```

ожидается:

```text
revenue = 450.00
profit  = 175.00
```

Очистите фильтры и убедитесь, что исходные значения вернулись.

Если фильтр не действует на нужный Chart, первым делом проверьте `Scope`.

Если не получилось — [урок 09](09-native-filters.md).

---

# 8. Повторите расчёт в SQL Lab

В `SQL → SQL Lab` самостоятельно напишите запрос, который возвращает выручку и прибыль каждого региона за февраль 2026 года.

Используйте знакомые конструкции:

```text
SELECT
FROM
WHERE
GROUP BY
ORDER BY
SUM
```

Ожидаемый результат:

| region | revenue | profit |
|---|---:|---:|
| Север | 450.00 | 175.00 |
| Юг | 730.00 | 285.00 |

Итого:

```text
revenue = 1180.00
profit  = 460.00
```

Отдельно проверьте работу `NULL`:

```text
COUNT(*)                = 12
COUNT(manager)           = 11
COUNT(DISTINCT manager)  = 4
```

Если не получилось — [урок 10](10-sql-lab.md).

---

# 9. Создайте Virtual Dataset

В SQL Lab подготовьте построчный запрос к `training.sales`, который возвращает исходные поля и дополнительный столбец:

```text
profit
```

Логика:

```sql
revenue - cost AS profit
```

Не делайте `GROUP BY` внутри этого запроса.

Из результата через:

```text
Create chart
→ Create a dataset
→ Save as new
```

создайте:

```text
sales_virtual
```

После сохранения одновременно должны существовать:

```text
sales
sales_virtual
```

В `sales_virtual` должно быть 12 строк исходных продаж и колонка `profit`.

Физическая таблица PostgreSQL с именем `sales_virtual` для этого не создаётся.

Если не получилось — [урок 11](11-create-virtual-dataset.md).

---

# 10. Создайте Chart на Virtual Dataset

На `sales_virtual` постройте прибыль по регионам:

```text
X Axis  = region
Metrics = SUM(profit)
```

Ожидается:

```text
Север = 520.00
Юг    = 1010.00
```

Сохраните Chart, найдите его через `Charts` и снова откройте.

В `Chart Source` должен быть:

```text
sales_virtual
```

---

# Что должно остаться в Superset

После успешной итоговой проверки минимальный набор объектов выглядит так:

```text
Database connection
└── Training PostgreSQL

Physical Dataset
└── sales
    ├── Calculated Column: profit
    └── Metric: total_profit / Прибыль

Charts
├── минимум 2 Chart на sales
└── минимум 1 Chart на sales_virtual

Dashboard
└── минимум 2 Chart
    ├── Native Filter: Период
    └── Native Filter: Регион

Virtual Dataset
└── sales_virtual
```

Это учебный контрольный набор, а не шаблон production-архитектуры.

---

# Контрольные числа курса

## Все данные

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

## Регионы

| region | rows | quantity | revenue | cost | profit |
|---|---:|---:|---:|---:|---:|
| Север | 6 | 10 | 1360.00 | 840.00 | 520.00 |
| Юг | 6 | 21 | 2645.00 | 1635.00 | 1010.00 |

## Месяцы

| month | revenue |
|---|---:|
| 2026-01 | 1160.00 |
| 2026-02 | 1180.00 |
| 2026-03 | 1665.00 |

## Февраль по регионам

| region | revenue | profit |
|---|---:|---:|
| Север | 450.00 | 175.00 |
| Юг | 730.00 | 285.00 |

## NULL в manager

```text
COUNT(*)                = 12
COUNT(manager)           = 11
COUNT(DISTINCT manager)  = 4
```

Если интерфейс настроен «похоже», но числа не совпадают, результат неправильный. Сначала ищите причину расхождения в фильтре, периоде, группировке или агрегации.

---

# К какому уроку возвращаться при ошибке

| Проблема | Урок |
|---|---|
| стенд не запускается или контрольные данные не совпадают | [02](02-start-training-superset.md) |
| Superset не подключается к PostgreSQL | [03](03-connect-postgresql.md) |
| Dataset создан неправильно | [04](04-create-dataset.md) |
| неверная группировка, фильтр или период в Explore | [05](05-explore-basics.md) |
| путаются Calculated Column и Metric | [06](06-metrics-and-calculations.md) |
| проблема с созданием или сохранением Chart | [07](07-create-charts.md) |
| проблема со сборкой Dashboard | [08](08-build-dashboard.md) |
| Native Filter не действует на нужные Chart | [09](09-native-filters.md) |
| не получается написать или проверить SQL | [10](10-sql-lab.md) |
| SQL не получается сохранить как Virtual Dataset | [11](11-create-virtual-dataset.md) |

После исправления слабого места итоговую проверку лучше повторить с чистого стенда.

---

# Базовый курс завершён, если вы умеете

- запустить и проверить учебный стенд;
- подключить PostgreSQL отдельным read-only пользователем;
- создать и повторно открыть Physical Dataset;
- работать с Dimension, Metric, Filter и Time Range в Explore;
- различать Calculated Column и Metric;
- создать, сохранить и изменить существующий Chart;
- собрать, опубликовать и снова отредактировать Dashboard;
- создать Native Filters и настроить их Scope;
- получить те же результаты через SQL Lab;
- создать Virtual Dataset из SQL;
- построить Chart на Virtual Dataset;
- объяснить, где на каждом этапе реально выполняются вычисления.

---

# Что изучать дальше

Следующий материал выбирайте по задаче, а не по количеству ещё не просмотренных меню Superset.

## Аналитика и SQL

Если основная работа — исследование данных и построение аналитики, следующий блок:

- зерно таблицы;
- факты и измерения;
- корректные агрегирования;
- `JOIN`;
- CTE;
- подзапросы;
- оконные функции;
- более сложные Virtual Dataset;
- проверка SQL до визуализации.

Superset не исправляет плохую модель данных. Ошибка в зерне или агрегации останется ошибкой и на красивом Dashboard.

## Роли и доступ к данным

Когда одним Superset пользуются разные группы, изучайте:

- пользователей;
- роли;
- доступ к Database и Dataset;
- доступ к Dashboard;
- `Gamma`;
- дополнительные роли доступа;
- Row Level Security;
- проверку результата под разными пользователями.

Не начинайте с хаотичной ручной выдачи отдельных permissions. Сначала разберите модель безопасности Superset целиком.

## Production-развёртывание

Учебный compose-файл этого курса не является production-конфигурацией.

Для реального сервера отдельно нужны:

- production metadata database;
- резервное копирование metadata;
- собственный `SUPERSET_SECRET_KEY`;
- HTTPS и reverse proxy;
- production-аутентификация;
- ограниченные пользователи источников данных;
- логирование;
- staging;
- процедура обновлений и отката.

Учебные значения:

```text
admin / admin
training / training
training-only SUPERSET_SECRET_KEY
```

в production не используются.

## Производительность и фоновые задачи

При реальной нагрузке изучайте:

- caching;
- Redis или другой cache backend;
- async queries;
- Celery worker;
- scheduler/beat;
- Alerts & Reports;
- нагрузку на аналитическую БД;
- materialized views и подготовленные витрины.

Redis и Celery не являются обязательными компонентами самого первого учебного запуска. Их добавляют под конкретную функцию и нагрузку.

## REST API

API нужен, когда создание и обслуживание объектов требуется автоматизировать или интегрировать с другими системами.

Сначала полезно уверенно понимать Dataset, Chart, Dashboard и права через обычный интерфейс. Иначе API автоматизирует непонятную модель.

## Embedding

Если Dashboard должен работать внутри другого приложения, отдельно изучаются:

- embedded configuration;
- allowed domains;
- guest token;
- аутентификация;
- права;
- безопасность внешнего приложения.

Embedding и статус `Published` — разные вещи.

---

# Рекомендуемый следующий порядок

Если конкретной задачи пока нет:

```text
1. модель аналитических данных
2. SQL
3. роли и доступ
4. Row Level Security
5. production security и architecture
6. backups и upgrades
7. caching / async / workers
8. Alerts & Reports
9. REST API
10. embedding
```

Базовые уроки 01–11 не нужно расширять всеми этими темами. Их задача — дать рабочий маршрут новичку от готового PostgreSQL до Dashboard и Virtual Dataset.

---

# Итоговая модель

```text
                    PostgreSQL
                        │
             ┌──────────┴──────────┐
             │                     │
      Physical Dataset          SQL Lab
             │                     │
             │                     ↓
             │               SQL-запрос
             │                     │
             │                     ↓
             │              Virtual Dataset
             │                     │
             └──────────┬──────────┘
                        ↓
                     Explore
                        ↓
                      Chart
                        ↓
                    Dashboard
                        ↓
                  Native Filters
```

На этом базовый маршрут закончен.

## Официальные источники для следующего уровня

- Apache Superset 6.1.0 — Introduction: <https://superset.apache.org/user-docs/6.1.0/intro/>
- Apache Superset 6.1.0 — Security Configurations: <https://superset.apache.org/admin-docs/6.1.0/security/>
- Apache Superset 6.1.0 — Securing Superset for Production: <https://superset.apache.org/admin-docs/6.1.0/security/securing_superset/>
- Apache Superset 6.1.0 — Architecture: <https://superset.apache.org/admin-docs/6.1.0/installation/architecture/>
- Apache Superset 6.1.0 — Caching: <https://superset.apache.org/admin-docs/6.1.0/configuration/cache/>
- Apache Superset 6.1.0 — Alerts and Reports: <https://github.com/apache/superset/blob/6.1.0/docs/admin_docs/configuration/alerts-reports.mdx>
- Apache Superset 6.1.0 — REST API Reference: <https://superset.apache.org/developer-docs/6.1.0/api/>
- Apache Superset 6.1.0 — Embedding Superset: <https://superset.apache.org/user-docs/6.1.0/using-superset/embedding/>
- Apache Superset 6.1.0 — Upgrading Superset: <https://superset.apache.org/admin-docs/6.1.0/installation/upgrading-superset/>

← [Урок 11. Создаём Virtual Dataset](11-create-virtual-dataset.md)

↑ [Вернуться к содержанию курса](../README.md)
