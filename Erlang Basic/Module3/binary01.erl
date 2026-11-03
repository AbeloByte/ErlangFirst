-module(binary01).
% -export([build_binary/1,parse_binary/1,parse_byte/1,build_packet/1,encode_message/1,decode_message/1,parse_frames/1,encode_file/2,decode_file/1]).
-export([build_binary/3,parse_binary/1,parse_byte/1,build_packet/3,parse_packet/1,convert_endiannes/1,encode_message/1,decode_message/1,parse_frames/1]).


build_binary(ID,Age,Status) ->
    <<ID:16,Age:8,Status:40>>.

parse_binary(Binary) ->
    <<ID:16,Age:8,Status:40>> = Binary,
    {ID,Age,Status}.




% % Flags
parse_byte(<<Active:1, Verified:1, Admin:1, Reserved:5>>) ->
            #{
                active => Active,
                verified =>Verified,
                admin => Admin,
                reserved => Reserved
        }.


% % Build a Packet
build_packet(Version, Type, Payload) ->
    Length = byte_size(Payload),
    <<Version:8, Type:8, Length:16, Payload/binary>>.

% % Parse Packet
parse_packet(
    <<Version:8,
      Type:8,
      Length:16,
      Payload:Length/binary>>
) ->
    #{
        version => Version,
        type => Type,
        length => Length,
        payload => Payload
    }.

% <<1,8,0,5,72,101,98,101,108>>
convert_endiannes(Num) ->
    % This one will take the most significat byte and store it at first
    Resul1 = <<Num:16/big>>,
    % This one will take the least significat byte and store it at first
    Resul2 = <<Num:16/little>>,
    {Resul1,Resul2}.

encode_message(Message) when is_binary(Message) ->
    Len = byte_size(Message),
    <<Len:16/big, Message/binary>>.

decode_message(<<Len:16/big, Payload:Len/binary>>) ->
    {ok, Payload}.

% % Multiple Frames
parse_frames(<<>>) ->
    [];

parse_frames(
    <<Length:16, Payload:Length/binary, Rest/binary>>
) ->
    [Payload | parse_frames(Rest)].

% % The custom file format
% % Layout -
% % Magic (4B) + Version (1B) + Flags (1B) + Length (4B) + Payload (NB)


encode_file(#{ version := Version,flags := Flags},Payload) ->
    Length = byte_size(Payload),
    <<Magic,Version:8,Flags:8,Length:32/big,Payload/binary>>.

% binary01:parse_frames(<<0,7,87,101,108,99,111,109,101,32,116,111,32,69,65,73,73,46,32,104,101,108,108,111>>).

decode_file(<<Magic,Version:8,Flags:8,Length:32/big,Payload/binary>>) ->
    {ok, #{
    version => Version,
    flags => Flags,
    payload => Payload
    }}.
