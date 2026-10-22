-module(bank).
-export([transaction/1]).

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
        _unkown ->
            transaction(Balance)
    end.


% receive ->
%     {mybank_status,Status,Balance} ->
%         io:format("Stats - ~p & Balance - ~p~n",[Status,Balance])
% end.
