SELECT DISTINCT name
FROM authors AS a1
WHERE NOT EXISTS (
    SELECT conference, year
    FROM authors AS a2
    WHERE a2.name = 'Omri Abend'
    EXCEPT
    SELECT conference, year
    FROM authors AS a3
    WHERE a3.name = a1.name)
ORDER BY name;