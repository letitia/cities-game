window.curr_letter = ''
window.last_city = ''
window.used_cities = []

window.handleSubmit = () ->
	valid = validate()
	update()
	setTimeout computerTurn, 1000 if valid

window.validate = () ->
	input = $('input[name=city_name]')
	input_city = $.trim(input.val())
	first_letter = (input_city[0]).toUpperCase()
	input_city = first_letter + input_city.substr(1)

	#TODO: Validate string:  all lowercase
	if not cities.hasOwnProperty first_letter
		$('.status').text "Invalid First letter!"
		return false

	if input_city in used_cities
		$('.status').text "You've used that city already!  Try again."
		return false

	city_list_starting_with = cities[first_letter]
	for tuple in city_list_starting_with
		city_name = tuple[0]
		country_id = tuple[1]
		if city_name is input_city
			$('.status').text "You got it!  " + city_name + " is in " + countries[country_id]
			window.last_city = city_name
			used_cities.push city_name
			input.val('')
			return true
	$('.status').text input_city + " is NOT a valid city."
	false

window.update = () ->
	$('.streak').text used_cities
	$('.count').text used_cities.length

window.computerTurn = () ->
	$('.status').text "Computer's turn..."


window.handleInputKeyup = (e) ->
	handleSubmit() if e.keyCode is 13


