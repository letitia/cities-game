countries_filename = "countries-cleaned.txt";

countries2continents = {}

countries_file = open(countries_filename)
for line in countries_file:
	terms = line.split(',')
	country_id = int(terms[0])
	mapreference = terms[8][1:-1]
	countries2continents[country_id] = mapreference
countries_file.close()



cities_long_fname = "cities-cleaned.txt"

output_fname = "cities-continents.txt"
output_file = open(output_fname, 'w')

continents = {}

# get city names and parent country IDs
cities_file = open(cities_long_fname)
for line in cities_file:
	terms = line.split(',')
	city_name = terms[3][1:-1]
	continent_name = countries2continents[int(terms[1])]
	output_file.write(city_name + ',' +continent_name+'\n')
	count = continents.setdefault(continent_name, 0)
	continents[continent_name] = count + 1
cities_file.close()
output_file.close()

print continents



"""
Output format:  City, Continent

Addis Ababa, Africa
Ambato, South America

.
.
.

Zeehan, Australia


"""

