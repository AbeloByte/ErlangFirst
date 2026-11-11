-module(payment_fsm).
-behaviour(gen_statem).
-export([start_link/0, authorize/0, capture/0, cancel/0, status/0, stop/0]).
-export([callback_mode/0, init/1, created/3, authorized/3, captured/3, cancelled/3, failed/3, terminate/3, code_change/4]).


start_link() ->
    gen_statem:start_link(
    {local,?MODULE},
    ?MODULE,
    [],
    []
).

init([]) ->
    {ok,created,#{payment_id => <<"PAY-1001">>, retries => 0}}.

authorize() ->
    gen_statem:call(?MODULE,authorize).
capture() ->
    gen_statem:call(?MODULE,capture).
cancel() ->
    gen_statem:call(?MODULE,cancel).
status() ->
    gen_statem:call(?MODULE,status).
stop() ->
    gen_statem:call(?MODULE).


callback_mode() ->
    state_functions.

created({call,From},authorize,Data) ->
    {next_state,authorized,Data,[{reply,From,{ok,authorized}}]};

created({call,From},cancel,Data) ->
    {next_state,cancelled,Data,[{reply,From,{ok,cancelled}}]};

created({call,From},status,Data) ->
    {keep_state,Data,[{reply,From,{ok,created}}]};

created({call,From},capture,Data) ->
    {keep_state,Data,[{reply,From,{error,not_autorized}}]};
% autorization failed
created({call, From}, authorize_fail, Data) ->
    Auth_Trial = maps:get(retries,Data),
    if
        Auth_Trial >= 3 ->
             {next_state, failed, Data, [{reply, From, {error, declined}}]};
        true ->
            NewValue = Auth_Trial + 1,
            NewData =  Data#{
            retries => NewValue
    },
             {keep_state,NewData,[{reply,From,{error,not_autorized}}]}
    end;

created(_Type,_Event,Data) ->
    {keep_state,Data}.


authorized({call,From},capture,Data) ->
    {next_state,captured,Data,[{reply,From,{ok,captured}}]};

authorized({call,From},cancel,Data) ->
    {next_state,cancelled,Data,[{reply,From,{ok,cancelled}}]};

authorized({call,From},authorize,Data) ->
    {keep_state,Data,[{reply,From,{ok,already_authorized}}]};

authorized({call,From},status,Data) ->
    {keep_state,Data,[{reply,From,{ok,authorized}}]};
authorized(_Type,_Event,Data) ->
    {keep_state,Data}.

captured({call,From},status,Data) ->
    {keep_state,Data,[{reply,From,{ok,captured}}]};

captured({call, From}, _Req, Data) ->
    {keep_state, Data, [{reply, From, {error, payment_already_captured}}]};

captured(_Type, _Event, Data) -> {keep_state, Data}.


cancelled({call, From}, status, Data) ->
    {keep_state, Data, [{reply, From, cancelled}]};
cancelled({call, From}, _Req, Data) ->
    {keep_state, Data, [{reply, From, {error, payment_cancelled}}]};
cancelled(_Type, _Event,Data) ->
    {keep_state,Data}.

failed({call, From}, status, Data) ->
    {keep_state, Data, [{reply, From, failed}]};

% failed({call, From}, _Req, Data) ->
%     {keep_state, Data, [{reply, From, {error, payment_failed}}]};

failed({call, From}, _Req, Data) ->
    {keep_state, Data, [{reply, From, {error, payment_in_terminal_failure_state}}]};

failed(_Type, _Event, Data) -> {keep_state, Data}.


terminate(_Reason, _State, _Data) -> ok.
code_change(_OldVsn, State, Data, _Extra) -> {ok, State, Data}.
