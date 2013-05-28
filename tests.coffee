# This takes a couple of minutes, or longer if you uncomment out the long cases
window.runTestCases = () ->
    """testWordsDontMatch('LA', 'Lazdijai', 2)
    testWordsMatch('Claremont', 'Claremont', 2)
    testWordsDontMatch('Clearmont', 'Claremont', 2)
    testWordsDontMatch('Upton', 'Unity', 2)
    """
    
    $('.testresults').append $('<br />')
    test_city_is_valid('Stanford')
    #testCityIsInvalid('Pirateville')           # this test takes 30 seconds
    test_city_is_valid('dubai')
    test_city_is_valid('Port-au-prince')
    test_city_is_valid('Sault Ste-Marie')
    #test_city_is_valid('Sault Sainte-Marie')       # this test takes a few minutes.  will fail unless we do edit distance
    test_city_is_valid('Belem')     
    test_city_is_valid('Port au prince')
    

testWordsMatch = (input, city, edit_dist) ->
    passed = wordsMatchWithinEditDistance input, city, edit_dist
    $result = $('<div />').text "Testing that " + input + " and " + city + " match within " + edit_dist + " ... " + resultText(passed)
    $result.css('color', resultColor(passed))
    $('.testresults').append $result

testWordsDontMatch = (input, city, edit_dist) ->
    passed = not wordsMatchWithinEditDistance input, city, edit_dist
    $result = $('<div />').text "Testing that " + input + " and " + city + " do NOT match within " + edit_dist + " ... " + resultText(passed)
    $result.css('color', resultColor(passed))
    $('.testresults').append $result

test_city_is_valid = (cityname) ->
    passed = is_valid_city cityname
    $result = $('<div />').text "Testing that " + cityname + " is valid ... " + resultText(passed)
    $result.css('color', resultColor(passed))
    $('.testresults').append $result

testCityIsInvalid = (cityname) ->
    passed = not is_valid_city cityname
    $result = $('<div />').text "Testing that " + cityname + " is NOT valid ... " + resultText(passed)
    $result.css('color', resultColor(passed))
    $('.testresults').append $result

resultText = (passed) ->
    if passed then 'Passed' else 'Failed'
    
resultColor = (passed) ->
    if passed then 'green' else 'red'
