use geodata;

-- задание 1

select
	_countries.title as country_name, _regions.title as region_name
from _cities
	INNER JOIN _regions ON _cities.region_id = _regions.id
    INNER JOIN _countries ON _cities.country_id = _countries.id
WHERE _cities.title = 'Октябрьский';

-- задание 2

select
	c.title as city_name
from _cities as c
	INNER JOIN _regions as r ON c.region_id = r.id
WHERE r.title = 'Московская область';

