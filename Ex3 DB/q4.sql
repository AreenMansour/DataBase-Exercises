SELECT DISTINCT a1.name, a1.year
FROM authors a1, conferences c1, authors a2, conferences c2
WHERE a1.conference = c1.conference
  AND a1.name = a2.name
  AND a1.year = a2.year
  AND a2.conference = c2.conference
  AND a1.institution = 'Hebrew University of Jerusalem'
  AND c1.subarea = 'ai'
  AND c2.subarea = 'economics'
ORDER BY a1.name, a1.year;