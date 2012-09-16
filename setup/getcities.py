countries_filename = "Countries.txt";

countries = {}

countries_file = open(countries_filename)
for line in countries_file:
	terms = line.split(',')
	country_id = int(terms[0])
	country_name = terms[1][1:-1]
	countries[country_id] = country_name
countries_file.close()



cities_long_fname = "cities-cleaned.txt"

output_fname = "cities-countries.txt"
output_file = open(output_fname, 'w')

# get city names and parent country IDs
cities_file = open(cities_long_fname)
for line in cities_file:
	terms = line.split(',')
	city_name = terms[3][1:-1]
	country_name = countries[int(terms[1])]
	output_file.write(city_name + ',' +country_name+'\n')
cities_file.close()
output_file.close()





"""
Output format:

Addis Ababa, Ethiopia
Ambato, Ecuador

.
.
.

Zeehan, Australia


"""


"""
Output format:

JSON object: {
	"A": [
		['Addis Ababa', 'Ethiopia'],
		['Ambato', 'Ecuador']
	],

	"B": [],

	"C": []
}

"""
