-file("fun_w_records.erl", 1).

birthday({person,_,Age,_} = P) ->
    begin
        rec0 = Age + 1,
        rec1 = P,
        case rec1 of
            {person,_,_,_} ->
                setelement(3, rec1, rec0);
            _ ->
                error({badrecord,person})
        end
    end.

joe() ->
    {person,"Joe",23,"01805-123"}.

showPerson({person,Name,Age,Phone}) ->
    io:format("name: ~p age: ~p phone: ~p~n", [Name,Age,Phone]).

test1() ->
    showPerson(joe()).

test2() ->
    showPerson(birthday(joe())).

module_info() ->
    erlang:get_module_info(fun_w_records).

module_info(X) ->
    erlang:get_module_info(fun_w_records, X).

