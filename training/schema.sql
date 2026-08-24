CREATE SCHEMA IF NOT EXISTS training AUTHORIZATION training;

CREATE TABLE IF NOT EXISTS training.sales (
    sale_id BIGINT PRIMARY KEY,
    sale_date DATE NOT NULL,
    region TEXT NOT NULL,
    office TEXT NOT NULL,
    manager TEXT,
    product TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    revenue NUMERIC(12,2) NOT NULL CHECK (revenue >= 0),
    cost NUMERIC(12,2) NOT NULL CHECK (cost >= 0)
);
