-module(user_server).
-behavior(gen_server).

-export([start_link/0, add_user/1,get_users/0,remove_user/1]).
-export([init/1, handle_call/3, handle_cast/2]).


start_link()->
    gen_server:start_link(
        {local, ?MODULE},
        ?MODULE,
        [],
        []
    ).

init([]) ->
    {ok,[]}.

add_user(User)->
    gen_server:cast(?MODULE, {add_user, User}).

get_users()->
    gen_server:call(?MODULE, get_users).

remove_user(Name) ->
    gen_server:cast(?MODULE, {remove_user, Name}).


handle_cast({add_user, User}, State)->
    NewState = [User | State],
    {noreply, NewState};

handle_cast({remove_user,Name}, State)->
        NewState = lists:delete(Name,State),
        {noreply, NewState}.

handle_call(get_users, _From, State)->
    {reply, State, State}.
