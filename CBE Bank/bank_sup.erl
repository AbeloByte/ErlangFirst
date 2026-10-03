-module(bank_sup).
-behavior(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(
        {local,?MODULE},
        ?MODULE,
        []
    ).

init([]) ->
    Bank_Server = #{
        id =>bank_server,
        start =>{bank_server,start_link,[]}
    },

  {ok ,{
        #{strategy=>one_for_one} ,[Bank_Server]
    }}.
