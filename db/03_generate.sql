-- Лаба 1 ★★. Генерация 1000+ строк скриптом.

INSERT INTO evidence (case_id, description, found_at, type)
SELECT 1,
       'Сгенерированная улика ' || g,
       now() - (g || ' hours')::interval,
       'physical'
FROM generate_series(1, 1000) AS g;