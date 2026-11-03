-module(monitorworker).
-export([start_process/0,start_process_without_pid/0,cancel_process/0]).




% Exercise 5
start_process() ->
    Pid = spawn(fun()-> worker() end),
    Ref = monitor(process,Pid),
    Ref,
    receive
        {'DOWN', Ref, process, Pid, Reason} ->
            io:format("Process down: ~p~n", [Reason])
    end.
worker() ->
    timer:sleep(2000),
    exit(normal).


% 42> monitorworker:start_process().
% #Ref<0.2791951366.769654785.23606>
% 43> flush().
% Shell got {'DOWN',#Ref<0.2791951366.769654785.23606>,process,<0.215.0>,normal}

% Question: Why does monitoring a worker not automatically terminate the monitoring process when the worker crashes? ====
%  SO the answer is  Because a monitor is designed to observe another process without making the monitoring process depend on its survival, When a worker crashes, Erlang sends a DOWN message to the monitoring process instead of automatically terminating it.




% Exercise 6
start_process_without_pid() ->
    Pid = list_to_pid("<0.123.0>"),
    Ref = monitor(process,Pid),
    Ref,
    receive
        {'DOWN', Ref, process, Pid, Reason} ->
            io:format("Process down: ~p~n", [Reason])
    end.
% Erlang checks whether the PID identifies a live process when you create the monitor. If no such process exists, it sends a DOWN message with reason noproc instead of waiting for the process to terminate.


% Exercise 7
cancel_process() ->
    Pid = spawn(fun()->
        timer:sleep(3000),exit(worker_finished) end),
    Ref = monitor(process,Pid),
    receive
        {'DOWN', Ref, process, Pid, Reason} ->
            io:format("Process down: ~p~n", [Reason])
    after 2000 ->
        Result = demonitor(Ref,[flush]),
        io:format("Is Demonitor Works : ~p~n",[Result]),
        % This is just for the confirmation
        receive
            {'DOWN', Ref, process, Pid, Reason2} ->
                io:format("DOWN still in mailbox: ~p~n", [Reason2])
        after 0 ->
            io:format("No matching DOWN in mailbox.~n")
        end
    end.
