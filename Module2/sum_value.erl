-module(sum_value).
-export([sum/1]).

sum(Input_list) ->
    sum(Input_list, 0).

sum([],Store) ->
    io:format("Final Sum Value is : ~p~n ", [Store]);

sum([H | T ],Store) ->
    sum(T, Store + H).
