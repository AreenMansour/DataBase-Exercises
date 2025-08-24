SELECT DISTINCT M1.movieId, M1.title, M1.duration
FROM movies M1
JOIN (
    SELECT M2.year, MIN(M2.duration) AS min_duration
    FROM movies M2
    GROUP BY M2.year
) AS min_dur
ON M1.year = min_dur.year AND M1.duration = min_dur.min_duration
ORDER BY M1.movieId, M1.title, M1.duration;
