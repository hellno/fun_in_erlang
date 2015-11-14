-module(recursion).
-export([bump/1, sum/1, sum_alt/2, len/1, average/1, even/1, member/2]).

average(List) -> sum(List) / len(List).

% bump([]) -> [];
% bump([Head | Tail]) -> [Head + 1 | bump(Tail)].

% sum([]) -> 0;
% sum([Head | Tail]) -> Head + sum(Tail).
bump(L) -> bump_alt(L, []).
bump_alt([], Acc) -> reverse(Acc);
bump_alt([H | T], Acc) -> bump_alt(T, [H + 1 | Acc]).

sum(List) -> sum_alt(List, 0).
sum_alt([], Sum) -> Sum;
sum_alt([H|T], Sum) -> sum_alt(T,H+Sum).

len([]) -> 0;
len([_ | Tail]) -> 1 + len(Tail).

even([]) -> [];
even([Head | Tail]) when Head rem 2 == 0 -> [Head | even(Tail)];
even([_ | Tail]) -> even(Tail).

member(_, []) -> false;
member(H, [H | _]) -> true;
member(H, [_ | T]) -> member(H, T).

reverse(L) -> reverse_alt(L, []).
reverse_alt([], Acc) -> Acc;
reverse_alt([H | T], Acc) -> reverse_alt(T, [H | Acc]).