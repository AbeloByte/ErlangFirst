-module(chat_logger).
-behaviour(gen_event).

-export([init/1,handle_event/2]).

init([]) ->
    {ok,#{}}.


handle_event({user_connected,Username},State) ->
    io:format("User Connected : ~p~n",[Username]),
    {ok,State}.
