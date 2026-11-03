-module(temp).
-export([temperature/1]).


temperature(Temp) ->
    if
        Temp >= 30 ->
            hot;
        Temp >= 20 , Temp =< 29 ->
            warm;
        Temp >=10 , Temp =<19 ->
            cool;
        Temp < 10 ->
            cold;
        true ->
            % {error,{invalid_temperature}}
            io:format("Invalid Temprature")
end.
