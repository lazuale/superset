# Шпаргалка к уроку 05. Dimension, Metric и Filter без путаницы

Эта памятка нужна, когда в `Explore` непонятно, что именно положить в `Dimensions`, `Metrics` и `Filters`.

Запомните три вопроса:

```text
Dimension → по чему разбиваем результат?
Metric    → что считаем?
Filter    → какие строки оставляем?
```

## Самый короткий пример

Вопрос:

> Какова выручка каждого региона за февраль?

Разбор:

```text
каждого региона
→ Dimension = region

какова выручка
→ Metric = SUM(revenue)

за февраль
→ временной Filter / Time range
```

## 1. Dimension — по чему делим результат

Примеры:

```text
region
product
office
manager
sale_date
```

Вопрос:

> Какая выручка у каждого региона?

```text
Dimension = region
Metric    = SUM(revenue)
```

Без Dimension:

```text
SUM(revenue) = 4005.00
```

С `region`:

```text
Север = 1360.00
Юг    = 2645.00
```

Практическое правило:

> Если нужно получить отдельный результат для каждого значения признака, этот признак обычно является Dimension.

## 2. Metric — что считаем

Примеры:

```text
SUM(revenue)
SUM(quantity)
COUNT(*)
COUNT_DISTINCT(manager)
AVG(revenue)
```

Вопрос:

> Сколько уникальных менеджеров?

```text
Metric = COUNT_DISTINCT(manager)
```

Dimension определяет группы, Metric — расчёт внутри них.

## 3. Filter — какие строки участвуют

Например:

```text
region = Север
```

оставляет только Север.

После фильтрации Metric считается уже по оставшимся строкам.

Упрощённая учебная модель:

```text
исходные строки
→ Filter
→ оставшиеся строки
→ Dimension
→ группы
→ Metric
→ результат
```

## 4. Dimension и Filter — не одно и то же

Одна колонка может играть разные роли.

```text
показать каждый регион
→ Dimension = region

оставить только Север
→ Filter = region = Север

показать продукты только Севера
→ Dimension = product
  Filter    = region = Север
```

Роль определяется вопросом, а не названием колонки.

## 5. Несколько Dimensions

Вопрос:

> Выручка по регионам и продуктам.

```text
Dimensions:
region
product

Metric:
SUM(revenue)
```

Получаются отдельные группы для каждой комбинации.

Каждый дополнительный Dimension делает результат детальнее. Не добавляйте поля «на всякий случай».

## 6. Частая ошибка: считать строки вместо объектов

Вопрос:

> Сколько менеджеров работало?

Если один менеджер встречается в нескольких продажах:

```text
COUNT(*)
```

считает строки Dataset, а не уникальных менеджеров.

Для уникальных менеджеров:

```text
COUNT_DISTINCT(manager)
```

Подробно:

→ [Как выбрать агрегирование](06a-aggregations.md)

## 7. Время — отдельная тема

Не нужно пытаться запомнить время как ещё один вариант Dimension или Filter.

В Superset отдельно различаются:

```text
Time column
Time range
Time grain
```

Их смысл разобран в следующей памятке:

→ [Time column, Time range и Time grain](05b-time-range-and-grain.md)

## 8. Алгоритм перед Chart

```text
1. Какой вопрос я задаю?
2. Что считаю?
   → Metric
3. По чему делю результат?
   → Dimension
4. Какие строки должны участвовать?
   → Filter
5. Если есть время — какой период и детализация?
   → отдельные time controls
6. Только после этого выбираю Chart.
```

## Контрольная таблица

| Задача | Dimension | Metric | Filter |
|---|---|---|---|
| общая выручка | — | `SUM(revenue)` | — |
| выручка по регионам | `region` | `SUM(revenue)` | — |
| выручка Севера | — | `SUM(revenue)` | `region = Север` |
| продукты Севера | `product` | `SUM(revenue)` | `region = Север` |
| уникальные менеджеры по регионам | `region` | `COUNT_DISTINCT(manager)` | — |

## Главное

```text
Dimension
→ по чему делим

Metric
→ что считаем

Filter
→ что оставляем
```

Если эти роли перепутаны, правильный тип Chart уже не спасёт расчёт.

## Связанные материалы

- [Урок 05. Осваиваем Explore](05-explore-basics.md)
- [Время](05b-time-range-and-grain.md)
- [Агрегации](06a-aggregations.md)
- [Как выбрать визуализацию](07a-choose-visualization.md)

## Источники Superset 6.1.0

- shared controls `Dimensions`, `Metrics`, `Filters`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/shared-controls/dndControls.tsx>
- Table control panel: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/controlPanel.tsx>
