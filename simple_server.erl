-module(simple_server).
-export([start/0,server/0]).

start()->
    spawn(fun server/0).

server()->
    receive
        hello ->
            io:format("Hello!~n ");
        hebel ->
            io:format("Hey: ~p~n", [self()]);
        {message, Text} ->
            io:format("Welcome To ~p",[Text]);
        bye ->
            io:format("Bye!~n")
        end,
      server().
