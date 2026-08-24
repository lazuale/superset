# Запуск sandbox

## 1. Получить release tree

Из корня wiki:

```bash
mkdir -p .lab
git clone --depth 1 --branch 6.1.0 https://github.com/apache/superset.git .lab/apache-superset
cd .lab/apache-superset
```

`--branch 6.1.0` фиксирует checkout на release ref и не повторяет ошибочный checkout `6.0.0`, присутствующий в upstream Quickstart 6.1.0.

## 2. Запустить release image через Compose

```bash
export TAG=6.1.0-dev
docker compose -f docker-compose-image-tag.yml up -d
```

В release `docker-compose-image-tag.yml` image определяется как `${TAG:-latest-dev}`. Official Docker Compose documentation объясняет использование `-dev` release image для этого Compose-варианта, поскольку dev build содержит PostgreSQL driver, необходимый внутреннему Postgres service.

## 3. Не считать этот запуск production

Release Compose file сам содержит предупреждение, что Docker Compose не поддерживается для production environments и требует собственных secrets даже если кто-то сознательно использует подобную topology.

## Источники

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docker-compose-image-tag.yml
```

```text
ref:  c83fb2bb1dcfac41ac51bcebd82471f4a7180d18
path: docs/admin_docs/installation/docker-compose.mdx
```

## Статус

```text
Тип страницы: lab
Проверка на стенде: не выполнена
```
