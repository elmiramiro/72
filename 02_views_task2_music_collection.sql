-- ===========================================
-- Модуль 17. Введение в теорию БД. Часть 5.1
-- Задание 2. БД «Музыкальная коллекция»
-- Обновляемые представления (INSERT/UPDATE/DELETE)
-- ===========================================

-- Предполагаемая структура таблиц:
--   performers (id, name)
--   styles     (id, name)
--   discs      (id, title, performer_id, publisher_id)
--   songs      (id, title, duration, disc_id, style_id)
--   publishers (id, name, address, phone, site)


-- -------------------------------------------
-- 2.1. Обновляемое представление для вставки
--      новых музыкальных стилей
-- -------------------------------------------

DROP VIEW IF EXISTS v_insert_styles;

CREATE VIEW v_insert_styles AS
SELECT
    id,
    name
FROM styles;

-- Пример использования:
-- INSERT INTO v_insert_styles (name)
-- VALUES ('Symphonic Metal');


-- -------------------------------------------
-- 2.2. Обновляемое представление для вставки
--      новых песен
-- -------------------------------------------

DROP VIEW IF EXISTS v_insert_songs;

CREATE VIEW v_insert_songs AS
SELECT
    id,
    title,
    duration,
    disc_id,
    style_id
FROM songs;

-- Пример использования:
-- INSERT INTO v_insert_songs (title, duration, disc_id, style_id)
-- VALUES ('New Track', 245, 1, 3);


-- -------------------------------------------
-- 2.3. Обновляемое представление для
--      обновления информации об издателе
-- -------------------------------------------

-- Предполагается, что есть отдельная таблица publishers.
-- Если в вашей БД издатель хранится непосредственно в таблице discs
-- в текстовом поле (например, disc.publisher_name),
-- нужно адаптировать представление под таблицу discs.

DROP VIEW IF EXISTS v_update_publishers;

CREATE VIEW v_update_publishers AS
SELECT
    id,
    name,
    address,
    phone,
    site
FROM publishers;

-- Примеры использования:
-- Изменить телефон издателя:
-- UPDATE v_update_publishers
-- SET phone = '+7-843-123-45-67'
-- WHERE name = 'Sony Music';
--
-- Изменить сайт издателя:
-- UPDATE v_update_publishers
-- SET site = 'https://new-label-site.com'
-- WHERE id = 2;


-- -------------------------------------------
-- 2.4. Обновляемое представление для удаления
--      исполнителей из коллекции
-- -------------------------------------------

DROP VIEW IF EXISTS v_delete_performers;

CREATE VIEW v_delete_performers AS
SELECT
    id,
    name
FROM performers;

-- Важно: если в БД настроены внешние ключи с ограничением
--        ссылочной целостности (FOREIGN KEY discs.performer_id REFERENCES performers(id)),
--        то перед удалением исполнителя нужно либо:
--        - удалить связанные диски и песни;
--        - либо изменить performer_id в discs на другого исполнителя.
--
-- Пример удаления исполнителя:
-- DELETE FROM v_delete_performers
-- WHERE name = 'Unknown Artist';


-- -------------------------------------------
-- 2.5. Обновляемое представление для точечного
--      обновления информации о конкретном
--      исполнителе (например, 'Muse')
-- -------------------------------------------

DROP VIEW IF EXISTS v_update_muse;

CREATE VIEW v_update_muse AS
SELECT
    id,
    name
FROM performers
WHERE name = 'Muse';

-- Примеры использования:
-- Изменить написание имени исполнителя:
-- UPDATE v_update_muse
-- SET name = 'Muse (UK)'
-- WHERE name = 'Muse';
--
-- Вернуть обратно:
-- UPDATE v_update_muse
-- SET name = 'Muse'
-- WHERE name = 'Muse (UK)';
