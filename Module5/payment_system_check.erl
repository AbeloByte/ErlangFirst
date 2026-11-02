-module(payment_system_check).
% -export([start_process/0,monitor_process/1,checkout_payment_process_id/1,checkout_payment/1]).
-export([start_worker/0,monitor_process/1,checkout_payment_process_id/1,checkout_payment/3]).



% start_process() ->
%     spawn(fun() -> watch_out(0) end).


% watch_out(Trial) when Trial >= 3 ->
%     io:format("Final Monitor Attempt Reached ~n");

% watch_out(Trial) when Trial < 3 ->
%     Pid = spawn(fun() -> process_payment() end),
%     Ref = monitor(process,Pid),
%     receive
%         {'DOWN', Ref, process, Pid, Reason} ->
%             io:format("Monitor Failed Because of ~p and Pid is ~p",[Reason,Pid]),
%             watch_out(Trial + 1);
%         {get_id,From} ->
%             From ! {get_id,Pid},
%             watch_out(Trial)
%     end.

% get_process_id_from_watch_out(WatchPid) ->
%     WatchPid ! {get_id,self()},
%     receive
%         {get_id,Pid} ->
%             Pid
%     end.

% process_payment() ->
%     receive
%         {charge, crash_test, _Amount, _ReplyTo} ->
%             exit(the_worker_is_terminated);
%         {charge, RequestId, Amount, ReplyTo} when is_number(Amount), Amount > 0 ->
%             ReplyTo ! {payment_result, RequestId, {ok, Amount}},
%             process_payment();

%         {charge, RequestId, _Amount, ReplyTo} ->
%             ReplyTo ! { payment_result,RequestId,{error, invalid_amount}},
%             process_payment();
%         stop ->
%             ok
%     end.


start_worker() ->
    spawn(fun() -> monitor_process(0) end).



monitor_process(Trial)  when Trial >= 3 ->
    io:format("The process is Beyond its Limit");

monitor_process(Trial)  when Trial < 3->
    Pid = spawn(fun() -> payment_process() end), %1
    Ref = monitor(process,Pid), %R1

    receive
        {'DOWN', Ref, process, Pid, Reason} ->
            io:format("The process is Terminated with process Id~p with a reason of that :~p~n",[Pid,Reason]),
            monitor_process(Trial + 1);
        {sendPid,From} ->
            From ! {get_pid,Pid},
            monitor_process(Trial, Pid, Ref)
    end.


monitor_process(Trial, Pid, Ref)  when Trial < 3->
    receive
        {'DOWN', Ref, process, Pid, Reason} ->
            io:format("The process is Terminated with process Id~p with a reason of that :~p~n",[Pid,Reason]),
            monitor_process(Trial + 1);
        {sendPid,From} ->
            From ! {get_pid,Pid},
            monitor_process(Trial, Pid, Ref)
    end.

checkout_payment_process_id(MonitorId) ->
    MonitorId ! {sendPid,self()},
    receive
        {get_pid,Pid} ->
            Pid
    end.


checkout_payment(NewPid,RequestId,Amount) ->
        NewPid ! {charge,RequestId,Amount,self()},
        receive
             {payment_result,success, RequestId, Result} ->
                io:format("The payment Record of request_id ~p: is ~p :~n",[RequestId,Result]),
                {payment_result, RequestId, Result,your_payment_is_successed};
             {payment_result,error, RequestId, Result} ->
                io:format("The payment Record of request_id ~p: is ~p :~n",[RequestId,Result]),
                {payment_result, RequestId,failed_to_process_the_payment,Result}
        after
            2000 ->
                io:format("Process Timeout Bye")
        end.


payment_process() ->
    receive
        {charge,crash_test,_Amount,_ReplyTo} ->
            exit(terminate_the_worker);
        {charge,RequestId,Amount,ReplyTo} when is_number(Amount), Amount > 0 ->
            ReplyTo ! {payment_result,success, RequestId, {ok, Amount}},
            payment_process();
        {charge,RequestId,_Amount,ReplyTo} ->
            ReplyTo ! {payment_result,error, RequestId, {error, invalid_amount}},
            payment_process();
        stop ->
            ok
    end.
