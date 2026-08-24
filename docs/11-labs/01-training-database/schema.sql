CREATE TABLE training.sales (
  sale_id BIGINT PRIMARY KEY,
  sale_ts TIMESTAMPTZ NOT NULL,
  region TEXT NOT NULL,
  office TEXT NOT NULL,
  manager TEXT,
  product TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  revenue NUMERIC(12,2) NOT NULL,
  cost NUMERIC(12,2) NOT NULL
);
