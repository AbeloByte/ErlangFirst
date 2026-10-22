-module(counter1).
-export([start/1,call_counter/1]).


start(Value) ->
    spawn(fun() -> counter_val(Value)  end).


counter_val(Initial) ->
    receive
        increment  ->
            Update = Initial + 1,
            counter_val(Update);
        decrement ->
            Update = Initial - 1,
            counter_val(Update);
        {get,From} ->
            From ! {count,Initial},
            counter_val(Initial)
    end.



call_counter(Pid) ->
    Pid ! {get,self()},
    receive
        {count,Value} ->
            LastValue = Value,
            io:format("Count Value : ~p~n",[LastValue]),
        LastValue
    end.
