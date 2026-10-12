-module(all_in_one).
-export([filteration/1,sumation/1,multiply/1,operational_process/1]).


filteration(Input) ->
    Even = lists:filter(fun(X) -> X rem 2 == 0 end,Input),
    Even.

multiply(Even) ->
    lists:map(fun(X) -> X * 3 end,Even).

sumation(Even) ->
    lists:foldl(fun(X,Result) -> X + Result end,0,Even).

operational_process(Input) ->
    Even = filteration(Input),
    Multiply = multiply(Even),
    FinalValue = sumation(Multiply),
    FinalValue.
