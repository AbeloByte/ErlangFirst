% Exercise 1: Counter Reset Implementation
% Task: Add a reset/0 API function and corresponding handle_call clause to counter_server that resets the stored count back to 0 and returns `{ok, 0}`.


-module(counter_server).
-behaviour(gen_server).
-export([start/0,increment/0,decrement/0,reset/0]).
-export([init/1,handle_call/3,handle_cast/2]).


start() ->
     gen_server:start_link({local,?MODULE},?MODULE,[],[]).

increment() ->
    gen_server:cast(?MODULE,increment).

decrement() ->
    gen_server:call(?MODULE,decrement).

reset() ->
    gen_server:call(?MODULE,reset).

init([]) ->
    io:format("starting the proces"),
    {ok,0}.


handle_cast(increment,Value) ->
    NewValue = Value + 1,
    {noreply,NewValue}.

handle_call(decrement,_From,Value) ->
    NewValue = Value - 1,
    {reply,{ok,NewValue},NewValue};

handle_call(reset,_From,_Value) ->
    {reply,{ok,0},0}.
