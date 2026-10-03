set_online(User)->
    #{
        status  => online
    }.

User = #{
    name => hebel,
    status => offline
}



sum([])->
    0;

sum([Head | Tail])->
    Head +  sum
