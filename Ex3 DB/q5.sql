SELECT DISTINCT name
FROM authors
WHERE conference IN (SELECT conference FROM conferences WHERE area = 'theory')
AND year < 1980
AND name NOT IN (
    SELECT DISTINCT name
    FROM authors
    WHERE conference NOT IN (SELECT conference FROM conferences WHERE area = 'theory')
    OR year >= 1980)
ORDER BY name;