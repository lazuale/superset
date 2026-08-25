# Справочник к уроку 05. Dimension, Metric и Filter без путаницы

Эта шпаргалка нужна, когда вы открыли `Explore` и не понимаете, **что именно класть в Dimensions, Metrics и Filters**.

Запомните три вопроса:

```text
Dimension → по чему разбиваем данные?
Metric    → что считаем?
Filter    → какие строки оставляем?
```

Если эти три вопроса сформулированы правильно, основная часть запроса уже понятна.

---

## Самая короткая схема

Допустим, вопрос звучит так:

> Какова выручка каждого региона за февраль?

Разбираем его на части:

```text
каждого региона
→ Dimension = region

какова выручка
→ Metric = SUM(revenue)

за февраль
→ Filter по sale_date
```

В Explore получится:

```text
Dimensions = region
Metrics    = SUM(revenue)
Filters    = sale_date: 2026-02-01 <= date < 2026-03-01
```

---

# 1. Dimension — по чему разбиваем результат

`Dimension` — это признак, по которому данные делятся на группы.

Примеры Dimension:

```text
region
product
office
manager
sale_date
```

Вопрос:

> Какая выручка у каждого региона?

Здесь:

```text
Dimension = region
```

Вопрос:

> Какая выручка у каждого продукта?

Здесь:

```text
Dimension = product
```

Без Dimension одна агрегированная Metric обычно даст один общий итог.

Например:

```text
Metric = SUM(revenue)
Dimension = пусто
```

даёт:

```text
4005.00
```

А:

```text
Metric = SUM(revenue)
Dimension = region
```

даёт две группы:

```text
Север = 1360.00
Юг    = 2645.00
```

## Как распознать Dimension в вопросе

Часто это слова после:

```text
по регионам
по участкам
по сотрудникам
по автомобилям
по продуктам
по месяцам
по статусам
```

Практическое правило:

> если нужно получить отдельный результат для каждого значения признака, этот признак обычно является Dimension.

---

# 2. Metric — что именно считаем

`Metric` — числовой показатель, который Superset вычисляет для всего набора данных или для каждой группы.

Примеры:

```text
SUM(revenue)
SUM(quantity)
COUNT(*)
COUNT_DISTINCT(manager)
AVG(revenue)
Прибыль
```

Вопрос:

> Сколько всего выручки?

```text
Metric = SUM(revenue)
```

Вопрос:

> Сколько уникальных менеджеров?

```text
Metric = COUNT_DISTINCT(manager)
```

Вопрос:

> Какова средняя выручка одной записи?

```text
Metric = AVG(revenue)
```

## Metric и Dimension работают вместе

```text
Dimension = region
Metric    = SUM(revenue)
```

означает:

> разбей строки по регионам и внутри каждой группы сложи revenue.

То есть Dimension определяет **группы**, а Metric — **расчёт внутри этих групп**.

---

# 3. Filter — какие строки вообще участвуют в расчёте

`Filter` отбрасывает строки, которые не должны попасть в расчёт.

Например:

> Выручка только региона Север.

```text
Filter:
region IN Север
```

> Выручка только за февраль 2026 года.

```text
Filter:
sale_date >= 2026-02-01
sale_date <  2026-03-01
```

После фильтрации Superset считает Metric уже не по всем исходным строкам, а только по оставшимся.

Упрощённо порядок можно представлять так:

```text
исходные строки
      ↓
    Filter
      ↓
оставшиеся строки
      ↓
  Dimension
      ↓
    группы
      ↓
    Metric
      ↓
   результат
```

Это упрощённая учебная модель, но для понимания Explore она полезна.

---

# 4. Разбираем вопросы на три части

## Пример 1. Общая выручка

Вопрос:

> Какова общая выручка?

```text
Dimension = пусто
Metric    = SUM(revenue)
Filter    = нет дополнительного отбора
```

Результат:

```text
4005.00
```

---

## Пример 2. Выручка по регионам

Вопрос:

> Какова выручка каждого региона?

```text
Dimension = region
Metric    = SUM(revenue)
Filter    = нет дополнительного отбора
```

---

## Пример 3. Выручка по продуктам за февраль

```text
Dimension = product
Metric    = SUM(revenue)
Filter    = февраль 2026
```

---

## Пример 4. Количество уникальных менеджеров по регионам

```text
Dimension = region
Metric    = COUNT_DISTINCT(manager)
Filter    = при необходимости период
```

