-module(age_classifier).
-export([classify_Age/1]).


classify_Age(Age) ->
    case Age of
        Age when is_integer(Age) , Age < 0 ->
            invalid;
        Age when is_integer(Age) , Age > 0 , Age =< 12  ->
            child;
        Age when is_integer(Age) , Age >= 13 , Age =< 19 ->
            teenAger;
        Age when is_integer(Age) , Age >= 20 ->
            adult;
        _ ->
            {error, invalid_argument}
end.
