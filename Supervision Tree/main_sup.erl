-module(main_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(
        {local,?MODULE},
        ?MODULE,
        [],
        []
    ).

init([]) ->
    Counter= #{
        id =>counter,
        start =>{counter,start_link,[]}
    },
    Logger = #{
        id => logger,
        start =>{logger,start_link,[]}
    },

    {ok ,{
        #{strategy=>one_for_one} ,[Counter,Logger]
    }}.
