
-module(payment_system).
-export([start_worker/0, watcher/1, process_payment/0]).


start_worker() ->
    spawn(fun() -> watcher(0) end).


watcher(Restarts) when Restarts >= 3 ->
    io:format("Maximum restart limit is reached. Bye Bye 👋.~n");

watcher(Restarts) ->
    Pid = spawn(fun() -> process_payment() end),
    Ref = monitor(process, Pid),
    io:format("Worker started: ~p~n", [Pid]),
    watcher_loop(Pid, Ref, Restarts).


watcher_loop(Pid, Ref, Restarts) ->
    receive
        {charge, crash_test, Amount, ReplyTo} ->
            Pid ! {charge, crash_test, Amount, ReplyTo},
            wait_for_down(Pid, Ref, Restarts);

        {charge, RequestId, Amount, ReplyTo} ->
            Pid ! {charge, RequestId, Amount, ReplyTo},
            watcher_loop(Pid, Ref, Restarts);

        {'DOWN', Ref, process, Pid, Reason} ->
            handle_down(Pid, Reason, Restarts)
    end.


wait_for_down(Pid, Ref, Restarts) ->
    receive
        {'DOWN', Ref, process, Pid, Reason} ->
            handle_down(Pid, Reason, Restarts)
    end.




% This one is just simply the exit was Normal
handle_down(Pid, normal, _Restarts) ->
    io:format("Worker ~p stopped normally.~n", [Pid]);


% This is for the exits that is different from Normal
handle_down(Pid, Reason, Restarts) ->
    io:format("Worker ~p terminated Bcuz of the Reason: ~p~n",[Pid, Reason]),
    io:format("Starting replacement worker...~n"),
    watcher(Restarts + 1).



process_payment() ->
    receive
        {charge, crash_test, _Amount, _ReplyTo} ->
            exit(the_worker_is_terminated);

        {charge, RequestId, Amount, ReplyTo} when is_number(Amount), Amount > 0 ->
            ReplyTo ! {payment_result, RequestId, {ok, Amount}},
            process_payment();

        {charge, RequestId, _Amount, ReplyTo} ->
            ReplyTo ! { payment_result,RequestId,{error, invalid_amount}},
            process_payment();
        stop ->
            ok
    end.
