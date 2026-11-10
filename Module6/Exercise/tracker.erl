-module(tracker).
-behaviour(gen_server).
-export([online/1,offline/1,check_user_status/1]).
-export([init/1,handle_call/3]).


start() ->
    gen_server:start_link({local,?MODULE},?MODULE,[],[]).


init([]) ->
    {}

online(User) ->
    gen_server:


check_user_status() ->
