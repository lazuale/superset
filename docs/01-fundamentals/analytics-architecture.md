# Superset в аналитической архитектуре

## Зачем это нужно

Один Dashboard затрагивает несколько слоёв. Без их разделения невозможно нормально диагностировать ошибки, нагрузку и права доступа.

## Базовая схема

```text
пользователь
    ↓
Superset application
    ↓
analytics database / query engine
    ↓
результат запроса
    ↓
Superset application
    ↓
Chart / Dashboard
```

Рядом существует отдельный контур:

```text
Superset application
        ↕
metadata database
```

А в production-oriented topology могут появляться дополнительные компоненты:

```text
cache / Redis
Celery worker
Celery beat
reverse proxy
```

Они не являются аналитической БД.

## Границы ответственности

Если исходные строки неверны, проблема находится в данных или upstream-модели. Если потерян Dashboard, это уже metadata Superset. Если результат SQL корректен, а визуализация нет — проблема находится выше слоя источника данных.

Поэтому диагностика должна идти по слоям, а не с перебора случайных настроек интерфейса.

## Контрольные вопросы

1. Где выполняется аналитический SQL?
2. Где хранится определение Dashboard?
3. Почему Redis нельзя называть analytics database?
4. Почему ошибка исходных данных не исправляется настройкой Chart?

## Официальные источники

```text
upstream: apache/superset
version:  6.1.0
ref:      c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path:     docs/admin_docs/installation/architecture.mdx
```

## Статус проверки

```text
Тип страницы: concept
Документировано для: Apache Superset 6.1.0
Проверка реализации: не требовалась
Проверка на стенде: неприменима
```

## Навигация

- Предыдущая тема: [`what-is-superset.md`](what-is-superset.md)
- Следующая тема: [`metadata-and-analytics-databases.md`](metadata-and-analytics-databases.md)
