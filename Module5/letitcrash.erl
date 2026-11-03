-module(letitcrash).
-export([process_payment/1]).


% process_payment(Amount) ->
%     try
%         1000 / Amount
%     catch
%         _:_ ->
%             ignored
%     end.


% So here we are saying or priniting ignored for any excpetions or error that happended instead of telling what the exact issue of that thing which makes a serious problem by letting serious problems to be ignored

% error Result
% process_payment(Amount) ->
%     try
%         1000 / Amount
%     catch
%         error:Reason ->
%             {error,Reason}
%     end.
