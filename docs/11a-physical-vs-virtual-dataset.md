# Шпаргалка к уроку 11. Physical Dataset или Virtual Dataset?

Эта шпаргалка нужна для выбора источника данных в Superset.

Самая короткая версия:

```text
Есть готовая таблица или VIEW, которые уже подходят для анализа?
→ Physical Dataset

Нужно сначала преобразовать данные SQL внутри Superset?
→ Virtual Dataset
```

Но есть важное продолжение:

```text
Если SQL тяжёлый, общий для многих систем или является частью корпоративной модели данных,
его лучше вынести в БД / ETL, а Superset подключить уже к готовому результату.
```

---

# 1. Что такое Physical Dataset

Physical Dataset в Superset указывает на физический объект источника данных — например таблицу или VIEW.

В нашем курсе:

```text
PostgreSQL
└── training.sales
        ↓
Superset
└── Physical Dataset sales
```

Superset не копирует таблицу к себе.

Он хранит описание Dataset и при выполнении Chart отправляет запрос в подключённую БД.

---

## Когда Physical Dataset — лучший вариант

Используйте его по умолчанию, если источник уже имеет правильный набор строк и столбцов.

Примеры:

```text
готовая таблица продаж
аналитическая VIEW
таблица-витрина
materialized view
```

Если Dataset можно использовать без дополнительного SQL-преобразования, Physical Dataset обычно проще и прозрачнее.

---

# 2. Что такое Virtual Dataset

Virtual Dataset определяется SQL-запросом.

Упрощённо:

```text
SQL
 ↓
результат запроса
 ↓
Virtual Dataset
 ↓
Explore / Chart
```

В уроке 11:

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
FROM training.sales
```

сохраняется как:

```text
sales_virtual
```

При этом физическая таблица PostgreSQL `sales_virtual` не создаётся.

---

# 3. Главное различие

```text
Physical Dataset
→ источник уже существует в БД

Virtual Dataset
→ источник определяется сохранённым SQL Superset
```

Оба являются Dataset для Explore.

Оба могут иметь Metrics, Charts и использоваться в Dashboard.

Различается место, где определяется входной набор данных.

---

# 4. Простая таблица выбора

| Ситуация | Выбор |
|---|---|
| готовая таблица уже подходит | Physical |
| готовая VIEW уже подходит | Physical |
| нужно переименовать или вычислить несколько полей SQL | Virtual возможен |
| нужен JOIN | Virtual или лучше VIEW/витрина |
| нужен CTE | Virtual или слой БД |
| нужен UNION | Virtual или слой БД |
| нужны оконные функции | Virtual или слой БД |
| SQL тяжёлый и используется постоянно | лучше объект БД / витрина |
| одна логика нужна нескольким BI и приложениям | лучше объект БД / общий слой данных |
| нужна только простая Calculated Column | Physical обычно достаточно |

---

# 5. Не переводите Dataset в Virtual без причины

Допустим, таблица:

```text
training.sales
```

уже имеет правильное зерно и все нужные строки.

Нужно только добавить:

```sql
revenue - cost
```

Можно создать Calculated Column `profit` в Physical Dataset.

Для одной такой формулы Virtual Dataset не обязателен.

В уроке 11 мы специально повторяем `profit` через SQL только для изучения механизма Virtual Dataset.

---

# 6. Когда Virtual Dataset действительно полезен

Например нужно получить:

```text
продажи
+
справочник регионов
+
расчёт profit
+
нормализованную категорию
```

SQL может выглядеть так:

```sql
SELECT
    s.sale_id,
    s.sale_date,
    s.region,
    r.region_group,
    s.revenue,
    s.cost,
    s.revenue - s.cost AS profit
FROM sales s
LEFT JOIN regions r
  ON r.region = s.region
```

Здесь SQL уже определяет структуру аналитического набора.

Virtual Dataset может быть удобным способом быстро использовать такой запрос в Superset.

---

# 7. Virtual Dataset не хранит снимок строк

Это критично понимать.

Сохранить Virtual Dataset — не значит сохранить текущий результат запроса как отдельную таблицу.

```text
Virtual Dataset
→ хранит SQL
→ SQL выполняется снова при запросах
```

Если исходные данные изменились, результат Virtual Dataset тоже может измениться.

В production дополнительно может влиять настроенное кэширование Superset, но сам Virtual Dataset не является materialized snapshot.

---

# 8. Virtual Dataset не ускоряет тяжёлый SQL сам по себе

Если запрос выполняется 30 секунд в SQL Lab, сохранение его как Virtual Dataset не превращает его автоматически в быстрый источник.

Chart концептуально работает поверх SQL Virtual Dataset.

Упрощённо:

```sql
SELECT
    region,
    SUM(profit)
FROM (
    -- SQL Virtual Dataset
) v
GROUP BY region
```

Поэтому тяжёлая подготовка остаётся тяжёлой, если база каждый раз должна выполнять её заново.

---

# 9. Когда лучше VIEW

VIEW живёт в самой БД.

```text
PostgreSQL
└── VIEW analytics.sales_enriched
        ↓
Superset
└── Physical Dataset
```

VIEW хорош, когда:

- логика должна быть централизована в БД;
- её используют разные BI-инструменты;
- права и изменение логики удобнее контролировать на уровне БД;
- нужно отделить аналитическую модель от конкретного Dashboard.

---

# 10. Когда лучше Materialized View или таблица-витрина

Если запрос слишком дорогой для пересчёта при каждом обращении, может понадобиться материализованный результат.

```text
источники
   ↓
ETL / ELT
   ↓
materialized view / таблица-витрина
   ↓
