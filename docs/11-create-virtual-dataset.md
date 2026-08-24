# 11. Создаём Virtual Dataset

## Что научимся делать

После этого урока вы должны уметь:

- объяснить разницу между физическим и виртуальным Dataset;
- выполнить понятный SQL-запрос в `SQL Lab`;
- открыть результат SQL в `Explore`;
- сохранить SQL как постоянный `Virtual Dataset`;
- найти созданный Virtual Dataset через `Data → Datasets`;
- снова открыть его в `Explore`;
- использовать столбцы Virtual Dataset так же, как столбцы обычного Dataset;
- построить и сохранить Chart на виртуальном источнике;
- понимать, когда Virtual Dataset удобен, а когда логику лучше перенести в саму базу данных.

В этом уроке мы не изучаем новый сложный SQL.

Наша задача — понять новую сущность Superset:

```text
Virtual Dataset
```

Поэтому SQL остаётся простым и использует только знакомые элементы.

## Что должно быть готово до начала

Должны быть полностью пройдены предыдущие уроки.

Особенно важны:

- [урок 04](04-create-dataset.md) — физический Dataset `sales`;
- [урок 05](05-explore-basics.md) — работа в Explore;
- [урок 06](06-metrics-and-calculations.md) — агрегирование и расчёты;
- [урок 07](07-create-charts.md) — создание и сохранение Chart;
- [урок 10](10-sql-lab.md) — базовый SQL Lab.

В Superset должны существовать:

```text
Database connection: Training PostgreSQL
Physical Dataset:    sales
```

В PostgreSQL должна существовать таблица:

```text
training.sales
```

Контрольные данные:

```text
строк      = 12
revenue    = 4005.00
cost       = 2475.00
profit     = 1530.00
```

Если учебный стенд остановлен, из каталога `training` запустите его:

```bash
docker compose up -d
```

---

# Сначала вспоминаем физический Dataset

В уроке 04 мы создали Dataset непосредственно на таблице PostgreSQL:

```text
PostgreSQL
    ↓
training.sales
    ↓
Superset Dataset sales
```

Источник такого Dataset — реальный объект базы данных:

```text
schema.table
```

В нашем случае:

```text
training.sales
```

Такой Dataset в этом курсе называем **физическим Dataset**.

Важно:

Superset не копировал 12 строк продаж в свою metadata database.

Он сохранил описание аналитического источника и при запросах обращается к PostgreSQL.

---

# Что такое Virtual Dataset

Virtual Dataset тоже является Dataset Superset, но вместо прямой ссылки на одну таблицу его источник задаётся SQL-запросом.

Упрощённо:

```text
Physical Dataset

training.sales
    ↓
Dataset
```

а Virtual Dataset:

```text
SQL-запрос
    ↓
Virtual Dataset
```

Например:

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

Этот SQL становится определением источника Dataset.

## Virtual Dataset не создаёт новую таблицу PostgreSQL

После сохранения Virtual Dataset в PostgreSQL не появляется таблица вроде:

```text
sales_virtual
```

Superset сохраняет определение Dataset и его SQL в своих metadata.

Когда затем Chart обращается к такому Dataset, PostgreSQL всё равно выполняет запрос к исходным данным.

То есть схема примерно такая:

```text
training.sales
      ↓
SQL Virtual Dataset
      ↓
Explore
      ↓
Chart
```

Это **не выгрузка** и **не копия строк**.

---

# Зачем в этом уроке добавляем profit через SQL

У нас уже есть столбцы:

```text
revenue
cost
```

и в уроке 06 мы считали прибыль как:

```text
revenue - cost
```

Теперь включим этот расчёт прямо в SQL виртуального источника:

```sql
revenue - cost AS profit
```

Результат SQL будет содержать новый столбец:

```text
profit
```

При этом исходная таблица PostgreSQL не изменяется.

В `training.sales` по-прежнему девять исходных столбцов.

