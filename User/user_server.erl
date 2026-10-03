-module(user_server).
-behaviour(gen_server).

-export([
    start_link/0,
    create_user/2,
    get_user/1,
    update_status/2,
    delete_user/1
]).

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2
]).

start_link() ->
    gen_server:start_link(
        {local, ?MODULE},
        ?MODULE,
        [],
        []
    ).

create_user(Id, Name) ->
    gen_server:call(
        ?MODULE,
        {create_user, Id, Name}
    ).

get_user(Id) ->
    gen_server:call(
        ?MODULE,
        {get_user, Id}
    ).

update_status(Id, Status) ->
    gen_server:cast(
        ?MODULE,
        {update_status, Id, Status}
    ).

delete_user(Id) ->
    gen_server:call(
        ?MODULE,
        {delete_user, Id}
    ).

init([]) ->
    {ok, #{}}.

handle_call({create_user, Id, Name}, _From, Users) ->
    User = #{
        name => Name,
        status => offline
    },
    NewUsers = Users#{
        Id => User
    },
    {reply, ok, NewUsers};

handle_call({get_user, Id}, _From, Users) ->
    case maps:find(Id, Users) of
        {ok, User} ->
            {reply, {ok, User}, Users};
        error ->
            {reply, {error, not_found}, Users}
    end;

handle_call({delete_user, Id}, _From, Users) ->
    NewUsers = maps:remove(Id, Users),
    {reply, ok, NewUsers}.

handle_cast({update_status, Id, Status}, Users) ->
    case maps:find(Id, Users) of
        {ok, User} ->
            NewUser = User#{
                status => Status
            },
            NewUsers = Users#{
                Id => NewUser
            },
            {noreply, NewUsers};

        error ->
            {noreply, Users}
    end.

handle_info(Message, State) ->
    io:format("Received message: ~p~n", [Message]),
    {noreply, State}.
