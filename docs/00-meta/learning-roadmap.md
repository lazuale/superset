# Маршрут обучения

Маршрут задаёт порядок понимания, а не фиксированное количество страниц. Полнота официального покрытия контролируется отдельно в [`official-coverage.md`](official-coverage.md).

## Этап 0. Fundamentals

- что такое Apache Superset и чего он не делает;
- место Superset в аналитической архитектуре;
- analytics data и metadata Superset;
- объекты Superset, объекты СУБД и аналитические понятия;
- query lifecycle на базовом уровне;
- назначение sandbox 6.1.0;
- отличие sandbox от production;
- отдельная учебная PostgreSQL analytics database через `11-labs`.

Результат: до первой работы в UI читатель понимает границы продукта и имеет воспроизводимый путь к стенду с контрольными данными.

## Этап 1. Data access

- Database Connection;
- DB-API driver и SQLAlchemy dialect;
- SQLAlchemy URI;
- права учётной записи источника;
- database / schema / table / view / Dataset;
- Physical Dataset;
- columns, data types, NULL и grain;
- dataset metadata sync;
- file upload как дополнительная возможность.

Результат: читатель подключает PostgreSQL и понимает, что Dataset не является копией строк.

## Этап 2. Explore

- anatomy и lifecycle Explore;
- dimensions и Group By;
- adhoc Metrics и saved Dataset Metrics;
- Calculated Columns;
- filters;
- time column, Time Range и Time Grain;
- query controls;
- связь настроек Explore с SQL;
- результаты и export boundaries.

Результат: читатель может объяснить, как конфигурация Explore превращается в аналитический запрос.

## Этап 3. Visualization

- выбор chart type;
- Table и Big Number;
- Bar / Line / Time-series;
- Pivot Table;
- Chart как сохраняемый объект;
- Dashboard, layout и publish state;
- Native Filters и scope;
- dashboard interactivity;
- Advanced Analytics;
- Annotations.

Специальные возможности отдельных chart plugins уходят в reference.

## Этап 4. SQL

- минимальный SQL для работы с Superset;
- SQL Lab;
- query results/history;
- Saved Queries;
- Virtual Datasets;
- SQL → Explore;
- JOIN и CTE;
- ограничения сложного virtual SQL.

Результат: понятен путь SQL → Virtual Dataset → Explore → Chart.

## Этап 5. Modeling

- grain;
- facts, dimensions и keys;
- star schema;
- database view / materialized view;
- выбор слоя для бизнес-логики;
- thin semantic layer Superset;
- metric governance;
- descriptions и certification;
- аналитический дизайн;
- data freshness: warehouse refresh ≠ dashboard refresh.

## Этап 6. Security model

- пользователи и роли;
- permission model;
- Database/Dataset access;
- Dashboard access;
- Row Level Security;
- SQL Lab security;
- source database least privilege;
- authentication boundaries.

Production hardening намеренно не находится здесь: сначала изучается deployment architecture.

## Этап 7. Administration

- инфраструктурная архитектура;
- installation methods;
- Docker Compose и его границы;
- production topology;
- metadata database;
- `superset_config.py`;
- `SECRET_KEY` и secrets;
- networking / reverse proxy;
- timezones;
- место Redis/Celery в topology без преждевременного тюнинга.

## Этап 8. Operations

- caching;
- Redis;
- Celery и async queries;
- Alerts & Reports;
- Event Logging;
- Feature Flags;
- Import / Export;
- backup / restore;
- upgrades / migrations;
- monitoring;
- performance;
- production hardening;
- security updates / CVE;
- Issue Codes и troubleshooting.

## Этап 9. Advanced

- SQL templating;
- embedding;
- theming;
- maps;
- REST API;
- MCP;
- AWS IAM;
- Using AI with Superset;
- developer architecture;
- extensions и чтение исходного кода.

Этот этап не является prerequisite для обычной аналитической или административной работы.

## Правило идентификаторов

Порядок определяется зависимостями в этом roadmap. Постоянная ссылка — смысловой slug файла, а не глобальный номер урока.
