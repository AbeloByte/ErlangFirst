-module(list_match).
-export([extract_list/1]).

extract_list(List) ->
    [First , Second | Rest] = List,
    io:format("First: ~p~n",[First]),
    io:format("Second: ~p~n",[Second]),
    io:format("Rest: ~p~n",[Rest])
    .
