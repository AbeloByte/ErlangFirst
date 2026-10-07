% Implement your own list length counter using recursion and accumulator-based recursion (tail recursion).
% ●len/1: Takes a list L and calls len(L, 0).
% ●len/2: Takes [Head | Tail] and an accumulator integer, returning the final total length when hitting the base case len([], Acc).


-module(list_counter).
-export([list_len/1]).
% -export([list_len/2]).

% Normal Recursion

% list_len([]) ->
%     0.

% list_len([ _ | T])  ->
%     1 + list_len(T).


% Tail Recursion

list_len(L) ->
    list_len(L,0).

list_len([],ACC) ->
    ACC;

list_len([ _ | T],ACC) ->
        list_len(T ,(ACC + 1));

list_len(_,_) ->
    {error,invalid_argument}.
