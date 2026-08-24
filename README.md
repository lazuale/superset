# Apache Superset 6.1 — учебная wiki

Русскоязычная техническая wiki по **Apache Superset 6.1.0**: от модели продукта и работы с данными до безопасности, эксплуатации и расширения.

Цель проекта — не пересказать интерфейс и не скопировать официальную документацию, а собрать последовательный курс, в котором каждое существенное действие связывается с SQL, metadata, permissions, cache или background execution — когда это действительно относится к механике операции.

## Базовая версия

```text
Apache Superset: 6.1.0
release tag:      6.1.0
release commit:   c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
versioned docs:   6fa0b4875228480ecf9ecd687c5c74c2e30c726b
```

Почему используются два официальных ref, описано в [`docs/00-meta/release-baseline.md`](docs/00-meta/release-baseline.md).

## Как устроена wiki

- [`docs/00-meta`](docs/00-meta/README.md) — правила, версия, источники и архитектура wiki;
- `docs/01-fundamentals` … `docs/10-advanced` — основной учебный маршрут;
- `docs/11-labs` — канонические исполняемые лабораторные работы и fixtures;
- `docs/12-troubleshooting` — диагностика подтверждённых проблем;
- `docs/13-reference` — справочное покрытие возможностей 6.1.0.

Каталоги создаются по мере появления проверенного материала. Пустые разделы ради дерева не добавляются.

## Управляющие документы

1. [`wiki-architecture.md`](docs/00-meta/wiki-architecture.md) — типы материалов и границы разделов;
2. [`learning-roadmap.md`](docs/00-meta/learning-roadmap.md) — последовательность обучения;
3. [`release-baseline.md`](docs/00-meta/release-baseline.md) — зафиксированная версия и official refs;
4. [`source-policy.md`](docs/00-meta/source-policy.md) — правила доказательности;
5. [`official-coverage.md`](docs/00-meta/official-coverage.md) — evidence ledger официальных областей;
6. [`page-standard.md`](docs/00-meta/page-standard.md) — Definition of Done для разных типов страниц;
7. [`training-model.md`](docs/00-meta/training-model.md) — сквозная учебная модель.

## Принципы

1. Основной маршрут строится по учебным зависимостям, а не по меню Superset.
2. Объекты Superset, объекты СУБД, аналитические понятия и инфраструктурные компоненты не смешиваются.
3. Version-specific факт должен иметь проверяемое официальное основание именно для 6.1.0.
4. Документировано, проверено по реализации и воспроизведено на стенде — разные статусы.
5. Исполняемые команды и fixtures имеют одно каноническое место в `11-labs`.
6. Sandbox и production-развёртывание описываются раздельно.
7. Реальные ограничения и ошибки фиксируются там, где они влияют на работу; гипотетические проблемы ради объёма не добавляются.
8. Материал `Next`, `master` и более новых версий не переносится в основной текст без проверки относительно baseline 6.1.0.
