# 02. Запускаем учебный Superset

## Что научимся делать

После этого урока вы должны уметь:

- проверить, что Docker готов к работе;
- запустить учебный стенд Apache Superset 6.1.0;
- проверить версию Superset;
- убедиться, что таблица `training.sales` создана и содержит правильные данные;
- открыть Superset в браузере и войти в учебную учётную запись;
- остановить стенд и снова его запустить;
- полностью вернуть стенд в исходное состояние, если что-то сломалось.

В этом уроке мы **не изучаем Docker как отдельную технологию**. Docker здесь нужен только для того, чтобы у всех учеников был одинаковый Superset и одинаковый PostgreSQL.

## Что нужно до начала

Нужны:

- локальная копия этого репозитория;
- Docker с командой `docker compose`;
- браузер.

Если локальной копии репозитория ещё нет, сначала выполните раздел [«Получаем файлы курса»](../README.md#получаем-файлы-курса) в README.

Перед выполнением команд этого урока откройте терминал **в корневом каталоге репозитория** — там, где находятся:

```text
README.md
docs/
training/
```

PostgreSQL отдельно устанавливать не нужно. Он входит в учебный стенд.

### Linux и macOS

Apache Superset рекомендует Docker Compose как быстрый способ локально попробовать Superset. Для Linux и macOS это официальный путь для локального запуска.

Если Docker ещё не установлен, используйте официальную документацию Docker:

- Linux: <https://docs.docker.com/engine/install/>
- macOS: <https://docs.docker.com/desktop/setup/install/mac-install/>

### Windows

Apache Superset не заявляет Windows как официально поддерживаемую систему для локального Docker Compose-сценария.

Для этого курса на Windows используйте **Docker Desktop с WSL 2 и Linux containers**. Сам Superset при этом работает внутри Linux-контейнера.

Официальная установка Docker Desktop для Windows:

<https://docs.docker.com/desktop/setup/install/windows-install/>

В рамках курса **все команды терминала на Windows выполняйте в оболочке WSL 2**. PowerShell и CMD не являются учебным путём этого маршрута. Так команды ниже остаются одинаковыми для Windows, macOS и Linux, включая bash-переносы строк через `\`.

## Проверяем Docker

Откройте терминал и выполните:

```bash
docker version
```

Затем:

```bash
docker compose version
```

Обе команды должны завершиться без ошибки.

Если первая команда сообщает, что не удаётся подключиться к Docker daemon, сначала запустите Docker Desktop или службу Docker.

## Что именно мы запускаем

Учебный стенд находится в каталоге:

```text
training/
```

Основной файл:

```text
training/compose.yaml
```

Он запускает три сервиса:

```text
db
│
├── PostgreSQL 17
└── база training
        └── schema training
                └── table sales

superset-init
└── инициализация metadata Superset

superset
└── Apache Superset 6.1.0
```

`db` — учебный PostgreSQL с таблицей продаж.

`superset-init` выполняет миграции metadata Superset, создаёт учебного администратора и инициализирует приложение. После успешного выполнения этот контейнер завершает работу с кодом `0`.

`superset` — само веб-приложение Superset.

## Переходим в каталог стенда

Из корневого каталога репозитория выполните:

```bash
cd training
```

Проверьте, что в текущем каталоге виден файл:

```text
compose.yaml
```

Начиная с этого места все команды `docker compose ...` в курсе выполняются из каталога `training/`, если явно не сказано иначе.

## Запускаем стенд

Выполните:

```bash
docker compose up -d
```

При первом запуске Docker скачает необходимые образы. Это нормально.

Посмотрите состояние контейнеров:

```bash
docker compose ps -a
```

После завершения инициализации ожидается примерно такое состояние:

```text
db             running / healthy
superset       running / healthy
superset-init  exited (0)
```

`superset-init` не должен оставаться запущенным постоянно. Его успешное состояние — `exited (0)`.

Если `superset` ещё имеет статус `health: starting`, повторите команду через некоторое время:

```bash
docker compose ps -a
```

## Проверяем версию Superset

Выполните:

```bash
docker compose exec -T superset superset version
```

В выводе должна быть версия:

```text
6.1.0
```

## Проверяем здоровье Superset

Выполните:

```bash
curl -fsS http://localhost:8088/health
```

Ожидаемый ответ:

```text
OK
```

Если в вашей системе команда `curl` отсутствует, этот шаг можно проверить в браузере, открыв:

```text
http://localhost:8088/health
```

Страница должна вернуть:

```text
OK
```

## Проверяем учебные данные

Выполните:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Основной контрольный результат:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

Если эти значения совпадают, учебная таблица загрузилась правильно.

Дополнительно `check.sql` показывает контроль по регионам и месяцам. Эти числа будут использоваться в следующих уроках.

## Открываем Superset

Откройте в браузере:

<http://localhost:8088>

Войдите:

```text
login:    admin
password: admin
```

После входа должен открыться интерфейс Apache Superset.

Это учебная учётная запись. В production пароль `admin` использовать нельзя.

## Останавливаем стенд

Для обычной остановки выполните:

```bash
docker compose down
```

Эта команда останавливает и удаляет контейнеры Compose-проекта, но сохраняет volumes с данными.

Чтобы снова запустить стенд:

```bash
docker compose up -d
```

После повторного запуска созданные вами объекты Superset должны сохраниться.

## Полностью возвращаем стенд в исходное состояние

Если учебный стенд нужно начать заново, выполните **только внутри каталога `training/` этого курса**:

```bash
docker compose down -v --remove-orphans
docker compose up -d
```

Ключ `-v` удаляет volumes этого Compose-проекта. Вместе с ними удаляются:

- metadata Superset;
- созданные вами Dataset, Chart и Dashboard;
- учебная база PostgreSQL.

При следующем `docker compose up -d` всё создаётся заново из файлов курса.

После полного сброса снова проверьте:

```bash
docker compose ps -a
```

и:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

## Если стенд не запускается

### Порт 8088 уже занят

Проверьте, не запущен ли другой Superset или другой сервис на `8088`.

### db unhealthy

Посмотрите журнал PostgreSQL:

```bash
docker compose logs db
```

### superset-init завершился с ошибкой

Посмотрите его журнал:

```bash
docker compose logs superset-init
```

### superset unhealthy

Посмотрите журнал Superset:

```bash
docker compose logs superset
```

### Нужно начать с нуля

Используйте полный сброс:

```bash
docker compose down -v --remove-orphans
docker compose up -d
```

## Критерий завершения

Перед переходом к следующему уроку должно выполняться всё сразу:

```text
Superset version = 6.1.0
/health          = OK
training.sales   = 12 строк
revenue          = 4005.00
profit           = 1530.00
```

и вы должны войти в браузере под:

```text
admin / admin
```

Следующий урок — подключение учебного PostgreSQL к Superset.

→ [Урок 03. Подключаем PostgreSQL](03-connect-postgresql.md)

## Источники Superset 6.1.0

- Docker Compose: <https://superset.apache.org/admin-docs/6.1.0/installation/docker-compose/>
- Docker builds: <https://superset.apache.org/admin-docs/6.1.0/installation/docker-builds/>
- Installation methods: <https://superset.apache.org/admin-docs/6.1.0/installation/>
- Health endpoint: <https://github.com/apache/superset/blob/6.1.0/superset/views/health.py>
