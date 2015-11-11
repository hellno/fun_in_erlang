-module(echo_server).
-export([start/0, print/1, stop/0, loop/0]).

start() ->
	register(echo_server, spawn(echo_server, loop, [])),
	ok.

loop() ->
	receive
		{_From, stop} -> 
			io:format("stopping that shiat~n"),
			true;

		{_From, Msg} ->
			io:format("~p~n", [Msg]),
			loop();

		_ -> loop()
	end.

print(Arg) ->
	echo_server ! {self(), Arg},
	ok.

stop() ->
	echo_server ! {self(), stop},
	ok.