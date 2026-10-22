-module(process).
-export([acknowledge/0,multiple_msg/1,counter/1]).

% hello() ->
%     Pid = spawn(fun() ->
%         io:format("Hello from Erlang Process")
%     end).



% Exercise 3
acknowledge() ->
    receive
        hello ->
            io:format("Hello received ~n")
    end.
% 10> Pid = spawn(process,acknowledge,[]).
% <0.108.0>
% 11> Pid ! hello.
% Hello received
% hello
% So i we try to send a second message it doesn't do anything like since it already terminated like the message is only send not recieved



% Exercise 4 & 5
multiple_msg(Amount) ->
    receive
        hello ->
            io:format("Hello received ~n"),
            multiple_msg(Amount);
        goodbye ->
            io:format("Good Bye Buddy ~n"),
            multiple_msg(Amount);
        {payment,Balance} ->
            io:format("Payment Received - Amount : ~p~n",[Balance]),
            multiple_msg(Amount);
        stop ->
            ok
        after
            3000 ->
                io:format("Timeout - 😄~n")
    end.




% timeout() ->
%     receive
%         hello ->
%             io:format("Hello received ~n"),
%             multiple_msg(Amount);
%         goodbye ->
%             io:format("Good Bye Buddy ~n"),
%             multiple_msg(Amount);
%         {payment,Balance} ->
%             io:format("Payment Received - Amount : ~p~n",[Balance]),
%             multiple_msg(Amount);
%         stop ->
%             ok
%         after
%               3000 ->
                    io:format("Timeout")
%      end.

% Ex - 6
counter(Value) ->
    receive
        increment ->
            % NewValue = Value + 1,
            % counter(NewValue);
            counter(Value + 1);
        decrement ->
            % NewValue = Value - 1,
            % counter(NewValue);
            counter(Value - 1);
        {get,From} ->
            From ! {count,Value},
            counter(Value);
        stop ->
            ok
    end.

% Final Value is goin to be
% receive
%     {count,Value} -> io:format("The Count Value Become : ~p~n",[Value])
% after
%     2000 ->
%         io:format("Nothing To Return")
% end.
