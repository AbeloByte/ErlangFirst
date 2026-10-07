insert(X,[]) ->
        [X];

insert(X,Set) ->
        case lists:member(X,Set) of
                true -> Set;
                false -> [X | Set]
        end.
