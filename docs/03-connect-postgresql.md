# 03. Подключаем PostgreSQL

## Результат урока

После урока в Superset должно существовать подключение:

```text
Training PostgreSQL
```

Оно должно использовать PostgreSQL-пользователя `superset_reader` и видеть:

```text
database: training
schema:   training
table:    sales
```

Dataset в этом уроке не создаём.

## Перед началом

Должен быть пройден [урок 02](02-start-training-superset.md).

Из каталога `training` проверьте стенд:

```bash
docker compose ps -a
```

Ожидаемое состояние:

```text
db             running / healthy
superset       running / healthy
superset-init  exited (0)
```

Проверьте учебные данные:

```bash
docker compose exec -T db \
  psql -U training -d training -f /training/check.sql
```

Контрольный результат:

```text
rows     = 12
quantity = 31
revenue  = 4005.00
cost     = 2475.00
profit   = 1530.00
```

## Какой пользователь PostgreSQL нужен Superset

В стенде есть две учётные записи PostgreSQL.

### `training`

Владелец учебной базы. Используется для инициализации и контрольных команд из терминала.

### `superset_reader`

Создаётся файлом [`../training/readonly.sql`](../training/readonly.sql). Для схемы `training` ему выданы права чтения:

```text
CONNECT
USAGE
SELECT
```

Superset подключаем именно как `superset_reader`.

## Реквизиты подключения

| Поле Superset | Значение |
|---|---|
| Database type | `PostgreSQL` |
| Host | `db` |
| Port | `5432` |
| Database name | `training` |
| Username | `superset_reader` |
| Password | `superset_reader` |
| Display Name | `Training PostgreSQL` |

`Display Name` — обязательное поле формы Superset 6.1.0. Это имя подключения внутри Superset, а не имя PostgreSQL database.

## Почему Host = db

Superset и PostgreSQL работают в разных контейнерах одного Compose-проекта:

```text
superset container
      |
      | db:5432
      v
db container
```

Внутри Compose-сети имя сервиса PostgreSQL — `db`.

`localhost` в контейнере Superset указывал бы на сам контейнер Superset, поэтому для этого стенда он не подходит.

## Открываем Database Connections

Откройте:

```text
http://localhost:8088
```

Войдите:

```text
login:    admin
password: admin
```

Перейдите:

```text
Settings → Data → Database Connections
```

На странице `Database Connections` нажмите кнопку:

```text
Database
```

В Superset 6.1.0 это основная кнопка создания подключения; слева от подписи отображается значок `+`.

Откроется окно:

```text
Connect a database
```

## Выбираем PostgreSQL

На первом шаге выберите:

```text
PostgreSQL
```

После выбора откроется форма параметров соединения.

## Заполняем форму

Укажите:

```text
Host:          db
Port:          5432
Database name: training
Username:      superset_reader
Password:      superset_reader
Display Name:  Training PostgreSQL
```

Не используйте `training / training` в полях Username/Password: это владелец базы, а не учётная запись Superset.

## Проверяем соединение

Нажмите:

```text
Test Connection
```

Успешная проверка означает, что Superset смог:

```text
разрешить host db
→ подключиться к 5432
→ открыть database training
→ пройти аутентификацию как superset_reader
```

После успешного теста нажмите:

```text
Connect
```

`Test Connection` проверяет реквизиты; `Connect` сохраняет объект Database в Superset.

## Проверяем сохранённое подключение

Вернитесь в:

```text
Settings → Data → Database Connections
```

В списке должно быть:

```text
Training PostgreSQL
```

## Проверяем доступ к schema и table

Откройте верхний раздел:

```text
Datasets
```

Нажмите:

```text
+ Dataset
```

В форме выбора источника последовательно выберите:

```text
Database: Training PostgreSQL
Schema:   training
Table:    sales
```

На этом проверка подключения закончена. Нажмите `Cancel` и Dataset пока не создавайте.

Если `training` отсутствует в списке Schema или `sales` отсутствует в списке Table, подключение не готово для следующего урока. Проверьте реквизиты соединения и права `superset_reader`.

## Database, schema и table

Для учебного PostgreSQL структура такая:

```text
database training
└── schema training
    └── table sales
```

Запись:

```text
training.sales
```

означает `schema.table`, а не `database.table`.

## SQLAlchemy URI

Те же реквизиты можно представить как URI:

```text
postgresql://superset_reader:superset_reader@db:5432/training
```

В URI входят пользователь, пароль, host, port и database. Schema `training` и `Display Name` в URI не входят.

Для выполнения урока URI вручную вводить не требуется.

## Проверка прав superset_reader

При необходимости права можно проверить из терминала:

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

Запись в таблицу этой учётной записи не разрешена.

## Типовые ошибки

### Test Connection не проходит

Проверьте форму без изменений в названиях полей:

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

### Host = localhost

Для учебного Compose это неверно. Используйте:

```text
db
```

### Подключение сохранилось как PostgreSQL, а не Training PostgreSQL

В поле `Display Name` должно быть:

```text
Training PostgreSQL
```

Это имя используется во всех следующих уроках.

### Schema training не видна

Проверьте, что Superset подключён как `superset_reader`, а `readonly.sql` выполнился при первичной инициализации PostgreSQL.

## Критерий завершения

Урок завершён, когда одновременно выполняется следующее:

```text
Database Connection = Training PostgreSQL
Test Connection      = успешно
Database             = training
Schema               = training
Table                = sales
User                 = superset_reader
```

Следующий шаг — создать Physical Dataset на таблице `training.sales`.

→ [Урок 04. Создаём первый Dataset](04-create-dataset.md)

## Источники Superset 6.1.0

- список Database Connections и кнопка `Database`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/pages/DatabaseList/index.tsx>
- окно `Connect a database` и кнопка `Connect`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/features/databases/DatabaseModal/index.tsx>
- поля `Host`, `Port`, `Database name`, `Username`, `Password`, `Display Name`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/features/databases/DatabaseModal/DatabaseConnectionForm/CommonParameters.tsx>
- тест `Test Connection`: <https://github.com/apache/superset/blob/6.1.0/superset-frontend/src/features/databases/DatabaseModal/index.test.tsx>
- учебные права PostgreSQL: [`../training/readonly.sql`](../training/readonly.sql)
