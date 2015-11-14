-module(frequency).
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).

start() ->
	register(frequency, spawn(frequency, init, [])).

%% Frequencies = {[LIST_OF_USED_FREQs],[LIST_OF_UNUSED_FREQs]}
init() ->
	process_flag(trap_exit, true),
	Frequencies = {get_frequencies(), []},
	loop(Frequencies).

get_frequencies() -> [10,11,23,42].

call(Msg) ->
	frequency ! {request, self(), Msg},
	receive
		{reply, Reply} -> Reply
	end.

%% client functions

stop() -> call(stop).
allocate() -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).

%% MAIN LOOHOP

loop(Frequencies) ->
	receive
		{request, Pid, allocate} ->
			{NewFrequencies, Reply} = allocate(Frequencies, Pid),
			reply(Pid, Reply),
			loop(NewFrequencies);

		{request, Pid, {deallocate, Freq}} ->
			NewFrequencies = deallocate(Frequencies, Freq),
			reply(Pid, ok),
			loop(NewFrequencies);

		{'EXIT', Pid, _Reason} ->
			NewFrequencies = exited(Frequencies, Pid),
			loop(NewFrequencies);

		{request, Pid, stop} ->
			reply(Pid, ok)
	end.

reply(Pid, Reply) ->
	Pid ! {reply, Reply}.

allocate({[], Allocated}, _Pid) ->
	{{[], Allocated}, {error, no_frequencies}};

allocate({[Freq|Free], Allocated}, Pid) ->
	link(Pid),
	{{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->
	{value, {Freq, Pid}} = lists:keysearch(Freq, 1, Allocated),
	unlink(Pid),
	NewAllocated = lists:keydelete(Freq, 1, Allocated),
	{[Freq|Free], NewAllocated}.

exited({Free, Allocated}, Pid) ->
	case lists:keysearch(Pid, 2, Allocated) of
		{value, {Freq, Pid}} ->
			NewAllocated = lists:keydelete(Freq, 1, Allocated),
			{[Freq|Free], NewAllocated};
		false ->
			{Free, Allocated}
	end.


