# 12. Итоговая проверка и что изучать дальше

## Задача урока

Новых функций здесь нет.

Нужно самостоятельно повторить базовый маршрут:

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

Если весь путь получается без пошаговой инструкции и контрольные числа совпадают, базовый курс пройден.

---

# Чистый старт

Итоговую проверку удобнее выполнять на чистом учебном стенде.

Команда ниже удаляет volumes текущего Compose-проекта, включая metadata Superset и учебную PostgreSQL. Выполняйте её только в каталоге `training` этого курса.

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

Основные значения:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

После полного сброса объекты Superset из уроков 03–11 нужно создать заново.

---

# Исходные реквизиты

Superset:

```text
login:    admin
password: admin
```

PostgreSQL внутри Compose-сети:

```text
host:     db
port:     5432
database: training
user:     superset_reader
password: superset_reader
```

Исходная таблица:

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

Создайте Dataset на:

```text
training.sales
```

Имя:

```text
sales
```

Проверьте:

```text
Database = Training PostgreSQL
Schema   = training
Table    = sales
Columns  = 9
```

`sale_date` должен быть temporal column.

Вернитесь в `Datasets`, убедитесь, что `sales` находится в общем списке, и откройте его по имени в Explore.

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

Затем ограничьте данные февралем 2026 года:

```text
Start (inclusive): 2026-02-01
End (exclusive):   2026-03-01
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

Dimension, Metric и Time Range выберите самостоятельно.

Если не получилось — [урок 05](05-explore-basics.md).

---

# 4. Создайте Calculated Column и Metric

В Dataset `sales` создайте Calculated Column:

```text
Column:         profit
SQL expression: revenue - cost
Data type:      NUMERIC
```

Контроль одной строки:

```text
sale_id = 1
200.00 - 120.00 = 80.00

sale_id = 12
725.00 - 440.00 = 285.00
```

`SUM(profit)` должен дать:

```text
все данные = 1530.00
Север      = 520.00
Юг         = 1010.00
```

Теперь создайте сохранённую Metric:

```text
Metric Key:     total_profit
Label:          Прибыль
SQL expression: SUM(revenue) - SUM(cost)
```

Она должна дать те же агрегированные значения.

Разница должна быть понятна без подсказки:

```text
Calculated Column
→ расчёт строки

Metric
→ расчёт набора строк после фильтрации и группировки
```

Если нет — [урок 06](06-metrics-and-calculations.md).

---

# 5. Создайте минимум два Chart

На `sales` сохраните минимум два Chart.

Первый — выручка и прибыль по регионам:

```text
Север: revenue = 1360.00, profit = 520.00
Юг:    revenue = 2645.00, profit = 1010.00
```

Второй — выручка по месяцам:

```text
2026-01 = 1160.00
2026-02 = 1180.00
2026-03 = 1665.00
```

Найдите оба объекта в `Charts`, откройте один из них снова, измените визуальную настройку и сохраните существующий Chart через:

```text
Save (Overwrite)
```

а не через `Save as...`.

Если не получилось — [урок 07](07-create-charts.md).

---

# 6. Соберите Dashboard

Создайте Dashboard и добавьте на него сохранённые Chart.

Разместите блоки без наложения и нажмите:

```text
Save
```

Переключите статус:

```text
Draft → Published
```

Затем:

1. вернитесь в `Dashboards`;
2. откройте Dashboard снова;
3. нажмите `Edit dashboard`;
4. измените размер или положение одного Chart;
5. нажмите `Save`.

Не путайте:

```text
Save
→ сохраняет содержимое и layout Dashboard

