# 04. Создаём первый Dataset

## Результат урока

После урока в Superset должен существовать физический Dataset типа `Physical`:

```text
sales
```

Источник:

```text
Database: Training PostgreSQL
Schema:   training
Table:    sales
```

В Dataset должны быть видны все девять физических столбцов, а `sale_date` должен быть отмечен как временной.

## Перед началом

Должны быть пройдены:

- [урок 02](02-start-training-superset.md) — стенд работает;
- [урок 03](03-connect-postgresql.md) — подключение `Training PostgreSQL` создано и видит `training.sales`.

Откройте:

```text
http://localhost:8088
```

Войдите:

```text
login:    admin
password: admin
```

## Что такое Dataset

Исходные строки продолжают храниться в PostgreSQL:

```text
training.sales
```

Физический Dataset хранит в Superset описание этого источника: Database, Schema, Table, список столбцов, признаки временных полей, Calculated Columns, Metrics и настройки Dataset.

Создание Dataset не копирует 12 строк продаж в служебную базу метаданных Superset.

## Создаём Dataset

Откройте верхний раздел:

```text
Datasets
```

Нажмите кнопку `Dataset` со значком `+`.

Откроется форма добавления Dataset.

Последовательно выберите:

```text
Database: Training PostgreSQL
Schema:   training
Table:    sales
```

Справа должна появиться структура таблицы.

Для учебного источника ожидаются столбцы:

| Column | Data type |
|---|---|
| `sale_id` | `BIGINT` |
| `sale_date` | `DATE` |
| `region` | `TEXT` |
| `office` | `TEXT` |
| `manager` | `TEXT` |
| `product` | `TEXT` |
| `quantity` | `INTEGER` |
| `revenue` | `NUMERIC(12, 2)` |
| `cost` | `NUMERIC(12, 2)` |

Внизу формы основная кнопка называется:

```text
Create and explore dataset
```

Справа у неё есть раскрывающееся меню. Откройте его и выберите:

```text
Create dataset
```

Этот вариант создаёт Dataset и возвращает к списку Datasets. Explore пока не нужен.

## Проверяем список Datasets

В списке должна появиться строка:

```text
Dataset:  sales
Type:     Physical
Database: Training PostgreSQL
Schema:   training
```

Наведите указатель на строку `sales`. В колонке `Actions` появится значок карандаша с действием `Edit`.

Нажмите `Edit`.

## Редактор Dataset

Для физического Dataset `sales` в редакторе Superset 6.1.0 используются вкладки:

```text
Source
Metrics
Columns
Calculated columns
Usage
Settings
```

В этом уроке работаем с `Source`, `Columns` и `Settings`.

## Source

На вкладке `Source` должны быть указаны:

```text
Physical (table or view)
Database: Training PostgreSQL
Schema:   training
Table:    sales
```

Рядом находится замок и текст:

```text
Click the lock to make changes.
```

Замок относится к полям `Source`. Он защищает от случайной смены типа Dataset, Database, Schema и Table.

В этом курсе источник уже выбран правильно, поэтому замок не открываем.

## Columns

Перейдите на вкладку:

```text
Columns
```

В таблице должны быть девять строк:

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

Проверьте типы:

```text
sale_id  → BIGINT
sale_date → DATE
region   → TEXT
office   → TEXT
manager  → TEXT
product  → TEXT
quantity → INTEGER
revenue  → NUMERIC(12, 2)
cost     → NUMERIC(12, 2)
```

У строки `sale_date` в колонке:

```text
Is temporal
```

должна стоять галка.

Это обязательная проверка для следующих уроков: временные фильтры и `Time grain` будут опираться на временной столбец `sale_date`.

## Sync columns from source

Над таблицей `Columns` находится кнопка:

```text
Sync columns from source
```

Она повторно считывает структуру исходной таблицы и синхронизирует метаданные Dataset.

Сейчас `training.sales` не менялась, поэтому кнопку не нажимаем. Она понадобится, если физическая структура таблицы в PostgreSQL изменится после создания Dataset.

`Sync columns from source` синхронизирует описание столбцов, а не копирует строки данных в Superset.

## Settings

Перейдите на вкладку:

```text
Settings
```

Поле:

```text
Description
```

редактируется без открытия замка `Source`.

Введите:

```text
Учебные продажи из PostgreSQL: training.sales
```

Нажмите:

```text
Save
```

## Проверяем сохранение

Вернитесь в:

```text
Datasets
```

Найдите `sales`, наведите указатель на строку и снова нажмите `Edit`.

Проверьте:

```text
Source:
Database = Training PostgreSQL
Schema   = training
Table    = sales

Columns:
9 физических столбцов
sale_date → Is temporal = включено

Settings:
Description = Учебные продажи из PostgreSQL: training.sales
```

## Проверяем Explore

Вернитесь в `Datasets` и нажмите имя:

```text
sales
```

Имя Dataset открывает `Explore`.

В левой панели источника должны быть видны девять физических столбцов. У `sale_date` отображается значок временного поля; числовые поля `sale_id`, `quantity`, `revenue`, `cost` отмечены как числовые.

На этом этапе график (`Chart`) не настраиваем и не сохраняем.

## Блокировка Source и редактирование Dataset

Замок на вкладке `Source` не переводит весь редактор Dataset в режим только для чтения.

Без открытия замка `Source` доступны, в частности:

```text
Metrics
Columns
Calculated columns
Settings
```

Поэтому для изменения `Description`, добавления Metric или Calculated Column разблокировать `Source` не требуется.

## Типовые ошибки

### В списке Database нет Training PostgreSQL

Вернитесь к [уроку 03](03-connect-postgresql.md). Подключение должно быть сохранено с `Display Name = Training PostgreSQL`.

### Нет схемы training или таблицы sales

Проверьте подключение и права `superset_reader`.

Контроль из терминала:

```bash
docker compose exec -T db bash -lc \
  "PGPASSWORD=superset_reader psql -h 127.0.0.1 -U superset_reader -d training -c 'SELECT COUNT(*) FROM training.sales;'"
```

Ожидается:

```text
12
```

### sale_date не отмечен как Is temporal

Сначала проверьте, что источник — именно `training.sales` и значение `Data type` столбца — `DATE`.

Если структура PostgreSQL действительно была изменена после создания Dataset, используйте `Sync columns from source`, затем снова проверьте `sale_date`.

### Description не сохранился

После изменения на вкладке `Settings` нажмите `Save` и повторно откройте Dataset через `Edit`.

## Критерий завершения

Урок завершён, если одновременно выполняется:

```text
Dataset  = sales
Type     = Physical
Database = Training PostgreSQL
Schema   = training
Table    = sales
Columns  = 9
sale_date Is temporal = true
Description = Учебные продажи из PostgreSQL: training.sales
```

Следующий урок — первый аналитический запрос через Explore.

→ [Урок 05. Осваиваем Explore](05-explore-basics.md)

## Источники Superset 6.1.0

- создание Dataset и переходы после создания: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/features/datasets/AddDataset/Footer/index.tsx>
- редактор Dataset, вкладки, блокировка `Source` и `Sync columns from source`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/components/Datasource/components/DatasourceEditor/DatasourceEditor.tsx>
- официальное руководство по созданию Dataset: <https://github.com/apache/superset/blob/6.1.0/docs/docs/using-superset/creating-your-first-dashboard.mdx>
- структура учебной таблицы: [`../training/schema.sql`](../training/schema.sql)