В результате нашего SQL будет десять:

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
profit
```

Это хороший минимальный пример того, зачем может понадобиться Virtual Dataset:

> аналитическому источнику нужна удобная форма, но изменять исходную таблицу для учебной задачи мы не хотим.

---

# Шаг 1. Открываем SQL Lab

В верхнем меню откройте:

```text
SQL Lab → SQL Lab
```

Выберите:

```text
Database: Training PostgreSQL
Schema:   training
```

Если редактор сохранил предыдущий запрос из урока 10, удалите его или откройте новую вкладку SQL Editor.

---

# Шаг 2. Выполняем SQL будущего Virtual Dataset

Введите:

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

Нажмите:

```text
Run
```

## Что должно получиться

SQL Lab должен вернуть:

```text
12 rows
```

В таблице результата должны быть десять столбцов:

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
profit
```

Проверьте несколько строк вручную.

Например, первая продажа:

```text
revenue = 200.00
cost    = 120.00
profit  = 80.00
```

Потому что:

```text
200.00 - 120.00 = 80.00
```

Для продажи `sale_id = 12`:

```text
revenue = 725.00
cost    = 440.00
profit  = 285.00
```

Если `profit` не появился или запрос не возвращает 12 строк, не переходите дальше.

Сначала исправьте SQL.

---

# Почему мы не используем GROUP BY внутри Virtual Dataset

Технически Virtual Dataset может содержать гораздо более сложный SQL.

Например, туда можно было бы сразу записать агрегацию по регионам.

Но сейчас мы этого намеренно не делаем.

Наш SQL остаётся построчным:

```text
одна строка результата SQL
=
одна продажа
```

Это важно для обучения.

После сохранения Dataset мы сами решим в Explore, как группировать эти строки:

```text
region
```

и что считать:

```text
SUM(profit)
```

Так хорошо видны два разных уровня:

```text
Virtual Dataset SQL
→ формирует аналитические строки и столбцы

Explore
→ фильтрует, группирует и агрегирует эти строки для конкретного Chart
```

---

# Шаг 3. Открываем результат SQL в Explore

После успешного `Run` найдите над результатом SQL действие с подсказкой:

```text
Create chart
```

В Superset 6.1.0 оно отображается как кнопка с иконкой графика.

Нажмите её.

Откроется `Explore`.

## Что произошло

Пока мы **ещё не сохранили постоянный Virtual Dataset**.

Superset открыл результат SQL как временный query datasource, чтобы его можно было исследовать в Explore.

То есть на этом промежуточном шаге цепочка такая:

```text
SQL Lab query
     ↓
query datasource
     ↓
Explore
```

Это удобно для быстрой проверки результата, но нам нужен постоянный Dataset, который затем можно снова найти в `Data → Datasets`.

---

# Шаг 4. Сохраняем query datasource как Virtual Dataset

Посмотрите на левую часть Explore, где отображаются поля источника.

Для временного query datasource Superset показывает информационное сообщение со ссылкой:

```text
Create a dataset
```

и пояснением о том, что после создания Dataset можно редактировать или добавлять columns и metrics.

Нажмите:

```text
Create a dataset
```

Откроется окно:

```text
Save or Overwrite Dataset
```

В нём есть два основных варианта:

```text
Save as new
Overwrite existing
```

Нам нужен новый Dataset.

Выберите:

```text
Save as new
```

В поле имени укажите:

```text
sales_virtual
```

Нажмите:

```text
Save
```

Не используйте `Overwrite existing`.

Физический Dataset `sales` из урока 04 должен остаться отдельным объектом.

---

# Что мы только что сохранили

Теперь в Superset существуют два разных Dataset.

## Физический

```text
sales
```

Источник:

```text
training.sales
```

## Виртуальный

```text
sales_virtual
```

Источник:

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

Оба Dataset в итоге работают с одними исходными продажами, но описывают аналитический источник по-разному.

---

# Шаг 5. Проверяем, что Virtual Dataset действительно сохранён

Не ограничивайтесь тем, что после `Save` Explore продолжил работать.

Нужно проверить повторное открытие объекта.

Перейдите:

```text
Data → Datasets
```

Найдите:

```text
sales_virtual
```

Рядом с ним также должен существовать:

```text
sales
```

Это два разных Dataset.

Если `sales_virtual` не находится в списке, сохранение не завершилось.

## Открываем повторно

Нажмите на:

```text
sales_virtual
```

Должен открыться Explore уже на сохранённом Dataset.

В списке полей должны быть доступны в том числе:

```text
region
revenue
cost
profit
```

Главный новый столбец:

```text
profit
```

Если он есть, SQL виртуального источника действительно стал частью Dataset.

