-module(road).
-export([main/1]).

main([FileName]) ->
    % FileName = "road.txt",
    {ok, B} = file:read_file(FileName),
    Map = parse_map(B),
    io:format("~p~n", [optimal_path(Map)]),
    erlang:halt().

parse_map(B) when is_binary(B) ->
    parse_map(binary_to_list(B));
parse_map(Str) when is_list(Str) ->
    Val = [list_to_integer(X) || X <- string:tokens(Str, "\r\n\t")],
    make_tuples(Val, []).

make_tuples([], Acc) ->
    lists:reverse(Acc);
make_tuples([A, B, X|Rest], Acc) ->
    make_tuples(Rest, [{A, B, X}|Acc]).

shortest_step({A, B, X}, {{DistA, PathA}, {DistB, PathB}}) ->
    OptA1 = {DistA + A, [{a, A}|PathA]},
    OptA2 = {DistB + B + X, [{x, X}, {b, B}|PathB]},
    OptB1 = {DistB + B, [{b, B}|PathB]},
    OptB2 = {DistA + A + X, [{x, X}, {a, A}|PathA]},
    {erlang:min(OptA1, OptA2), erlang:min(OptB1, OptB2)}.

optimal_path(Map) ->
    {A, B} = lists:foldl(fun shortest_step/2, {{0, []}, {0, []}}, Map),
    {_Dist, Path} = if hd(element(2, A)) =/= {x,0} -> A;
                        hd(element(2, B)) =/= {x,0} -> B
                    end,
    lists:reverse(Path).