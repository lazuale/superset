# Apache Superset 6.1.0 — вики для новичка

Это практический курс по Apache Superset для человека, который открывает его впервые.

Здесь не нужно заранее знать SQL, разбираться в Docker или понимать внутреннее устройство Superset. Сначала мы поднимем готовый учебный стенд, затем последовательно пройдём обычный путь пользователя: подключим PostgreSQL, создадим Dataset, поработаем в Explore, построим графики, соберём Dashboard и только после этого доберёмся до SQL Lab и Virtual Dataset.

Курс зафиксирован на **Apache Superset 6.1.0**. Это важно: интерфейс Superset меняется, поэтому инструкции и названия элементов проверяются именно для этой версии.

## Что понадобится

Нужны обычный компьютер, браузер и Docker с поддержкой `docker compose`. На Windows используем **Docker Desktop + WSL 2 + Linux-контейнеры**; команды курса выполняются в WSL 2. На macOS и Linux достаточно обычного терминала.

PostgreSQL отдельно устанавливать не нужно — он уже входит в учебный стенд.

## Получаем файлы курса

Если Git установлен:

```bash
git clone https://github.com/lazuale/superset.git
cd superset
```

Если Git нет, на странице репозитория выберите:

```text
Code → Download ZIP
```

Распакуйте архив и откройте терминал в корневом каталоге репозитория — там, где находятся `README.md`, `docs/` и `training/`.

Команды `docker compose ...` в уроках выполняются из каталога:

```text
training/
```

если в конкретном месте не сказано иначе.

## Как здесь используются английские названия

Текст курса написан по-русски, но названия элементов Superset оставлены такими, какими их нужно искать в интерфейсе. Поэтому `Explore`, `Dataset`, `Metric`, `Save`, `Is temporal` или `Time grain` не переводятся в инструкциях, если перевод только мешает найти нужное место.

То же относится к SQL, командам, именам файлов и техническим идентификаторам. В обычном объяснении, наоборот, нет смысла писать «temporal-столбец» или «production deployment», если можно нормально сказать «временной столбец» или «промышленное развёртывание».

## Учебный маршрут

Основные уроки лучше проходить по порядку. Они специально собраны так, чтобы каждый следующий шаг опирался на уже созданные объекты.

1. [Что такое Apache Superset](docs/01-what-is-superset.md)
2. [Запускаем учебный Superset](docs/02-start-training-superset.md)
3. [Подключаем PostgreSQL](docs/03-connect-postgresql.md)
4. [Создаём первый Dataset](docs/04-create-dataset.md)
5. [Осваиваем Explore](docs/05-explore-basics.md)
   - [Dimension, Metric и Filter без путаницы](docs/05a-dimension-metric-filter.md)
   - [Time column, Time range и Time grain](docs/05b-time-range-and-grain.md)
6. [Метрики и расчёты](docs/06-metrics-and-calculations.md)
   - [SUM, COUNT, COUNT DISTINCT, AVG, MIN и MAX](docs/06a-aggregations.md)
   - [Calculated Column, Metric или SQL?](docs/06b-calculated-column-metric-or-sql.md)
   - [Зерно Dataset — что означает одна строка](docs/06c-data-grain.md)
7. [Строим и сохраняем Chart](docs/07-create-charts.md)
   - [Как выбрать визуализацию](docs/07a-choose-visualization.md)
   - [Почему цифры в Superset не сходятся](docs/07b-troubleshoot-wrong-numbers.md)
   - [Форматы чисел, процентов и дат](docs/07c-formatting.md)
   - [Каталог Chart Apache Superset 6.1.0](docs/reference/charts-catalog-6.1.0.md)
8. [Собираем Dashboard](docs/08-build-dashboard.md)
   - [Как спроектировать нормальный Dashboard](docs/08a-dashboard-design.md)
9. [Добавляем Native Filters](docs/09-native-filters.md)
   - [Как выбрать Native Filter и настроить Scoping](docs/09a-choose-native-filter.md)
10. [SQL Lab с нуля](docs/10-sql-lab.md)
    - [Минимальный SQL для Superset](docs/10a-minimal-sql-cheatsheet.md)
    - [JOIN без размножения данных](docs/10b-join-without-duplication.md)
    - [Следующий уровень SQL](docs/reference/sql-next-level.md)
11. [Создаём Virtual Dataset](docs/11-create-virtual-dataset.md)
    - [Physical Dataset или Virtual Dataset?](docs/11a-physical-vs-virtual-dataset.md)
12. [Итоговая проверка и что изучать дальше](docs/12-next-steps.md)
    - [Где заканчивается Superset](docs/12a-what-belongs-in-superset.md)

Шпаргалки и справочники не нужно читать подряд. Они нужны тогда, когда соответствующая тема уже встретилась на практике и в ней возник вопрос.

## Учебные данные

Весь базовый маршрут работает с одной небольшой таблицей:

```text
training.sales
```

В ней всего 12 строк. Данных намеренно мало: результат любого упражнения можно проверить руками, а не верить графику только потому, что он красиво отрисовался.

Контрольные значения в уроках приводятся точно. Например:

```text
Север = 1360.00
Прибыль = 1530.00
```

При этом Superset может показать `1360` как `1.36k`. Это не ошибка расчёта, а только формат отображения. Оформлением чисел занимаемся отдельно после того, как убедились, что сама математика правильная.

Описание стенда и полный набор контрольных чисел находятся в [`training/README.md`](training/README.md).

## Что должно получиться в конце

Финальный урок не ведёт за руку. На чистом стенде нужно самостоятельно пройти тот же путь, который раньше выполнялся по инструкции: подключить базу, создать Dataset, получить результаты в Explore, добавить расчёты, сохранить четыре базовых Chart, собрать Dashboard, настроить Native Filters, выполнить контрольные SQL-запросы и создать Virtual Dataset.

Если всё это получается без пошаговой подсказки и контрольные числа сходятся, базовый курс выполнен. Дальше уже имеет смысл идти в безопасность, эксплуатацию, более сложный SQL, встраивание и другие темы — не раньше.