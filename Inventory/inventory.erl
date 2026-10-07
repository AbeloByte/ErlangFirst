-module(inventory).
-export([
 process_order/2,
 calculate_order_total/2,
 restock/2
]).

% {order, ProductId, Quantity}

process_order(order)->
    process_order(order,0)


