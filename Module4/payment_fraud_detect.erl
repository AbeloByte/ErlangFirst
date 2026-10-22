-module(payment_fraud_detect).
-export([payment_check/1,fraud_detect/0,notification/0]).


payment_check(Amount) ->
        Pid = spawn(fun() -> fraud_detect/0 end),
        Pid2 = spawn(fun() -> notification/0 end),
        Pid ! {payment,self(),Amount},
        receive
            {payment_success,Msg} ->
                Pid2 ! {paymentsuccess,Msg}
        end.

fraud_detect() ->
    receive
        {payment,PaymentSendrId,Amount} when Amount > 0 ->
            PaymentSendrId ! {payment_success,"approved"};
        {payment,PaymentSendrId,Amount} when Amount < 0 ->
            PaymentSendrId ! {payment_success,"rejected"};

    end.

notification() ->
    receive
        {paymentsuccess,Response} ->
            io:format("Your Payment successfully Got ~p~n",[Response])
    end.
