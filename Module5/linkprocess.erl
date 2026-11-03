-module(linkprocess).
-export([test_process/0,worker/0]).



% % Exercise 3
% test_process() ->
%     spawn_link(fun() -> worker() end).

% worker() ->
%     exit(worker_failed).


% - What happens to a linked process when its partner exits abnormally?
%  Both the worker and Test_process failed
%  2. No. A normal exit generally does not terminate the linked partner.
% Eshell V13.2.2.5  (abort with ^G)
% 1> c(linkprocess).
% {ok,linkprocess}
% 2> linkprocess:test_process().
% ** exception exit: worker_failed -- This is with failed exit
% 3> c(linkprocess).
% {ok,linkprocess}
% 4> linkprocess:test_process().
% <0.97.0> -  This is with normal exit



% _______________________________________________________________________
% Exercise 4
% ============= One Way =============
% test_process() ->
%     process_flag(trap_exit, true),
%     spawn_link(fun() -> worker() end).

% worker() ->
%     exit(worker_failed).
% 7> c(linkprocess).
% {ok,linkprocess}
% 8> linkprocess:test_process().
% <0.113.0>
% 9> flush().
% Shell got {'EXIT',<0.113.0>,worker_failed}
% ok
% 10>


% ============= The Other Way =============
test_process() ->
    process_flag(trap_exit, true),
    spawn_link(fun() -> worker() end),
    receive
        {'EXIT',Pid,worker_failed} ->
            io:format("Your Worker Process is Down with pid ~p~n",[Pid])
    end.

worker() ->
    exit(worker_failed).


%  So trapping exit is to let a process receive exit signals as
% messages instead of terminating because of them.
% Without trapping exits - An abnormal exit from a linked process can kill the process too.
% With trapping exits: The process receives a message and can decide what to do.
% _______________________________________________________________________