---

# Physical Dataset и Virtual Dataset выглядят похоже в Explore

Это одна из главных идей урока.

В Explore вы можете работать с обоими источниками привычным способом:

```text
Dataset
  ↓
columns
  ↓
metrics / ad hoc metrics
  ↓
filters
  ↓
Chart
```

Разница находится ниже — в том, **откуда Dataset получает строки**.

```text
sales
→ напрямую из training.sales

sales_virtual
→ из результата сохранённого SQL
```

Для пользователя Explore оба являются аналитическими Dataset.

---

# Как Superset выполняет запрос к Virtual Dataset

Не нужно запоминать внутренний SQL Superset дословно.

Важно понимать принцип.

Наш Virtual Dataset определён запросом:

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

Если в Explore затем попросить:

```text
Group by = region
Metric   = SUM(profit)
```

то логика запроса концептуально выглядит примерно так:

```sql
SELECT
    region,
    SUM(profit)
FROM (
    -- SQL Virtual Dataset
) AS virtual_dataset
GROUP BY region
```

Это **упрощённая схема для понимания**, а не обещание точного текста SQL, который Superset сгенерирует в каждой ситуации.

Главное:

```text
SQL Virtual Dataset
становится входными данными
для запроса Explore
```

Поэтому слишком тяжёлый SQL внутри Virtual Dataset не становится бесплатным только из-за того, что он сохранён в Superset.

---

# Шаг 6. Строим Chart на Virtual Dataset

Теперь используем уже знакомый навык.

Нужно ответить на вопрос:

> какую прибыль дали Север и Юг?

В Explore на Dataset:

```text
sales_virtual
```

выберите визуализацию:

```text
Generic Chart
```

Для ряда используйте:

```text
Bar
```

Настройте категорию:

```text
region
```

Добавьте временную ad hoc metric:

```text
SUM(profit)
```

Запустите запрос.

Ожидаемый результат:

| region | profit |
|---|---:|
| Север | 520.00 |
| Юг | 1010.00 |

Проверка общей суммы:

```text
520 + 1010 = 1530
```

Это тот же общий profit, который мы получали раньше:

```text
1530.00
```

Если значения другие, проверьте:

1. выбран ли именно `sales_virtual`;
2. используется ли `region` как категория;
3. используется ли `SUM(profit)`, а не просто `profit`;
4. нет ли оставшегося фильтра или Time Range.

---

# Шаг 7. Сохраняем Chart

Нажмите:

```text
Save
```

Сохраните Chart под именем:

```text
Прибыль по регионам — Virtual Dataset
```

Новый Dashboard для него создавать не нужно.

Цель урока — доказать, что Virtual Dataset является полноценным источником для Explore и Chart.

После сохранения перейдите в:

```text
Charts
```

и убедитесь, что Chart можно снова найти по имени.

---

# Проверяем источник сохранённого Chart

Откройте:

```text
Прибыль по регионам — Virtual Dataset
```

Вернитесь в режим редактирования Chart, если он открылся только для просмотра.

Проверьте источник:

```text
sales_virtual
```

Он не должен случайно переключиться на физический:

```text
sales
```

Это простой, но важный контроль.

Chart может показывать те же числа, что Chart на физическом Dataset, но источник у него другой.

---

# Почему результаты совпали с физическим Dataset

Мы не поменяли сами продажи.

Virtual Dataset использует ту же таблицу:

```text
training.sales
```

и лишь добавляет вычисляемый столбец:

```text
profit = revenue - cost
```

Поэтому итог:

```text
Север = 520.00
Юг    = 1010.00
```

совпадает с уроком 06.

Это полезная проверка корректности.

Новый способ описания источника не должен сам по себе менять математику данных.

---

# Virtual Dataset и Calculated Column — не одно и то же

В уроке 06 мы уже создавали Calculated Column:

```text
profit
```

Там выражение было частью Dataset metadata:

```text
Dataset sales
└── Calculated Column profit
```

Сейчас `profit` рождается внутри SQL:

```text
Virtual Dataset sales_virtual
└── SQL
    └── revenue - cost AS profit
```

С точки зрения последующего Explore мы снова видим столбец `profit`, но происхождение разное.

## Calculated Column

Подходит, когда:

- источник уже хороший;
- нужен простой row-level расчёт;
- не требуется перестраивать сам набор строк;
- расчёт удобно хранить в semantic layer Dataset.

## Virtual Dataset

Полезен, когда SQL должен определить сам аналитический набор данных:

- выбрать только нужные столбцы;
- переименовать их;
- добавить SQL-выражения;
- отфильтровать ненужные строки;
- позже, на более продвинутом уровне, объединить или преобразовать данные.

Не нужно превращать любой Calculated Column в Virtual Dataset.

Используйте более простой механизм, если его достаточно.

---

# Virtual Dataset и database VIEW — тоже не одно и то же

Оба механизма могут скрывать SQL за удобным аналитическим источником, но живут на разных уровнях.

## Virtual Dataset

Определяется в Superset.

Упрощённо:

```text
Superset metadata
└── Dataset
    └── SQL
```

Он удобен, если логика нужна прежде всего внутри Superset и не требует отдельного объекта в PostgreSQL.

## VIEW в PostgreSQL

Определяется в самой базе данных:

```text
PostgreSQL
└── VIEW
```

Такой объект могут использовать не только Superset, но и другие приложения и инструменты, которым доступна база.

---

# Когда Virtual Dataset — хороший выбор

Для базового уровня используйте его, когда одновременно выполняются условия:

- нужный источник удобно выразить понятным SQL;
- SQL не слишком тяжёлый;
- логика нужна прежде всего для аналитики в Superset;
- отдельная физическая таблица или VIEW в базе ради этой небольшой логики избыточны;
- вы понимаете, какие строки и столбцы возвращает запрос.

Например, наш учебный случай:

```text
training.sales
+
profit = revenue - cost
```

для знакомства с механизмом подходит хорошо.

---

# Когда не стоит прятать проблему в Virtual Dataset

Virtual Dataset — не замена нормальной модели данных.

Если логика:

- используется многими системами, а не только Superset;
- очень тяжёлая;
- содержит большое количество преобразований;
- постоянно копируется между несколькими Dataset;
- требует централизованного контроля;
- должна стабильно и быстро обслуживать много пользователей;

то стоит рассмотреть изменение модели в базе, VIEW, materialized view или заранее подготовленную аналитическую таблицу.

Конкретное решение зависит от архитектуры данных.

Главная мысль для новичка:

> Virtual Dataset удобен, но не делает тяжёлый SQL автоматически быстрым и не исправляет плохую модель данных.

---

# Не агрегируйте данные заранее без причины

Для Superset особенно важно понимать два уровня вычислений.

Если Virtual Dataset уже делает:

```sql
GROUP BY region
```

а затем Chart снова группирует результат, получается несколько уровней агрегации.

Иногда это необходимо.

Но если вы не можете объяснить, зачем нужны оба уровня, архитектура становится трудной для проверки.

В этом курсе придерживаемся простого правила:

```text
сначала сохраняем понятные аналитические строки в Dataset
        ↓
затем агрегируем их под конкретный вопрос в Explore
```

Это не универсальный запрет на агрегированные Virtual Dataset.

Это безопасное правило для первого уровня обучения.

---

# Что произойдёт, если изменить исходные данные

Представим, что завтра в `training.sales` появилась новая продажа.

Virtual Dataset не нужно вручную «перезагружать» как Excel-файл только потому, что появилась новая строка.

Его SQL снова обращается к исходной таблице при выполнении аналитического запроса.

Поэтому:

```text
Virtual Dataset
≠ снимок данных на момент сохранения
```

Он является сохранённым определением запроса.

При этом кэширование Superset и возможности конкретной базы могут влиять на то, когда пользователь увидит обновлённый результат. Кэширование в этом базовом курсе мы отдельно не настраиваем.

---

# Что произойдёт, если изменить SQL Virtual Dataset

Если позже изменить SQL самого Virtual Dataset, вы меняете источник для Chart, которые на него опираются.

Например, если убрать из SQL:

```text
profit
```

то Chart с:

```text
SUM(profit)
```

больше не сможет использовать этот столбец.

Поэтому Virtual Dataset — уже не временный текст в SQL Lab.

После появления зависимых Chart это полноценный объект аналитической модели.

Изменять его нужно осознанно.

В этом уроке SQL `sales_virtual` после создания больше не меняем.

---

# Не путайте три разных состояния SQL