Обратите внимание: `manager` здесь находится внутри Metric, потому что вопрос не просит показать каждого менеджера отдельно. Нужно **посчитать количество уникальных менеджеров**.

---

## Пример 5. Выручка по месяцам

```text
Dimension = sale_date
Time grain = Month
Metric    = SUM(revenue)
Filter    = нужный период
```

Здесь `sale_date` одновременно является временным Dimension, а `Time grain` говорит Superset, как объединять даты в группы.

---

# 5. Dimension и Filter — не одно и то же

Одна и та же колонка может использоваться по-разному.

Например `region`.

### Хотим увидеть каждый регион

```text
Dimension = region
```

### Хотим оставить только Север

```text
Filter = region IN Север
```

### Хотим увидеть продукты только Севера

```text
Dimension = product
Filter    = region IN Север
```

Поэтому вопрос всегда важнее названия колонки.

---

# 6. Можно использовать несколько Dimensions

Например:

> Выручка по регионам и продуктам.

```text
Dimensions:
region
product

Metric:
SUM(revenue)
```

Получаются группы вида:

```text
Север + Датчик
Север + Терминал
Юг + Датчик
Юг + Терминал
...
```

Каждый дополнительный Dimension делает результат детальнее.

Поэтому не добавляйте Dimensions просто потому, что поле кажется интересным.

---

# 7. Самая частая ошибка: считать строки вместо объектов

Вопрос:

> Сколько менеджеров работало?

Если один менеджер встречается в нескольких строках, то:

```text
COUNT(*)
```

посчитает строки, а не менеджеров.

Если нужны уникальные менеджеры:

```text
COUNT_DISTINCT(manager)
```

Как выбирать агрегирование подробно разобрано в следующей шпаргалке:

→ [Как выбрать SUM, COUNT, COUNT DISTINCT, AVG, MIN и MAX](06a-aggregations.md)

---

# 8. Если результат неожиданно один

Например, вы ожидали:

```text
Север
Юг
```

а получили только:

```text
4005.00
```

Сначала проверьте:

```text
Dimensions
```

Скорее всего `region` не добавлен.

---

# 9. Если пропала часть данных

Сначала проверьте:

```text
Filters
```

Особенно:

```text
Time Range / temporal filter
```

Старый фильтр может остаться после предыдущего эксперимента и незаметно ограничивать результат.

---

# 10. Алгоритм перед каждым Chart

Перед настройкой Explore сформулируйте вопрос обычным языком.

Затем заполните:

```text
1. Что считаю?
   → Metric

2. По чему хочу разделить результат?
   → Dimension

3. Какие данные должны участвовать?
   → Filter

4. Если есть время — какой период беру?
   → Time Range / temporal Filter

5. Если группирую по времени — с какой детализацией?
   → Time grain
```

Только после этого выбирайте визуализацию.

Выбор Chart разобран отдельно:

→ [Как выбрать визуализацию](07a-choose-visualization.md)

---

# 11. Контрольная таблица

| Формулировка задачи | Dimension | Metric | Filter |
|---|---|---|---|
| общая выручка | — | `SUM(revenue)` | — |
| выручка по регионам | `region` | `SUM(revenue)` | — |
| выручка Севера | — | `SUM(revenue)` | `region = Север` |
| выручка продуктов Севера | `product` | `SUM(revenue)` | `region = Север` |
| уникальные менеджеры по регионам | `region` | `COUNT_DISTINCT(manager)` | — |
| выручка по месяцам | `sale_date`, grain `Month` | `SUM(revenue)` | нужный период |
| средняя выручка по офисам | `office` | `AVG(revenue)` | — |

---

## Главное, что нужно запомнить

```text
Dimension
→ по чему делим

Metric
→ что считаем

Filter
→ что оставляем
```

Если эти три вещи перепутаны, красивый Chart не исправит неправильный аналитический запрос.

## Источники Superset 6.1.0

- общие controls `Dimensions`, `Metrics`, `Filters`, временная группировка: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/packages/superset-ui-chart-controls/src/shared-controls/dndControls.tsx>
- Table control panel: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/plugins/plugin-chart-table/src/controlPanel.tsx>
- редактор обычного Filter: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/FilterControl/AdhocFilterEditPopoverSimpleTabContent/index.tsx>
- пользовательский временной диапазон: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/controls/DateFilterControl/components/CustomFrame.tsx>
