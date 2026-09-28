-module(bank_server).
-behaviour(gen_server).

-export([start_link/0, deposit/1,withdraw/1,balance/0]).
-export([init/1,handle_call/3,handle_cast/2]).


start_link()->
    gen_server:start_link(
        {local, ?MODULE},
        ?MODULE,
        [],
        []
    ).

init([])->
    {ok, 0}.


deposit(Amount)->
    gen_server:cast(?MODULE, {deposit, Amount}).

withdraw(Amount)->
    gen_server:call(?MODULE, {withdraw, Amount}).

balance()->
    gen_server:call(?MODULE, balance).



handle_cast({deposit, Amount}, State) ->
    NewState = State + Amount,
    {noreply, NewState}.

handle_call({withdraw, Amount}, _From, State) when State >= Amount ->
    NewState = State - Amount,
    {reply, ok, NewState};

handle_call({withdraw, _Amount}, _From, State) ->
    {reply, {error, insufficient_funds}, State};

handle_call(balance, _From, State)->
    {reply, State, State}.
