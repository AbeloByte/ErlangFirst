-module(rev_recursive).
-export([reverse/1]).


reverse([]) ->
    [];

reverse([H | T]) ->
    reverse(T) ++ [H].

tail_rec()
