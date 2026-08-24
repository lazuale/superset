# Учебный sandbox и production

## Зачем это нужно

Работающий Docker Compose не является доказательством production-ready архитектуры.

## Sandbox

Для курса Docker Compose нужен как управляемый способ поднять конкретную версию Superset и выполнить labs.

Цели sandbox:

- фиксированная версия;
- известная topology;
- одноразовые test credentials;
- возможность полного reset;
- воспроизводимые упражнения.

## Production

Production добавляет вопросы, которых Stage 0 намеренно не решает:

- секреты;
- backup и restore;
- high availability;
- scaling;
- monitoring;
- reverse proxy / TLS;
- security hardening;
- production metadata database;
- cache / worker topology.

Официальный Docker Compose guide 6.1.0 прямо указывает, что supplied Compose constructs не поддерживаются и не рекомендуются для production-type use cases и high availability.

## Каноническая практика

Команды не дублируются здесь. Они находятся в:

- [`../11-labs/00-sandbox/README.md`](../11-labs/00-sandbox/README.md)
- [`../11-labs/00-sandbox/start.md`](../11-labs/00-sandbox/start.md)
- [`../11-labs/00-sandbox/verify-version.md`](../11-labs/00-sandbox/verify-version.md)
- [`../11-labs/00-sandbox/reset.md`](../11-labs/00-sandbox/reset.md)

## Официальные источники

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/docs/quickstart.mdx
```

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/admin_docs/installation/docker-compose.mdx
```

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/admin_docs/installation/installation-methods.mdx
```

## Статус проверки

```text
Тип страницы: concept
Документировано для: Apache Superset 6.1.0
Проверка реализации: выполнена по release Compose files
Проверка на стенде: неприменима
```

## Навигация

- Предыдущая тема: [`query-lifecycle.md`](query-lifecycle.md)
- Следующая работа: [`../11-labs/00-sandbox/README.md`](../11-labs/00-sandbox/README.md)
