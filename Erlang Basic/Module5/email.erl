-module(email).
% -export([divide/2]).
-export([validate_email/1]).

% divide(A, B) ->
%     try
%         A / B
%     catch
%         error:badarith ->
%             {error, division_by_zero}
%     end.

% Write a function  that checks whether an email address looks valid.

% 1 - Exercise One

validate_email(Email) ->
    case re:run(Email,"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$") of
        {match,_} ->
            {ok,valid_email_format};
            % ok;
        nomatch ->
                throw(invalid_email_format)
    end.

% Erlang/OTP 25 [erts-13.2.2.5] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns]
% Eshell V13.2.2.5  (abort with ^G)
% 1> c(email).
% {ok,email}
% 2> email:validate_email("hebel@gmail.com").
% {ok,valid_email_format}
% 3> email:validate_email("hebel#gmail.com").
% ** exception throw: invalid_email_format
%      in function  email:validate_email/1 (email.erl, line 23)



% 2 - Exercise Two
