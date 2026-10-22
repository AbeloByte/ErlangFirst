-module(counter).
-export([start/0]).

start() ->
    register(counter, self()),
    loop(0).

loop(Count) ->
    receive
        increment ->
            loop(Count + 1);
        decrement ->
            loop(Count - 1);
        {get, From} ->
            From ! {count, Count},
            loop(Count);
        stop ->
            ok;
        _Unknown ->
            loop(Count)
    end.
