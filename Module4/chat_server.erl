-module(chat_server).
-export([chat/0]).

chat() ->
    receive
        {send,Username,Message} ->
            io:format("Chat - ~s - ~s ~n ",[Username,Message]),
            chat();
        stop ->
            ok
    end.