Published
→ статус публикации внутри Superset
```

`Published` не делает Dashboard анонимно доступным в Интернет.

Если не получилось — [урок 08](08-build-dashboard.md).

---

# 7. Добавьте Native Filters

Создайте на Dashboard два фильтра:

```text
Период
Регион
```

Через вкладку:

```text
Scoping
```

включите нужные Chart.

Без активных фильтров:

```text
revenue = 4005.00
profit  = 1530.00
```

Для:

```text
Регион = Север
```

ожидается:

```text
revenue = 1360.00
profit  = 520.00
```

Для:

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

Если фильтр не влияет на нужный Chart, сначала проверьте `Scoping`.

Если не получилось — [урок 09](09-native-filters.md).

---

# 8. Повторите расчёт в SQL Lab

В `SQL → SQL Lab` самостоятельно получите выручку и прибыль каждого региона за февраль 2026 года.

Используйте знакомые конструкции:

```text
SELECT
FROM
WHERE
GROUP BY
ORDER BY
SUM
```

Ожидается:

| region | revenue | profit |
|---|---:|---:|
| Север | 450.00 | 175.00 |
| Юг | 730.00 | 285.00 |

Итого:

```text
revenue = 1180.00
profit  = 460.00
```

Отдельно проверьте:

```text
COUNT(*)                = 12
COUNT(manager)           = 11
COUNT(DISTINCT manager)  = 4
```

Если не получилось — [урок 10](10-sql-lab.md).

---

# 9. Создайте Virtual Dataset

В SQL Lab подготовьте построчный запрос к `training.sales`, который возвращает исходные поля и:

```sql
revenue - cost AS profit
```

Не делайте `GROUP BY` внутри этого запроса.

Сохраните результат по маршруту:

```text
Create chart
→ Create a dataset
→ Save as new
→ Dataset name: sales_virtual
→ Save
```

После этого в `Datasets` должны одновременно существовать:

```text
sales
sales_virtual
```

Запрос `sales_virtual` должен возвращать 12 исходных продаж и колонку `profit`.

Физическая таблица PostgreSQL `sales_virtual` при этом не создаётся.

Если не получилось — [урок 11](11-create-virtual-dataset.md).

---

# 10. Создайте Chart на Virtual Dataset

На `sales_virtual` постройте:

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

# Минимальный набор объектов после проверки

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
└── сохранённые Chart
    ├── Native Filter: Период
    └── Native Filter: Регион

Virtual Dataset
└── sales_virtual
```

Это контрольный набор курса, а не шаблон production-архитектуры.

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

Если настройки выглядят правильно, но контрольное число не совпадает, результат неправильный. Проверяйте период, Filters, Dimensions и агрегацию.

---

# К какому уроку возвращаться

| Проблема | Урок |
|---|---|
| стенд или контрольные данные | [02](02-start-training-superset.md) |
| Database connection | [03](03-connect-postgresql.md) |
| Physical Dataset | [04](04-create-dataset.md) |
| Explore, фильтры и период | [05](05-explore-basics.md) |
| Calculated Column и Metric | [06](06-metrics-and-calculations.md) |
| Chart | [07](07-create-charts.md) |
| Dashboard | [08](08-build-dashboard.md) |
| Native Filters / Scoping | [09](09-native-filters.md) |
| SQL Lab | [10](10-sql-lab.md) |
| Virtual Dataset | [11](11-create-virtual-dataset.md) |

---

# Что изучать дальше

Базовый курс специально не включает всё сразу. Следующий блок выбирайте по реальной задаче.

## Аналитическая модель и SQL

Если основная работа — исследование данных:

- зерно таблицы;
- факты и измерения;
- корректные агрегирования;
- `JOIN`;
- CTE;
- подзапросы;
- оконные функции;
- сложные Virtual Dataset;
- проверка SQL до визуализации.

Superset не исправляет плохую модель данных: ошибка в зерне или агрегации останется ошибкой на Dashboard.

## Роли и доступ

Для нескольких групп пользователей изучайте:

- users и roles;
- доступ к Database и Dataset;
- доступ к Dashboard;
- `Gamma`;
- дополнительные роли;
- Row Level Security;
- проверку результата под разными пользователями.

Сначала разберите модель безопасности целиком, а не раздавайте permissions по одному без схемы.

## Production

Учебный `training/compose.yaml` не является production-конфигурацией.

Для реального сервера отдельно нужны:

- production metadata database;
- backup и restore metadata;
- собственный `SUPERSET_SECRET_KEY`;
- HTTPS и reverse proxy;
- production-аутентификация;
- ограниченные пользователи источников;
- логирование;
- staging;
- обновление и откат.

Учебные значения:

```text
admin / admin
training / training
training-only SUPERSET_SECRET_KEY
```

в production не переносятся.

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

Redis и Celery не нужны для самого первого учебного запуска. Их добавляют под конкретные функции.

## REST API

API нужен для интеграций и автоматизации объектов Superset. Сначала полезно уверенно понимать Dataset, Chart, Dashboard и права через обычный интерфейс.

## Embedding

Для встраивания Dashboard в другое приложение отдельно изучаются:

- embedded configuration;
- allowed domains;
- guest token;
- аутентификация;
- права;
- безопасность внешнего приложения.

Embedding и `Published` — разные механизмы.

---

# Рекомендуемый порядок следующего уровня

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

Эти темы не нужно добавлять обратно в базовые уроки 01–11. Их задача — провести новичка от готовых данных до рабочего Dashboard и Virtual Dataset.

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
