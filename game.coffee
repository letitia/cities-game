window.curr_letter = ""
window.curr_city = []
window.used_citynames = []
window.used_countries = {}
window.error = ""
window.alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
window.special_chars = {
		"a": ['\xe0', '\xe1', '\xe2', '\xe3', '\xe4', '\xe5', '\xc2',],	#['ä', 'â', 'å', 'ã', 'á', 'à', 'Â'],
		"e": ['\xe8', '\xe9', '\xea'],									#["è", "é", "ê""],
		"i": ['\xed'],													#['í'],
		"o": ['\xf3', '\xf4', '\xf5', '\xf6', '\xf8'],				 	#["ó", "ô", "õ", "ö", "ø"],
		"u": ['\xfa', '\xfc']											#['ú', 'ü'],
		"c": ['\xe7'],													#['ç'],
		"d": ['\xf0'],													#["ð"]
		"n": ['\xf1'],													#['ñ'],
		"s": ['\x9a'],													#['š'],
		"ss": ['\xdf'],													#['ß'],
		".": [" ", "-", ";", ""],
		" ": ["'", "-", ";", ""],
		"-": [" ", "'", ";", ""],
		"'": [" ", "-", ";", ""],
		";": [" ", "'", "-", ""]
	}
window.busy = false


window.handleInputKeyup = (evt) ->
	handleSubmit() if evt.keyCode is 13

window.handleSubmit = () ->
	window.setBusy()
	cityname = $.trim($('input[name=city_name]').val())
	answerIsValid = cityname and currLetterStartsCityname(cityname) and isValidCity(cityname) and currCityNeverUsed()
	window.setNotBusy()
	updateProgramAndDisplay(answerIsValid)
	handleComputerTurn()
	
window.currLetterStartsCityname = (city) ->
	if curr_letter
		if not (city[0].toUpperCase() is curr_letter)
			window.error = "The first letter of your city must start with " + curr_letter
			return false
	true
		
window.isValidCity = (input_city) ->
	first_letter = (input_city[0]).toUpperCase()
	city = first_letter + input_city.substr(1)

	if not (first_letter of cities)
		window.error = "The first letter of your city is not in the English alphabet."
		return false

	city_list_starting_with = cities[first_letter]
	for tuple in city_list_starting_with
		list_city = tuple[0]
		country_id = tuple[1]
		if wordsMatch(city.toLowerCase(), list_city.toLowerCase())
			$('.status').text "You got it!  " + list_city + " is in " + countries[country_id]
			window.curr_city = [list_city, country_id]
			$('input[name=city_name]').val('')
			return true
	window.error = input_city + " is NOT a valid city."
	false

window.currCityNeverUsed = () ->
	unused = true
	curr_cityname = curr_city[0]
	if curr_cityname in used_citynames
		window.error = "You've used that city already!"
		unused = false
	unused

window.wordsMatch = (word1, word2) ->
	edit_dist = getEditDistance word1
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
	
	#  test every letter except first letter
	for letter, i in shorterWord when i > 0
		if letter of special_chars
			replacements = special_chars[letter]
			for rep in replacements
				replaced = shorterWord[...i] + rep + shorterWord[i+1...]
				return true if wordsMatchWithinEditDistance replaced, longerWord, edit_dist-1

	wordsMatch

window.updateProgramAndDisplay = (cityIsValid) ->
	if cityIsValid
		curr_cityname = curr_city[0]; curr_country = curr_city[1]
		window.curr_city = []
		used_citynames.push curr_cityname
		incrementKeyFrequencyInMap(curr_country, used_countries)
		window.curr_letter = curr_cityname[-1..].toUpperCase()
		$('.currletter').text curr_letter
	else
		handleErrors()
	$('.usedcities').text used_citynames
	$('.count').text used_citynames.length
	printCountries()
	return

window.printCountries = () ->
	result = ""
	for id, count of used_countries
		result += countries[id] + ": " + count + "<br />"
	$('.countries').html result

window.handleComputerTurn = (valid) ->
	setTimeout computerTurn, 1000 if valid
	

window.computerTurn = () ->
	$('.status').text "Computer's turn..."

window.handleErrors = () ->
	$('.status').text error

window.incrementKeyFrequencyInMap = (key, map) ->
	if not (key of map) then map[key] = 0
	map[key] += 1

window.checkBusyStatus = () ->
	setInterval (() -> if busy then $('#spinner').show() else $('#spinner').hide()), 10

window.setBusy = () ->
	$('#spinner').show()

window.setNotBusy = () ->
	$('#spinner').hide()


#checkBusyStatus();



# This takes a couple of minutes, or longer if you uncomment out the long cases
window.runTestCases = () ->
	testWordsDontMatch('LA', 'Lazdijai', 2)
	testWordsMatch('Claremont', 'Claremont', 2)
	testWordsDontMatch('Clearmont', 'Claremont', 2)
	testWordsDontMatch('Upton', 'Unity', 2)
	
	
	$('.testresults').append $('<br />')
	testCityIsValid('Stanford')
	#testCityIsInvalid('Pirateville')			# this test takes 30 seconds
	testCityIsValid('dubai')
	testCityIsValid('Port-au-prince')
	testCityIsValid('Sault Ste-Marie')
	#testCityIsValid('Sault Sainte-Marie')		# this test takes a few minutes.  will fail unless we do edit distance
	testCityIsValid('Belem')		
	testCityIsValid('Port au prince')
	

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
