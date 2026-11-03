-module(wallet).
-export([start/1,check_balance/1]).


start(InitialBalance) ->
    spawn(fun() -> wallet_transfer(InitialBalance) end).

wallet_transfer(Balance) ->
    receive
        {deposit,Amount,From} when is_number(Amount) , Amount > 0 ->
            Wallet_Balance = Balance + Amount,
            From ! {deposit, {ok, Amount, Wallet_Balance}},
            check_balance(From),
            wallet_transfer(Wallet_Balance);
        {withdraw,Amount,From} when is_number(Amount), Amount >= Balance, Amount > 0 ->
            Wallet_Balance = Balance - Amount,
            From ! {withdraw, {ok, Amount, Wallet_Balance}},
            wallet_transfer(Wallet_Balance);
        {getbalance,From} ->
            From ! {balance,Balance},
            wallet_transfer(Balance);
        stop ->
            io:format("Counter stopped.~n"),
            ok
    end.


check_balance(Pid) ->
    Pid ! {getbalance,self()},
    receive
        {deposit, {ok, Amount, NewBalance}} ->
        io:format("You added ~p successfully! Your new balance is ~p.~n",
                  [Amount, NewBalance]);
        {balance,YourBalance} ->
            io:format("Your Balance is : ~p~n",[YourBalance])
    end.
