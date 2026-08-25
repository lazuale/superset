# Справочник к уроку 11. Physical Dataset или Virtual Dataset?

Урок 11 показывает, как создать `Virtual Dataset`. Этот справочник помогает решить, **когда он вообще нужен**.

## Быстрая схема

```text
есть готовая таблица / VIEW, подходящая для анализа
→ Physical Dataset

нужно локально преобразовать данные SQL внутри Superset
→ Virtual Dataset

SQL тяжёлый, общий или критичен для рабочей системы
→ лучше слой БД / DWH / ETL
```

## 1. Physical Dataset

Physical Dataset указывает на физический объект SQL-источника — например таблицу или VIEW.

В курсе:

```text
PostgreSQL
└── training.sales
        ↓
Superset
└── Physical Dataset sales
```

Superset не копирует бизнес-строки в служебную базу метаданных. Он хранит описание Dataset и выполняет запросы к подключённому источнику.

## 2. Когда Physical — выбор по умолчанию

Используйте Physical Dataset, если источник уже имеет подходящие:

```text
строки
столбцы
зерно
типы данных
```

Примеры:

```text
готовая таблица
VIEW
материализованное представление (MATERIALIZED VIEW)
таблица-витрина
```

Чем меньше лишнего слоя преобразований, тем проще объяснить и сопровождать модель.

## 3. Virtual Dataset

Virtual Dataset определяется сохранённым SQL-запросом Superset.

```text
SQL
↓
результат запроса
↓
Virtual Dataset
↓
Explore / Chart
```

В уроке 11 запрос добавляет:

```sql
revenue - cost AS profit
```

и сохраняется как:

```text
sales_virtual
```

Физическая таблица PostgreSQL с таким именем при этом не создаётся.

## 4. Когда Virtual действительно полезен

Например нужно:

```text
выбрать только нужные поля
переименовать поля
добавить SQL-выражения
сделать локальный JOIN
использовать CTE
использовать оконную функцию
изменить структуру аналитического набора
```

Если SQL нужен только конкретной аналитической задаче и достаточно лёгкий, Virtual Dataset может быть удобен.

## 5. Когда Virtual не нужен

Если таблица уже подходит, а нужно только:

```sql
revenue - cost
```

может быть достаточно:

```text
Physical Dataset + Calculated Column
```

В уроке 11 мы повторяем `profit` через SQL специально для изучения механизма Virtual Dataset.

## 6. Virtual Dataset не хранит снимок строк

Важно:

```text
Virtual Dataset
→ хранит SQL
→ SQL выполняется снова при запросах
```

Это не материализованный снимок данных.

Если исходные данные изменились, результат SQL тоже может измениться.

## 7. Virtual Dataset не ускоряет тяжёлый SQL автоматически

Если SQL сам по себе дорогой, сохранение как Virtual Dataset не делает его мгновенным.

График (`Chart`) формирует свой запрос поверх SQL, определяющего Virtual Dataset.

Если одна и та же тяжёлая подготовка нужна постоянно, рассмотрите:

```text
VIEW
MATERIALIZED VIEW
таблицу-витрину
ETL / ELT
```

## 8. Physical не означает «без SQL»

Например в PostgreSQL можно создать:

```sql
CREATE VIEW analytics.sales_enriched AS
SELECT ...;
```

Для Superset это затем обычный объект источника:

```text
Physical Dataset → analytics.sales_enriched
```

Поэтому вопрос `Physical vs Virtual` — это не «SQL или не SQL».

Это вопрос:

```text
логика определена в источнике данных
или
логика определена внутри Superset
```

## 9. Зерно важнее типа Dataset

И Physical, и Virtual могут быть спроектированы плохо.

Перед использованием закончите фразу:

```text
1 строка Dataset = ...
```

Например:

```text
1 продажа
1 транзакция
1 автомобиль за день
1 сотрудник за смену
```

→ [Зерно Dataset](06c-data-grain.md)

## 10. JOIN не делает Virtual Dataset автоматически правильным

JOIN может размножить строки и изменить `SUM`, `AVG` и `COUNT`.

Поэтому после SQL-подготовки проверяйте контрольные числа.

→ [JOIN без размножения данных](10b-join-without-duplication.md)

## 11. Где должна жить общая бизнес-логика

Полезный принцип:

```text
локальная аналитическая логика только для Superset
→ Virtual Dataset возможен

общая логика компании
→ лучше общий слой данных
```

Если одно определение используется многими Dashboard и системами, отдельная копия внутри одного Virtual Dataset создаёт риск расхождения.

## 12. Не создавайте Dataset на каждый график

Лучше:

```text
sales
vehicle_shifts
fuel_transactions
```

чем:

```text
sales_chart_1
sales_chart_2
sales_chart_3
```

Один понятный Dataset может обслуживать несколько связанных аналитических вопросов, если их зерно совместимо.

## Дерево решений

```text
Есть готовая таблица / VIEW?
│
├─ да
│  ├─ структура подходит?
│  │   └─ да → Physical
│  └─ нужна только простая построчная формула?
│      └─ да → Physical + Calculated Column
│
└─ нужен слой SQL-преобразования
   ├─ локальный и достаточно лёгкий?
   │   └─ Virtual Dataset
   └─ тяжёлый / общий / критичный для рабочей системы?
       └─ слой БД → Physical Dataset
```

## Главное

```text
Physical
→ используем готовый объект источника

Virtual
→ определяем SQL-набор внутри Superset

общая тяжёлая модель
→ готовим ниже Superset
```

## Связанные материалы

- [Урок 04. Создаём Dataset](04-create-dataset.md)
- [Calculated Column, Metric или SQL?](06b-calculated-column-metric-or-sql.md)
- [Минимальный SQL](10a-minimal-sql-cheatsheet.md)
- [JOIN без размножения данных](10b-join-without-duplication.md)
- [Урок 11. Virtual Dataset](11-create-virtual-dataset.md)
- [Где заканчивается Superset](12a-what-belongs-in-superset.md)

## Источники Superset 6.1.0

- модель Dataset SQLAlchemy: <https://github.com/apache/superset/blob/6.1.0/superset/connectors/sqla/models.py>
- SQL Lab: <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/SqlLab>
- Explore: <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/explore>
