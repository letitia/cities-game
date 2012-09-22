window.curr_letter = ''
window.last_city = ''
window.used_cities = []
window.error = ''


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

	#TODO:  Validate string:  all lowercase
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
		if city is list_city
			$('.status').text "You got it!  " + list_city + " is in " + countries[country_id]
			window.last_city = list_city
			used_cities.push list_city
			$('input[name=city_name]').val('')
			return true
	window.error = input_city + " is NOT a valid city."
	false

window.updateDisplay = (cityIsValid) ->
	handleErrors() if not cityIsValid
	$('.streak').text used_cities
	$('.count').text used_cities.length

window.handleComputerTurn = (valid) ->
	setTimeout computerTurn, 1000 if valid
	

window.computerTurn = () ->
	$('.status').text "Computer's turn..."

window.handleErrors = () ->
	$('.status').text window.error





window.runTestCases = () ->
	testIsValid('Stanford');
	testIsInvalid('Pirateville');
	testIsValid('dubai');
	testIsValid('Belem');		# this will fail for Belém unless we do edit distance

window.testIsValid = (cityname) ->
	passed = isValidCity cityname
	$result = $('<div />').text "Testing that " + cityname + " is valid ... " + resultText(passed)
	$result.css('color', resultColor(passed))
	$('.testresults').append $result

window.testIsInvalid = (cityname) ->
	passed = not isValidCity cityname
	$result = $('<div />').text "Testing that " + cityname + " is not valid ... " + resultText(passed)
	$result.css('color', resultColor(passed))
	$('.testresults').append $result

window.resultText = (passed) ->
	if passed then 'Passed' else 'Failed'
	
window.resultColor = (passed) ->
	if passed then 'green' else 'red'