После уроков 10 и 11 у нас появилось три близких по виду, но разных вещи.

## SQL в SQL Lab

```text
текст запроса в редакторе
```

Можно менять и запускать для исследования.

Сам по себе выполненный запрос ещё не обязан быть Dataset.

## Временный query datasource

Появляется, когда после результата SQL Lab нажимаем:

```text
Create chart
```

Superset позволяет открыть результат в Explore.

Это промежуточный аналитический источник.

## Virtual Dataset

Появляется после:

```text
Create a dataset
→ Save as new
→ Save
```

Он сохраняется как объект Dataset и доступен через:

```text
Data → Datasets
```

Именно третий вариант нам нужен для повторного использования.

---

# Полная цепочка урока

Теперь вы должны понимать весь путь без магии:

```text
PostgreSQL
    ↓
training.sales
    ↓
SQL Lab
    ↓
SELECT ... revenue - cost AS profit
    ↓
Run
    ↓
12 строк результата
    ↓
Create chart
    ↓
временный query datasource в Explore
    ↓
Create a dataset
    ↓
Save as new: sales_virtual
    ↓
Virtual Dataset
    ↓
Explore
    ↓
region + SUM(profit)
    ↓
Generic Chart / Bar
    ↓
Прибыль по регионам — Virtual Dataset
```

---

# Самостоятельная проверка урока

После прохождения основной инструкции выполните следующую работу без копирования шагов один в один.

## Задание 1

Вернитесь в `Data → Datasets` и найдите одновременно:

```text
sales
sales_virtual
```

Объясните вслух или письменно:

```text
что является источником sales
что является источником sales_virtual
```

## Задание 2

Откройте `sales_virtual` в Explore.

Соберите обычную Table:

```text
Group by = product
Metric   = SUM(profit)
```

Контроль:

| product | profit |
|---|---:|
| Маршрутизатор | 630.00 |
| Датчик | 475.00 |
| Терминал | 425.00 |

Общий итог:

```text
630 + 475 + 425 = 1530
```

Эту таблицу сохранять не обязательно.

## Задание 3

Ответьте без подсказки:

> появилась ли в PostgreSQL таблица `sales_virtual`?

Правильный ответ:

```text
нет
```

Потому что Virtual Dataset — объект Superset с SQL-определением, а не автоматически созданная физическая таблица PostgreSQL.

## Задание 4

Объясните разницу:

```text
Calculated Column profit в physical Dataset
```

и:

```text
revenue - cost AS profit внутри SQL Virtual Dataset
```

Если вы можете объяснить это без фразы «они просто одинаковые», граница между механизмами понятна.

---

# Типовые проблемы

## После Run нет Create chart

Сначала проверьте:

1. запрос действительно успешно выполнен;
2. выбран `Training PostgreSQL`;
3. результат SQL появился во вкладке `Results`;
4. используется учебное подключение из предыдущих уроков.

Кнопка `Create chart` в SQL Lab зависит от того, разрешает ли конкретное database connection исследовать результаты виртуальной таблицы.

Для учебного PostgreSQL этот путь должен быть доступен.

Если кнопки всё равно нет, не пытайтесь компенсировать это созданием физической таблицы через `CREATE TABLE`: это уже другой механизм и не соответствует задаче урока.

## Create chart открыл Explore, но sales_virtual ещё нет в Datasets

Это нормально, если вы ещё не нажали:

```text
Create a dataset
```

`Create chart` сначала открывает временный query datasource.

Постоянный Virtual Dataset появляется только после сохранения Dataset.

## В Explore нет ссылки Create a dataset

Проверьте, что вы пришли именно из результата SQL Lab через:

```text
Create chart
```

а не открыли физический Dataset `sales` из списка Datasets.

Ссылка нужна именно для сохраняемого query datasource.

## Случайно выбрали Overwrite existing

Не перезаписывайте:

```text
sales
```

Закройте окно и снова выполните сохранение через:

```text
Save as new
```

с именем:

```text
sales_virtual
```

## sales_virtual уже существует

Не создавайте бесконечные копии:

```text
sales_virtual_2
sales_virtual_final
sales_virtual_final2
```

Если объект уже был создан при предыдущей попытке и он корректный, используйте его.

