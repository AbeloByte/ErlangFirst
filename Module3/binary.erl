-module(binary).
-export([build_binary/1,parse_binary/1,parse_byte/1,build_packet/1,encode_message/1,decode_message/1,parse_frames/1,encode_file/2,decode_file/1]).


build_binary(ID,Age,Status) ->
    <<ID:16,Age:8,Status:8>>.

parse_binary(Binary) ->
    <<ID:16,Age:8,Status:8>> = Binary,
    {ID,Age,Status}.




% Flags
parse_byte(<<Active:1, Verified:1, Admin:1, Reserved:5>>) ->
            #{
                active => Active,
                verified =>Verified,
                admin => Admin,
                reserved => Reserved
        }.


% Build a Packet
build_packet(Version, Type, Payload) ->
    Length = byte_size(Payload),
    <<Version:8, Type:8, Length:16, Payload/binary>>.

% Parse Packet
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


convert_endiannes(Num) ->
    % This one will take the most significat byte and store it at first
    <<Num:16/big>>.
    % This one will take the least significat byte and store it at first
    % <<Num:16/little>>.

encode_message(Message) when is_binary(Message) ->
    Len = byte_size(Message),
    <<Len:16/big, Message/binary>>.

decode_message(<<Len:16/big, Payload:Len/binary>>) ->
    {ok, Payload};

% Multiple Frames
parse_frames(<<>>) ->
    [];

parse_frames(
    <<Length:16, Payload:Length/binary, Rest/binary>>
) ->
    [Payload | parse_frames(Rest)].

% The custom file format
% Layout -
% Magic (4B) + Version (1B) + Flags (1B) + Length (4B) + Payload (NB)


encode_file(#{ version := Version,flags := Flags},Payload) ->
    Length = byte_size(Payload),
    <<Magic,Version:8,Flags:8,Length:32/big,Payload/binary>>.

decode_file(<<Magic,Version:8,Flags:8,Length:32/big,Payload/binary>>) ->
    {ok, #{
    version => Version,
    flags => Flags,
    payload => Payload
    }}.
