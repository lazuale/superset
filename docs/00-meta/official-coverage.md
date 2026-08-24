# Evidence ledger официального покрытия

Этот файл не является оглавлением и не утверждает, что перечисленные страницы уже написаны. Он связывает официальную область Apache Superset 6.1.0 с точным upstream source и каноническим местом в нашей wiki.

## Official refs

```text
R = release tag 6.1.0
    c83fb2bb1dcfac41ac51bcebd82471f4a7180d18

V = official versioned-docs snapshot
    6fa0b4875228480ecf9ecd687c5c74c2e30c726b
```

## Статусы учебной роли

- `core` — основной маршрут;
- `extended` — после базовой темы;
- `reference` — справочное покрытие;
- `developer` — developer-трек;
- `optional` — официальная возможность вне обязательного маршрута.

Статус не означает готовность страницы.

## User / analyst track

| Область | Ref | Upstream path | Каноническое место | Роль |
|---|---|---|---|---|
| Product overview | R | `docs/docs/index.mdx` | `01-fundamentals/what-is-superset.md` | core |
| Quickstart | R | `docs/docs/quickstart.mdx` | concept в `01-fundamentals`, команды в `11-labs/00-sandbox` | core |
| First Dashboard | R | `docs/docs/using-superset/creating-your-first-dashboard.mdx` | `02-data-access`, `03-explore`, `04-visualization` | core |
| Exploring Data | R | `docs/docs/using-superset/exploring-data.mdx` | `03-explore`, `04-visualization` | core |
| Connecting to Databases | V | `docs/user_docs_versioned_docs/version-6.1.0/databases/index.mdx` | `02-data-access` | core |
| PostgreSQL | V | `docs/user_docs_versioned_docs/version-6.1.0/databases/supported/postgresql.mdx` | lab `02-connect-postgresql` + reference | core |
| Issue Codes | R | `docs/docs/using-superset/issue-codes.mdx` | `12-troubleshooting` | core |
| SQL Templating | R | `docs/docs/using-superset/sql-templating.mdx` | `10-advanced/sql-templating.md` | extended |
| Embedding | R | `docs/docs/using-superset/embedding.mdx` | `10-advanced/embedding.md` | extended |
| Using AI with Superset | R | `docs/docs/using-superset/using-ai-with-superset.mdx` | `10-advanced/using-ai-with-superset.md` | optional |
| FAQ | R | `docs/docs/faq.mdx` | `12-troubleshooting` / `13-reference` | reference |

## Installation / administration

| Область | Ref | Upstream path | Каноническое место | Роль |
|---|---|---|---|---|
| Architecture | R | `docs/admin_docs/installation/architecture.mdx` | `08-administration/architecture.md` | core |
| Installation Methods | R | `docs/admin_docs/installation/installation-methods.mdx` | `08-administration/installation-methods.md` | core |
| Docker Compose | R | `docs/admin_docs/installation/docker-compose.mdx` | sandbox lab + `08-administration/docker-compose.md` | core |
| Docker Builds | R | `docs/admin_docs/installation/docker-builds.mdx` | `13-reference` | extended |
| Kubernetes | R | `docs/admin_docs/installation/kubernetes.mdx` | `13-reference` | extended |
| PyPI | R | `docs/admin_docs/installation/pypi.mdx` | `13-reference` | extended |
| Upgrading Superset | R | `docs/admin_docs/installation/upgrading-superset.mdx` | `09-operations/upgrades-and-migrations.md` | core |

## Configuration / operations

| Область | Ref | Upstream path | Каноническое место | Роль |
|---|---|---|---|---|
| Configuring Superset | R | `docs/admin_docs/configuration/configuring-superset.mdx` | `08-administration/configuring-superset.md` | core |
| Timezones | R | `docs/admin_docs/configuration/timezones.mdx` | `03-explore/time-analysis.md` + `08-administration/timezones.md` | core |
| Cache | R | `docs/admin_docs/configuration/cache.mdx` | `09-operations/caching.md` | core |
| Async Queries / Celery | R | `docs/admin_docs/configuration/async-queries-celery.mdx` | `09-operations/celery-and-async.md` | core |
| Alerts & Reports | R | `docs/admin_docs/configuration/alerts-reports.mdx` | `09-operations/alerts-and-reports.md` | core |
| Event Logging | R | `docs/admin_docs/configuration/event-logging.mdx` | `09-operations/event-logging.md` | core |
| Feature Flags | R | `docs/admin_docs/configuration/feature-flags.mdx` | `09-operations/feature-flags.md` | core |
| Import / Export | R | `docs/admin_docs/configuration/importing-exporting-datasources.mdx` | `09-operations/import-export.md` | core |
| Networking | R | `docs/admin_docs/configuration/networking-settings.mdx` | `08-administration/networking-and-reverse-proxy.md` | core |
| SQL Templating (admin) | R | `docs/admin_docs/configuration/sql-templating.mdx` | `10-advanced/sql-templating.md` | extended |
| Theming | R | `docs/admin_docs/configuration/theming.mdx` | `10-advanced/theming.md` | extended |
| Map Tiles | R | `docs/admin_docs/configuration/map-tiles.mdx` | `10-advanced/maps.md` / reference | extended |
| Country Map Tools | R | `docs/admin_docs/configuration/country-map-tools.mdx` | `10-advanced/maps.md` / reference | extended |
| MCP Server | R | `docs/admin_docs/configuration/mcp-server.mdx` | `10-advanced/mcp.md` | optional |
| AWS IAM | R | `docs/admin_docs/configuration/aws-iam.mdx` | `10-advanced/aws-iam.md` | optional |

## Security

| Область | Ref | Upstream path | Каноническое место | Роль |
|---|---|---|---|---|
| Security model | R | `docs/admin_docs/security/security.mdx` | `07-security` | core |
| Securing Superset | R | `docs/admin_docs/security/securing_superset.mdx` | access boundaries в `07-security`, production hardening в `09-operations` | core |
| CVEs | R | `docs/admin_docs/security/cves.mdx` | `09-operations/security-updates-and-cves.md` + reference | reference |

## Developer track

| Область | Ref | Upstream path | Каноническое место | Роль |
|---|---|---|---|---|
| Developer overview | R | `docs/developer_docs/index.md` | `10-advanced/developer-architecture.md` | developer |
| REST API | R | `docs/developer_docs/api.mdx` | `10-advanced/rest-api.md` | developer |
| Components | R | `docs/developer_docs/components/` | `10-advanced` / reference | developer |
| Extensions | R | `docs/developer_docs/extensions/` | `10-advanced/extensions-and-source.md` | developer |
| Guidelines | R | `docs/developer_docs/guidelines/` | `13-reference` | developer |
| Testing | R | `docs/developer_docs/testing/` | `13-reference` | developer |
| Contributing | R | `docs/developer_docs/contributing/` | `13-reference` | developer |

## Правило расширения ledger

Перед тем как объявить новую функцию частью 6.1.0:

1. находится точный официальный path;
2. выбирается правильный ref `R` или `V`;
3. при необходимости поведение сверяется с implementation release tag;
4. определяется одно каноническое место в wiki;
5. только после этого строка добавляется в ledger.

Функция, найденная только в `Next`, `master` или более новой документации, не считается частью покрытия 6.1.0 без отдельного подтверждения.
