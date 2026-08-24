# Сквозная учебная модель

Практика должна поддерживать весь маршрут: Dataset, Explore, time analytics, SQL Lab, моделирование, RLS и performance troubleshooting.

## Разделение хранилищ

```text
Superset metadata database
        ≠
training analytics database
```

Предметные строки хранятся в отдельной PostgreSQL analytics database. Metadata database Superset не используется как учебное хранилище бизнес-данных.

## Этап A. Плоская таблица

```text
training.sales
```

Поля:

```text
sale_id
sale_ts
region
office
manager
product
quantity
revenue
cost
```

Grain: **одна строка = одна строка продажи**.

Набор должен содержать:

- несколько месяцев;
- минимум два региона;
- несколько офисов, менеджеров и продуктов;
- повторяющиеся категории;
- значения для SUM, COUNT, COUNT DISTINCT и AVG;
- контролируемый NULL;
- timestamps на границе временного периода;
- заранее рассчитанные totals;
- данные, пригодные для будущего RLS.

## Этап B. Аналитическая модель

```text
fact_sales
dim_date
dim_region
dim_office
dim_manager
dim_product
```

На ней изучаются grain, facts/dimensions, keys, joins, star schema, views, materialized views и граница между моделью БД и Virtual Dataset Superset.

Это переход к аналитической модели, а не урок «нормализации».

## Этап C. Security

Минимум три профиля:

```text
роль North → North
роль South → South
роль manager/admin → полный разрешённый набор
```

RLS вводится только в соответствующем разделе безопасности.

## Размеры fixture

**small** — небольшой детерминированный набор для ручной проверки уроков.

**large** — воспроизводимо генерируемый набор для performance/cache/troubleshooting. Он не меняет определения показателей.

## Каноническая структура labs

```text
docs/11-labs/
├── README.md
├── 00-sandbox/
├── 01-training-database/
├── 02-connect-postgresql/
├── 03-physical-dataset/
├── 04-explore-basics/
├── 05-metrics-and-calculated-columns/
├── 06-time-and-filters/
├── 07-charts-and-dashboard/
├── 08-native-filters/
├── 09-sql-lab-and-virtual-dataset/
├── 10-star-schema/
├── 11-semantic-layer/
├── 12-roles-and-rls/
├── 13-metadata-and-configuration/
├── 14-cache-and-async/
└── 15-backup-and-upgrade/
```

Каждый stateful lab обязан иметь reset/rebuild и ожидаемый результат.

## Контроль результата

Визуальное совпадение графика недостаточно. Предпочтительная схема:

```text
результат Superset
      ↓
ожидаемое значение
      ↓
контрольный SQL напрямую к training DB
      ↓
сравнение
```

Новая таблица, поле или edge case добавляются только при реальной учебной необходимости и не должны незаметно ломать уже опубликованные expected results.