Если хотите полностью повторить урок, удалите только учебный `sales_virtual`, убедившись, что он не нужен сохранённому Chart, и создайте заново.

## В результате нет profit

Вернитесь в SQL Lab и проверьте выражение:

```sql
revenue - cost AS profit
```

Не создавайте пустой Calculated Column только для того, чтобы скрыть ошибку SQL этого урока.

## SUM(profit) даёт неправильный результат

Ожидается:

```text
Север = 520.00
Юг    = 1010.00
```

Проверьте:

- Dataset `sales_virtual`;
- отсутствие ненужных фильтров;
- `Group by = region`;
- агрегацию именно `SUM(profit)`;
- исходный SQL Virtual Dataset.

---

# Критерии завершения урока

Урок можно считать пройденным, если вы без пошаговой подсказки можете:

1. открыть SQL Lab;
2. выполнить простой SELECT к `training.sales`;
3. добавить `revenue - cost AS profit`;
4. получить 12 строк и столбец `profit`;
5. открыть SQL-result через `Create chart`;
6. объяснить, почему в этот момент постоянного Dataset ещё может не быть;
7. нажать `Create a dataset`;
8. сохранить новый Dataset как `sales_virtual`;
9. найти его через `Data → Datasets`;
10. объяснить разницу между `sales` и `sales_virtual`;
11. открыть `sales_virtual` повторно в Explore;
12. построить `region + SUM(profit)`;
13. получить `520.00` и `1010.00`;
14. сохранить Chart `Прибыль по регионам — Virtual Dataset`;
15. объяснить, почему Virtual Dataset не создаёт автоматически таблицу `sales_virtual` в PostgreSQL;
16. объяснить различие между Virtual Dataset и Calculated Column;
17. назвать хотя бы одну ситуацию, когда логику разумнее перенести в модель или VIEW базы данных.

## Что в этом уроке сознательно не изучали

Не разбираем:

- `JOIN`;
- CTE и `WITH`;
- подзапросы как отдельную тему SQL;
- оконные функции;
- Jinja;
- SQL templating;
- параметры Virtual Dataset;
- вложенные Dataset macros;
- сложные агрегированные Virtual Dataset;
- производительность больших Virtual Dataset;
- materialized views подробно;
- архитектуру DWH;
- управление зависимостями Dataset;
- RLS для Virtual Dataset.

Все эти темы могут быть полезны позже, но не нужны для первого рабочего цикла.

## Что дальше

Базовая цепочка Superset теперь практически собрана полностью:

```text
PostgreSQL
→ Dataset
→ Explore
→ Metric / Calculated Column
→ Chart
→ Dashboard
→ Native Filters
→ SQL Lab
→ Virtual Dataset
```

В последнем уроке не будем добавлять ещё один инструмент.

Вместо этого проверим, можете ли вы пройти эту цепочку самостоятельно без пошаговых подсказок, и зафиксируем карту дальнейшего изучения.

→ [Урок 12. Итоговая проверка и что изучать дальше](12-next-steps.md)

## Официальные источники

- Apache Superset 6.1.0 — Introduction: <https://superset.apache.org/user-docs/6.1.0/intro/>
- Apache Superset 6.1.0 — FAQ, раздел о таблицах, views и SQL Lab: <https://superset.apache.org/user-docs/6.1.0/faq/>
- Apache Superset 6.1.0 — SQL templating, где отдельно рассматриваются SQL Lab и virtual datasets: <https://superset.apache.org/admin-docs/6.1.0/configuration/sql-templating/>
- Apache Superset 6.1.0 — Dataset API: <https://superset.apache.org/developer-docs/6.1.0/api/datasets/>
- Исходный код Superset 6.1.0 — `Create chart` для результата SQL Lab: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ExploreResultsButton/index.tsx>
- Исходный код Superset 6.1.0 — переход из результата SQL Lab в Explore: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/ResultSet/index.tsx>
- Исходный код Superset 6.1.0 — `Create a dataset` для query datasource в Explore: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/explore/components/DatasourcePanel/index.tsx>
- Исходный код Superset 6.1.0 — окно `Save or Overwrite Dataset`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/SqlLab/components/SaveDatasetModal/index.tsx>
- Учебная структура таблицы: [`../training/schema.sql`](../training/schema.sql)
- Учебные строки: [`../training/data.sql`](../training/data.sql)