# 03. Подключаем PostgreSQL

Стенд уже работает, таблица `training.sales` существует, но Superset пока о ней ничего не знает. В этом уроке создадим одно подключение:

```text
Training PostgreSQL
```

Dataset пока не создаём — это будет следующим шагом.

## Быстрая проверка стенда

Из каталога `training` убедитесь, что контейнеры в нормальном состоянии:

```bash
docker compose ps -a
```

Ожидаем:

```text
db             running / healthy
superset       running / healthy
superset-init  exited (0)
```

Если есть сомнения в данных, запустите контрольный скрипт:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Основные значения:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

## Каким пользователем подключаться

В учебной PostgreSQL есть две разные учётные записи, и смешивать их не нужно.

`training` — владелец базы. Он используется для инициализации стенда и административных проверок из терминала.

`superset_reader` — отдельный пользователь только для чтения. Его создаёт [`../training/readonly.sql`](../training/readonly.sql), и именно его используем в Superset.

Для схемы `training` ему достаточно прав:

```text
CONNECT
USAGE
SELECT
```

Такой подход полезно закрепить с самого начала: BI-инструменту не нужен владелец базы, если задача — читать данные.

## Реквизиты

| Поле Superset | Значение |
|---|---|
| Database type | `PostgreSQL` |
| Host | `db` |
| Port | `5432` |
| Database name | `training` |
| Username | `superset_reader` |
| Password | `superset_reader` |
| Display Name | `Training PostgreSQL` |

`Display Name` — имя подключения внутри Superset. Оно никак не переименовывает базу PostgreSQL.

### Почему Host именно `db`

Superset и PostgreSQL находятся в разных контейнерах одного Compose-проекта. Внутри этой сети PostgreSQL доступен по имени сервиса `db`:

```text
superset → db:5432
```

`localhost` внутри контейнера Superset означал бы сам контейнер Superset, а не PostgreSQL. Поэтому здесь `localhost` — неправильный адрес.

## Создаём подключение

Откройте Superset:

```text
http://localhost:8088
```

Войдите под учебной учётной записью `admin / admin` и перейдите:

```text
Settings → Data → Database Connections
```

Нажмите кнопку:

```text
Database
```

Затем выберите:

```text
PostgreSQL
```

В форме укажите:

```text
Host:          db
Port:          5432
Database name: training
Username:      superset_reader
Password:      superset_reader
Display Name:  Training PostgreSQL
```

Не подставляйте `training / training` в `Username` и `Password`: это владелец учебной базы, а не пользователь для аналитического подключения.

## Сначала тест, потом сохранение

Нажмите:

```text
Test Connection
```

Если тест прошёл, Superset смог найти `db`, подключиться к порту `5432`, открыть базу `training` и пройти аутентификацию как `superset_reader`.

После этого нажмите:

```text
Connect
```

Разница простая: `Test Connection` только проверяет реквизиты, `Connect` сохраняет объект Database.

## Проверяем, что Superset действительно видит данные

Вернитесь в:

```text
Settings → Data → Database Connections
```

В списке должно появиться:

```text
Training PostgreSQL
```

Теперь откройте:

```text
Datasets
```

и нажмите:

```text
+ Dataset
```

В форме выбора источника последовательно выберите:

```text
Database: Training PostgreSQL
Schema:   training
Table:    sales
```

Если все три значения доступны, подключение работает как нужно. Нажмите `Cancel`: сам Dataset создадим уже в следующем уроке.

Если схема `training` или таблица `sales` не видна, проблема ещё на уровне подключения или прав пользователя — переходить дальше рано.

## Небольшое уточнение про PostgreSQL

В нашей базе структура такая:

```text
база training
└── схема training
    └── таблица sales
```

Поэтому запись:

```text
training.sales
```

означает `схема.таблица`, а не `база.таблица`.

Те же реквизиты подключения можно записать SQLAlchemy URI:

```text
postgresql://superset_reader:superset_reader@db:5432/training
```

Для этого урока вводить URI вручную не требуется, но полезно понимать, что в нём находятся пользователь, пароль, узел, порт и база. Схема `training` туда не входит.

## Если подключение не проходит

Если `Test Connection` падает, сначала просто сравните форму с эталоном:

```text
Host          = db
Port          = 5432
Database name = training
Username      = superset_reader
Password      = superset_reader
Display Name  = Training PostgreSQL
```

Затем проверьте контейнеры:

```bash
docker compose ps -a
```

Если в `Host` стоит `localhost`, замените его на `db`.

Если подключение сохранилось под именем `PostgreSQL`, а не `Training PostgreSQL`, исправьте `Display Name`: это имя используется дальше во всём курсе.

Если не видна схема `training`, проверьте, что подключение действительно выполнено пользователем `superset_reader` и что `readonly.sql` отработал при создании базы.

При необходимости можно проверить чтение напрямую из терминала:

```bash
docker compose exec -T db bash -lc \
  "PGPASSWORD=superset_reader psql -h 127.0.0.1 -U superset_reader -d training -c 'SELECT COUNT(*) FROM training.sales;'"
```

Ожидается:

```text
count
-----
12
```

Записывать данные этим пользователем нельзя — и для нашего сценария это правильно.

## Можно идти дальше, если

В Superset есть подключение `Training PostgreSQL`, `Test Connection` проходит, а в форме создания Dataset видны:

```text
Database = Training PostgreSQL
Schema   = training
Table    = sales
```

Следующий урок — уже про сам Dataset.

→ [Урок 04. Создаём первый Dataset](04-create-dataset.md)

## Источники Superset 6.1.0

- список `Database Connections` и кнопка `Database`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/pages/DatabaseList/index.tsx>
- окно `Connect a database` и кнопка `Connect`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/features/databases/DatabaseModal/index.tsx>
- поля `Host`, `Port`, `Database name`, `Username`, `Password`, `Display Name`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/features/databases/DatabaseModal/DatabaseConnectionForm/CommonParameters.tsx>
- тест `Test Connection`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/features/databases/DatabaseModal/index.test.tsx>
- учебные права PostgreSQL: [`../training/readonly.sql`](../training/readonly.sql)