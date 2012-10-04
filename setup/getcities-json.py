import pickle

countries_filename = "countries-cleaned.txt";
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

# populate map with city names and parent country IDs
cities_file = open(cities_long_fname)
for line in cities_file:
    terms = line.split(',')
    city_name = terms[3][1:-1]
    first_letter = city_name[0]
    letter_map = cities.setdefault(first_letter, {})

    countryid = int(terms[1])
    cid_list = letter_map.setdefault(city_name, [])
    if countryid not in cid_list:
        cid_list.append(countryid)
cities_file.close()




# Output into a dictionary mapping cityname to array of countries
output_fname = "cities.js"
output_file = open(output_fname, 'w')
output_file.write('cities = {\n')
num_letters = 0
for letter, cities in cities.iteritems():
    if num_letters > 0:
        output_file.write(',\n')
    output_file.write('"' + letter + '": {')

    num_cities = 0
    for cityname in cities:
        if num_cities > 0:
            output_file.write(',')
        output_file.write('"' + cityname.lower() + '":' + str(cities[cityname]))
        num_cities += 1

    num_letters += 1
    output_file.write('}')

output_file.write('\n}')
output_file.close()

"""
Output format:

{
    'A': {
        'Addis Ababa': [76],
        'Addington': [254]
    },

    'B': {
        'Baldwin Park': [254],
        'Balfour': [254],
    },
    
    'C': {
        'Callao': [194, 254],
        'Calumet': [254]
    },
}

"""


"""
# Output a dictionary mapping first letter to
# arrays of city-country_id tuples

cities_long_fname = "cities-cleaned.txt"
cities = {}

# populate map with city names and parent country IDs
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

    cities_sorted = sorted(cities, key=lambda x: x[0].lower())       # sort cities list alphabetically
    num_tuples = 0
    for tuple in cities_sorted:
        if num_tuples > 0:
            output_file.write(',')
        city_name = tuple[0]
        country_id = tuple[1]
        output_file.write('["' + city_name + '", ' + country_id + ']')
        num_tuples += 1

    num_letters += 1
    output_file.write(']')

output_file.write('\n}')
output_file.close()
"""


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
