-module(maximum_list).
-export([maximum/1]).


maximum(List)->
    maximum(List,0).

maximum([],Max_val) ->
    io:format("Maximum Value : ~p~n",[Max_val]);

maximum([H | T],Max_val) when H > Max_val ->
    maximum(T,H);

%  If the Head is not greater, keep the CurrentMax and keep moving.
maximum([_ | T],Max_val) ->
    maximum(T,Max_val).
