-module(bank).
% -export([transaction/1,check_balence/1]).
-export([start/1,check_balence/1]).


start(InitBalance) ->
    spawn(fun() -> transaction(InitBalance) end).

transaction(Balance) ->
    receive
        {deposit,Amount,From} when  Amount > 0 , is_number(Amount)->
            New_Balance = Balance + Amount,
            From ! {mybank_status,ok,New_Balance},
            transaction(New_Balance);
        {withdraw,Amount,From} when  Amount > 0 ,Amount =< Balance, is_number(Amount) ->
            New_Balance= Balance - Amount,
            From ! {after_withdraw , ok, New_Balance},
            transaction(New_Balance);
        {get,From} ->
            From ! {mybalance,Balance},
            transaction(Balance);
        stop ->
            ok;
        _ ->
            transaction(Balance)
    end.

check_balence(Pid) ->
    Pid ! {get,self()},
    receive
        {mybalance,Balance} ->
            % io:format("Stats - ~p & Balance - ~p~n",[Balance])
            io:format("Stats & Balance - ~p~n",[Balance])
    end.
