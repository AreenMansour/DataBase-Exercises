WITH country_counts AS (
    SELECT institutions.country, authors.institution, SUM(authors.totalcount) AS countryCount
    FROM authors, institutions
    WHERE authors.institution = institutions.institution
    GROUP BY institutions.country, authors.institution
),
max_country_counts AS (
    SELECT country, MAX(countryCount) AS maxCount
    FROM country_counts
    GROUP BY country
)
SELECT cc.country, cc.institution, cc.countryCount
FROM country_counts cc
WHERE cc.countryCount = (SELECT maxCount FROM max_country_counts mcc WHERE mcc.country = cc.country)
ORDER BY cc.country, cc.institution;
