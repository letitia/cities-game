window.curr_letter = ""
window.curr_city = ""
window.last_city = ""
window.used_cities = []
window.error = ""
window.alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
window.special_chars = {
		"a": ['\xe0', '\xe1', '\xe2', '\xe3', '\xe4', '\xe5', '\xc2',],	#['ä', 'â', 'å', 'ã', 'á', 'à', 'Â'],
		"e": ['\xe8', '\xe9', '\xea'],									#["è", "é", "ê""],
		"i": ['\xed'],													#['í'],
		"o": ['\xf3', '\xf4', '\xf5', '\xf6', '\xf8'],				 	#[ó", "ô", "õ", "ö", "ø"],
		"u": ['\xfa', '\xfc']											#['ú', 'ü'],
		"c": ['\xe7'],													#['ç'],
		"d": ['\xf0'],													#["ð"]
		"n": ['\xf1'],													#['ñ'],
		"s": ['\x9a'],													#['š'],
		"ss": ['ß'],
		" ": ["'", "-", ";", ""],
		"-": [" ", "'", ";", ""],
		"'": [" ", "-", ";", ""],
		";": [" ", "'", "-", ""]
	}


window.handleInputKeyup = (evt) ->
	handleSubmit() if evt.keyCode is 13

window.handleSubmit = () ->
	cityname = $.trim($('input[name=city_name]').val())
	isValid = isValidCity(cityname)
	updateDisplay(isValid)
	handleComputerTurn()
	
		
window.isValidCity = (input_city) ->
	first_letter = (input_city[0]).toUpperCase()
	city = first_letter + input_city.substr(1)

	if not cities.hasOwnProperty first_letter
		window.error = "The first letter of your city is not in the English alphabet."
		return false

	#TODO:  Need to use edit distance to check against used_cities
	if city in used_cities
		window.error = "You've used that city already!"
		return false

	city_list_starting_with = cities[first_letter]
	for tuple in city_list_starting_with
		list_city = tuple[0]
		country_id = tuple[1]
		if wordsMatch(city.toLowerCase(), list_city.toLowerCase())
		#if city.toLowerCase() is list_city.toLowerCase()
			$('.status').text "You got it!  " + list_city + " is in " + countries[country_id]
			window.last_city = list_city
			used_cities.push list_city
			$('input[name=city_name]').val('')
			return true
	window.error = input_city + " is NOT a valid city."
	false

window.wordsMatch = (word1, word2) ->
	#shorterWord = if word1.length > word2.length  then word2  else word1
	#longerWord  = if shorterWord is word1  then word2  else word1
	edit_dist = getEditDistance word1
	console.log "testing wordsMatch " + word1 + ' ' + word2
	wordsMatchWithinEditDistance(word1, word2, edit_dist)

window.getEditDistance = (word) ->
	len = word.length
	if len < 3  then return 1
	if len < 11 then return 2
	if len < 15 then return 3
	4
	
window.wordsMatchWithinEditDistance = (shorterWord, longerWord, edit_dist) ->
	if shorterWord is longerWord
		return true

	if edit_dist is 0
		return false

	if Math.abs(longerWord.length - shorterWord.length) > edit_dist
		return false

	wordsMatch = false
	
	#  test every letter except the first letter
	for letter, i in shorterWord when i > 0
		if letter of special_chars
			replacements = special_chars[letter]
			for rep in replacements
				replaced = shorterWord[...i] + rep + shorterWord[i+1...]
				console.log "testing replaced: " + replaced + " with " + longerWord
				return true if wordsMatchWithinEditDistance replaced, longerWord, edit_dist-1
		#removed = shorterWord[...i] + shorterWord[i+1...]
		#return true if wordsMatchWithinEditDistance removed, longerWord, edit_dist-1

	wordsMatch

window.updateDisplay = (cityIsValid) ->
	handleErrors() if not cityIsValid
	$('.streak').text used_cities
	$('.count').text used_cities.length

window.handleComputerTurn = (valid) ->
	setTimeout computerTurn, 1000 if valid
	

window.computerTurn = () ->
	$('.status').text "Computer's turn..."

window.handleErrors = () ->
	$('.status').text error





window.runTestCases = () ->
	testCityIsValid('Belem')
	###testWordsDontMatch('LA', 'Lazdijai', 2)
	testWordsMatch('Claremont', 'Claremont', 2)
	testWordsDontMatch('Clearmont', 'Claremont', 2)
	testWordsDontMatch('Upton', 'Unity', 2)###
	
	

	###
	$('.testresults').append $('<br />')
	testCityIsValid('Stanford')
	testCityIsInvalid('Pirateville')
	testCityIsValid('dubai')
	testCityIsValid('Port-au-prince')
	testCityIsValid('Sault Sainte-Marie')
	testCityIsValid('Belem')		# this will fail unless we do edit distance
	testCityIsValid('Port au prince')		# this will fail for unless we do edit distance
	###

window.testWordsMatch = (input, city, edit_dist) ->
	passed = wordsMatchWithinEditDistance input, city, edit_dist
	$result = $('<div />').text "Testing that " + input + " and " + city + " match within " + edit_dist + " ... " + resultText(passed)
	$result.css('color', resultColor(passed))
	$('.testresults').append $result

window.testWordsDontMatch = (input, city, edit_dist) ->
	passed = not wordsMatchWithinEditDistance input, city, edit_dist
	$result = $('<div />').text "Testing that " + input + " and " + city + " do NOT match within " + edit_dist + " ... " + resultText(passed)
	$result.css('color', resultColor(passed))
	$('.testresults').append $result

window.testCityIsValid = (cityname) ->
	passed = isValidCity cityname
	$result = $('<div />').text "Testing that " + cityname + " is valid ... " + resultText(passed)
	$result.css('color', resultColor(passed))
	$('.testresults').append $result

window.testCityIsInvalid = (cityname) ->
	passed = not isValidCity cityname
	$result = $('<div />').text "Testing that " + cityname + " is NOT valid ... " + resultText(passed)
	$result.css('color', resultColor(passed))
	$('.testresults').append $result

window.resultText = (passed) ->
	if passed then 'Passed' else 'Failed'
	
window.resultColor = (passed) ->
	if passed then 'green' else 'red'
