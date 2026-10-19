-module(hr).
% -export([list_employees/1,get_developers/1,get_managers/1,get_high_salary/1]).
-export([list_employees/1,get_developers/1,calculate_total_salary/1,get_managers/1,find_highest_paid/1,calculate_average_salary/1,get_high_salary/1]).


list_employees(Employees) ->
    [Name || {_,Name,_,_} <- Employees].

get_developers(Employees) ->
    [{Name,Role} || {_,Name,_,Role} <- Employees].

get_managers(Employees) ->
    [{Name,Role} || {_,Name,_,Role} <- Employees, Role == manager].

% get_high_salary(Students) ->
%     get_high_salary(Students,0).

% get_high_salary([],Acc) ->
%     Acc,

% get_high_salary([{_,_,Salary,_} | T],Acc) when Acc > Salary->
%     get_high_salary(Salary, Acc),

% get_high_salary([{_,_,Salary,_} | T],Acc) >
%     get_high_salary(Acc, Salary),

get_high_salary(Employees) ->
    Genzebu = [Salary || {_,_,Salary,_} <- Employees],
    lists:max(Genzebu).

calculate_total_salary(Employees) ->
    Genzebu = [Salary || {_,_,Salary,_} <- Employees],
    lists:sum(Genzebu).

calculate_average_salary([]) ->
   io:format("Please Insert Values First the list is empty");

calculate_average_salary(Employees) ->
    % Len = length(Employees);
    % if Len == 0 ->
    %     io:format("Please Insert Values First the list is empty")
    % true ->
    %     Genzebu = [Salary || {_,_,Salary,_} <- Employees],
    %     Sum = lists:sum(Genzebu),
    %     Result = Sum/Len,
    %     Result,
% end.
    Len = length(Employees),
    Genzebu = [Salary || {_,_,Salary,_} <- Employees],
    Sum = lists:sum(Genzebu),
    Result = Sum div Len,
    Result.


find_highest_paid(Employees) ->
    MaxValue = get_high_salary(Employees),
    % Genzebu = [Salary || {_,_,Salary,_} <- Employees],
    % MaxValue = lists:max(Genzebu),
    [ X || X = {_,_,Salary,_} <- Employees, Salary == MaxValue].
    % lists:keyfind(MaxValue,3,Employees).







% 2> c(hr).
% {ok,hr}
% 3> Employees = [
% 3>     {employee, "Abebe", 8500, developer},
% 3>     {employee, "Hanna", 12000, manager},
% 3>     {employee, "Dawit", 6500, tester},
% 3>     {employee, "Almaz", 15000, architect},
% 3>     {employee, "Kebede", 7000, developer}
% 3> ].
% [{employee,"Abebe",8500,developer},
%  {employee,"Hanna",12000,manager},
%  {employee,"Dawit",6500,tester},
%  {employee,"Almaz",15000,architect},
%  {employee,"Kebede",7000,developer}]
% 4> hr:list_employees(Employees).
% ["Abebe","Hanna","Dawit","Almaz","Kebede"]



% Employees2 = [
%     {employee, "Abebe", 8500, developer},
%     {employee, "Hanna", 12000, manager},
%     {employee, "Dawit", 6500, tester},
%     {employee, "Almaz", 15000, architect},
%     {employee, "Kebede", 7000, developer},
%     {employee, "Jeafar", 15000, architect}
% ].
