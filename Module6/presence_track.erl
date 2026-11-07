-module(presence_track).
-behaviour(gen_server).

-export([online/0,offline/0,start/0]).
-export([init/1,handle_call/3,handle_cast/2]).
