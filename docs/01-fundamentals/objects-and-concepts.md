# Объекты Superset и аналитические понятия

## Зачем это нужно

В интерфейсе рядом находятся сущности разных уровней. Если всё называть «объектами Superset», дальнейшая модель становится противоречивой.

## Четыре уровня

| Уровень | Примеры | Где существует |
|---|---|---|
| объекты Superset | Database Connection, Dataset, saved Dataset Metric, Chart, Dashboard, Saved Query, Role | metadata Superset |
| объекты СУБД | database, schema, table, view | подключённая СУБД |
| аналитические понятия | grain, dimension, measure, fact | модель анализа |
| инфраструктура | metadata DB, cache, worker, beat, reverse proxy | среда развёртывания |

## Ключевые различия

**Database Connection** — сохранённая конфигурация доступа к источнику, а не сама PostgreSQL database.

**Dataset** — объект Superset, описывающий анализируемый набор и связанную metadata. Создание Dataset не означает копирование строк исходной таблицы.

**Metric** в интерфейсе может быть adhoc в конкретном запросе или сохранённой в Dataset. Поэтому слово `Metric` нельзя определять только как «сохранённое выражение».

**Chart** — сохраняемая конфигурация визуализации и запроса к Dataset.

**Dashboard** — сохраняемый объект компоновки и взаимодействия Charts и dashboard-компонентов.

**dimension**, **measure** и **grain** — аналитические понятия, а не самостоятельные metadata-объекты уровня Dataset или Dashboard.

## Минимальная зависимость

```text
PostgreSQL table/view
        ↓
Database Connection
        ↓
Dataset
        ↓
query / Explore
        ↓
Chart
        ↓
Dashboard
```

Схема показывает зависимость, а не физическое перемещение строк.

## Контрольные вопросы

1. Table и Dataset — один объект или два связанных объекта?
2. Где хранится определение Chart?
3. Может ли Metric быть adhoc?
4. Является ли dimension отдельной metadata-сущностью Superset?

## Официальные источники

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/docs/index.mdx
```

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/docs/using-superset/exploring-data.mdx
```

## Статус проверки

```text
Тип страницы: concept
Документировано для: Apache Superset 6.1.0
Проверка реализации: не требовалась
Проверка на стенде: неприменима
```

## Навигация

- Предыдущая тема: [`metadata-and-analytics-databases.md`](metadata-and-analytics-databases.md)
- Следующая тема: [`query-lifecycle.md`](query-lifecycle.md)
