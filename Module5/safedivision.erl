-module(safedivision).
-export([safe_divide/2]).



% with try catch
safe_divide(_N,0)  ->
    {error, division_by_zero};

safe_divide(N,M) ->
    try
        Result = N / M,
        {ok,Result}
    catch
        error:Reason ->
            {error,Reason}
    end.

% 16> c(safedivision).
% {ok,safedivision}
% 17> safedivision:safe_divide(5,"safsdfa").
% {error,badarith}
% 18> safedivision:safe_divide(5,0).
% {error,badarith}
% 19> c(safedivision).
% {ok,safedivision}
% 20> safedivision:safe_divide(5,0).
% {error,division_by_zero}
% 21> safedivision:safe_divide(5,2).
% {ok,2.5}


% with Guards Only
% safe_divide(_N,0)  ->
%     {error, division_by_zero};

% safe_divide(N,M) when not is_number(N) orelse not is_number(M) ->
%     {error,invalid_inputs};

% safe_divide(N,M) when is_number(N), is_number(M) ->
%         Result = N / M,
%     {ok,Result}.
