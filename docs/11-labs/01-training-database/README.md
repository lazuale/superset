# Lab 01 — Учебная PostgreSQL analytics database

## Цель

Создать отдельную database `training` внутри PostgreSQL service учебного Compose stack и восстановить канонический small fixture из нулевого состояния schema.

Metadata database Superset и training database используют один PostgreSQL instance только ради компактности sandbox. Логически это разные хранилища.

## Предварительное условие

Выполнен [`../00-sandbox/README.md`](../00-sandbox/README.md).

Команды ниже выполняются из корня wiki.

## 1. Создать роль и database, если их ещё нет

```bash
docker exec -i superset_db psql -U superset -d postgres <<'SQL'
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'training') THEN
    CREATE ROLE training LOGIN PASSWORD 'training';
  END IF;
END
$$;

SELECT 'CREATE DATABASE training OWNER training'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'training')\gexec
SQL
```

Credentials `training` / `training` существуют только в isolated lab.

## 2. Сбросить subject schema до эталона

```bash
docker exec -e PGPASSWORD=training -i superset_db \
  psql -h 127.0.0.1 -U training -d training \
  < docs/11-labs/01-training-database/reset.sql
```

## 3. Создать структуру

```bash
docker exec -e PGPASSWORD=training -i superset_db \
  psql -h 127.0.0.1 -U training -d training \
  < docs/11-labs/01-training-database/schema.sql
```

## 4. Загрузить small fixture

```bash
docker exec -e PGPASSWORD=training -i superset_db \
  psql -h 127.0.0.1 -U training -d training \
  < docs/11-labs/01-training-database/seed.sql
```

## 5. Проверить результат

```bash
docker exec -e PGPASSWORD=training -i superset_db \
  psql -h 127.0.0.1 -U training -d training \
  < docs/11-labs/01-training-database/expected-results.sql
```

Главный контроль:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
```

## 6. Проверить повторяемость

Повторить шаги **2–5**. Результаты должны остаться теми же. Именно reset schema делает fixture детерминированным относительно старого содержимого `training.sales`.

## Grain

```text
одна строка training.sales = одна строка продажи
```

## Источники

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/admin_docs/installation/architecture.mdx
```

```text
ref:  6fa0b4875228480ecf9ecd687c5c74c2e30c726b
path: docs/user_docs_versioned_docs/version-6.1.0/databases/supported/postgresql.mdx
```

## Статус

```text
Тип страницы: lab
Документировано для: Apache Superset 6.1.0
Проверка реализации: выполнена по Compose topology и official PostgreSQL docs
Проверка на стенде: не выполнена
```
