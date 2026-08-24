# Этап 0. Fundamentals

Stage 0 нужен до работы в интерфейсе. Его задача — дать правильную модель Superset и подготовить воспроизводимый учебный стенд.

## Порядок

1. [`what-is-superset.md`](what-is-superset.md)
2. [`analytics-architecture.md`](analytics-architecture.md)
3. [`metadata-and-analytics-databases.md`](metadata-and-analytics-databases.md)
4. [`objects-and-concepts.md`](objects-and-concepts.md)
5. [`query-lifecycle.md`](query-lifecycle.md)
6. [`sandbox-and-production.md`](sandbox-and-production.md)
7. [`../11-labs/00-sandbox/README.md`](../11-labs/00-sandbox/README.md)
8. [`../11-labs/01-training-database/README.md`](../11-labs/01-training-database/README.md)

## Результат этапа

После Stage 0 читатель должен:

- объяснить, что делает и чего не делает Superset;
- различать analytics database и metadata database;
- различать объекты Superset, объекты СУБД, аналитические понятия и инфраструктурные компоненты;
- объяснить базовый query lifecycle с учётом cache;
- понимать, почему Docker Compose sandbox не является production deployment;
- иметь проверяемый путь к Superset 6.1.0 и учебной PostgreSQL-базе `training`.

Runtime-labs могут находиться в draft со статусом `Проверка на стенде: не выполнена`, но не считаются готовыми к merge до фактического выполнения.
