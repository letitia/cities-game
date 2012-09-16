cities_filename = "cities-countries.txt"

citiesByLastLetter = {}

cities_file = open(cities_filename, 'r')
for line in cities_file:
	terms = line.split(',')
	cityname = terms[0]
	lastletter = cityname[len(cityname)-1]
	if lastletter not in citiesByLastLetter:
		citiesByLastLetter[lastletter] = []
	citiesByLastLetter[lastletter].append(cityname)

cities_file.close()

output_fname = "cities-last-letter.txt"
output_file = open(output_fname, 'w')

for letter, cities in citiesByLastLetter.iteritems():
	output_file.write(letter + ': ' + str(len(cities)) + '\n')

output_file.close()