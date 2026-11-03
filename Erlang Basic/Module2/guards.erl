-module(guards).
-export([classify_number/1]).


classify_number(Num) when Num =:= 0 ->
    zero;

classify_number(Num) when Num  > 0 ->
    positive;

classify_number(Num) when Num < 0 ->
    negative;

classify_number(_) ->
    {error,invalid_input}.
