# 11. Создаём Virtual Dataset

В прошлом уроке SQL жил только в SQL Lab. Теперь сохраним результат как полноценный Dataset и снова вернёмся в Explore.

После урока должны появиться:

```text
Virtual Dataset: sales_virtual
Chart: Прибыль по регионам — Virtual Dataset
```

`training.sales` при этом останется обычной физической таблицей PostgreSQL. Никакой новой таблицы `sales_virtual` в базе не создаётся.

## Что меняется по сравнению с Physical Dataset

Наш обычный Dataset `sales` напрямую указывает на таблицу:

```text
PostgreSQL: training.sales
        ↓
Physical Dataset: sales
```

Virtual Dataset вместо физической таблицы хранит SQL-запрос.

В этом уроке запрос будет специально простым и построчным:

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
FROM training.sales;
```

У исходной таблицы девять полей, у результата — десять. Добавляется `profit`, но зерно не меняется:

```text
1 строка = 1 продажа
```

Это важнее самого факта появления десятого столбца.

## Выполняем SQL

Откройте:

```text
SQL → SQL Lab
```

Выберите:

```text
Database: Training PostgreSQL
Schema:   training
```

Выполните запрос выше.

Ожидается:

```text
12 строк
10 столбцов
```

Для быстрой проверки:

```text
sale_id = 1
revenue = 200.00
cost    = 120.00
profit  = 80.00

sale_id = 12
revenue = 725.00
cost    = 440.00
profit  = 285.00
```

Если уже здесь результат неверный, ничего не сохраняйте. Сначала исправьте SQL.

## Открываем SQL-результат в Explore

У результата SQL Lab нажмите:

```text
Create chart
```

Explore откроется на временном источнике, построенном из результата запроса.

На этом месте часто возникает путаница: **постоянного Dataset ещё нет**.

Пока цепочка выглядит так:

```text
SQL Lab → результат запроса → временный источник Explore
```

В исходном коде такой временный объект называется `query datasource`. Для практики достаточно понимать, что он существует только как промежуточный источник перед сохранением Dataset.

## Сохраняем постоянный Virtual Dataset

В левой панели Explore появится сообщение:

```text
Create a dataset to edit or add columns and metrics.
```

Нажмите:

```text
Create a dataset
```

В окне:

```text
Save or Overwrite Dataset
```

выберите:

```text
Save as new
```

и задайте имя:

```text
sales_virtual
```

После `Save` Explore уже будет работать не с временным результатом SQL Lab, а с сохранённым Virtual Dataset.

`Overwrite existing` здесь не используйте: физический Dataset `sales` должен остаться отдельным объектом.

## Проверяем, что получилось

Откройте `Datasets`. Теперь в списке должны одновременно быть:

```text
sales
sales_virtual
```

У `sales_virtual` в колонке `Type` ожидается:

```text
Virtual
```

Откройте его и проверьте наличие `region`, `revenue`, `cost` и `profit`.

Разница между двумя Dataset теперь хорошо видна:

```text
sales
→ физическая таблица training.sales

sales_virtual
→ сохранённый SQL-запрос
```

Оба при этом читают одни и те же 12 учебных продаж.

## Строим Chart на sales_virtual

Откройте `sales_virtual` в Explore и выберите:

```text
Bar Chart
```

Настройте:

```text
X Axis:     region
Metrics:    SUM(profit)
Dimensions: пусто
```

Активных фильтров быть не должно.

После `Create chart` ожидается:

| region | profit |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

Общая сумма:

```text
1530.00
```

Результат совпадает с Physical Dataset не случайно. В обоих случаях используются те же 12 продаж и та же построчная формула:

```text
profit = revenue - cost
```

Различается только место, где эта формула определена:

```text
sales
→ Calculated Column Superset

