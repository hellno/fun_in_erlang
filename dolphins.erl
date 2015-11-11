-module(dolphins).
-compile(export_all).

dolphin1() ->
    receive
        do_a_flip ->
            io:format("NOPE?!~n");
        fish ->
            io:format("FISH, THANKS!~n");
        _ ->
            io:format("stupid human!~n")
    end.

dolphin2() ->
    receive
        {From, do_a_flip} ->
            From ! "How about now?",
            dolphin2();
        {From, fish} ->
            From ! "FISH, THANKS!";
        _ -> io:format("stupid human!~n")
        dolphin2().
    end.
