-module(demo).
-import(math, [sqrt/1]).
-author("HolgerNo").
-export([double/1, times/2, root_ass/1]).
%-compile(export_all).

% comment yo
double(Value) ->
    times(Value, 2).
times(X,Y) ->
    X*Y.
root_ass(X) ->
    sqrt(X).