# Lab 00 — Sandbox Apache Superset 6.1.0

## Цель

Получить изолированный учебный Superset, привязанный к release tag `6.1.0`, и иметь понятный полный reset.

## Порядок

1. [`start.md`](start.md) — получить upstream release и запустить Compose;
2. [`verify-version.md`](verify-version.md) — убедиться, что запущена нужная версия;
3. перейти к [`../01-training-database/README.md`](../01-training-database/README.md);
4. [`reset.md`](reset.md) — полный сброс sandbox, когда нужен чистый повторный прогон.

## Предварительные условия

- Git;
- Docker Engine / Docker Desktop с `docker compose`;
- свободный TCP port `8088`;
- команды выполняются из корня репозитория wiki, если явно не указано обратное.

## Статус

```text
Тип страницы: lab
Документировано для: Apache Superset 6.1.0
Проверка реализации: выполнена по release Compose files
Проверка на стенде: не выполнена
```

Пока runtime-проверка не выполнена, Lab 00 остаётся draft-материалом.
