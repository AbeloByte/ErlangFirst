-module(heartbeat_check).
-behaviour(gen_server).

-export([start/0,check_heartbeat/1]).
-export([init/1,handle_cast/2,handle_info/2]).

start() ->
    gen_server:start_link(
{local,?MODULE},
?MODULE,
[],
[]
).


init([]) ->
      erlang:send_after(10000, self(), check_heartbeats),
    {ok, #{}}.

check_heartbeat(User) ->
    gen_server:cast(?MODULE,{heartbeat, User}).


handle_cast({heartbeat,User},State) ->
    NewTimer = erlang:monotonic_time(millisecond),
    EachUserData = maps:get(User,State,#{}),
    NewUserData = EachUserData#{
            status => online,
            last_seen => NewTimer
},
    NewState = State#{
        User => NewUserData
},

{noreply,NewState}.

handle_info(check_heartbeats,State) ->
    % gEt the current monotonic time
     CurrentTime = erlang:monotonic_time(millisecond),
     NewState = maps:fold(
    fun(User,UserData,Acc) ->
        Status = maps:get(status,UserData),
        LastSeen = maps:get(last_seen,UserData),
     case Status of
        online ->
        ElapsedTime = CurrentTime - LastSeen,
            case ElapsedTime > 10000 of
                true ->
                NewUserData = UserData#{
                    status => offline
                },
                Acc#{User => NewUserData};
                false ->
                     Acc#{User => UserData}
            end;
        offline ->
            Acc#{User => UserData}
     end
    end
,#{},
State),
    io:format("The Current Users Status ~p~n",[NewState]),
    erlang:send_after(10000, self(), check_heartbeats),
% maps:fold(Function, InitialAccumulator, Map)
{noreply,NewState}.
