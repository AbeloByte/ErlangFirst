-module(calculator_server).
-behaviour(gen_server).

-export([start_link/0, add/2, subtract/2, multiply/2, divide/2]).
-export([init/1, handle_call/3, handle_cast/2]).

start_link() ->
    gen_server:start_link(
        {local, ?MODULE},
        ?MODULE,
        [],
        []
    ).

init([]) ->
    {ok, 0}.

add(A, B) ->
    gen_server:call(?MODULE, {add, A, B}).
subtract(A, B) ->
    gen_server:call(?MODULE, {subtract, A, B}).
multiply(A, B) ->
    gen_server:call(?MODULE, {multiply, A, B}).
divide(A, B) ->
    gen_server:call(?MODULE, {divide, A, B}).


handle_call({add, A, B}, _From ,State) ->
    Result = A + B,
    {reply, Result, State};
handle_call({subtract, A, B} ,_From,State) ->
    Result = A - B,
    {reply, Result,State};
handle_call({multiply, A, B} ,_From,State) ->
    Result = A * B,
    {reply, Result,State};

handle_call({divide, _A, 0}, _From, State) ->
    % io:format("Cannot divide by zero~n"),
    {reply, {error,divide_by_zero}, State};

handle_call({divide, A, B} ,_From,State) ->
    Result = A / B,
    {reply, Result,State}.

handle_cast(_Request, State) ->
    {noreply, State}.
