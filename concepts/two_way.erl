-module(two_way).

-export([start/0, add/3, server/0]).

start() ->
    spawn(fun server/0).

server() ->
    receive
        {add, ClientPid, A, B} ->
            Result = A + B,
            ClientPid ! {result, Result},
            server()
    end.

add(ServerPid, A, B) ->
    ServerPid ! {add, self(), A, B},
    receive
        {result, Result} ->
            Result
    end.
