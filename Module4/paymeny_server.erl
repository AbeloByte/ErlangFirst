-module(payment_server).
-export([start/0]).

start() ->
    register(payment_server, self()),
    Stats = #{
        total => 0,
        successful => 0,
        failed => 0
    },
    loop(Stats).
