# 03. Подключаем PostgreSQL

## Что научимся делать

После этого урока вы должны уметь:

- открыть список подключений к базам данных в Superset;
- создать подключение к PostgreSQL по готовым реквизитам;
- понимать, что указывать в полях `Host`, `Port`, `Database name`, `Username` и `Password`;
- проверить соединение через `Test Connection`;
- сохранить подключение;
- снова найти его в Superset;
- убедиться, что Superset видит схему `training` и таблицу `sales`.

В этом уроке мы **не создаём Dataset**. Сначала Superset должен научиться подключаться к PostgreSQL как к источнику данных. Dataset на таблице `training.sales` создадим в следующем уроке.

## Что нужно до начала

Должен быть полностью пройден [урок 02](02-start-training-superset.md).

Учебный стенд должен быть запущен:

```bash
cd training
docker compose up -d
```

Проверьте состояние:

```bash
docker compose ps -a
```

Нормальная картина:

```text
db             running / healthy
superset       running
superset-init  exited (0)
```

Если вы ещё не проверяли учебные данные после запуска, выполните:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Главная контрольная строка должна содержать:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

Только после этого переходите к подключению базы в Superset.

## Что именно мы сейчас подключаем

В учебном стенде уже работают два отдельных сервиса:

```text
Superset
   │
   │ подключение к источнику данных
   ▼
PostgreSQL
   └── database: training
       └── schema: training
           └── table: sales
```

PostgreSQL уже существует и таблица `training.sales` уже заполнена.

Но Superset пока не знает, **как к этой базе подключаться**.

В Superset для этого создаётся объект `Database` — сохранённое описание подключения к внешней базе данных.

Такой объект содержит реквизиты соединения: тип СУБД, адрес сервера, порт, имя базы, пользователя и другие параметры.

Само подключение **не копирует строки из PostgreSQL в Superset**. Оно только даёт Superset возможность обращаться к базе и выполнять запросы к доступным объектам.

## Реквизиты учебной базы

Для курса используем следующие значения:

| Параметр | Значение |
|---|---|
| Тип базы | `PostgreSQL` |
| Имя подключения в Superset | `Training PostgreSQL` |
| Host | `db` |
| Port | `5432` |
| Database name | `training` |
| Username | `training` |
| Password | `training` |
| Схема с учебными данными | `training` |
| Таблица | `sales` |

Обратите внимание: имя подключения `Training PostgreSQL` мы придумываем сами. Это только понятная подпись внутри Superset.

А `training` в поле `Database name` — уже реальное имя базы PostgreSQL.

## Почему Host — `db`, а не `localhost`

Это важный момент.

Superset и PostgreSQL запущены в **разных Docker-контейнерах**.

В `compose.yaml` PostgreSQL объявлен как сервис:

```yaml
services:
  db:
    image: postgres:17
```

Superset объявлен другим сервисом:

```yaml
services:
  superset:
    image: apache/superset:6.1.0-dev
```

Docker Compose автоматически помещает такие сервисы в общую сеть проекта. Внутри этой сети контейнеры находят друг друга по имени сервиса.

Поэтому Superset обращается к PostgreSQL так:

```text
db:5432
```

Здесь:

- `db` — имя сервиса PostgreSQL в `compose.yaml`;
- `5432` — стандартный порт PostgreSQL внутри контейнера.

Если в поле `Host` написать:

```text
localhost
```

то для контейнера Superset это будет означать **сам контейнер Superset**, а не контейнер PostgreSQL.

Для нашего стенда это неправильный адрес.

Не подставляйте IP-адрес контейнера вручную. Docker может изменить его после пересоздания контейнера, а имя сервиса `db` остаётся стабильным.

## Открываем подключения к базам данных

Откройте Superset:

<http://localhost:8088>

Войдите:

```text
логин:  admin
пароль: admin
```

В верхнем меню откройте:

```text
Settings → Data → Database Connections
```

Названия элементов могут частично отображаться на английском даже при русской локали.

На странице `Database Connections` находятся сохранённые подключения Superset к источникам данных.

Сейчас нам нужно создать первое учебное подключение.

## Создаём новое подключение

Нажмите:

```text
+ DATABASE
```

или кнопку с тем же смыслом `Database`, если подпись в интерфейсе отображается немного иначе.

Superset предложит выбрать тип базы данных.

Выберите:

```text
PostgreSQL
```

В учебном образе `apache/superset:6.1.0-dev` PostgreSQL-драйвер уже доступен, поэтому PostgreSQL должен присутствовать среди доступных типов подключения.

