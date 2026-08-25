# Справочник к уроку 11. Physical Dataset или Virtual Dataset?

Урок 11 показывает механику Virtual Dataset. Здесь разбираем, когда он действительно нужен.

```text
готовая таблица / VIEW уже подходит для анализа
→ Physical Dataset

нужно локально преобразовать данные SQL внутри Superset
→ Virtual Dataset

SQL тяжёлый, общий или критичен для рабочей системы
→ лучше слой БД / DWH / ETL
```

## Physical Dataset

Physical Dataset указывает на объект SQL-источника — таблицу или VIEW.

В курсе:

```text
PostgreSQL
└── training.sales
        ↓
Superset
└── Physical Dataset sales
```

Superset хранит описание Dataset и выполняет запросы к источнику. Бизнес-строки в служебную базу метаданных при этом не копируются.

## Когда Physical — нормальный выбор по умолчанию

Если источник уже имеет подходящие строки, столбцы, зерно и типы данных, дополнительный SQL-слой внутри Superset может быть просто не нужен.

Это может быть таблица, `VIEW`, `MATERIALIZED VIEW` или готовая витрина.

Чем меньше лишних преобразований между источником и аналитикой, тем проще объяснить и сопровождать модель.

## Virtual Dataset

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

и сохраняется как `sales_virtual`. Физическая таблица PostgreSQL с таким именем не создаётся.

## Когда Virtual полезен

Он удобен, если для конкретной аналитической задачи нужно выбрать или переименовать поля, добавить SQL-выражения, сделать локальный JOIN, использовать CTE или оконную функцию, либо иначе изменить структуру набора.

Если такой SQL нужен только внутри Superset и остаётся достаточно простым, Virtual Dataset — нормальный вариант.

## Когда Virtual лишний

Если физическая таблица уже подходит, а нужен только простой построчный расчёт вроде `revenue - cost`, может быть достаточно Physical Dataset + Calculated Column.

В уроке 11 `profit` повторяется через SQL специально, чтобы показать сам механизм Virtual Dataset.

## Virtual Dataset не хранит снимок строк

Он хранит SQL-определение. При обращении к Dataset запрос выполняется снова, поэтому изменение исходных данных может изменить результат.

Virtual Dataset также не ускоряет тяжёлый SQL сам по себе. График формирует запрос поверх SQL, определяющего Dataset.

Если одна и та же дорогая подготовка нужна постоянно, стоит рассмотреть `VIEW`, `MATERIALIZED VIEW`, витрину или отдельный ETL/ELT-процесс.

## Physical не означает «без SQL»

Можно создать представление в PostgreSQL:

```sql
CREATE VIEW analytics.sales_enriched AS
SELECT ...;
```

а затем подключить его в Superset как Physical Dataset.

То есть вопрос Physical vs Virtual — не «есть SQL или нет», а **где определена логика: в источнике данных или внутри Superset**.

## Зерно важнее типа Dataset

И Physical, и Virtual можно спроектировать неправильно. Перед использованием всё равно нужно закончить фразу:

```text
1 строка Dataset = ...
```

Например: одна продажа, одна транзакция, один автомобиль за день, один сотрудник за смену.

→ [Зерно Dataset](06c-data-grain.md)

## JOIN не делает Virtual Dataset правильным автоматически

JOIN может размножить строки и изменить `SUM`, `AVG` и `COUNT`. После SQL-подготовки проверяйте зерно и контрольные числа.

→ [JOIN без размножения данных](10b-join-without-duplication.md)

## Где должна жить общая бизнес-логика

Локальная логика, нужная только одной аналитике Superset, может жить в Virtual Dataset.

Если одно определение используется многими Dashboard и другими системами, безопаснее иметь общий слой данных. Иначе один и тот же показатель легко начинает жить в нескольких несовпадающих SQL-копиях.

## Не создавайте Dataset на каждый график

Имена вроде:

```text
sales
vehicle_shifts
fuel_transactions
```

обычно лучше набора `sales_chart_1`, `sales_chart_2`, `sales_chart_3`.

Один понятный Dataset может обслуживать несколько связанных аналитических вопросов, если их зерно совместимо.

## Быстрое решение

```text
Есть готовая таблица / VIEW?
│
├─ структура подходит → Physical Dataset
│
├─ нужна только простая построчная формула
│  └─ Physical + Calculated Column
│
└─ нужен отдельный SQL-набор
   ├─ локальный и достаточно лёгкий → Virtual Dataset
   └─ тяжёлый / общий / переиспользуемый → слой БД → Physical Dataset
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
