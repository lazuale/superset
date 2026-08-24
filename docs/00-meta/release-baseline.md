# Release baseline

## Базовая версия

```text
Product:                 Apache Superset
Version:                 6.1.0
Release tag:             6.1.0
Release commit:          c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
Versioned docs snapshot: 6fa0b4875228480ecf9ecd687c5c74c2e30c726b
```

## Зачем нужны два ref

Release tag `6.1.0` указывает на commit `c83fb2bb1dcfac41ac51bcebd82471f4a7180d18`. Он является основным якорем для исходного кода, конфигурации, migrations, deployment-файлов и документационных файлов, которые присутствуют в самом release tree.

Отдельные versioned snapshots User/Admin/Developer documentation были созданы официальным commit `6fa0b4875228480ecf9ecd687c5c74c2e30c726b` (`docs: cut 6.1.0 versions ...`). Поэтому путь вида `docs/user_docs_versioned_docs/version-6.1.0/...` нельзя выдавать за файл, находящийся внутри release tag, если его там нет.

## Правило использования

```text
source/code/config/deployment
        ↓
release tag 6.1.0 / c83fb2bb...

versioned generated documentation
        ↓
6fa0b487...

поведение, требующее проверки
        ↓
реализация release tag
        ↓
стенд 6.1.0, если воспроизведение применимо
```

Versioned docs используются как официальный документированный snapshot. Они не имеют права переопределять фактическую реализацию release tag без отдельного объяснения расхождения.

## Известное расхождение upstream

`docs/docs/quickstart.mdx` в release tag `6.1.0` содержит пример checkout `tags/6.0.0`. Поэтому команды из официальной документации не копируются механически: версия, используемая в lab, фиксируется и проверяется отдельно.

## Смена baseline

Переход на новую базовую версию выполняется отдельным PR и аудитом. Минимально перепроверяются:

- UI и object semantics;
- configuration keys и feature flags;
- security model;
- API;
- database drivers;
- installation/deployment assumptions;
- migrations и upgrade notes;
- все воспроизводимые labs.

Массовая замена номера версии без повторной проверки запрещена.
