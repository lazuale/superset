# Базовый query lifecycle

## Зачем это нужно

Фраза «Dashboard делает SQL-запрос» слишком грубая. Она ломается сразу после появления cache. Нужна модель, которая останется верной и на следующих этапах курса.

## Упрощённый lifecycle

Когда визуализации нужны данные, Superset формирует query context на основе Dataset, Metrics, dimensions, filters, time controls и других параметров.

Дальше возможны два принципиальных пути:

```text
нужны данные для Chart
        ↓
проверка применимого cache-механизма
       ↙ ↘
  результат есть   результата нет / cache не применим
       ↓                    ↓
использовать result      сформировать / выполнить SQL
                            ↓
                    analytics database
                            ↓
                       result set
       ↘                    ↙
        данные для визуализации
```

Конкретные типы cache, cache keys и async execution изучаются позже. На Stage 0 важно только не утверждать, что каждый просмотр Dashboard обязательно означает новый SQL round trip.

## Что не входит в эту главу

- точная структура generated SQL;
- конкретные cache backends;
- Redis;
- Celery;
- async chart queries;
- backend API internals.

Они появятся после того, как будут изучены Dataset, Explore и deployment architecture.

## Контрольные вопросы

1. Почему открытие Chart не гарантирует новый запрос к analytics database?
2. Какие настройки будущего Explore влияют на query context?
3. Где физически выполняется SQL, если cache не дал готовый результат?

## Официальные источники

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/admin_docs/installation/architecture.mdx
```

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/admin_docs/configuration/cache.mdx
```

## Статус проверки

```text
Тип страницы: concept
Документировано для: Apache Superset 6.1.0
Проверка реализации: не требовалась
Проверка на стенде: неприменима
```

## Навигация

- Предыдущая тема: [`objects-and-concepts.md`](objects-and-concepts.md)
- Следующая тема: [`sandbox-and-production.md`](sandbox-and-production.md)
