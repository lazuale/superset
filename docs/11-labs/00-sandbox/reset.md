# Полный reset sandbox

## Когда использовать

Полный reset нужен перед проверкой воспроизводимости с чистого состояния или если старые volumes могут влиять на результат.

## Удалить контейнеры и named volumes

Из `.lab/apache-superset`:

```bash
export TAG=6.1.0-dev
docker compose -f docker-compose-image-tag.yml down -v --remove-orphans
```

`-v` удаляет volumes этого Compose project, включая metadata PostgreSQL и Redis state. Это **разрушительная команда для учебного sandbox**.

## Полный checkout reset

Если нужно повторить сценарий начиная с clone, из корня wiki после `down -v`:

```bash
rm -rf .lab/apache-superset
```

После этого повторяются [`start.md`](start.md) и [`verify-version.md`](verify-version.md).

## Критерий воспроизводимости

Lab считается воспроизведённым только после успешного запуска с чистого состояния. Для итоговой проверки курса выполняется как минимум один полный reset и повторный запуск.

## Статус

```text
Тип страницы: lab
Проверка на стенде: не выполнена
```
