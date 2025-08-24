SELECT DISTINCT institution, name
FROM authors
WHERE institution IN (SELECT institution FROM institutions WHERE region = 'africa')
ORDER BY institution,name;