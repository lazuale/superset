# 04. Создаём первый Dataset

Подключение к PostgreSQL уже есть. Теперь нужно зарегистрировать таблицу `training.sales` в Superset как Dataset и проверить, что Superset правильно понял её структуру.

В конце должен появиться физический Dataset:

```text
sales
```

с источником:

```text
Database: Training PostgreSQL
Schema:   training
Table:    sales
```

## Что мы сейчас создаём

Исходные 12 строк по-прежнему остаются в PostgreSQL. Dataset не копирует их в служебную базу Superset.

Он хранит описание источника: откуда читать данные, какие есть столбцы, какие из них временные, какие Metrics и Calculated Columns добавлены и другие настройки аналитической модели.

В нашем случае Dataset будет напрямую указывать на таблицу `training.sales`.

## Создаём Dataset

Откройте:

```text
Datasets
```

Нажмите кнопку `Dataset` со значком `+` и выберите:

```text
Database: Training PostgreSQL
Schema:   training
Table:    sales
```

Справа должна появиться структура таблицы. Для учебного источника ожидаются девять столбцов:

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

Внизу формы есть кнопка:

```text
Create and explore dataset
```

Откройте её выпадающее меню и выберите:

```text
Create dataset
```

Так Dataset создастся, но мы не будем сразу уходить в Explore. Сначала проверим его настройки.

## Открываем редактор Dataset

В списке `Datasets` найдите `sales`, наведите указатель на строку и нажмите `Edit`.

У физического Dataset доступны вкладки:

```text
Source
Metrics
Columns
Calculated columns
Usage
Settings
```

Сейчас нас интересуют только `Source`, `Columns` и `Settings`.

### Source

На вкладке `Source` должны быть:

```text
Physical (table or view)
Database: Training PostgreSQL
Schema:   training
Table:    sales
```

Рядом находится замок с подписью:

```text
Click the lock to make changes.
```

Он защищает именно источник Dataset от случайной замены. Нам источник менять не нужно, поэтому замок не трогаем.

### Columns

На вкладке `Columns` должно быть девять строк:

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

Самое важное здесь — `sale_date`. В колонке:

```text
Is temporal
```

у него должна стоять галка.

Дальше временные фильтры и `Time grain` будут опираться именно на этот признак. Если `sale_date` не распознан как временной столбец, ошибки начнут проявляться уже в следующем уроке.

Над списком есть кнопка:

```text
Sync columns from source
```

Сейчас она не нужна. Её используют, когда структура исходной таблицы в PostgreSQL уже изменилась, а Dataset нужно синхронизировать с источником. Строки данных при этом никуда не копируются.

### Settings

Перейдите в `Settings` и заполните `Description`:

```text
Учебные продажи из PostgreSQL: training.sales
```

Нажмите:

```text
Save
```

Замок `Source` для этого открывать не требуется. Он не блокирует весь редактор Dataset.

## Проверяем результат

Снова откройте `sales` через `Edit` и убедитесь, что всё осталось на месте:

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

Теперь вернитесь в список `Datasets` и нажмите имя `sales`.

Откроется `Explore`. В левой панели должны быть видны все девять физических столбцов. `sale_date` должен отображаться как временной, а `sale_id`, `quantity`, `revenue` и `cost` — как числовые поля.

Ничего строить и сохранять пока не нужно. Сам Explore начнём разбирать в следующем уроке.

## Если что-то не совпало

Если в списке Database нет `Training PostgreSQL`, проблема ещё в уроке 03.

Если не видны схема `training` или таблица `sales`, проверьте подключение и права `superset_reader`. Быстрый контроль из терминала:

```bash
docker compose exec -T db bash -lc \
  "PGPASSWORD=superset_reader psql -h 127.0.0.1 -U superset_reader -d training -c 'SELECT COUNT(*) FROM training.sales;'"
```

Ожидается:

```text
12
```

Если `sale_date` не отмечен как `Is temporal`, сначала убедитесь, что Dataset действительно указывает на `training.sales`, а тип столбца — `DATE`. Только если структура таблицы менялась после создания Dataset, используйте `Sync columns from source`.

Если не сохранился `Description`, откройте `Settings`, внесите значение ещё раз и нажмите `Save`.

## Перед следующим уроком

Достаточно проверить:

```text
Dataset  = sales
Type     = Physical
Database = Training PostgreSQL
Schema   = training
Table    = sales
Columns  = 9
sale_date Is temporal = true
```

Если это совпадает, можно переходить к первой реальной работе в Explore.

→ [Урок 05. Осваиваем Explore](05-explore-basics.md)

## Источники Superset 6.1.0

- создание Dataset и переходы после создания: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/features/datasets/AddDataset/Footer/index.tsx>
- редактор Dataset, вкладки, блокировка `Source` и `Sync columns from source`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/components/Datasource/components/DatasourceEditor/DatasourceEditor.tsx>
- официальное руководство по созданию Dataset: <https://github.com/apache/superset/blob/6.1.0/docs/docs/using-superset/creating-your-first-dashboard.mdx>
- структура учебной таблицы: [`../training/schema.sql`](../training/schema.sql)