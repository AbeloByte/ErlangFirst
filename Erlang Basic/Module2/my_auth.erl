-module(my_auth).
-export([login/1]).

login(Auth_info) ->
    % {user,Username,Password} = Auth_info,
    case Auth_info of
        {user,Username,Password} when Username == "admin" ,  Password == "1234" ->
            {ok, "Welcome admin"};
        {user,Username,Password} when Username == "admin" ,  Password =/= "1234" ->
            {error, incorrect_password};
        {user,Username,Password} when Username =/= "admin" ,  Password == "1234" ->
            {error, incorrect_username};
        _->
            {error, invalid_credentials}

    end.



% 1> c(my_auth).
% {ok,my_auth}
% 2> my_auth:login({user,"Tomas","123"}).
% {error,invalid_credentials}
% 3> my_auth:login({user,"Tomas","1234"}).
% {error,incorrect_username}
% 4> my_auth:login({user,"admin","1234"}).
% {ok,"Welcome admin"}
% 5>
