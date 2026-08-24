# Управление wiki

`00-meta` определяет правила проекта. Здесь нет учебных уроков по Apache Superset.

## Документы

- [`wiki-architecture.md`](wiki-architecture.md) — структура wiki, типы материалов, канонические места и навигация;
- [`learning-roadmap.md`](learning-roadmap.md) — порядок обучения;
- [`release-baseline.md`](release-baseline.md) — версия продукта и официальные ref;
- [`source-policy.md`](source-policy.md) — иерархия доказательств и статусы проверки;
- [`official-coverage.md`](official-coverage.md) — evidence ledger официальных областей Superset 6.1.0;
- [`page-standard.md`](page-standard.md) — Definition of Done для concept, procedure, lab, reference и troubleshooting;
- [`training-model.md`](training-model.md) — сквозная модель данных и требования к fixtures.

## Зафиксированные решения

- базовая версия: Apache Superset 6.1.0;
- основной язык: русский;
- официальная терминология сохраняется без смысловой подмены;
- основной маршрут строится по зависимостям;
- полнота официального покрытия контролируется отдельно от порядка обучения;
- канонические исполняемые сценарии находятся только в `docs/11-labs`;
- metadata database Superset не смешивается с учебной analytics database;
- sandbox не выдаётся за production deployment;
- глобальное количество уроков не фиксируется;
- стабильный идентификатор страницы — смысловой slug, а не порядковый номер;
- изменение любого документа `00-meta` считается изменением архитектуры wiki и требует проверки влияния на весь маршрут.
