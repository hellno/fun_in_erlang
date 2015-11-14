-module(db_server).
-export([start/0, stop/0, upgrade/1]).
-export([write/2, read/1, delete/1]).
-export([init/0, loop/1]).
-vsn(0.1).

start() ->
	register(db_server, spawn(db_server, init, [])).

stop() ->
	db_server ! stop.

upgrade(Data) ->
	db_server ! {upgrade, Data}.

write(Key, Data) ->
	db_server ! {write, Key, Data}.

read(Key) ->
	db_server ! {read, self(), Key},
	receive Reply -> Reply end.

delete(Key) ->
	db_serve ! {delete, Key}.

init() ->
	loop(db_new:new()).

loop(Db) ->
	receive
		{write, Key, Data} ->
			loop(db_new:write(Key, Data, Db));
		{read, Pid, Key} ->
			Pid ! db_new:read(Key, Db),
			loop(Db);
		{delete, Key} ->
			loop(db_new:delete(Key, Db));
		{upgrade, Data} ->
			NewDb = db_new:convert(Data, Db),
			db_server:loop(NewDb);
		stop ->
			db_new:destroy()
	end.