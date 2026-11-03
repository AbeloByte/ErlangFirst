-module(payment_msg).
-export([encode_payment/4,decode_payment/1]).

encode_payment(
 UserId,
 Amount,
 Currency,
 MsgType
) when is_integer(MsgType), MsgType >= 0, is_integer(UserId) , UserId =< 16#FFFFFFFF, MsgType =< 255,byte_size(Currency) =:= 3, Amount >= 0 , Amount =< 16#FFFFFFFFFFFFFFFF ->
    <<1:8,MsgType:8,UserId:32,Amount:64,Currency:3/binary>>;

encode_payment(_, _, _, _) ->
    {error, invalid_packet}.
% Packet = <<Userid:8,Amount:64,Currency:3,msgtype:8>>
decode_payment(<<1:8,MsgType:8,Userid:32,Amount:64,Currency:3/binary>>) ->
    {ok,#{
        version => 1,
        msgtype => MsgType,
        userid => Userid,
        amount => Amount,
        currency => Currency
}};

decode_payment(_) ->
    {error,invalid_packet}.
