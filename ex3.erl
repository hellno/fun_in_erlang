-module(ex3).
-export([sum/1, sum/2]).

sum(Val) -> sum_acc(Val, 0).

sum_acc(Val, Sum) when Val > 0 -> sum_acc(Val-1, Sum+Val);
sum_acc(Val, Sum) when Val < 0 -> sum_acc(Val+1, Sum+Val);
sum_acc(_, Sum) -> Sum.

sum(N, M) when N > M -> throw({'EXIT', {'N bigger than M'}});
sum(N, M) ->
    sum(M) - sum(N).