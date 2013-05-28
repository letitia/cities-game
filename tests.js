// Generated by CoffeeScript 1.3.3
(function() {
  var resultColor, resultText, testCityIsInvalid, testWordsDontMatch, testWordsMatch, test_city_is_valid;

  window.runTestCases = function() {
    "testWordsDontMatch('LA', 'Lazdijai', 2)\ntestWordsMatch('Claremont', 'Claremont', 2)\ntestWordsDontMatch('Clearmont', 'Claremont', 2)\ntestWordsDontMatch('Upton', 'Unity', 2)";
    $('.testresults').append($('<br />'));
    test_city_is_valid('Stanford');
    test_city_is_valid('dubai');
    test_city_is_valid('Port-au-prince');
    test_city_is_valid('Sault Ste-Marie');
    test_city_is_valid('Belem');
    return test_city_is_valid('Port au prince');
  };

  testWordsMatch = function(input, city, edit_dist) {
    var $result, passed;
    passed = wordsMatchWithinEditDistance(input, city, edit_dist);
    $result = $('<div />').text("Testing that " + input + " and " + city + " match within " + edit_dist + " ... " + resultText(passed));
    $result.css('color', resultColor(passed));
    return $('.testresults').append($result);
  };

  testWordsDontMatch = function(input, city, edit_dist) {
    var $result, passed;
    passed = !wordsMatchWithinEditDistance(input, city, edit_dist);
    $result = $('<div />').text("Testing that " + input + " and " + city + " do NOT match within " + edit_dist + " ... " + resultText(passed));
    $result.css('color', resultColor(passed));
    return $('.testresults').append($result);
  };

  test_city_is_valid = function(cityname) {
    var $result, passed;
    passed = is_valid_city(cityname);
    $result = $('<div />').text("Testing that " + cityname + " is valid ... " + resultText(passed));
    $result.css('color', resultColor(passed));
    return $('.testresults').append($result);
  };

  testCityIsInvalid = function(cityname) {
    var $result, passed;
    passed = !is_valid_city(cityname);
    $result = $('<div />').text("Testing that " + cityname + " is NOT valid ... " + resultText(passed));
    $result.css('color', resultColor(passed));
    return $('.testresults').append($result);
  };

  resultText = function(passed) {
    if (passed) {
      return 'Passed';
    } else {
      return 'Failed';
    }
  };

  resultColor = function(passed) {
    if (passed) {
      return 'green';
    } else {
      return 'red';
    }
  };

}).call(this);
