
-module(nested_map).
-export([check_data/1]).


check_data(User) ->
    {
        user,
            {name,UserName},
            {age,Age},
            {address,Address}
    } = User,

    io:format("Username : ~p~n",[UserName]),
    io:format("Age : ~p~n",[Age]),
    io:format("Address : ~p~n",[Address]).

