-module(msg).
-export([wait_for_message/0,start/1]).

start() ->
    spawn().
wait_for_message() ->
    receive
        {hello, Name} ->
            io:format("Hello ~p~n", [Name]);

        {calculate, A, B} ->
            io:format("Result: ~p~n", [A + B]);

        stop ->
            io:format("Stopping...~n");

        _ ->
            io:format("Unknown message~n")
    after
        10000 ->
            io:format("No message received~n")
    end,
    wait_for_message().
