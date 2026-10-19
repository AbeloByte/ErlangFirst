-module(inventory).
-export([
 process_order/2,
 calculate_order_total/2,
 restock/2
]).

% {order, ProductId, Quantity}

process_order(Inventory,Order)->
    % io:format("No Order to Process ~p~n").
    process_order(Inventory,Order,[]).

process_order([],[],Acc) ->
    lists:reverse(Acc);

process_order([H | T],[],Acc) ->
    process_order(T,[],[H | Acc]);

process_order([],[ H | T],Acc) ->
    process_order([],T,[H | Acc]);

process_order([{_,ID,Item,Price,Stock} | T1],[{_,ID,OrderQty} | T2],Acc) when Stock >= OrderQty ->
    Remain = Stock - OrderQty,
    io:format("The Remaining ~p is : ~p~n ", [Item,Remain]),
    process_order(T1,T2,[{product,ID,Item,Price,Remain} | Acc]);

process_order([{_,ID,Item,Price,Stock}| T1],[{_,ID,OrderQty} | T2],Acc) when Stock < OrderQty ->
    process_order(T1,T2,[{product,ID,Item,Price,Stock} | Acc]).


calculate_order_total(Inventory,Order)->
    % io:format("No Order to Process ~p~n").
    calculate_order_total(Inventory,Order,0).

calculate_order_total([],[],Acc) ->
    Acc;

calculate_order_total([{_, ID, _, Price, Stock} | T1], [{_, ID, OrderQty} | T2],Acc)  when Stock >= OrderQty ->
    TotalPrice = Price * OrderQty,
    calculate_order_total(T1,T2,(TotalPrice + Acc));


calculate_order_total([{_, ID, _, _, Stock} | T1], [{_, ID, OrderQty} | T2],Acc)  when Stock < OrderQty ->
    calculate_order_total(T1,T2,Acc).

% --------------------------------------------------------------------------------------------------------------------

restock(Inventory, Restocks) ->
    SortedInv = lists:keysort(2, Inventory),
    SortedRest = lists:keysort(1, Restocks), % Assuming restocks are keyed by ID
    restock(SortedInv, SortedRest, []).

restock([H | T],[],Acc) ->
    restock(T,[],[H | Acc]);

restock([],_,Acc) ->
    lists:reverse(Acc);


restock([{Product,ID,Item,Price,Stock} | T1],[{RestokID,Quantity} | T2],Acc) when ID == RestokID ->
    NewStock = Stock + Quantity,
    restock(T1,T2,[{Product,ID,Item,Price,NewStock} | Acc]).
