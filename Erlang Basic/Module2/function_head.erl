-module(function_head).
-export([describe/1]).

describe({student,Name}) ->
    {student,Name};

describe({teacher,Name}) ->
    {teacher,Name};

describe({admin,Name}) ->
    {admin,Name};

describe(_) ->
    {error,unknown}.
