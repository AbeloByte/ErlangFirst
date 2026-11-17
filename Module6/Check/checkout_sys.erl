
-module(checkout_sys).
-behaviour(gen_statem).

-export([
    callback_mode/0, init/1,
    cart/3, payment/3, inventory/3, fulfil/3,
    refund/3, refunded/3, completed/3, failed/3,
    terminate/3, code_change/4
]).

-export([
    start/0, add_product/1, add_product/2, cart_items/0,
    checkout/0, payment_successful/0, payment_declined/0,
    order_shipped/0, refund_successful/0, refund_failed/0
]).

%% Public API

start() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).

add_product(Product) ->
    add_product(Product, 1).

add_product(Product, Qty) ->
    gen_statem:cast(?MODULE, {add_product, Product, Qty}).

cart_items() ->
    gen_statem:call(?MODULE, get_cart).

checkout() ->
    gen_statem:call(?MODULE, checkout).

payment_successful() ->
    gen_statem:cast(?MODULE, payment_successful).

payment_declined() ->
    gen_statem:cast(?MODULE, payment_declined).

order_shipped() ->
    gen_statem:cast(?MODULE, order_shipped).

refund_successful() ->
    gen_statem:cast(?MODULE, refund_successful).

refund_failed() ->
    gen_statem:cast(?MODULE, refund_failed).

%% OTP configuration

callback_mode() ->
    state_functions.

init([]) ->
    {ok, cart, #{items => #{}}}.

%% CART STATE

cart(cast, {add_product, Product, Qty}, Data)
        when is_integer(Qty), Qty > 0 ->
    Items = maps:get(items, Data),
    CurrentQty = maps:get(Product, Items, 0),
    NewItems = Items#{Product => CurrentQty + Qty},
    NewData = Data#{items => NewItems},
    {keep_state, NewData};

cart({call, From}, get_cart, Data) ->
    Items = maps:get(items, Data),
    {keep_state, Data, [{reply, From, Items}]};

cart({call, From}, checkout, Data) ->
    Items = maps:get(items, Data),
    case map_size(Items) of
        0 ->
            {keep_state, Data,
             [{reply, From, {error, empty_cart}}]};
        _ ->
            {next_state, payment, Data,
             [{reply, From, {ok, checkout_started}}]}
    end;

cart(_Type, _Event, Data) ->
    {keep_state, Data}.

%% PAYMENT STATE

payment({call, From}, checkout, Data) ->
    {keep_state, Data,
     [{reply, From, {error, checkout_already_processing}}]};

payment(cast, payment_successful, Data) ->
    {next_state, inventory, Data,
     [{next_event, internal, reserve_inventory}]};

payment(cast, payment_declined, Data) ->
    {next_state, failed, Data};

payment({call, From}, get_cart, Data) ->
    Items = maps:get(items, Data),
    {keep_state, Data, [{reply, From, Items}]};

payment(_Type, _Event, Data) ->
    {keep_state, Data}.

%% INVENTORY STATE

inventory(internal, reserve_inventory, Data) ->
    Items = maps:get(items, Data),

    case reserve_items(maps:to_list(Items), []) of
        {ok, Reserved} ->
            io:format("Inventory reserved: ~p~n", [Reserved]),
            {next_state, fulfil, Data};

        {error, Product, Reason, Reserved} ->
            rollback_reservations(Reserved),
            io:format("Inventory reservation failed for ~p: ~p~n",
                      [Product, Reason]),
            NewData = Data#{inventory_error => {Product, Reason}},
            {next_state, refund, NewData}
    end;


inventory(internal, inventory_reserved, Data) ->
    {next_state, fulfil, Data};

inventory(internal, inventory_failed, Data) ->
    {next_state, refund, Data};

inventory({call, From}, get_cart, Data) ->
    Items = maps:get(items, Data),
    {keep_state, Data, [{reply, From, Items}]};

inventory(_Type, _Event, Data) ->
    {keep_state, Data}.

%% Reserve each product in the cart

reserve_items([], Reserved) ->
    {ok, Reserved};

reserve_items([{Product, Qty} | Rest], Reserved) ->
    case inventory_server:reserve(Product, Qty) of
        {ok, reserved} ->
            reserve_items(Rest, [{Product, Qty} | Reserved]);

        {error, Reason} ->
            {error, Product, Reason, Reserved}
    end.

%% Restore stock if a later reservation fails

rollback_reservations(Reserved) ->
    lists:foreach(
        fun({Product, Qty}) ->
            inventory_server:restock(Product, Qty)
        end,
        Reserved
    ).

%% FULFILMENT STATE

fulfil(cast, order_shipped, Data) ->
    {next_state, completed, Data};

fulfil({call, From}, get_cart, Data) ->
    Items = maps:get(items, Data),
    {keep_state, Data, [{reply, From, Items}]};

fulfil(_Type, _Event, Data) ->
    {keep_state, Data}.

%% REFUND STATE

refund(cast, refund_successful, Data) ->
    {next_state, refunded, Data};

refund(cast, refund_failed, Data) ->
    {next_state, failed, Data};

refund({call, From}, get_cart, Data) ->
    Items = maps:get(items, Data),
    {keep_state, Data, [{reply, From, Items}]};

refund(_Type, _Event, Data) ->
    {keep_state, Data}.

%% REFUNDED STATE

refunded({call, From}, get_cart, Data) ->
    Items = maps:get(items, Data),
    {keep_state, Data, [{reply, From, Items}]};

refunded(_Type, _Event, Data) ->
    {keep_state, Data}.

%% COMPLETED STATE

completed({call, From}, checkout, Data) ->
    {keep_state, Data,
     [{reply, From, {error, order_already_completed}}]};

completed({call, From}, get_cart, Data) ->
    Items = maps:get(items, Data),
    {keep_state, Data, [{reply, From, Items}]};

completed(_Type, _Event, Data) ->
    {keep_state, Data}.

%% FAILED STATE

failed({call, From}, get_cart, Data) ->
    Items = maps:get(items, Data),
    {keep_state, Data, [{reply, From, Items}]};

failed(_Type, _Event, Data) ->
    {keep_state, Data}.

%% OTP callbacks

terminate(_Reason, _State, _Data) ->
    ok.

code_change(_OldVsn, State, Data, _Extra) ->
    {ok, State, Data}.



% c(inventory_server).
% c(checkout_sys).

% inventory_server:start_link().
% checkout_sys:start().


% checkout_sys:add_product(mouse, 2).
% checkout_sys:add_product(laptop, 1).
% checkout_sys:checkout().
% checkout_sys:payment_successful().
% sys:get_state(checkout_sys).
% inventory_server:available().
