import pickle

countries_filename = "Countries-cleaned.txt";

countries = {}

countries_file = open(countries_filename)
for line in countries_file:
	terms = line.split(',')
	country_id = terms[0]
	country_name = terms[1][1:-1]
	countries[country_id] = country_name
countries_file.close()

"""
output_fname = "countries.js"
output_file = open(output_fname, 'wb')
output_file.write('countries = {')
for country_id, country_name in countries.iteritems():
	output_file.write(country_id + ': "' + country_name + '",\n')
output_file.write('}')
output_file.close()

"""

cities_long_fname = "cities-cleaned.txt"

cities = {}

# get city names and parent country IDs
cities_file = open(cities_long_fname)
for line in cities_file:
	terms = line.split(',')
	city_name = terms[3][1:-1]
	first_letter = city_name[0]
	country_id = terms[1]
	if first_letter not in cities:
		cities[first_letter] = []
	cities[first_letter].append([city_name, country_id])
	
cities_file.close()

output_fname = "cities.js"
output_file = open(output_fname, 'w')
output_file.write('cities = {\n')
num_letters = 0
for letter, cities in cities.iteritems():
	if num_letters > 0:
		output_file.write(',\n')
	output_file.write('"' + letter + '": [')

	num_tuples = 0
	for tuple in cities:
		if num_tuples > 0:
			output_file.write(',')
		city_name = tuple[0]
		country_id = tuple[1]
		output_file.write('["' + city_name + '", ' + country_id + ']')
		num_tuples += 1
	output_file.write(']')
	num_letters += 1
output_file.write('\n}')
output_file.close()



"""
Output format:

{
	"A": [
		['Addis Ababa', 'Ethiopia'],
		['Ambato', 'Ecuador']
	],

	"B": [],

	"C": []
}

"""
