-module(single_server).
-export([start/0,server/0]).

start()->
    spawn(fun server/0).

server()->
    receive
        arigato ->
            io:format("Arigato Kosayimas")
    end.
