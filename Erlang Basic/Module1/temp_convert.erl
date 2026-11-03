-module(temp_convert).
-export([temp_convertor/1]).


temp_convertor({celisus,Temp}) when is_number(Temp) ->
    {fahrenheit, (Temp * 9/5) + 32};

temp_convertor({fahrenheit,Temp}) when is_number(Temp) ->
    {celisus,  (Temp - 32) * 32};

temp_convertor(_) ->
    {error, invalid_scale}.
