-module(register).
-export([start/0,verify/1]).

start() ->
    register(counter, self()),
    loop_process(0).

loop_process(Count) ->
    receive
        increment ->
            loop_process(Count + 1);
        decrement ->
            loop_process(Count - 1);
        {get, From} ->
            From ! {count, Count},
            loop_process(Count);
        stop ->
            ok;
        _Unknown ->
            loop_process(Count)
    end.



% Eshell V13.2.2.5  (abort with ^G)
% 1> c(register).
% {ok,register}
% 2> Pid = spawn(register,start,[]).
% <0.89.0>
% 3> whereis(counter).
% <0.89.0>
% 4> counter ! increment.
% increment
% 5> counter ! increment.
% increment
% 6> counter ! increment.
% increment
% 7> counter ! decrement.
% decrement
% 8> counter ! {get,self()}.
% {get,<0.82.0>}
% 9> receive
% 9>     {count, Count} -> io:format("Counter = ~p~n", [Count])
% 9> after
% 9>     2000 -> io:format("No response~n")
% 9> end.
% Counter = 2
% ok

% Process Registration and Look up

% P1 = spawn(fun() ->
%         receive
%             stop ->
%                 ok
%         end
%     end).

% P2 = spawn(fun() ->
%         receive
%             stop ->
%                 ok
%         end
%     end).


% P3 = spawn(fun() ->
%         receive
%             stop ->
%                 ok
%         end
%     end).


% register(payment_server,P1).
% register(notification_server,P2).
% register(fraud_server,P3).

% whereis(payment_server).
% whereis(notification_server).
% whereis(fraud_server).
% whereis(unknown_server).

% start() ->
%     P1 = spawn(fun() ->
%             receive
%                 stop ->
%                     ok
%             end
%         end).

%     P2 = spawn(fun() ->
%             receive
%                 stop ->
%                     ok
%             end
%         end).


%     P3 = spawn(fun() ->
%             receive
%                 stop ->
%                     ok
%             end
%         end).


%     register(payment_server,P1).
%     register(notification_server,P2).
%     register(fraud_server,P3).

%     whereis(payment_server).
%     whereis(notification_server).
%     whereis(fraud_server).
%     whereis(unknown_server).


% selective receive
verify(Amount) ->
    receive
        hello ->
            io:format("Hello 👋👋👋"),
            verify(Amount);
        {notification,"Welcome"} ->
            io:format("Welcome"),
            verify(Amount);
        {payment_server,Balance} ->
            io:format("The received Amount of Money is : ~p~n",[Balance]),
            verify(Amount)
    end.
