-- ===========================================
-- Модуль 17. Введение в теорию БД. Часть 5.1
-- Задание 1. БД «Музыкальная коллекция»
-- Представления для работы с коллекцией
-- ===========================================

-- Предполагаемая структура таблиц (для понимания):
-- performers (id, name)                          -- исполнители
-- styles     (id, name)                          -- музыкальные стили
-- discs      (id, title, performer_id)           -- диски (альбомы)
-- songs      (id, title, duration, disc_id, style_id) -- песни

-- 1) Представление: названия всех исполнителей
DROP VIEW IF EXISTS v_all_performers;
CREATE VIEW v_all_performers AS
SELECT
    p.name AS performer_name
FROM performers AS p;


-- 2) Представление: полная информация о всех песнях
-- (название песни, название диска, длительность песни, музыкальный стиль, исполнитель)
DROP VIEW IF EXISTS v_songs_full_info;
CREATE VIEW v_songs_full_info AS
SELECT
    s.title    AS song_title,      -- название песни
    d.title    AS disc_title,      -- название диска
    s.duration AS song_duration,   -- длительность песни
    st.name    AS style_name,      -- музыкальный стиль
    p.name     AS performer_name   -- исполнитель
FROM songs      AS s
JOIN discs      AS d  ON s.disc_id      = d.id
JOIN styles     AS st ON s.style_id     = st.id
JOIN performers AS p  ON d.performer_id = p.id;


-- 3) Представление: информация о музыкальных альбомах
-- (диск, исполнитель, число песен, общая длительность альбома)
DROP VIEW IF EXISTS v_albums_info;
CREATE VIEW v_albums_info AS
SELECT
    d.id             AS disc_id,
    d.title          AS disc_title,       -- название диска
    p.name           AS performer_name,   -- исполнитель
    COUNT(s.id)      AS songs_count,      -- количество песен
    COALESCE(SUM(s.duration), 0) AS total_duration  -- суммарная длительность
FROM discs      AS d
JOIN performers AS p ON d.performer_id = p.id
LEFT JOIN songs AS s ON s.disc_id      = d.id
GROUP BY
    d.id,
    d.title,
    p.name;


-- 4) Представление: самый популярный исполнитель
-- (по количеству дисков в коллекции)
DROP VIEW IF EXISTS v_most_popular_performer;
CREATE VIEW v_most_popular_performer AS
SELECT
    p.id,
    p.name,
    COUNT(d.id) AS discs_count
FROM performers AS p
LEFT JOIN discs AS d ON d.performer_id = p.id
GROUP BY
    p.id,
    p.name
ORDER BY discs_count DESC
LIMIT 1;


-- 5) Представление: топ-3 самых популярных исполнителей
-- (по количеству дисков)
DROP VIEW IF EXISTS v_top3_performers;
CREATE VIEW v_top3_performers AS
SELECT
    p.id,
    p.name,
    COUNT(d.id) AS discs_count
FROM performers AS p
LEFT JOIN discs AS d ON d.performer_id = p.id
GROUP BY
    p.id,
    p.name
ORDER BY discs_count DESC
LIMIT 3;


-- 6) Представление: самый долгий по длительности музыкальный альбом
-- (по сумме длительностей всех песен диска)
DROP VIEW IF EXISTS v_longest_album;
CREATE VIEW v_longest_album AS
SELECT
    d.id            AS disc_id,
    d.title         AS disc_title,
    p.name          AS performer_name,
    SUM(s.duration) AS total_duration
FROM discs      AS d
JOIN performers AS p ON d.performer_id = p.id
JOIN songs      AS s ON s.disc_id      = d.id
GROUP BY
    d.id,
    d.title,
    p.name
HAVING SUM(s.duration) = (
    SELECT MAX(total_duration)
    FROM (
        SELECT
            d2.id            AS disc_id,
            SUM(s2.duration) AS total_duration
        FROM discs AS d2
        JOIN songs AS s2 ON s2.disc_id = d2.id
        GROUP BY d2.id
    ) AS t
);
