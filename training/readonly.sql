-- Отдельная учётная запись Superset с минимальными правами на учебные данные.
-- Владелец базы training используется только для инициализации стенда.

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'superset_reader'
    ) THEN
        CREATE ROLE superset_reader
            LOGIN
            PASSWORD 'superset_reader';
    END IF;
END
$$;

GRANT CONNECT ON DATABASE training TO superset_reader;
GRANT USAGE ON SCHEMA training TO superset_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA training TO superset_reader;

-- Новые таблицы, которые владелец training создаст в учебной схеме позднее,
-- также будут доступны Superset только на чтение.
ALTER DEFAULT PRIVILEGES FOR ROLE training IN SCHEMA training
    GRANT SELECT ON TABLES TO superset_reader;
