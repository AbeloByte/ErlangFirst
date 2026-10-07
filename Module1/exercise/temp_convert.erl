% Write a function that accepts a tuple representing a temperature reading in either Celsius or Fahrenheit and converts it to the opposite scale.
% ● Input format: {celsius, Temp} or {fahrenheit, Temp}
% ●
% ● Behavior:
% ○{celsius, C} → returns {fahrenheit, (C * 9/5) + 32}
% ○
% ○{fahrenheit, F} → returns {celsius, (F - 32) * 5/9}
% ○
% ○Any other pattern should return {error, invalid_scale}.

-module(temp_convert).
% -export([celsius/1,fahrenheit/1]).
-export([temp_convertor/1]).


temp_convertor({celsius,Temp}) when is_number(Temp) ->
        {fahrenheit,(Temp * 9/5) + 32};

temp_convertor({fahrenheit,Temp}) when is_number(Temp) ->
        {celsius,(Temp - 32) * 5/9};

temp_convertor(_) ->
        {error,invalid_scale}.
