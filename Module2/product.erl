-module(product).
-export([multiply/2,filter_list/1,fold/1]).

multiply(List,Operator) ->
    Double = lists:map(fun(X) -> X * Operator end, List),
    Double.

filter_list(Input) ->
    lists:filter(fun(X) -> X rem 2 =/= 0 end, Input).

fold(List) ->
    lists:foldl(fun(X,Store)-> X + Store end,0,List).



% 1> c(product).
% {ok,product}
% 2> product:multiply([1,2,3,4,5]).
% ** exception error: undefined function product:multiply/1
% 3> product:multiply([1,2,3,4,5],10).
% [10,20,30,40,50]
% 4> product:filter_list([1,2,3,4,5]).
% [1,3,5]
% 5> product:fold([1,2,3,4,5]).
% 15
