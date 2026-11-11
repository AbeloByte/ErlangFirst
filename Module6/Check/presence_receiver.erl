-module(presence_receiver).

-export([start/0, loop/0]).

start() ->
    register(receiver, spawn(?MODULE, loop, [])).

loop() ->
    receive
        Message ->
            io:format("Received message: ~p~n", [Message]),
            loop()
    end.
