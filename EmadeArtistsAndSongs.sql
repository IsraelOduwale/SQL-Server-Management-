-- =============================================
-- Author:		Israel Oduwale
-- Create date: 11-09-2025
-- Description:	This code is to create and run analysis on the tables in EmadeArtistsAndSongs Project
-- Revise Date: 
-- Version:		v2.0
-- =============================================

USE EMADE_DEV;

DROP TABLE IF EXISTS EMADE_ARTISTS;
create table EMADE_ARTISTS
(
artist_id INT,
artist_name VARCHAR(50),
label_owner VARCHAR(100)
);


insert into EMADE_ARTISTS values
(101, 'Ed Sheeran', 'Warner Music Group'),
(120, 'Drake', 'Warner Music Group'),
(125, 'Bad Bunny', 'Rimas Entertainment'),
(145, 'Lady Gaga', 'Interscope Records'),
(160, 'Chris Brown', 'RCA Records'),
(200, 'Adele', 'Columbia Records'),
(240, 'Katy Perry', 'Capitol Records'),
(250, 'The Weeknd', 'Universal Music Group'),
(260, 'Taylor Swift', 'Universal Music Group'),
(270, 'Ariana Grande', 'Universal Music Group');

DROP TABLE IF EXISTS EMADE_SONGS;
create table EMADE_SONGS
(
song_id	 INT,
artist_id INT,
name VARCHAR(100)
);


INSERT INTO EMADE_SONGS 
(song_id, artist_id, name) 
VALUES
(55511, 101, 'Perfect'),
(45202, 101, 'Shape of You'),
(22222, 120, 'One Dance'),
(19960, 120, 'Hotline Bling'),
(12636, 125, 'Mia'),
(69820, 125, 'Dakiti'),
(44552, 125, 'Callaita'),
(11254, 145, 'Bad Romance'),
(33101, 160, 'Go Crazy'),
(23299, 200, 'Hello'),
(89633, 240, 'Last Friday Night'),
(28079, 200, 'Someone Like You'),
(13997, 120, 'Rich Flex'),
(14525, 260, 'Cruel Summer'),
(23689, 260, 'Blank Space'),
(54622, 260, 'Wildest Dreams'),
(62887, 260, 'Anti-Hero'),
(56112, 270, '7 Rings'),
(86645, 270, 'Thank U, Next'),
(87752, 260, 'Karma'),
(23339, 250, 'Blinding Lights');


DROP TABLE IF EXISTS EMADE_GLOBAL_SONG_RANK;
CREATE TABLE EMADE_GLOBAL_SONG_RANK (
    day INT CHECK (day BETWEEN 1 AND 52),
    song_id INT,
    rank INT CHECK (rank BETWEEN 1 AND 1000000)
);


INSERT INTO EMADE_GLOBAL_SONG_RANK (day, song_id, rank) VALUES
(1, 45202, 2),
(3, 45202, 2),
(15, 45202, 6),
(2, 55511, 2),
(1, 19960, 3),
(9, 19960, 15),
(23, 12636, 9),
(24, 12636, 7),
(2, 12636, 23),
(29, 12636, 7),
(1, 69820, 1),
(17, 44552, 8),
(11, 44552, 16),
(11, 11254, 5),
(12, 11254, 16),
(3, 33101, 16),
(6, 23299, 1),
(14, 89633, 2),
(9, 28079, 9),
(7, 28079, 10),
(40, 11254, 1),
(37, 23299, 5),
(19, 11254, 10),
(23, 89633, 10),
(52, 33101, 7),
(20, 55511, 10),
(7, 22222, 8),
(8, 44552, 1),
(1, 54622, 34),
(2, 44552, 1),
(2, 19960, 3),
(3, 260, 1),
(3, 22222, 35),
(3, 56112, 3),
(4, 14525, 1),
(4, 23339, 29),
(4, 13997, 5),
(13, 87752, 1),
(14, 87752, 1),
(1, 11254, 12),
(51, 13997, 1),
(52, 28079, 75),
(15, 87752, 1),
(5, 14525, 1),
(6, 14525, 2),
(7, 14525, 1),
(40, 33101, 13),
(1, 54622, 84),
(7, 62887, 2),
(50, 89633, 67),
(50, 13997, 1),
(33, 13997, 3),
(1, 23299, 9);



-- Top 5 Artist

/* Assume there are three Spotify tables: EMADE_ARTISTS, EMADE_SONGS, and EMADE_GLOBAL_SONG_RANK, 
which contain information about the EMADE_ARTISTS, EMADE_SONGS, and music charts, respectively.

Write a query to find the top 5 EMADE_ARTISTS whose EMADE_SONGS appear most frequently in the 
Top 10 of the EMADE_GLOBAL_SONG_RANK table. 
Display the top 5 artist names in ascending order, along with their song appearance ranking.*/


select * from EMADE_GLOBAL_SONG_RANK
order by rank 

select * from EMADE_ARTISTS
select * from EMADE_SONGS


--Top Artists and their songs in the global rank

SELECT 
    c.day,
    c.song_id,
    c.rank,
    b.name,
    a.artist_name
FROM EMADE_ARTISTS a
JOIN EMADE_SONGS b
    ON a.artist_id = b.artist_id
JOIN EMADE_GLOBAL_SONG_RANK c
    ON c.song_id = b.song_id
WHERE c.day = (
        SELECT MAX(day)
        FROM EMADE_GLOBAL_SONG_RANK d
        WHERE d.song_id = c.song_id      
    )
--and rank<=10
ORDER BY c.rank;

--top 5 artists based on the songs latest day of the song 
--currently trending artists 
SELECT TOP 5
    x.artist_name,
    COUNT(*) AS Global_Ranking_Appearance
FROM (
    SELECT 
        c.day,
        c.song_id,
        c.rank,
        b.name,
        a.artist_name
    FROM EMADE_ARTISTS a
    JOIN EMADE_SONGS b
        ON a.artist_id = b.artist_id
    JOIN EMADE_GLOBAL_SONG_RANK c
        ON c.song_id = b.song_id
    WHERE c.day = (
            SELECT MAX(day)
            FROM EMADE_GLOBAL_SONG_RANK d
            WHERE d.song_id = c.song_id
        )
) x
WHERE x.rank <= 10      
GROUP BY x.artist_name
ORDER BY Global_Ranking_Appearance desc, x.artist_name ASC;


--top 5 artists on most frequently in the Top 10 of the EMADE_GLOBAL_SONG_RANK table. ALL TIME
--basically counts everytime an artist gets on the global song rank 
SELECT TOP 5
    C.artist_name,
    COUNT(*) AS appearance_count
FROM EMADE_GLOBAL_SONG_RANK A          
JOIN EMADE_SONGS B                   
    ON A.song_id = B.song_id
JOIN EMADE_ARTISTS C                  
    ON B.artist_id = C.artist_id
WHERE A.rank <= 10                    
GROUP BY C.artist_name
ORDER BY appearance_count DESC,       
         C.artist_name ASC;            
