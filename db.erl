-module(db).
-compile(export_all).

new() -> [].
write(Key, Element, Db) -> 
    case read(Key, Db) of
        {error, "Key not found"} -> [{Key, Element} | Db]; 
        _Else -> Db
    end.

% delete(Key, Db) ->

read(_ , Db) when Db == [] -> {error, "Key not found"};
read(Key, [{DbKey, Element} | _]) when Key == DbKey -> {ok, Element};
read(Key, [_ | TDb]) -> read(Key, TDb).

delete(Key, Db) -> delete_alt(Key, Db, []).

delete_alt(_, [], Stack) -> Stack;
delete_alt(Key, [{DbKey, _ }| Tail], Stack) when Key == DbKey ->
    Tail ++ Stack;
delete_alt(Key, [H|T], Stack) -> delete_alt(Key, T, [H|Stack]).

match(Element, Db) -> match_alt(Element, Db, []).

match_alt(_, [], Result) -> Result;
match_alt(Element, [{DbKey, DbElement}|T], Result) when Element == DbElement ->
    match_alt(Element, T, [DbKey|Result]);
match_alt(Element, [_|T], Result) ->
    match_alt(Element, T, Result).