Если PostgreSQL вообще отсутствует в списке, не продолжайте заполнять форму как другой тип базы. Сначала проверьте, что вы действительно запустили учебный стенд из этого репозитория и используете образ Superset из урока 02.

## Заполняем форму PostgreSQL

В форме подключения заполните реквизиты учебной базы.

### Host

```text
db
```

Это имя PostgreSQL-сервиса внутри Docker Compose.

### Port

```text
5432
```

Это стандартный порт PostgreSQL.

### Database name

```text
training
```

Это имя самой базы PostgreSQL.

### Username

```text
training
```

### Password

```text
training
```

Если форма отдельно запрашивает отображаемое имя подключения, укажите:

```text
Training PostgreSQL
```

Это имя будем использовать во всех следующих уроках.

## Проверяем соединение

После заполнения реквизитов нажмите:

```text
Test Connection
```

Superset попробует открыть соединение с PostgreSQL указанным пользователем.

Успешный тест означает, что как минимум выполняется вся цепочка:

```text
Superset
   │
   ├── находит host db
   ├── подключается к port 5432
   ├── открывает database training
   └── проходит аутентификацию как user training
```

Если Superset сообщает об успешном соединении, реквизиты подходят.

Важно: `Test Connection` только проверяет соединение. Чтобы подключение осталось в Superset, его ещё нужно сохранить.

## Сохраняем подключение

После успешного теста нажмите:

```text
Connect
```

Superset сохранит новое подключение.

Вернитесь к списку:

```text
Settings → Data → Database Connections
```

В нём должно появиться подключение:

```text
Training PostgreSQL
```

На этом этапе Superset уже знает, как обращаться к учебному PostgreSQL.

## Как этот же адрес выглядит как SQLAlchemy URI

Superset использует SQLAlchemy для работы со многими поддерживаемыми базами данных.

Для PostgreSQL базовая форма URI выглядит так:

```text
postgresql://username:password@host:port/database
```

Подставим наши учебные реквизиты:

```text
postgresql://training:training@db:5432/training
```

Разберём строку:

```text
postgresql://training:training@db:5432/training
│            │        │        │   │    │
│            │        │        │   │    └── database
│            │        │        │   └─────── port
│            │        │        └─────────── host
│            │        └──────────────────── password
│            └───────────────────────────── username
└────────────────────────────────────────── тип подключения
```

В этом курсе не нужно заучивать синтаксис SQLAlchemy URI.

Важно понять связь: поля формы подключения и URI описывают одни и те же реквизиты соединения.

Схема `training` в этот URI **не входит**. URI подключает нас к базе PostgreSQL `training`, а нужную схему внутри этой базы мы выбираем отдельно.

## Проверяем, что Superset видит схему и таблицу

Одного сообщения `Test Connection` недостаточно для учебной проверки. Нам нужно убедиться, что через сохранённое подключение Superset действительно получает метаданные нужной таблицы.

Откройте раздел:

```text
Datasets
```

Начните создание нового Dataset через кнопку добавления Dataset.

В форме выбора источника выберите базу:

```text
Training PostgreSQL
```

После выбора базы откройте список схем.

В нём должна быть:

```text
training
```

Выберите её.

После этого откройте список таблиц.

В нём должна быть:

```text
sales
```

Если одновременно доступны:

```text
Database: Training PostgreSQL
Schema:   training
Table:    sales
```

то подключение работает полностью для задачи этого урока.

**Не завершайте создание Dataset.**

Закройте форму или вернитесь назад, не создавая новый объект.

Создание Dataset — отдельный навык следующего урока.

## Что произошло внутри

После сохранения подключения цепочка стала такой:

```text
Browser
   │
   ▼
Superset
   │
   │ сохранённое Database connection
   │
   ▼
PostgreSQL service: db:5432
   │
   ▼
database: training
   │
   ▼
schema: training
   │
   ▼
table: sales
```

Когда вы открыли списки схем и таблиц, Superset запросил у PostgreSQL метаданные доступных объектов.

Но строки `training.sales` при этом не были импортированы в отдельное хранилище Superset.

Дальше Dataset будет описывать, **как Superset должен использовать конкретную таблицу или SQL-запрос как аналитический набор данных**.

## Важное различие: Database, schema и table

В PostgreSQL эти уровни нельзя смешивать.

Для нашего курса структура такая:

```text
database
└── training
    │
    └── schema
        └── training
            │
            └── table
                └── sales
```

Поэтому запись:

```text
training.sales
```

означает:

```text
schema.table
```

а не:

```text
database.table
```

Полное описание учебного объекта словами:

