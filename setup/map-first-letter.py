cities_filename = "cities-countries.txt"

citiesByFirstLetter = {}

cities_file = open(cities_filename, 'r')
for line in cities_file:
	terms = line.split(',')
	cityname = terms[0]
	firstletter = cityname[0]
	if firstletter not in citiesByFirstLetter:
		citiesByFirstLetter[firstletter] = []
	citiesByFirstLetter[firstletter].append(cityname)

cities_file.close()

output_fname = "cities-first-letter.txt"
output_file = open(output_fname, 'w')

for letter, cities in citiesByFirstLetter.iteritems():
	output_file.write(letter + ': ' + str(len(cities)) + '\n')

output_file.close()