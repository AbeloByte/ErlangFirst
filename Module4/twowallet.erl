-module(twowallet).
-export([start/1,check_balance_transfer/3,getbalance_check/1]).

start(Amount) ->
    spawn(fun() -> wallet(Amount) end).

wallet(Balance) ->
    receive
        {debit,Amount} when Amount > 0 , Amount =< Balance ->
            wallet(Balance - Amount);


        {credit,Amount} when Amount > 0  ->
            wallet(Balance + Amount);
        {getbalance,From} ->
            From ! {balance,Balance},
            wallet(Balance);
        % {_,_} ->
        %     {error,something_is_wrong},
        %      wallet(Balance);
        stop ->
            ok
    end.


getbalance_check(Pid) ->
    Pid ! {getbalance,self()},
    receive
        {balance,Balance} ->
         Balance
    end.

check_balance_transfer(Pid1,Pid2,Amount) ->
    % BalanceA = getbalance_check(Pid1),
    % BalanceB = getbalance_check(Pid2),
    % NewBalanceA = BalanceA - Amount,
    % NewBalanceB = BalanceB + Amount,
    % Pid1 ! {debit , NewBalanceA},
    % Pid2 ! {credit , NewBalanceB}
    Pid1 ! {debit , Amount},
    Pid2 ! {credit , Amount}.
    % {NewBalanceA,NewBalanceB}.
