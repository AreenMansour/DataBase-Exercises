WITH ml_authors AS (
    SELECT name
    FROM authors
    WHERE conference IN (SELECT conference FROM conferences WHERE subarea = 'ml')
    GROUP BY name
    HAVING COUNT(DISTINCT conference) >= 3
),
recent_ml_authors AS (
    SELECT name
    FROM authors
    WHERE conference IN (SELECT conference FROM conferences WHERE subarea = 'ml')
    AND year >= 2020
    GROUP BY name
    HAVING COUNT(DISTINCT conference) >= 1
)
SELECT DISTINCT name
FROM ml_authors
WHERE name IN (SELECT name FROM recent_ml_authors)
ORDER BY name;
