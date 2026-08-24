# Проверка sandbox

Команды выполняются из `.lab/apache-superset` после запуска.

## Проверить Git ref

```bash
git describe --tags --exact-match
```

Ожидается:

```text
6.1.0
```

## Проверить image приложения

```bash
docker inspect superset_app --format '{{.Config.Image}}'
```

Image должен оканчиваться на:

```text
:6.1.0-dev
```

`latest-dev` не считается допустимым результатом для курса.

## Проверить services

```bash
docker compose -f docker-compose-image-tag.yml ps
```

Перед переходом к следующему lab контейнер приложения и необходимые зависимости должны быть запущены без явной ошибки startup.

## UI

После успешного старта ожидаемый локальный адрес:

```text
http://localhost:8088
```

Default development credentials upstream Compose используются только в изолированном sandbox.

## Статус

```text
Тип страницы: lab
Проверка на стенде: не выполнена
```
