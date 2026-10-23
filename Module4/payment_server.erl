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
