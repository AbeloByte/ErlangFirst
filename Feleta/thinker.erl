-module(thinker).
-export([main_process/0]).



main_process() ->
    Pid1 = spawn(fun() -> workera() end),
    Pid2 = spawn(fun() -> workerb() end).


workera() ->
    receive
         ->

    end
