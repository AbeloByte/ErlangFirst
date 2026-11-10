-module(chat_events).
-export([start/0,add_logger/0,user_connected/1]).

start() ->
    gen_event:start_link({local,chat_events}).


add_logger() ->
    gen_event:add_handler(chat_events,chat_logger,[]).


user_connected(Username) ->
    gen_event:notify(chat_events,{user_connected,Username}).
