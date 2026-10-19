-module(calc).
-export([rpn/1]).


read(N) ->
    case string:to_float(N) of
        {error,no_float} -> list_to_integer(N);
    {F,_} -> F
    end.

rpn(Expression) when is_list(Expression) ->
    Tokens = string:tokens(Expression, " "),
    try
        Stack = lists:foldl(fun rpn/2, [], Tokens),
        case Stack of
            [Result] -> Result;
            _ -> {error, invalid_expression}
        end
    catch
        error:Reason -> {error, Reason}
    end.

rpn("+",[N1,N2 | S]) ->[ N1 + N2 | S];
rpn(" - ",[N1,N2 | S]) ->[ N1 - N2 | S];
rpn(" * ",[N1,N2 | S]) ->[ N1 * N2 | S];
rpn(" / ",[N1,N2 | S]) ->[ N1 /  N2 | S];
rpn(" ^ ",[N1,N2 | S]) ->[ math:power(N1 ,N2) | S];
rpn("ln", [N|S]) -> [math:log(N)|S];
rpn("log10", [N|S]) -> [math:log10(N)|S];
rpn(X, Stack) -> [read(X)|Stack].
