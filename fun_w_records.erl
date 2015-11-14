-module(fun_w_records).
-compile(export_all).

-record(person, {name, age=18, phone="", address=""}).
-define(HOME, "671 Lincoln Ave, Winnetka, IL 60093 | Zillow").

birthday(#person{age=Age} = P) ->
	P#person{age = Age + 1}.

joe() ->
	#person{name = "Joe", phone="01805-123", age=23, address=?HOME}.

showPerson(#person{age=Age, name=Name, phone=Phone, address=Address}) ->
	io:format("name: ~p age: ~p phone: ~p address: ~p~n", 
		[Name, Age, Phone, Address]).

test1() ->
	showPerson(joe()).

test2() ->
	showPerson(birthday(joe())).