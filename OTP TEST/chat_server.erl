-module(chat_server).
-behaviour(gen_server).
-export([start/0,get_users/0,add_users/1,remove_user/1]).
-export([init/1,handle_call/3,handle_cast/2,terminate/2,code_change/3,handle_info/2,remove_userdata/1,handle_continue/2]).



start() ->
    gen_server:start_link(
        {local,?MODULE},
        ?MODULE,
        [],
        []
).

init([]) ->
    State = #{
    users => []

},
{ok,State,{continue,load_users}}.


get_users() ->
    gen_server:call(?MODULE,get_users).

add_users(Data) ->
    gen_server:call(?MODULE,{add_user,Data}).

remove_user(UserI) ->
    gen_server:cast(?MODULE,{remove_user,UserI}).


remove_userdata(UserI) ->
    gen_server:call(?MODULE,{remove_userdata,UserI}).


handle_call(get_users, _From, State) ->
    Users = maps:get(users, State),
    {reply, Users, State};
handle_call({remove_userdata, UserI}, _From, State) ->
    Users = maps:get(users, State),

    case lists:member(UserI, Users) of
        true ->
            NewUsers = lists:delete(UserI, Users),
            NewState = State#{users => NewUsers},
            {reply, {ok, removed}, NewState};
        false ->
            {reply, {error, user_not_found}, State}
    end;
handle_call({add_user, Data}, _From, State) ->
    Users = maps:get(users, State),
    NewUsers = [Data | Users],
    NewState = State#{
        users => NewUsers
    },
    {reply, {ok, NewUsers}, NewState}.


handle_cast({remove_user,UserI},State) ->
    Users = maps:get(users,State),
    NewUsers = lists:delete(UserI,Users),
    NewState = State#{users => NewUsers},
    {noreply,NewState}.




handle_info(hello, State) ->
    io:format("Hello received!~n"),
    {noreply, State};

handle_info(UnknownMessage, State) ->
    io:format("Unknown message: ~p~n", [UnknownMessage]),
    {noreply, State}.

terminate(Reason, _State) ->
    io:format("Chat server terminated: ~p~n", [Reason]),
    ok.

code_change(_OldVersion, State, _Extra) ->
    {ok, State}.

handle_continue(load_users, State) ->
    Users = [abebe, kebede, boss],
    NewState = State#{users => Users},
    {noreply, NewState}.
