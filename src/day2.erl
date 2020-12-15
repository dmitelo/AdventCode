%%%-------------------------------------------------------------------
%%% @author dylanmitelo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Dec 2020 9:48 AM
%%%-------------------------------------------------------------------
-module(day2).
-author("dylanmitelo").

%% API
-export([solve/1]).

solve(Filename) ->
	{ok, Contents} = file:read_file(Filename),
	ParsedBinary = binary:split(Contents, [<<"\n">>], [global, trim_all]),
	io:format("Input data as binary: ~p~n", [ParsedBinary]),

	Ans = check_passwords(ParsedBinary, []),
	Ans2 = check_passwords2(ParsedBinary, []),
	io:format("Answer: ~p~n", [length(Ans)]),
	io:format("Answer2: ~p~n", [length(Ans2)]),
	ok.

check_passwords([], Ans) ->
	Ans;
check_passwords([H | T], A) ->
	List = binary:split(H, [<<"-">>, <<" ">>, <<":">>], [global, trim_all]),
	[Min, Max, Key, Pass] = [binary_to_list(X) || X <- List],
	MPass = [X || X <- Pass, [X] =:= Key],
	case (length(MPass) >= list_to_integer(Min) andalso length(MPass) =< list_to_integer(Max)) of
		true ->
			check_passwords(T, [Pass | A]);
		false ->
			check_passwords(T, A)
	end.

check_passwords2([], Ans) ->
	Ans;
check_passwords2([H | T], A) ->
	List = binary:split(H, [<<"-">>, <<" ">>, <<":">>], [global, trim_all]),
	[Min, Max, Key, Pass] = [binary_to_list(X) || X <- List],
	MinInt = list_to_integer(Min),
	MaxInt = list_to_integer(Max),
	Y = Key =:= [lists:nth(MinInt, Pass)],
	Z = Key =:= [lists:nth(MaxInt, Pass)],
	io:format("MinInt: ~p MaxInt: ~p Key: ~p Pass: ~p~n", [MinInt, MaxInt, Key, Pass]),
	io:format("Y: ~p Z: ~p~n", [Y, Z]),
	case (Y xor Z) of
		true ->
			check_passwords2(T, [Pass | A]);
		false ->
			check_passwords2(T, A)
	end.