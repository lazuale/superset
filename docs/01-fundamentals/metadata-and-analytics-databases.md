# Metadata database и analytics database

## Зачем это нужно

Слово `database` встречается в Superset на разных уровнях. Если их смешать, дальше ломается понимание backup, нагрузки, Dataset и безопасности.

## Metadata database

Внутреннее хранилище состояния Superset. В нём находятся metadata приложения: определения объектов, пользователи, роли и другие служебные записи.

Backend connection к metadata database задаётся конфигурацией Superset, в том числе через `SQLALCHEMY_DATABASE_URI`.

## Analytics database

Внешний источник, по которому Superset выполняет аналитические запросы. Там находятся таблицы, views и строки предметной области.

```text
metadata database          analytics database
-----------------          ------------------
состояние Superset         данные предметной области
Charts / Dashboards        training.sales
users / roles              tables / views
connection metadata        вычисления в СУБД
```

Сохранение Database Connection в Superset не копирует строки аналитической таблицы в metadata database.

В учебном sandbox обе логические базы могут находиться в одном PostgreSQL instance, но их ответственность остаётся разной.

## Контрольные вопросы

1. Что нужно сохранить, чтобы не потерять определения Dashboards?
2. Где должна находиться `training.sales`?
3. Почему нагрузку аналитического SQL нельзя оценивать только по metadata database?

## Официальные источники

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/admin_docs/installation/architecture.mdx
```

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/admin_docs/configuration/configuring-superset.mdx
```

## Статус проверки

```text
Тип страницы: concept
Документировано для: Apache Superset 6.1.0
Проверка реализации: не требовалась
Проверка на стенде: неприменима
```

## Навигация

- Предыдущая тема: [`analytics-architecture.md`](analytics-architecture.md)
- Следующая тема: [`objects-and-concepts.md`](objects-and-concepts.md)
