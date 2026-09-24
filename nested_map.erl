#!/usr/bin/env escript

main(_) ->
    User = [
        #{
            name => hebel,
            age => 24,
            role => backend,
            profile => #{
                division => software,
                city => addis_abeba
            }
        },

        #{
            name => ayele,
            age => 25,
            role => backend,
            profile => #{
                division => devops,
                city => france
            }
        },
         #{
            name => ayele,
            name => ayele,
            age => 25,
            role => backend,
            profile => #{
                division => devops,
                city => france
            }
        }
    ],

    [First | Rest] = User,

    io:format("First: ~p~n", [First]),
    io:format("Rest: ~p~n", [Rest]).



