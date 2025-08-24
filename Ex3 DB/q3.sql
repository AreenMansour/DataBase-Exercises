SELECT DISTINCT institution,name
FROM authors
WHERE institution IN (SELECT institution FROM institutions WHERE country = 'il')
AND conference LIKE 'sig%'
AND totalcount >= 2
ORDER BY institution,name;