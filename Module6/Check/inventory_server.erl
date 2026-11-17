
-module(inventory_server).
-behaviour(gen_server).

-export([start_link/0, reserve/2, restock/2, available/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

reserve(Product, Qty) ->
    gen_server:call(?MODULE, {reserve, Product, Qty}).

restock(Product, Qty) ->
    gen_server:call(?MODULE, {restock, Product, Qty}).

available() ->
    gen_server:call(?MODULE, available).

stop() ->
    gen_server:stop(?MODULE).

init([]) ->
    {ok, #{
        mouse => 10,
        laptop => 5,
        keyboard => 20
    }}.

%% Check all available stock
handle_call(available, _From, Stock) ->
    {reply, Stock, Stock};

%% Reserve a product
handle_call({reserve, Product, Qty}, _From, Stock)
        when is_integer(Qty), Qty > 0 ->
    case maps:find(Product, Stock) of
        {ok, CurrentQty} when CurrentQty >= Qty ->
            NewStock = Stock#{Product => CurrentQty - Qty},
            {reply, {ok, reserved}, NewStock};

        {ok, _CurrentQty} ->
            {reply, {error, insufficient_stock}, Stock};

        error ->
            {reply, {error, unknown_product}, Stock}
    end;

handle_call({reserve, _Product, _Qty}, _From, Stock) ->
    {reply, {error, invalid_quantity}, Stock};

%% Restock a product
handle_call({restock, Product, Qty}, _From, Stock)
        when is_integer(Qty), Qty > 0 ->
    case maps:find(Product, Stock) of
        {ok, CurrentQty} ->
            NewStock = Stock#{Product => CurrentQty + Qty},
            {reply, {ok, restocked}, NewStock};

        error ->
            {reply, {error, unknown_product}, Stock}
    end;

handle_call({restock, _Product, _Qty}, _From, Stock) ->
    {reply, {error, invalid_quantity}, Stock};

handle_call(_Request, _From, Stock) ->
    {reply, {error, unknown_request}, Stock}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_Old, State, _Extra) ->
    {ok, State}.