```text
база PostgreSQL training
→ схема training
→ таблица sales
```

Это различие понадобится уже в следующем уроке.

## Попробуйте сами

Не подглядывая в таблицу реквизитов выше:

1. откройте `Database Connections`;
2. найдите `Training PostgreSQL`;
3. откройте его для просмотра или редактирования;
4. вспомните, почему `Host` равен `db`, а не `localhost`;
5. вернитесь в `Datasets`;
6. начните добавление Dataset;
7. убедитесь, что для `Training PostgreSQL` доступны схема `training` и таблица `sales`;
8. выйдите из формы, ничего не создавая.

Если всё получилось, вы уже умеете отличать создание подключения к базе от создания Dataset.

## Если не получилось

### PostgreSQL отсутствует среди типов баз

Проверьте версию и образ учебного Superset:

```bash
docker compose exec superset superset version
```

Ожидаемая версия:

```text
6.1.0
```

Учебный стенд использует:

```text
apache/superset:6.1.0-dev
```

Для подключения к PostgreSQL Superset нужен соответствующий Python DB-API драйвер. В учебном образе он уже предусмотрен; отдельно устанавливать драйвер в рамках курса не нужно.

### `Test Connection` не проходит, а Host указан как `localhost`

Для этого стенда замените:

```text
localhost
```

на:

```text
db
```

Superset подключается к PostgreSQL из своего контейнера, поэтому использует имя Compose-сервиса.

### Ошибка соединения с `db:5432`

Проверьте контейнеры:

```bash
docker compose ps -a
```

Сервис `db` должен быть `running` и `healthy`.

Посмотрите журнал PostgreSQL:

```bash
docker compose logs db
```

Если `db` не запущен, сначала восстановите стенд по уроку 02.

### Ошибка аутентификации

Проверьте значения без изменений:

```text
Username: training
Password: training
```

Это учебные реквизиты из `training/compose.yaml`.

### Ошибка, что база не существует

Проверьте:

```text
Database name: training
```

Затем повторно выполните контроль учебных данных:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Если `check.sql` выполняется, база `training` существует и PostgreSQL работает.

### Соединение проходит, но схема `training` не видна

Сначала повторно выполните:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Если контрольные значения правильные, таблица существует в PostgreSQL.

Затем проверьте, что в Superset сохранено именно подключение к базе:

```text
training
```

а не к другой PostgreSQL-базе.

### Схема видна, но таблицы `sales` нет

Проверьте, что в выборе Dataset указана именно схема:

```text
training
```

и ещё раз выполните `check.sql`.

Не создавайте вместо `sales` другую таблицу вручную. Учебный набор должен оставаться одинаковым для всех последующих уроков.

## Не делаем полный reset без необходимости

После этого урока подключение `Training PostgreSQL` хранится в служебном состоянии Superset.

Команда:

```bash
docker compose down -v --remove-orphans
```

удалит volumes учебного стенда, а вместе с ними и созданное подключение.

Поэтому полный reset используйте только если действительно хотите начать курс сначала.

Обычные команды:

```bash
docker compose stop
```

и затем:

```bash
docker compose up -d
```

созданное подключение сохраняют.

## Что должно получиться

К концу урока одновременно выполнены четыре условия:

- в `Database Connections` есть `Training PostgreSQL`;
- `Test Connection` для учебных реквизитов проходит успешно;
- Superset показывает схему `training`;
- внутри неё Superset показывает таблицу `sales`.

Dataset при этом ещё **не создан**.

Это и есть правильная конечная точка урока 03.

## Следующий урок

Теперь Superset умеет подключаться к PostgreSQL и видит таблицу `training.sales`.

Следующий шаг — превратить эту таблицу в первый физический Dataset Superset, проверить его столбцы и научиться повторно открывать его настройки.

→ [Урок 04. Создаём первый Dataset](04-create-dataset.md)

## Официальные источники

Материал урока сверяется с документацией Apache Superset 6.1.0 и Docker Compose:

- подключение баз данных в Superset: <https://superset.apache.org/user-docs/6.1.0/databases/>
- PostgreSQL в Superset и формат connection string: <https://superset.apache.org/user-docs/6.1.0/databases/supported/postgresql/>
- архитектура Superset и различие между приложением, metadata database и источниками данных: <https://superset.apache.org/admin-docs/6.1.0/installation/architecture/>
- сеть Docker Compose и обращение к сервисам по имени: <https://docs.docker.com/compose/how-tos/networking/>

В учебном стенде реквизиты PostgreSQL задаются непосредственно в [`training/compose.yaml`](../training/compose.yaml).