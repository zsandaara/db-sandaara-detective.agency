-- Лаба 1. Сценарий для показа. Формат описан в docs/scenarios.md.
-- Запуск: dbcheck run demo/lab1.sql, или в psql: \i /demo/lab1.sql

-- 1. Таблицы на месте: 7 таблиц
-- expect: rows 7
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY 1;

-- 2. Повтор email клиента: ошибка UNIQUE
-- expect: error unique
INSERT INTO clients (name, email) VALUES ('Дубликат', 'ivan.petrov@example.com');

-- 3. Плохой статус дела: ошибка CHECK
-- expect: error check
INSERT INTO cases (client_id, title, status, fee)
VALUES (1, 'Плохой статус', 'invalid', 1000.00);

-- 4. Дело с несуществующим клиентом: ошибка внешнего ключа
-- expect: error fk
INSERT INTO cases (client_id, title, fee)
VALUES (999, 'Несуществующий клиент', 1000.00);