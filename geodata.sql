use geodata;

-- задание 1

SELECT 
    _countries.title AS country_name,
    _regions.title AS region_name
FROM
    _cities
        INNER JOIN
    _regions ON _cities.region_id = _regions.id
        INNER JOIN
    _countries ON _cities.country_id = _countries.id
WHERE
    _cities.title = 'Октябрьский';

-- задание 2

SELECT 
    c.title AS city_name
FROM
    _cities AS c
        INNER JOIN
    _regions AS r ON c.region_id = r.id
WHERE
    r.title = 'Московская область';

