CREATE DATABASE music_collection;

USE music_collection;

# Таблица для исполнителей
CREATE TABLE artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

# Таблица для альбомов
CREATE TABLE albums (
    album_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT,
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

# Таблица для треков
CREATE TABLE tracks (
    track_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration INT, -- Продолжительность трека в секундах
    album_id INT,
    FOREIGN KEY (album_id) REFERENCES albums(album_id)
);

# Таблица для жанров
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

# Таблица для связи альбомов с жанрами (многие-ко-многим)
CREATE TABLE album_genre (
    album_id INT,
    genre_id INT,
    FOREIGN KEY (album_id) REFERENCES albums(album_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

INSERT INTO `artists` (`artist_id`, `name`) VALUES
(1, 'Rammstein'),
(2, 'Pink Floyd'),
(3, 'Sabaton'),
(4, 'Tchaikovsky');


INSERT INTO `albums` (`album_id`, `title`, `release_year`, `artist_id`) VALUES
(1, 'Mutter', 2001, 1),
(2, 'The Wall', 1979, 2),
(3, 'Heroes', 2014, 3);

INSERT INTO `genres` (`genre_id`, `name`) VALUES
(1, 'Rock'),
(2, 'Metal'),
(3, 'Classic');

INSERT INTO `tracks` (`track_id`, `title`, `duration`, `album_id`) VALUES
(1, 'Nebel', 241, 1),
(2, 'Another Brick in the Wall', 194, 2),
(3, 'To Hell and Back', 207, 3);

INSERT INTO `album_genre` (`album_id`, `genre_id`) VALUES
(1, 2),
(2, 1),
(3, 2);

/* Выбрать все альбомы и их треки для конкретного исполнителя (например, "The Beatles")*/
SELECT artists.name AS artist, albums.title AS album, tracks.title AS track
FROM artists
JOIN albums ON artists.artist_id = albums.artist_id
LEFT JOIN tracks ON albums.album_id = tracks.album_id
WHERE artists.name = 'The Beatles';

/*Получить список всех исполнителей и количество альбомов у каждого исполнителя:*/
SELECT artists.name AS artist, COUNT(albums.album_id) AS album_count
FROM artists
LEFT JOIN albums ON artists.artist_id = albums.artist_id
GROUP BY artists.name;

/*Найти альбомы, которые принадлежат более чем одному жанру:*/
SELECT albums.title AS album, GROUP_CONCAT(DISTINCT genres.name ORDER BY genres.name ASC) AS genres
FROM albums
JOIN album_genre ON albums.album_id = album_genre.album_id
JOIN genres ON album_genre.genre_id = genres.genre_id
GROUP BY albums.title
HAVING COUNT(DISTINCT genres.genre_id) > 1;

/*Найти самый длинный трек и его альбом:*/
SELECT tracks.title AS track, tracks.duration, albums.title AS album
FROM tracks
JOIN albums ON tracks.album_id = albums.album_id
ORDER BY tracks.duration DESC
LIMIT 1;

/*Получить список альбомов, выпущенных в конкретном году, включая список треков в каждом альбоме:*/
SELECT albums.title AS album, albums.release_year, GROUP_CONCAT(tracks.title ORDER BY tracks.title ASC) AS tracks
FROM albums
LEFT JOIN tracks ON albums.album_id = tracks.album_id
GROUP BY albums.title
HAVING albums.release_year = 2001;

/*Найти количество альбомов в каждом жанре:*/
SELECT genres.name AS genre, COUNT(album_genre.album_id) AS album_count
FROM genres
LEFT JOIN album_genre ON genres.genre_id = album_genre.genre_id
GROUP BY genres.name;
