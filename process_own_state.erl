-module(process_own_state).
-export([start/1,server/1]).


start(Count) ->
    spawn(fun() -> server(Count) end).

server(Count)->
        receive
            increment ->
                server(Count + 1);

            get ->
                io:format("Count Value Become = ~p~n",[Count])
        end.
