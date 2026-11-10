-module(checkout_sys).
-behaviour(gen_statem).
-export([callback_mode/0, init/1]).
-export([start/0,cart/3, payment/3,inventory/3,fulfil/3,refund/3,code_change/4,terminate/3,completed/3,failed/3]).


start() ->
    gen_statem:start_link({local,?MODULE},?MODULE,[],[]).

callback_mode() ->
    state_functions.


init([]) ->
    {ok,#{}}
cart() ->
    gen_statem:call(?MODULE,cart).
payment() ->
    gen_statem:cast(?MODULE,payment).
inventory() ->
    gen_statem:cast(?MODULE,inventory).
fullfil() ->
    gen_statem:cast(?MODULE,fulfil).
completed() ->
    gen_statem:cast(?MODULE,completed).
refund() ->
    gen_statem:call(?MODULE,refund).
failed()->
    gen_statem:call(?MODULE,failed)

cart({call,From},add_product,Data) ->
    {keep_state,Data,[{reply,From,{ok,product_added_to_cart}}]}.

cart({call,From},payment,Data) ->
    {keep_state,Data,[{reply,From,{error,pick_atleast_one_item}}]}.

payment(cast,payment_successful,Data) ->
    {next_state,inventory,Data}.

payment(cast,payment_declined,Data) ->
    {next_state,failed,Data}.

inventory(cast,reserve_done,Data) ->
    {next_state,fulfil,Data}.

inventory(cast,reservation_failed,Data) ->
    {next_state,refund,Data}

fullfil(cast,order_shipped,Data) ->
    {next_state,completed,Data}.

completed(cast,order_shipped,Data) ->
    {keep_state,Data}.

refund({call,From},refund,Data) ->
    {next_state,refund,[reply,From,{ok,refunded}]}

failed({call,From},payment_declined,Data) ->
    {keep_state,Data,[reply,From,{ok,payment_declined}]}


failed(_T, _E, Data) -> {keep_state, Data}.


terminate(_Reason, _State, _Data) -> ok.
code_change(_OldVsn, State, Data, _Extra) -> {ok, State, Data}.
