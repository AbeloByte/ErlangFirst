-module(inventory_server).
-behaviour(gen_server).

-export([start_link/0, reserve/1, restock/1, available/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
reserve(Qty) -> gen_server:call(?MODULE, {reserve, Qty}).
restock(Qty) -> gen_server:call(?MODULE, {restock, Qty}).
available() -> gen_server:call(?MODULE, available).
stop() -> gen_server:stop(?MODULE).

init([]) -> {ok, 10}.

handle_call(available, _From, Stock) -> {reply, Stock, Stock};
handle_call({reserve, Qty}, _From, Stock) when is_integer(Qty), Qty > 0, Qty =< Stock ->
    {reply, {ok, reserved}, Stock - Qty};
handle_call({reserve, Qty}, _From, Stock) when is_integer(Qty), Qty > 0 ->
    {reply, {error, insufficient_stock}, Stock};
handle_call({reserve, _}, _From, Stock) -> {reply, {error, invalid_quantity}, Stock};
handle_call({restock, Qty}, _From, Stock) when is_integer(Qty), Qty > 0 ->
    {reply, {ok, Stock + Qty}, Stock + Qty};
handle_call({restock, _}, _From, Stock) -> {reply, {error, invalid_quantity}, Stock}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_Old, State, _Extra) -> {ok, State}.
