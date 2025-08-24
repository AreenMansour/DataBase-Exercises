SELECT DISTINCT A.name
FROM authors AS A
JOIN (
    SELECT A.conference, COUNT(DISTINCT A.year) AS year_count
    FROM authors AS A
    NATURAL JOIN conferences AS C
    GROUP BY A.conference
) AS C ON A.conference = C.conference
WHERE C.year_count <= 15
AND A.name NOT IN (
    SELECT DISTINCT A.name
    FROM authors AS A
    JOIN (
        SELECT A.conference, COUNT(DISTINCT A.year) AS year_count
        FROM authors AS A
        NATURAL JOIN conferences AS C
        GROUP BY A.conference
    ) AS C ON A.conference = C.conference
    WHERE C.year_count > 15
)
ORDER BY A.name ASC;
