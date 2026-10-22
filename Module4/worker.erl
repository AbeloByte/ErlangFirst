-module(worker).
-export([start/0,greet/1]).


start() ->
    io:format("Start ~n").

greet(Name) ->
    io:format("Welcome ~p~n",[Name]).


% c(worker).

% 1. Spawning start/0 takes 0 arguments, so the list is empty
% spawn(worker, start, []).

% 2. Spawning greet/1 takes 1 argument, so the list contains "Abebe")
% spawn(worker, greet, ["Abebe"]).
