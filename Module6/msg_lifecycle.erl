-module(msg_lifecycle).
-behaviour(gen_statem).

-export([start_link/0, mark_delivered/1, mark_read/1, mark_failed/1, get_status/1]).
-export([callback_mode/0, init/1, sent/3, delivered/3, read/3, failed/3, terminate/3, code_change/4]).

start_link() -> gen_statem:start_link(?MODULE, [], []).
mark_delivered(Pid) -> gen_statem:cast(Pid, delivered).
mark_read(Pid) -> gen_statem:cast(Pid, read).
mark_failed(Pid) -> gen_statem:cast(Pid, failed).
get_status(Pid) -> gen_statem:call(Pid, get_status).

callback_mode() -> state_functions.
init([]) -> {ok, sent, #{message_id => <<"MSG-100">>}}.

sent(cast, delivered, Data) -> {next_state, delivered, Data};
sent(cast, failed, Data) -> {next_state, failed, Data};
sent({call, From}, get_status, Data) -> {keep_state, Data, [{reply, From, sent}]};
sent(_T, _E, Data) -> {keep_state, Data}.

delivered(cast, read, Data) -> {next_state, read, Data};
delivered(cast, delivered, Data) -> {keep_state, Data}; % Idempotent duplicate check
delivered({call, From}, get_status, Data) -> {keep_state, Data, [{reply, From, delivered}]};
delivered(_T, _E, Data) -> {keep_state, Data}.

read(cast, read, Data) -> {keep_state, Data}; % Idempotent
read(cast, delivered, Data) -> {keep_state, Data}; % Reject backward transition
read({call, From}, get_status, Data) -> {keep_state, Data, [{reply, From, read}]};
read(_T, _E, Data) -> {keep_state, Data}.

failed({call, From}, get_status, Data) -> {keep_state, Data, [{reply, From, failed}]};
failed(_T, _E, Data) -> {keep_state, Data}.

terminate(_Reason, _State, _Data) -> ok.
code_change(_Old, State, Data, _Extra) -> {ok, State, Data}.
