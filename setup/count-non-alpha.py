cities_filename = "cities-countries.txt"

nonalphas = []
cities_file = open(cities_filename, 'r')
for line in cities_file:
	terms = line.split(',')
	city_name = terms[0].lower()
	num_nonalpha_in_word = 0
	for letter in city_name:
		if not letter.isalpha() and letter != ' ':
			num_nonalpha_in_word += 1
	if num_nonalpha_in_word > 2:
		nonalphas.append([city_name, num_nonalpha_in_word, len(city_name)])
	

cities_file.close()
print nonalphas
