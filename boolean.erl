-module(boolean).
%-compile(export_all).
-export([b_not/1, b_and/2, b_or/2, b_nand/2]).

b_not(Value) ->
    Value == false.

b_and(A, B) ->
    A == B.

b_or(A, B) ->
    A /= B.

b_nand(A, B) ->
    b_not(b_and(A,B)).