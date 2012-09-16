# ------- STARTER CODE ----------
# --- do NOT edit this code  ---
import random
cities = {}
cfile = open('cities-countries-sample.txt')
for line in cfile:
	terms = line.split(',')
	city = terms[0]
	firstletter = city[0]
	cities.put(firstletter.upper(), {} )	#upper
	cities.put()	#lowercase

# Usage of cities
# a_cities = cities['A']
# city_starting_with_a = random.choice(a_cities)


#TODO:  Delete cities which contain / end in non-alphabetical characters,
#       or add common ones like São Paulo and Sao Paulo
#		or accept answers with edit distance of ~3?



# YOUR CODE HERE








# BONUS:  Keep track of cities already played
#cities_used = []
