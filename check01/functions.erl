-module(functions).
-compile(export_all).


head([H | _]) ->
    H.

second([_,_,X | _]) ->
    X.
