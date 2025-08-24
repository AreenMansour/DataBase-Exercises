WITH yearly_publications AS (
    SELECT
        a.name,
        SUM(a.totalcount) AS totalcount,
        a.year
    FROM
        authors a
    NATURAL JOIN
        conferences c
    WHERE
        a.institution = 'Hebrew University of Jerusalem'
        AND c.area = 'ai'
        AND a.year BETWEEN 2000 AND 2020
    GROUP BY
        a.name, a.year
),
highest_publications AS (
    SELECT
        year,
        MAX(totalcount) AS max_count
    FROM
        yearly_publications
    GROUP BY
        year
)
SELECT
    yp.year,
    yp.name
FROM
    yearly_publications yp
WHERE
    yp.totalcount = (
        SELECT
            hp.max_count
        FROM
            highest_publications hp
        WHERE
            hp.year = yp.year
    )
ORDER BY
    yp.year, yp.name;
