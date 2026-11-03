% -module(anon).
% % -export([Square/1]).


Square = fun(Num) -> Num * 2 end.

Number = lists:map(Square).
