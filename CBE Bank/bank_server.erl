-module(bank_server).
-behaviour(gen_server).

-export([
    start_link/0,
    deposit/1,
    withdraw/1,
    get_balance/0
]).

-export([
    init/1,
    handle_call/3,
    handle_cast/2
]).

start_link() ->
    gen_server:start_link(
        {local, ?MODULE},
        ?MODULE,
        [],
        []
    ).

deposit(Amount) ->
    gen_server:cast(?MODULE, {deposit, Amount}).

withdraw(Amount) ->
    gen_server:call(?MODULE, {withdraw, Amount}).

get_balance() ->
    gen_server:call(?MODULE, get_balance).

init([]) ->
    {ok, 100}.

handle_cast({deposit, Amount}, Balance) ->
    NewBalance = Balance + Amount,
    {noreply, NewBalance}.

handle_call({withdraw, Amount}, _From, Balance)
    when Amount =< Balance ->
    NewBalance = Balance - Amount,
    {reply, {ok, NewBalance}, NewBalance};

handle_call({withdraw, _Amount}, _From, Balance) ->
    {reply, {error, insufficient_funds}, Balance};

handle_call(get_balance, _From, Balance) ->
    {reply, Balance, Balance}.
