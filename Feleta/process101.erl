-module(process101).
% -export([start/0,main_process/2,checkout_balance/1]).
-export([start/0,checkout_balance/1]).


start() ->
    spawn(fun()-> greet() end).


greet() ->
    receive
        hello ->
            io:format("Hello Recieved")
    end.





% main_process(A,B) ->
%     Pid = spawn(fun()-> worker() end),
%     Pid ! {calculate,A,B,self()},
%     receive
%         {result,Result} ->
%             io:format("The Sum of The Two Values are : ~p~n",[Result])
%     end.

% worker() ->
%     receive
%         {calculate, A, B,From} when is_number(A),is_number(B) ->
%             Result = A + B,
%             From ! {result,Result}
%     end.


start() ->
    spawn(fun() -> bank(1000) end).


bank(Balance) ->
    receive
        {deposit, Amount} when is_number(Amount) , Amount > 0 ->
            Newbalance = Balance + Amount,
            bank(Newbalance);
        {withdraw, Amount} when is_number(Amount) , Amount < Balance ->
            Newbalance = Balance - Amount,
            bank(Newbalance);
        {get_balance,From} ->
            From ! {get_balance,Balance};
         stop ->
            ok
    end.


checkout_balance(Pid) ->
    Pid ! {get_balance,self()},
    receive
         {get_balance,Balance} ->
            {your_current_balance_is,Balance}
    end.
