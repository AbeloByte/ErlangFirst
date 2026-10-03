-module(my_logger_server).
-behaviour(gen_server).

-export([start_link/0,log/1]).
-export([init/1,handle_cast/2,handle_call/3]).

start_link() ->
    gen_server:start_link(
    {local,?MODULE},
    ?MODULE,
    [],
    []
    ).

init([]) ->
    {ok,#{}}.

log(Message) ->
    gen_server:cast(?MODULE,{log,Message}).

handle_cast({log,Message},State) ->
    io:format("LOG: ~p~n",[Message]),
    {noreply,State}.

handle_call(_Request,_From,State)->
    {reply,{error,unexpected},State}.
