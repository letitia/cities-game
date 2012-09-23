cities_filename = "cities-countries.txt"

characters = {}
cities_file = open(cities_filename, 'r')
for line in cities_file:
	terms = line.split(',')
	city_name = terms[0].lower()
	for letter in city_name:
		if not letter.isalpha():
			if letter not in characters:
				characters[letter] = 0
			characters[letter] += 1	

cities_file.close()
print characters
