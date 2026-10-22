-module(map01).
% -export([information/0,student_info/0,get_user/1,classify_student/1,get_sizes/1,
% extract_string/1
% ]).
-export([get_sizes/1]).

% % get_employee_name/1,get_employee_salary/1,update_salary/2

% % information
% information() ->
%     Student = #{
%     id => 001,
%     name => "Hebel",
%     age => 18,
%     department => "Software Engineering",
%     gpa => 3.50
% },

%     #{id:=ID , name := Name, age := Age, department:= Department, gpa:= GPA} = Student,
%     io:format("Stundet with id:~p name: ~p age: ~p Department: ~p with Gpa Result : ~p please come to the 3rd floor ~n",[ID,Name,Age,Department,GPA]),

%    NewStudent = Student#{
%         gpa := 3.78,
%         status => active
%     },

%     #{id:=ID , name := Name, age := Age, department:= Department, gpa:= NewGPA} = NewStudent,
%     io:format("Stundet with id:~p name: ~p age: ~p Department: ~p with Gpa Result : ~p please come to the 3rd floor ~n",[ID,Name,Age,Department,NewGPA]).

% % Student Information
% % student_info() ->
% %     Name = string:trim(io:get_line("Enter your name: ")),
% %     GpaInput = string:trim(io:get_line("Enter your age: ")),
% %     Gpa = string:to_integer(GpaInput),
% %     StudentInfo = # {
% %         name => Name,
% %         gpa => Gpa
% %     },
% %     %  io:format("Student Profile -  Name : ~p and Gpa Result : ~p",[Name,Gpa]).
% %      io:format("Student Profile - ~p~n",[StudentInfo]),
% %      io:format("Student Profile - Name : ~p and Age : ~p~n",[Name,GpaInput]).


% % classify_student(#{ gpa := GPA}) when GPA >= 3.5  ->
% %     excellent;
% % classify_student(#{ gpa := GPA}) when GPA >= 3.0  ->
% %     good;
% % classify_student(#{ gpa := GPA}) when GPA >= 2.0  ->
% %     average;
% % classify_student(#{ gpa := GPA}) when GPA < 2.0  ->
% %     poor.



% % Get User - Exercise 5 — Dynamic Keys
% get_user(UserId) ->
%     Users = #{
%         1001 => "Abebe",
%         1002 => "kebede",
%         1003 => "Almaz"
%     },
%     Name = maps:get(UserId,Users),
%     io:format("The Person Name is :~p~n",[Name]).

% % -record(employee, {
% %     id,
% %     name,
% %     department,
% %     salary
% % }).

% % get_employee_name(#employee{name = Name}) ->
% %     io:format("Employee name is: ~p~n", [Name]).

% % get_employee_name(#employee{salary = salary}) ->
% %     io:format("Employee name is: ~p~n", [Name]).

% % get_employee_name(salary) ->
% %     UpdateEmployee = #employee{
% %     salary = 1000
% % }.
% %     io:format("Employee name is: ~p~n", [Name]).

get_sizes(Input) ->
    Bytsize = byte_size(Input),
    io:format("The Binary File size in BYTE is :~p~n",[Bytsize]),
    Bitsize = bit_size(Input),
    io:format("The Binary File size in Bi is :~p~n",[Bitsize]).



extract_string(Data) ->
    <<First:5/binary, Rest/binary>> = Data,
    io:format("First: ~p~n",[First]),
    io:format("Second: ~p~n",[Rest]).
