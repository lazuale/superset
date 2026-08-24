# Что такое Apache Superset

## Зачем это нужно

Superset нужно сначала понять как слой аналитики поверх существующих источников данных, а не как место хранения бизнес-данных.

## Термины и типы понятий

**Apache Superset** — BI web application.

**Analytics database / query engine** — внешний источник, где находятся анализируемые данные и выполняется SQL.

**Metadata database** — внутреннее хранилище состояния самого Superset.

## Границы темы

Superset подключается к SQL-совместимым источникам и предоставляет Explore, SQL Lab, Charts, Dashboards и semantic capabilities вокруг Datasets, columns и Metrics.

Он не становится из-за этого DWH, ETL/ELT-системой или каноническим хранилищем бизнес-данных.

```text
analytics database → хранит и обрабатывает данные
Superset            → формирует аналитические запросы и визуализирует результат
```

Создание Chart или Dashboard не переносит строки исходной таблицы в Superset как новую копию бизнес-данных.

## Что происходит при работе

В упрощённом виде:

```text
пользователь
    ↓
Superset
    ↓
получение аналитического результата
    ↓
Chart / Dashboard
```

Где именно берётся результат — из cache или через новый запрос к источнику — разбирается отдельно в [`query-lifecycle.md`](query-lifecycle.md).

## Контрольные вопросы

1. Где находятся строки продаж, показанные на Dashboard?
2. Почему удаление Chart не удаляет исходную таблицу?
3. Почему Metric в Superset не заменяет модель данных в аналитической БД?

## Официальные источники

```text
upstream: apache/superset
version:  6.1.0
ref:      c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path:     docs/docs/index.mdx
```

```text
upstream: apache/superset
version:  6.1.0
ref:      c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path:     docs/docs/using-superset/creating-your-first-dashboard.mdx
```

## Статус проверки

```text
Тип страницы: concept
Документировано для: Apache Superset 6.1.0
Проверка реализации: не требовалась
Проверка на стенде: неприменима
```

## Навигация

- Этап: [`README.md`](README.md)
- Следующая тема: [`analytics-architecture.md`](analytics-architecture.md)
