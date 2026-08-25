# 02. Запускаем учебный Superset

В этом уроке Docker нужен только как способ получить одинаковую среду у всех, кто проходит курс. Разбирать Docker как отдельную технологию здесь не будем.

К концу урока должен работать локальный стенд с Apache Superset 6.1.0 и PostgreSQL, а контрольный набор `training.sales` должен давать те же значения, что указаны ниже.

## Перед запуском

Нужны локальная копия репозитория, Docker с командой `docker compose` и браузер.

Если репозиторий ещё не скачан, сначала выполните раздел [«Получаем файлы курса»](../README.md#получаем-файлы-курса).

Откройте терминал в корне репозитория, где видны:

```text
README.md
docs/
training/
```

PostgreSQL отдельно ставить не нужно.

### Linux и macOS

Для локального запуска Superset используем Docker Compose. Если Docker ещё не установлен, ориентируйтесь на официальную документацию Docker:

- Linux: <https://docs.docker.com/engine/install/>
- macOS: <https://docs.docker.com/desktop/setup/install/mac-install/>

### Windows

На Windows используем **Docker Desktop + WSL 2 + Linux-контейнеры**. Команды курса выполняются внутри WSL 2, а не в PowerShell или CMD. Так один и тот же набор команд работает на всех трёх платформах.

Официальная установка Docker Desktop:

<https://docs.docker.com/desktop/setup/install/windows-install/>

## Сначала проверим Docker

Выполните:

```bash
docker version
docker compose version
```

Обе команды должны завершиться без ошибки. Если Docker установлен, но сервер недоступен, запустите Docker Desktop или службу Docker.

## Что входит в учебный стенд

Основной файл находится здесь:

```text
training/compose.yaml
```

Он поднимает три сервиса:

```text
db
│
├── PostgreSQL 17
└── база training
        └── схема training
                └── таблица sales

superset-init
└── однократная подготовка Superset

superset
└── Apache Superset 6.1.0
        └── http://localhost:8088
```

`superset-init` после успешной инициализации завершится. Это ожидаемое поведение, а не упавший контейнер.

Для Superset используется официальный образ:

```text
apache/superset:6.1.0-dev
```

Вариант `dev` выбран потому, что в нём уже есть PostgreSQL-драйвер `psycopg2-binary`. Версия самого Superset при этом остаётся 6.1.0.

Стенд учебный и локальный. Не воспринимайте его как готовую схему промышленного развёртывания.

## Первый запуск

Перейдите в каталог `training`:

```bash
cd training
```

Дальше команды `docker compose ...` выполняются отсюда, если отдельно не сказано обратное.

Сначала загрузим образы:

```bash
docker compose pull
```

Затем запустим стенд:

```bash
docker compose up -d
```

Проверим состояние:

```bash
docker compose ps -a
```

После завершения инициализации ожидается примерно такая картина:

```text
db             running / healthy
superset       running / healthy
superset-init  exited (0)
```

Нас интересуют именно сервисы и их состояние; полные имена контейнеров могут отличаться.

Сразу после запуска `superset` может некоторое время не быть `healthy`. Подождите, пока встроенная проверка начнёт успешно отвечать на `/health`, и только потом продолжайте.

## Проверяем, что запущена нужная версия

```bash
docker compose exec superset superset version
```

В выводе должна быть:

```text
6.1.0
```

Если версия другая, дальнейшие инструкции могут не совпасть с интерфейсом курса.

## Проверяем учебные данные

При первом создании PostgreSQL автоматически выполняются:

```text
schema.sql
data.sql
readonly.sql
```

Они создают `training.sales`, загружают 12 учебных строк и подготавливают пользователя `superset_reader` для чтения данных из Superset.

Запустите контрольный скрипт:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Основные значения должны совпасть:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

`check.sql` выводит и более подробные разрезы. Эти цифры ещё не раз встретятся в курсе: они нужны, чтобы проверять Superset по известному эталону, а не «на глаз».

## Открываем Superset

В браузере откройте:

<http://localhost:8088>

Учебная учётная запись:

```text
логин:  admin
пароль: admin
```

Порт `8088` привязан только к `127.0.0.1`, поэтому этот стенд доступен с того же компьютера, где работает Docker, и не публикуется в сеть.

Простые реквизиты допустимы только потому, что это локальная учебная среда. В реальной системе так делать не нужно.

Пока ничего не создавайте. Просто найдите основные разделы:

- `Datasets`;
- `Charts`;
- `Dashboards`;
- `SQL → SQL Lab`;
- настройки подключений к базам данных.

На этом этапе достаточно убедиться, что интерфейс открывается и вы понимаете, где примерно будем работать дальше.

## Что уже произошло, хотя мы ничего не настраивали в интерфейсе

После `docker compose up -d` PostgreSQL уже создал базу `training`, таблицу `training.sales` и загрузил учебные строки. Скрипт `readonly.sql` добавил пользователя `superset_reader`.

Отдельно контейнер `superset-init` выполнил миграции Superset, создал учебного администратора и подготовил служебные данные приложения.

Но Superset пока **не подключён** к учебной PostgreSQL как к аналитическому источнику. Таблица существует, а объекта `Database` в Superset ещё нет. Этим займёмся в следующем уроке.

## Как остановить стенд и не потерять работу

Обычная остановка:

```bash
docker compose stop
```

Повторный запуск:

```bash
docker compose up -d
```

При такой остановке созданные позже Dataset, Chart и Dashboard сохраняются.

Полный сброс — совсем другая операция:

```bash
docker compose down -v --remove-orphans
docker compose up -d
```

Ключ `-v` удаляет учебные тома Docker. Вместе с ними исчезнут служебное состояние Superset, созданные объекты и база `training`; при следующем запуске всё создастся заново из файлов репозитория.

После того как начнёте проходить следующие уроки, не используйте полный сброс без необходимости.

## Если что-то не запустилось

Если Docker не отвечает, начните с:

```bash
docker version
```

Если ошибка у `superset-init`, посмотрите его журнал:

```bash
docker compose logs superset-init
```

Если не открывается `localhost:8088`, проверьте контейнеры и журнал Superset:

```bash
docker compose ps -a
docker compose logs superset
```

Если `training.sales` отсутствует или контрольные суммы испорчены, проще всего вернуть стенд в исходное состояние полным сбросом и снова выполнить `check.sql`.

На Windows дополнительно проверьте, что Docker Desktop работает с Linux-контейнерами и WSL 2, а команды запускаются именно внутри WSL 2. Сам Apache Superset не заявляет Windows как официально поддерживаемый хост своего Docker Compose-сценария.

## Перед переходом дальше

Убедитесь в пяти вещах:

- `db` и `superset` имеют состояние `healthy`;
- `superset-init` завершился с кодом `0`;
- `superset version` показывает `6.1.0`;
- `check.sql` подтверждает 12 строк и выручку `4005.00`;
- <http://localhost:8088> открывается под `admin / admin`.

Если всё совпало, стенд готов. Следующий шаг — познакомить Superset с уже работающей PostgreSQL.

→ [Урок 03. Подключаем PostgreSQL](03-connect-postgresql.md)

## Официальные источники

- Docker Compose: <https://superset.apache.org/admin-docs/6.1.0/installation/docker-compose/>
- Docker builds и типы образов: <https://superset.apache.org/admin-docs/6.1.0/installation/docker-builds/>
- Installation Methods: <https://superset.apache.org/admin-docs/6.1.0/installation/installation-methods/>
- официальный `docker-compose-image-tag.yml` для тега `6.1.0`: <https://github.com/apache/superset/blob/6.1.0/docker-compose-image-tag.yml>
- официальный `docker-init.sh` для тега `6.1.0`: <https://github.com/apache/superset/blob/6.1.0/docker/docker-init.sh>
- базовая конфигурация Superset 6.1.0: <https://github.com/apache/superset/blob/6.1.0/superset/config.py>

Учебный `training/compose.yaml` намеренно проще промышленной конфигурации Superset. Он нужен для воспроизводимого обучения, а не как шаблон реального развёртывания.