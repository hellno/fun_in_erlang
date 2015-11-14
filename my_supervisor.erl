-module(my_supervisor).
-export([start_link/2, stop/1]).
-export([init/1]).

start_link(Name, ChildSpecList) ->
	register(Name, spawn_link(my_supervisor, init, [ChildSpecList])),
	ok.

init(ChildSpecList) ->
	process_flag(trap_exit, true),
	loop(start_children(ChildSpecList)).

start_children([]) -> [];
start_children([{M, F, A, T} | ChildSpecList]) ->
	case (catch apply(M,F,A)) of
		{ok, Pid} ->
			[{Pid, {M, F, A, T}} | start_children(ChildSpecList)];
		_ ->
			start_children(ChildSpecList)
	end.

restart_child(Pid, ChildList) ->
	case lists:keysearch(Pid, 1, ChildList) of
		{value, {Pid, {M, F, A, permanent}}} ->
			{ok, NewPid} = apply(M, F, A),
			io:format("~p was restarted, new Pid ~p~n",[Pid, NewPid]),
			[{NewPid, {M, F, A, permanent}} | lists:keydelete(Pid, 1, ChildList)]
		false ->
			io:format("~p was NOT restarted~n",[Pid]),
	end.
	
loop(ChildList) ->
	receive
		{'EXIT', Pid, Reason} ->
			io:format("Reason: ~p~n",[Reason]),
			NewChildList = restart_child(Pid, ChildList),
			loop(NewChildList);
		{stop, From} ->
			From ! {reply, terminate(ChildList)}
	end.

stop(Name) ->
	Name ! {stop, self()},
	receive 
		{reply, Reply} -> Reply 
	end.

terminate([{Pid, _} | ChildList]) ->
	exit(Pid, kill),
	terminate(ChildList);
terminate(_ChildList) -> ok.