-module(payment_server).
-export([start/0,make_payment/1,stats_report/0]).

start() ->
   case whereis(payment_server) of
        undefined ->
            Stats = #{
                total => 0,
                successful => 0,
                failed => 0
            },
            spawn(fun() ->
                register(payment_server, self()),
                loop(Stats)
            end);
        _Pid ->
            {error, already_started}
    end.



loop(Stats) ->
    receive
        
        {payment, Amount, From} when  is_number(Amount) ,Amount > 0->
            PreviousValue = maps:get(total,Stats),
            SuccessfulValue = maps:get(successful,Stats),
            NewStats = Stats#{
                total := PreviousValue + Amount,
                successful := SuccessfulValue + 1
        },
        From !  {payment_server, "successfully payment received"},
        loop(NewStats);

        {payment, Amount, From} when not is_number(Amount) orelse Amount =< 0  ->
            PreviousFailed = maps:get(failed,Stats),
            NewStats = Stats#{
            failed := PreviousFailed + 1
        },
        From !  {payment_server, "payment Failes"},
        loop(NewStats);
        {stats,From} ->
            From ! {payment_server,Stats},
            loop(Stats);
        stop ->
            ok
    end.


make_payment(Amount) ->
    payment_server ! {payment, Amount, self()},
    receive
        Reply -> Reply
    after 5000 ->
        {error, timeout}
    end.

stats_report()->
    payment_server ! {stats,self()},
    receive
        Reply -> Reply
    after 5000 ->
        {error,timeout}
    end.






% 1> c(payment_server).
% {ok,payment_server}
% 2> payment_server:start().
% <0.89.0>
% 3> payment_server:make_payment(200).
% {payment_server,"successfully payment received"}
% 4> c(payment_server).
% {ok,payment_server}
% 5> payment_server:make_payment(200).
% {payment_server,"successfully payment received"}
% 6> payment_server:stats_report().
% {error,timeout}
% 7> c(payment_server).
% {ok,payment_server}
% 8> payment_server:stats_report().
% ** exception error: bad argument
%      in function  erlang:send/2
%         called as erlang:send(payment_server,{stats,<0.82.0>})
%         *** argument 1: invalid destination
%      in call from payment_server:stats_report/0 (payment_server.erl, line 57)
% 9> c(payment_server).
% {ok,payment_server}
% 10> payment_server:start().
% <0.111.0>
% 11> payment_server:make_payment(200).
% {payment_server,"successfully payment received"}
% 12> payment_server:stats_report().
% {payment_server,#{failed => 0,successful => 1,total => 200}}
% 13>
