// Generated by CoffeeScript 1.3.3
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  window.curr_letter = "";

  window.curr_city = [];

  window.used_citynames = [];

  window.used_countries = {};

  window.error = "";

  window.alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];

  window.special_chars = {
    "a": ['\xe0', '\xe1', '\xe2', '\xe3', '\xe4', '\xe5', '\xc2'],
    "e": ['\xe8', '\xe9', '\xea'],
    "i": ['\xed'],
    "o": ['\xf3', '\xf4', '\xf5', '\xf6', '\xf8'],
    "u": ['\xfa', '\xfc'],
    "c": ['\xe7'],
    "d": ['\xf0'],
    "n": ['\xf1'],
    "s": ['\x9a'],
    "ss": ['\xdf'],
    ".": [" ", "-", ";", ""],
    " ": ["'", "-", ";", ""],
    "-": [" ", "'", ";", ""],
    "'": [" ", "-", ";", ""],
    ";": [" ", "'", "-", ""]
  };

  window.busy = false;

  window.handleInputKeyup = function(evt) {
    if (evt.keyCode === 13) {
      return handleSubmit();
    }
  };

  window.handleSubmit = function() {
    var answerIsValid, cityname;
    window.setBusy();
    cityname = $.trim($('input[name=city_name]').val());
    answerIsValid = cityname && currLetterStartsCityname(cityname) && isValidCity(cityname) && currCityNeverUsed();
    window.setNotBusy();
    updateProgramAndDisplay(answerIsValid);
    return handleComputerTurn();
  };

  window.currLetterStartsCityname = function(city) {
    if (curr_letter) {
      if (!(city[0].toUpperCase() === curr_letter)) {
        window.error = "The first letter of your city must start with " + curr_letter;
        return false;
      }
    }
    return true;
  };

  window.isValidCity = function(input_city) {
    var city, city_list_starting_with, country_id, first_letter, list_city, tuple, _i, _len;
    first_letter = input_city[0].toUpperCase();
    city = first_letter + input_city.substr(1);
    if (!(first_letter in cities)) {
      window.error = "The first letter of your city is not in the English alphabet.";
      return false;
    }
    city_list_starting_with = cities[first_letter];
    for (_i = 0, _len = city_list_starting_with.length; _i < _len; _i++) {
      tuple = city_list_starting_with[_i];
      list_city = tuple[0];
      country_id = tuple[1];
      if (wordsMatch(city.toLowerCase(), list_city.toLowerCase())) {
        $('.status').text("You got it!  " + list_city + " is in " + countries[country_id]);
        window.curr_city = [list_city, country_id];
        $('input[name=city_name]').val('');
        return true;
      }
    }
    window.error = input_city + " is NOT a valid city.";
    return false;
  };

  window.currCityNeverUsed = function() {
    var curr_cityname, unused;
    unused = true;
    curr_cityname = curr_city[0];
    if (__indexOf.call(used_citynames, curr_cityname) >= 0) {
      window.error = "You've used that city already!";
      unused = false;
    }
    return unused;
  };

  window.wordsMatch = function(word1, word2) {
    var edit_dist;
    edit_dist = getEditDistance(word1);
    return wordsMatchWithinEditDistance(word1, word2, edit_dist);
  };

  window.getEditDistance = function(word) {
    var len;
    len = word.length;
    if (len < 3) {
      return 1;
    }
    if (len < 11) {
      return 2;
    }
    if (len < 15) {
      return 3;
    }
    return 4;
  };

  window.wordsMatchWithinEditDistance = function(shorterWord, longerWord, edit_dist) {
    var i, letter, rep, replaced, replacements, wordsMatch, _i, _j, _len, _len1;
    if (shorterWord === longerWord) {
      return true;
    }
    if (edit_dist === 0) {
      return false;
    }
    if (Math.abs(longerWord.length - shorterWord.length) > edit_dist) {
      return false;
    }
    wordsMatch = false;
    for (i = _i = 0, _len = shorterWord.length; _i < _len; i = ++_i) {
      letter = shorterWord[i];
      if (i > 0) {
        if (letter in special_chars) {
          replacements = special_chars[letter];
          for (_j = 0, _len1 = replacements.length; _j < _len1; _j++) {
            rep = replacements[_j];
            replaced = shorterWord.slice(0, i) + rep + shorterWord.slice(i + 1);
            if (wordsMatchWithinEditDistance(replaced, longerWord, edit_dist - 1)) {
              return true;
            }
          }
        }
      }
    }
    return wordsMatch;
  };

  window.updateProgramAndDisplay = function(cityIsValid) {
    var curr_cityname, curr_country;
    if (cityIsValid) {
      curr_cityname = curr_city[0];
      curr_country = curr_city[1];
      window.curr_city = [];
      used_citynames.push(curr_cityname);
      incrementKeyFrequencyInMap(curr_country, used_countries);
      window.curr_letter = curr_cityname.slice(-1).toUpperCase();
      $('.currletter').text(curr_letter);
    } else {
      handleErrors();
    }
    $('.usedcities').text(used_citynames);
    $('.count').text(used_citynames.length);
    printCountries();
  };

  window.printCountries = function() {
    var count, id, result;
    result = "";
    for (id in used_countries) {
      count = used_countries[id];
      result += countries[id] + ": " + count + "<br />";
    }
    return $('.countries').html(result);
  };

  window.handleComputerTurn = function(valid) {
    if (valid) {
      return setTimeout(computerTurn, 1000);
    }
  };

  window.computerTurn = function() {
    return $('.status').text("Computer's turn...");
  };

  window.handleErrors = function() {
    return $('.status').text(error);
  };

  window.incrementKeyFrequencyInMap = function(key, map) {
    if (!(key in map)) {
      map[key] = 0;
    }
    return map[key] += 1;
  };

  window.checkBusyStatus = function() {
    return setInterval((function() {
      if (busy) {
        return $('#spinner').show();
      } else {
        return $('#spinner').hide();
      }
    }), 10);
  };

  window.setBusy = function() {
    return $('#spinner').show();
  };

  window.setNotBusy = function() {
    return $('#spinner').hide();
  };

  window.runTestCases = function() {
    testWordsDontMatch('LA', 'Lazdijai', 2);
    testWordsMatch('Claremont', 'Claremont', 2);
    testWordsDontMatch('Clearmont', 'Claremont', 2);
    testWordsDontMatch('Upton', 'Unity', 2);
    $('.testresults').append($('<br />'));
    testCityIsValid('Stanford');
    testCityIsValid('dubai');
    testCityIsValid('Port-au-prince');
    testCityIsValid('Sault Ste-Marie');
    testCityIsValid('Belem');
    return testCityIsValid('Port au prince');
  };

  window.testWordsMatch = function(input, city, edit_dist) {
    var $result, passed;
    passed = wordsMatchWithinEditDistance(input, city, edit_dist);
    $result = $('<div />').text("Testing that " + input + " and " + city + " match within " + edit_dist + " ... " + resultText(passed));
    $result.css('color', resultColor(passed));
    return $('.testresults').append($result);
  };

  window.testWordsDontMatch = function(input, city, edit_dist) {
    var $result, passed;
    passed = !wordsMatchWithinEditDistance(input, city, edit_dist);
    $result = $('<div />').text("Testing that " + input + " and " + city + " do NOT match within " + edit_dist + " ... " + resultText(passed));
    $result.css('color', resultColor(passed));
    return $('.testresults').append($result);
  };

  window.testCityIsValid = function(cityname) {
    var $result, passed;
    passed = isValidCity(cityname);
    $result = $('<div />').text("Testing that " + cityname + " is valid ... " + resultText(passed));
    $result.css('color', resultColor(passed));
    return $('.testresults').append($result);
  };

  window.testCityIsInvalid = function(cityname) {
    var $result, passed;
    passed = !isValidCity(cityname);
    $result = $('<div />').text("Testing that " + cityname + " is NOT valid ... " + resultText(passed));
    $result.css('color', resultColor(passed));
    return $('.testresults').append($result);
  };

  window.resultText = function(passed) {
    if (passed) {
      return 'Passed';
    } else {
      return 'Failed';
    }
  };

  window.resultColor = function(passed) {
    if (passed) {
      return 'green';
    } else {
      return 'red';
    }
  };

}).call(this);
