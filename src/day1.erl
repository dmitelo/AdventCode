%%%-------------------------------------------------------------------
%%% @author dylanmitelo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Dec 2020 5:15 PM
%%%-------------------------------------------------------------------
-module(day1).
-author("dylanmitelo").

%% API
-export([solve/1]).

solve(Filename) ->
	{ok, Contents} = file:read_file(Filename),
	ParsedBinary = binary:split(Contents, [<<",">>, <<"\n">>], [global, trim_all]),
	IntegerList = [binary_to_integer(X) || X <- ParsedBinary],

	io:format("Input data as int list: ~p~n", [IntegerList]),

	{_, Answer} = fold_fun(IntegerList),
	Answer2 = fun2(IntegerList),
	io:format("Answer: ~p~n", [Answer]),
	io:format("Answer2: ~p~n", [Answer2]).

fold_fun(List) ->
	lists:foldl(fun(A, {Acc0, _} = Acc) ->
		case [X || X <- Acc0, A =:= (2020 - X)] of
			[] ->
				Acc;
			[B] ->
				{Acc0, A*B}
		end
				end, {List, 0}, List).

fun2(List) ->
	Map = maps:new(),
	fun2(List, Map).
fun2(done, Answer) ->
	Answer;
fun2([], _Map) ->
	no_answer;
fun2([H | T], Map) ->
	Val = 2020 - H,
	case maps:is_key(Val, Map) of
		false ->
			case fun3(H, T, Map) of
				{done, Result} ->
					Result;
				Map1 ->
					fun2(T, maps:put(H, 0, Map1))
			end;
		true ->
			fun2(T, Map)
	end.
fun3(_, [], Map) ->
	Map;
fun3(A, [H | T], Map) ->
	Val = 2020 - (A+H),
	case maps:is_key(Val, Map) of
		false ->
			fun3(A, T, maps:put(H, 0, Map));
		true ->
			{done, Val*A*H}
	end.
