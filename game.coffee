GAME = {}
GAME.curr_letter = ""
GAME.curr_city = []
GAME.used_citynames = []
GAME.used_countries = {}
GAME.error = ""
GAME.alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
GAME.special_chars = {
        "a": ['\xe0', '\xe1', '\xe2', '\xe3', '\xe4', '\xe5', '\xc2',], #['ä', 'â', 'å', 'ã', 'á', 'à', 'Â'],
        "e": ['\xe8', '\xe9', '\xea'],                                  #["è", "é", "ê""],
        "i": ['\xed'],                                                  #['í'],
        "o": ['\xf3', '\xf4', '\xf5', '\xf6', '\xf8'],                  #["ó", "ô", "õ", "ö", "ø"],
        "u": ['\xfa', '\xfc']                                           #['ú', 'ü'],
        "c": ['\xe7'],                                                  #['ç'],
        "d": ['\xf0'],                                                  #["ð"]
        "n": ['\xf1'],                                                  #['ñ'],
        "s": ['\x9a'],                                                  #['š'],
        "ss": ['\xdf'],                                                 #['ß'],
        ".": [" ", "-", ";", ""],
        " ": ["'", "-", ";", ""],
        "-": [" ", "'", ";", ""],
        "'": [" ", "-", ";", ""],
        ";": [" ", "'", "-", ""]
    }
GAME.busy = false


window.handle_input_keyup = (evt) ->
	handle_submit() if evt.keyCode is 13

window.handle_submit = () ->
	cityname = $.trim($('input[name=city_name]').val())
	answer_is_valid = cityname and curr_letter_starts_cityname(cityname) and is_valid_city(cityname) and curr_city_never_used()
	update_program_and_display(answer_is_valid)
	#handle_computer_turn()
	
curr_letter_starts_cityname = (city) ->
	if GAME.curr_letter
		if not (city[0].toUpperCase() is GAME.curr_letter)
			GAME.error = "The first letter of your city must start with " + GAME.curr_letter
			return false
	true
		
is_valid_city = (input_cityname) ->
	input_cityname = input_cityname.toLowerCase()
	first_letter = (input_cityname[0]).toUpperCase()
	city = first_letter + input_cityname.substr(1)

	if not (first_letter of cities)
		GAME.error = "The first letter of your city is not in the English alphabet."
		return false

	city_dict_starting_with = cities[first_letter]

	if input_cityname of city_dict_starting_with
		acknowledge_input_city(input_cityname, city_dict_starting_with)
		return true

	close_names = generate_close_word_list(input_cityname)
	for name in close_names
		if name of city_dict_starting_with
			acknowledge_input_city(name, city_dict_starting_with)
			return true
	GAME.error = input_cityname + " is NOT a valid city."
	false

acknowledge_input_city = (name, dict) ->
	country_id = dict[name][0]	#FIXME:  for now, only take first country in list
	display_name = name.toProperCase()
	GAME.curr_city = [display_name, country_id]
	$('input[name=city_name]').val('')

generate_close_word_list = (word) ->
	word = word.toLowerCase()
	edit_dist = get_edit_distance(word)
	
	wordlist = []
	generate_edit_distance_list(word, edit_dist, wordlist)
	wordlist

generate_edit_distance_list = (word, edit_dist, wordlist) ->
	if edit_dist is 0 then return

	# replace every letter except first letter
	for letter, i in word when i > 0
		if letter of GAME.special_chars
			replacements = GAME.special_chars[letter]
			for rep in replacements
				replaced = word[...i] + rep + word[i+1...]
				wordlist.push(replaced)
				generate_edit_distance_list(replaced, edit_dist - 1, wordlist)

curr_city_never_used = ->
	unused = true
	curr_cityname = GAME.curr_city[0]
	if curr_cityname in GAME.used_citynames
		GAME.error = "You've used that city already!"
		unused = false
	unused

get_edit_distance = (word) ->
	len = word.length
	if len < 3  then return 1
	if len < 11 then return 2
	if len < 15 then return 3
	4

update_program_and_display = (city_is_valid) ->
	if city_is_valid
		update_with_new_city()
	else
		handle_errors()
	$('.usedcities').text GAME.used_citynames
	$('.count').text GAME.used_citynames.length
	print_countries()
	return

update_with_new_city = ->
	curr_cityname = GAME.curr_city[0]
	curr_country = GAME.curr_city[1]
	$('.status').text "You got it!  #{curr_cityname} is in #{countries[curr_country]}"
	GAME.curr_city = []
	GAME.used_citynames.push curr_cityname
	increment_key_frequency_in_map(curr_country, GAME.used_countries)

	add_city_tile(curr_cityname)

	GAME.curr_letter = curr_cityname[-1..].toUpperCase()
	$('.currletter').text GAME.curr_letter

add_city_tile = (cityname) ->
	tile = $('<div class="city" />')
	tile.text cityname

	# get image
	$.get "http://en.wikipedia.org/w/api.php?action=query&titles=#{format_name_for_wikipedia(cityname)}&format=json&prop=images&imlimit=1"

	# get wiki text
	$.get "http://en.wikipedia.org/w/api.php?action=query&titles=#{format_name_for_wikipedia(cityname)}&format=json&prop=revisions&rvprop=content"
	
	$('#content').prepend tile

print_countries = ->
	result = ""
	for id, count of GAME.used_countries
		result += "#{countries[id]}: #{count}<br />"
	$('.countries').html result

format_name_for_wikipedia = (cityname) ->
	# upper case and escape everything with underscore,
	# e.g. San_Francisco, Port_Au_Prince, Sault_Ste_Marie, Sault_Sainte_Marie


handle_computer_turn = (valid) ->
	setTimeout computerTurn, 1000 if valid
	

computerTurn = ->
	$('.status').text "Computer's turn..."

handle_errors = ->
	$('.status').text GAME.error

increment_key_frequency_in_map = (key, map) ->
	if not (key of map) then map[key] = 0
	map[key] += 1






# Utilities

String.prototype.toProperCase = () ->
    this.replace /\w\S*/g, (txt) -> txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