sales_virtual
→ SQL: revenue - cost AS profit
```

## Сохраняем Chart

Нажмите `Save` и выберите:

```text
Save as...
```

Имя:

```text
Прибыль по регионам — Virtual Dataset
```

Dashboard выбирать не нужно.

После сохранения откройте `Charts`, найдите этот объект и снова войдите в Explore.

Проверьте:

```text
Chart Source = sales_virtual
```

Если источником оказался `sales`, упражнение не выполнено — график построен на старом Physical Dataset.

## Что важно понять про Virtual Dataset

Virtual Dataset хранит **определение SQL**, а не снимок строк на момент сохранения.

Если изменится `training.sales`, следующий запрос к `sales_virtual` может вернуть уже другие данные.

Если изменить сам SQL Virtual Dataset, это может сломать зависимые Chart. Например, уберёте `profit` — `SUM(profit)` больше не из чего будет считать.

И ещё раз про зерно: мы намеренно не добавляли `GROUP BY`. Если заранее свернуть данные до регионов, Virtual Dataset уже перестанет означать «одна строка = одна продажа». Иногда это нормально, но должно быть осознанным решением.

## Три объекта, которые легко спутать

После этого урока стоит чётко различать:

1. SQL-текст и результат в SQL Lab;
2. временный источник Explore после `Create chart`;
3. постоянный `sales_virtual` после `Create a dataset`.

Только третий объект появляется в `Datasets` и предназначен для повторного использования.

## Проверьте себя

На `sales_virtual` соберите Table:

```text
Dimensions = product
Metrics    = SUM(profit)
```

Ожидается:

```text
Маршрутизатор = 630.00
Датчик        = 475.00
Терминал      = 425.00
```

Сумма:

```text
1530.00
```

После этого ответьте без интерфейса:

- где хранится SQL `sales_virtual`;
- создалась ли физическая таблица `sales_virtual` в PostgreSQL;
- что означает одна строка результата.

Правильные ответы: SQL хранится в метаданных Superset как определение Dataset, физической таблицы нет, одна строка по-прежнему означает одну продажу.

## Если что-то не сходится

Если `Create chart` у результата SQL Lab недоступна, сначала убедитесь, что запрос успешно выполнен. В Superset 6.1.0 открытие результата в Explore также зависит от возможности подзапросов; в исходном коде проверяется `allows_subquery`.

Если после `Create chart` в `Datasets` ещё нет `sales_virtual`, это нормально: вы пока открыли только временный источник. Постоянный Dataset появляется после:

```text
Create a dataset → Save as new → Save
```

Если в Chart появился лишний `COUNT(*)`, удалите его из `Metrics`.

Если SQL возвращает не 12 строк, проверьте, не появились ли случайно `GROUP BY` или ограничивающий `WHERE`.

Если `sales_virtual` уже существует, не нажимайте `Overwrite existing` автоматически. Сначала убедитесь, что существующий объект действительно соответствует этому уроку.

## Перед итоговой проверкой

Должно быть так:

```text
Physical Dataset = sales
Virtual Dataset  = sales_virtual
```

`sales_virtual` возвращает:

```text
12 строк
10 столбцов
1 строка = 1 продажа
profit присутствует
```

А Chart:

```text
Прибыль по регионам — Virtual Dataset
Chart Source = sales_virtual
Север = 520.00
Юг    = 1010.00
```

Если хочется отдельно разобраться, когда выбирать Physical или Virtual Dataset и когда SQL уже лучше вынести в слой данных, смотрите [справочник по границе Physical/Virtual](11a-physical-vs-virtual-dataset.md).

Следующий урок — уже без ведения за руку: повторяем весь маршрут самостоятельно.

→ [Урок 12. Итоговая проверка](12-next-steps.md)

## Источники Superset 6.1.0

- кнопка результата SQL Lab `Create chart` и проверка `allows_subquery`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ExploreResultsButton/index.tsx>
- SQL Lab: <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/SqlLab>
- модель Dataset SQLAlchemy: <https://github.com/apache/superset/blob/6.1.0/superset/connectors/sqla/models.py>
- Explore: <https://github.com/apache/superset/tree/6.1.0/superset-frontend/src/explore>