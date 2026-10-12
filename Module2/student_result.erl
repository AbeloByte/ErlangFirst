-module(student_result).
-export([get_names/1,get_passed/1,get_failed/1,highest/1,average/1]).

% [ Expression || Generator , Condition1 , Condition2 ]

get_names(Students) ->
    [Name || {Name,_} <- Students].

get_passed(Students) ->
    [{Name,Age} || {Name,Age} <- Students, Age >=60 ].

get_failed(Students) ->
    [{Name,Age }|| {Name,Age} <- Students, Age < 60 ].

highest(Students) ->
    Score = [ Score || {_,Score} <- Students],
    lists:max(Score).
average(Students) ->
    Score = [ Score || {_,Score} <- Students],
    Len = length(Students),
    Result = lists:sum(Score),
    Ave = Result / Len,
    Ave.



% 1> c(student_result).
% {ok,student_result}
% 2> Students = [
% 2>     {"Abebe", 85},
% 2>     {"Kebede", 65},
% 2>     {"Almaz", 92},
% 2>     {"Hanna", 55},
% 2>     {"Dawit", 78}
% 2> ].
% [{"Abebe",85},
%  {"Kebede",65},
%  {"Almaz",92},
%  {"Hanna",55},
%  {"Dawit",78}]
% 3> student_result:get_names(Students).
% ["Abebe","Kebede","Almaz","Hanna","Dawit"]
% 4> student_result:get_passed(Students).
% [{"Abebe",85},{"Kebede",65},{"Almaz",92},{"Dawit",78}]
% 5> student_result:get_failed(Students).
% [{"Hanna",55}]
