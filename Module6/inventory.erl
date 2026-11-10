-module(inventory).
-behaviour(gen_server).
-export([restock/1,start/0]).
-export([init/1,handle_call/3,handle_cast/2]).

start() ->
    gen_server:start_link({local,?MODULE},?MODULE,[],[])


restock() ->
    gen_server:call(?MODULE,{restock,Qty}).



handle_call({restock, Qty}, _From, Stock) when is_integer(Qty), Qty > 0 ->
    {reply, {ok, Stock + Qty}, Stock + Qty};

handle_call({restock, _}, _From, Stock) ->
    {reply, {error, invalid_quantity}, Stock}.
