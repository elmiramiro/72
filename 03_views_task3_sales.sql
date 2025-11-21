-- ===========================================
-- Модуль 17. Введение в теорию БД. Часть 5.1
-- Задание 3. БД «Продажи»
-- Представления (обновляемые и обычные)
-- ===========================================

-- Предполагаемая структура таблиц:
--   salesmen  (id, name, ...)
--   customers (id, name, ...)
--   goods     (id, name, ...)
--   sales     (id, salesman_id, customer_id,
--              good_id, quantity, amount, sale_date)


-- -------------------------------------------
-- 3.1. Обновляемое представление, отображающее
--      информацию о всех продавцах
-- -------------------------------------------

DROP VIEW IF EXISTS v_all_salesmen;

CREATE VIEW v_all_salesmen AS
SELECT
    id,
    name
FROM salesmen;

-- Примеры использования:
-- INSERT INTO v_all_salesmen (name)
-- VALUES ('Иванов И.И.');
--
-- UPDATE v_all_salesmen
-- SET name = 'Петров П.П.'
-- WHERE id = 1;
--
-- DELETE FROM v_all_salesmen
-- WHERE id = 3;


-- -------------------------------------------
-- 3.2. Обновляемое представление, отображающее
--      информацию о всех покупателях
-- -------------------------------------------

DROP VIEW IF EXISTS v_all_customers;

CREATE VIEW v_all_customers AS
SELECT
    id,
    name
FROM customers;

-- Примеры использования:
-- INSERT INTO v_all_customers (name)
-- VALUES ('ООО "Колос"');
--
-- UPDATE v_all_customers
-- SET name = 'ООО "Новый Колос"'
-- WHERE id = 2;
--
-- DELETE FROM v_all_customers
-- WHERE id = 4;


-- -------------------------------------------
-- 3.3. Обновляемое представление, отображающее
--      все продажи конкретного товара
--      (например, яблок)
-- -------------------------------------------

-- Вариант 1: фильтрация по id товара (предпочтительно с точки
-- зрения целостности, если вам известен id товара "Яблоки").
-- Предположим, что товар "Яблоки" имеет good_id = 1.

DROP VIEW IF EXISTS v_sales_apples;

CREATE VIEW v_sales_apples AS
SELECT
    id,
    salesman_id,
    customer_id,
    good_id,
    quantity,
    amount,
    sale_date
FROM sales
WHERE good_id = 1;    -- здесь подставьте id товара "Яблоки"

-- Примеры использования:
-- Добавить новую продажу яблок:
-- INSERT INTO v_sales_apples (salesman_id, customer_id, quantity, amount, sale_date)
-- VALUES (1, 2, 10, 500.00, '2025-11-21');
--
-- Обновить существующую продажу яблок:
-- UPDATE v_sales_apples
-- SET quantity = 15, amount = 700.00
-- WHERE id = 5;
--
-- Удалить запись о продаже:
-- DELETE FROM v_sales_apples
-- WHERE id = 6;


-- -------------------------------------------
-- 3.4. Представление, отображающее все
--      осуществлённые сделки
-- -------------------------------------------

DROP VIEW IF EXISTS v_all_deals;

CREATE VIEW v_all_deals AS
SELECT
    s.id           AS sale_id,
    sm.name        AS salesman_name,
    c.name         AS customer_name,
    g.name         AS good_name,
    s.quantity,
    s.amount,
    s.sale_date
FROM sales     AS s
JOIN salesmen  AS sm ON s.salesman_id = sm.id
JOIN customers AS c  ON s.customer_id = c.id
JOIN goods     AS g  ON s.good_id     = g.id;

-- Пример использования:
-- SELECT * FROM v_all_deals;
-- Позволяет получить «человеческий» отчёт по всем сделкам.


-- -------------------------------------------
-- 3.5. Представление, отображающее информацию
--      о самом активном продавце
--      (по максимальной общей сумме продаж)
-- -------------------------------------------

DROP VIEW IF EXISTS v_top_salesman;

CREATE VIEW v_top_salesman AS
SELECT
    sm.id,
    sm.name,
    SUM(s.amount) AS total_sales
FROM sales    AS s
JOIN salesmen AS sm ON s.salesman_id = sm.id
GROUP BY
    sm.id,
    sm.name
ORDER BY total_sales DESC
LIMIT 1;

-- Пример использования:
-- SELECT * FROM v_top_salesman;


-- -------------------------------------------
-- 3.6. Представление, отображающее информацию
--      о самом активном покупателе
--      (по максимальной общей сумме покупок)
-- -------------------------------------------

DROP VIEW IF EXISTS v_top_customer;

CREATE VIEW v_top_customer AS
SELECT
    c.id,
    c.name,
    SUM(s.amount) AS total_purchases
FROM sales     AS s
JOIN customers AS c ON s.customer_id = c.id
GROUP BY
    c.id,
    c.name
ORDER BY total_purchases DESC
LIMIT 1;

-- Пример использования:
-- SELECT * FROM v_top_customer;
