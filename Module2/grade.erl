-module(grade).
% -export([grade_calc/1]).
-export([check_grade/1]).

% grade_calc(grade) when grade >= 90 , grade =< 100   ->
%     a;

% grade_calc(grade) when grade >= 80 , grade =< 89   ->
%     b;

% grade_calc(grade) when grade >= 70 , grade =< 79   ->
%     c;

% grade_calc(grade) when grade >= 60 , grade =< 69   ->
%     d;

% grade_calc(grade) when grade <= 60 ->
%     f;

% grade_calc(_)
%     {error,invalid_input}.


check_grade(Grade) ->
    if
        Grade >= 90 , Grade =< 100 ->
            a;
        Grade >= 80 , Grade =< 89 ->
            b;
        Grade >= 70 , Grade =< 79 ->
            c;
        Grade >= 60 , Grade =< 69 ->
            d;
        Grade < 60 ->
            f;
        Grade > 100 ->
            io:format("Out of bound, please insert grade only between 0 and 100 ~n");
        true -> "please insert number only"
    end
.


% 14> c(grade).
% {ok,grade}
% 15> grade:check_grade(40).
% "please insert number only"
% 16> grade:check_grade(40).
% "please insert number only"
% 17> c(grade).
% {ok,grade}
% 18> grade:check_grade(40).
% f
% 19> grade:check_grade(120).
% Out of bound
% ok
% 20> c(grade).
% {ok,grade}
% 21> grade:check_grade(120).
% Out of bound, please insert grade only between 0 and 100
% ok
% 22>
