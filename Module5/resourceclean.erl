-module(resourceclean).
-export([process_resource/1]).


process_resource(Msg) ->
    try
        open_resource(Msg)
    of
        {success,Result} -> {success,Result};
        {failed,Result} -> {failed,Result}
    catch
        error:Reason ->
            {error,Reason}
    after
        the_resource_is_cleaned_up()
    end.


open_resource(Msg) ->
      io:format("Opening the resource...~n"),
      case Msg of
        success ->
            {success, "Resource processed successfully"};
        failure ->
            erlang:error(processing_failed)
    end.

the_resource_is_cleaned_up() ->
    io:format("Cleaning up the resource...~n").


% The after block simply guarantees cleanup; it does not prevent an exception from propagating.
%  so in erlang fter executes whether the try block succeeds or raises an exception. Once cleanup finishes, an uncaught exception continues to propagate.
