-module(calculator).
-behaviour(gen_server).

-export([start_link/0,add/2]).
-export([init/1,handle_call/3]).
start_link() ->
    gen_server:start_link(
        { local,?MODULE},
        ?MODULE,
        [],
        []

    )

add(A,B) ->
    gen_server:call(?MODULE, {add, A,B}).

init([])->
    {ok, 0}
