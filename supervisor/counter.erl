-module(counter).
-behaviour(gen_server).

-export([
    start_link/0,
    increment/0,
    get/0,
    crash/0
]).

-export([
    init/1,
    handle_call/3,
    handle_cast/2
]).

start_link() ->
    gen_server:start_link(
        {local, ?MODULE},
        ?MODULE,
        [],
        []
    ).

increment() ->
    gen_server:cast(?MODULE, increment).

get() ->
    gen_server:call(?MODULE, get).

crash() ->
    gen_server:cast(?MODULE, crash).

init([]) ->
    {ok, 0}.

handle_call(get, _From, State) ->
    {reply, State, State}.

handle_cast(increment, State) ->
    NewState = State + 1,
    {noreply, NewState};

handle_cast(crash, _State) ->
    error(test_crash).
