-module(chat_connection).
-behaviour(gen_statem).

-export([start/0]).
-export([callback_mode/0,init/1]).
-export([connected/3,disconnected/3,banned/3]).


start() ->
    gen_statem:start_link(
        {local,?MODULE},
        ?MODULE,
        [],
        []
).

callback_mode() ->
    state_functions.


init([]) ->
    {ok,disconnected,#{username => hebel, messages => []}}.



% connecting.....
disconnected({call,From},connect,Data) ->
    {next_state,connected,Data,[{reply,From,connected}]};

disconnected(cast,{new_message, _Message},Data) ->
    io:format("Cannot send message: user is disconnected.~n"),
    {keep_state,Data}.

connected({call,From},connect,Data) ->
    {keep_state,Data,[{reply,From,already_connected}]};

connected({call,From},disconnect,Data) ->
    {next_state,disconnected,Data,[{reply,From,ok}]};

connected(cast,{new_message, Message},Data) ->
    Messages = maps:get(messages,Data),
    NewMessages = [Message | Messages],
    NewData = Data#{
        messages => NewMessages
    },
    {keep_state,NewData};

connected(state_timeout,idle_timeout,Data) ->
    {next_state,disconnected,Data}.


banned({call,From},connect,Data) ->
    {keep_state,Data,[{reply,From,{error,banned}}]}.
