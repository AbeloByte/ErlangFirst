-module(checkout_sys).
-behaviour(gen_statem).
-export([  callback_mode/0,init/1,cart/3,payment/3,inventory/3,fulfil/3,refund/3,refunded/3,completed/3,failed/3,
terminate/3,code_change/4]).
-export([start/0,add_product/1,checkout/0,payment_successful/0,payment_declined/0,
reserve_done/0,reservation_failed/0,order_shipped/0,refund_successful/0,refund_failed/0]).


start() ->
    gen_statem:start_link({local,?MODULE},?MODULE,[],[]).

callback_mode() ->
    state_functions.

init([]) ->
    {ok, cart, #{items => []}}.

% Cart
add_product(Product) ->
    gen_statem:cast(?MODULE, {add_product, Product}).

checkout() ->
    gen_statem:call(?MODULE, checkout).

% Payment
payment_successful() ->
    gen_statem:cast(?MODULE, payment_successful).

payment_declined() ->
    gen_statem:cast(?MODULE, payment_declined).

% Inventory
reserve_done() ->
    gen_statem:cast(?MODULE, reserve_done).

reservation_failed() ->
    gen_statem:cast(?MODULE, reservation_failed).

% Fulfillment
order_shipped() ->
    gen_statem:cast(?MODULE, order_shipped).

% Refund
refund_successful() ->
    gen_statem:cast(?MODULE, refund_successful).

refund_failed() ->
    gen_statem:cast(?MODULE, refund_failed).

cart(cast,{add_product,Product}, Data) ->
    PreviousItem = maps:get(items,Data),
    NewItems = [Product | PreviousItem ],
    NewData = Data#{
        items =>NewItems
},
    {keep_state,NewData};

cart({call,From},checkout,Data) ->
    Items = maps:get(items,Data),
    case Items of
        [] ->
            {keep_state,Data,[{reply,From,{error,checkout_failed_empty_cart}}]};
        _ ->
            {next_state,payment,Data,[{reply,From,{ok,checkout_started}}]}
    end;

cart(_Type, _Event, Data) ->
    {keep_state, Data}.

payment({call, From}, checkout, Data) ->
    {keep_state, Data, [
        {reply, From, {error, checkout_already_processing}}
    ]};

payment(cast,payment_successful,Data) ->
    {next_state,inventory,Data};

payment(cast,payment_declined,Data) ->
    {next_state,failed,Data};

payment(_Type, _Event, Data) ->
    {keep_state, Data}.

inventory(cast,reserve_done,Data) ->
    {next_state,fulfil,Data};

inventory(cast,reservation_failed,Data) ->
    {next_state,refund,Data};

inventory(_Type, _Event, Data) ->
    {keep_state, Data}.

fulfil(cast,order_shipped,Data) ->
    {next_state,completed,Data};

fulfil(_Type, _Event, Data) ->
    {keep_state, Data}.

completed({call, From}, checkout, Data) ->
    {keep_state, Data, [
        {reply, From, {error, order_already_completed}}
    ]};

completed(cast,order_shipped,Data) ->
    {keep_state,Data};

completed(_Type, _Event, Data) ->
    {keep_state, Data}.

refund(cast,refund_successful,Data) ->
    {next_state,refunded,Data};

refund(cast,refund_failed,Data) ->
    {next_state,failed,Data};

refund(_Type, _Event, Data) ->
    {keep_state, Data}.

refunded(cast,refund_successful,Data) ->
    {keep_state,Data};

refunded(_Type, _Event, Data) ->
    {keep_state, Data}.

failed({call,From},payment_declined,Data) ->
    {keep_state,Data,[reply,From,{ok,payment_declined}]};

failed({call,From},refund_failed,Data) ->
    {keep_state,Data,[{reply,From,{ok,refund_failed}}]};

failed(_T, _E, Data) -> {keep_state, Data}.

terminate(_Reason, _State, _Data) -> ok.
code_change(_OldVsn, State, Data, _Extra) -> {ok, State, Data}.