Physical Dataset Superset
```

Это уже архитектура данных, а не настройка Chart.

Типовые причины:

```text
миллионы строк
тяжёлые JOIN
сложные оконные расчёты
долгая агрегация
одна и та же подготовка повторяется на многих Dashboard
```

---

# 11. Где должна жить бизнес-логика

Полезный принцип:

```text
локальная аналитическая логика только для Superset
→ может жить в Virtual Dataset

общая корпоративная логика
→ лучше общий слой данных
```

Например определение показателя:

> «активный клиент компании»

если используется во многих системах, не стоит иметь отдельную независимую версию этой логики только в одном Virtual Dataset.

---

# 12. Зерно Dataset важнее его типа

Physical Dataset может быть плохим.

Virtual Dataset тоже может быть плохим.

Главный вопрос:

```text
что означает одна строка результата?
```

Например:

```text
одна строка = одна продажа
```

или:

```text
одна строка = один автомобиль за один день
```

Если зерно непонятно, нельзя надёжно выбирать `SUM`, `COUNT` и `COUNT DISTINCT`.

Тип Dataset сам по себе проблему зерна не решает.

---

# 13. JOIN и размножение строк

Virtual Dataset часто появляется именно из-за JOIN.

Поэтому после JOIN обязательно проверяйте количество строк и контрольные суммы.

Было:

```text
1 продажа
```

после неправильного JOIN стало:

```text
3 строки той же продажи
```

Тогда:

```text
SUM(revenue)
```

утроится.

Superset не может догадаться, что это ошибка модели данных.

---

# 14. Physical Dataset не означает «без SQL»

Физический источник вполне может быть SQL VIEW, созданной в PostgreSQL.

Например:

```sql
CREATE VIEW analytics.sales_enriched AS
SELECT ...
```

Для Superset это затем физический объект источника:

```text
Physical Dataset → analytics.sales_enriched
```

Поэтому выбор `Physical vs Virtual` — не выбор между «SQL и без SQL».

Это выбор между:

```text
SQL/логика определена в источнике данных
```

и:

```text
SQL/логика определена внутри Superset
```

---

# 15. Что происходит при изменении Virtual Dataset

Если изменить SQL Virtual Dataset, изменится входной набор для всех Chart, которые на него опираются.

Например Chart использует:

```text
SUM(profit)
```

а из SQL Virtual Dataset удалили колонку:

```text
profit
```

Chart больше не сможет выполнить старую конфигурацию.

Поэтому Virtual Dataset — повторно используемый объект аналитической модели, а не личный черновик одного Chart.

---

# 16. Когда делать отдельный Virtual Dataset

Не нужно превращать каждый Chart в отдельный SQL Dataset.

Лучше выделять Dataset по смыслу аналитического набора.

Например:

```text
sales
sales_by_day
vehicle_shifts
fuel_transactions
```

а не:

```text
sales_chart_1
sales_chart_2
sales_chart_3
```

Один нормальный Dataset должен обслуживать несколько связанных аналитических вопросов, если у них совместимое зерно.

---

# 17. Быстрое дерево решений

```text
Есть готовая таблица / VIEW?
│
├─ да
│  │
│  ├─ структура уже подходит?
│  │     ├─ да → Physical Dataset
│  │     └─ нет → нужен слой преобразования
│  │
│  └─ нужна только простая row-level формула?
│        └─ да → Physical + Calculated Column
│
└─ нет / нужно преобразование
   │
   ├─ SQL локальный и достаточно лёгкий?
   │     └─ Virtual Dataset
   │
   └─ SQL тяжёлый / общий / production-critical?
         └─ VIEW / materialized view / витрина → Physical Dataset
```

---

# 18. Для новичка: правило по умолчанию

Не начинайте с Virtual Dataset только потому, что умеете писать SQL.

Начинайте с наиболее простого и прозрачного источника.

```text
готовая таблица
→ Physical

нужен один новый столбец
→ Physical + Calculated Column

нужна агрегированная формула
→ Metric

нужно перестроить набор данных
→ Virtual / слой БД
```

---

# 19. Контрольный пример курса

В курсе одновременно существуют:

```text
Physical Dataset
sales
→ training.sales
```

и:

```text
Virtual Dataset
sales_virtual
→ SELECT ... revenue - cost AS profit ...
```

Они читают одни и те же исходные продажи.

Поэтому при одинаковой логике расчёта ожидается:

```text
Север = 520.00
Юг    = 1010.00
```

Разница не в цифре результата, а в том, где подготовлено поле `profit`.

---

# 20. Главное правило

```text
Physical Dataset
→ используем готовый объект БД

Virtual Dataset
→ определяем набор SQL внутри Superset

тяжёлая или общая модель данных
→ готовим ниже Superset и подключаем как Physical
```

Superset — BI-слой, а не обязательное место для всей инженерной подготовки данных.

---

## Связанные материалы

- [Урок 04. Создаём первый Dataset](04-create-dataset.md)
- [Шпаргалка: Calculated Column, Metric или SQL?](06b-calculated-column-metric-or-sql.md)
- [Урок 10. SQL Lab с нуля](10-sql-lab.md)
- [Урок 11. Создаём Virtual Dataset](11-create-virtual-dataset.md)
- [Шпаргалка: почему цифры в Superset не сходятся](07b-troubleshoot-wrong-numbers.md)

## Источники Superset 6.1.0

- Dataset model и физический/SQL источник: <https://github.com/apache/superset/blob/6.1.0/superset/connectors/sqla/models.py>
- SQL Lab: <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/SqlLab>
- Explore для query datasource и сохранение Dataset: <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/explore>
