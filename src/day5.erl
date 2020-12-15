%%%-------------------------------------------------------------------
%%% @author dylanmitelo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2020 11:37 AM
%%%-------------------------------------------------------------------
-module(day5).
-author("dylanmitelo").

%% API
-export([solve/0]).


solve() ->
	Filename = "../data/day5",
	{ok, Contents} = file:read_file(Filename),
	ParsedBinary = binary:split(Contents, [<<"\n">>], [global, trim_all]),

	io:format("Input data as int list: ~p~n", [ParsedBinary]),

	{Max, Ans} = find_id(ParsedBinary, []),
	io:format("Max: ~p Ans: ~p~n", [Max, Ans]),

	ok.

find_id([], Ans) ->
	Max = lists:max(Ans),
	Sorted = lists:sort(Ans),
	io:format("Sorted: ~p~n", [Sorted]),
	{Max, lists:foldl(fun(X, {Prev, Seat}) ->
		X0 = X - 1,
		case X0 of
			Prev ->
				{X, Seat};
			_ ->
				{X, X0}
		end
			   end, {hd(Sorted) - 1, 0}, Sorted)};

find_id([H | T], ID) ->
	{{_,Row}, {_,Column}} = find_seats(H, {{0, 127}, {0,7}}),
	NewId = (Row * 8) + Column,
	find_id(T, [NewId | ID]).
%%	case NewId >= ID of
%%		true ->
%%			find_id(T, NewId);
%%		false ->
%%			find_id(T, ID)
%%	end.

find_seats(<<>>, {Row, Column}) ->
	{Row, Column};
find_seats(<<X:1/binary, Y/binary>>, {{LRow, URow}, {LColumn, UColumn}}) ->
	case X of
		<<"F">> ->
			Diff = URow - LRow,
			URow1 = Diff div 2,
			find_seats(Y, {{LRow, LRow + URow1}, {LColumn, UColumn}});
		<<"B">> ->
			Diff = URow - LRow,
			LRow1 = Diff div 2,
			find_seats(Y, {{LRow + LRow1 + 1, URow}, {LColumn, UColumn}});
		<<"R">> ->
			Diff = UColumn - LColumn,
			LColumn1 = Diff div 2,
			find_seats(Y, {{LRow, URow}, {LColumn + LColumn1 + 1, UColumn}});
		<<"L">> ->
			Diff = UColumn - LColumn,
			LColumn1 = Diff div 2,
			find_seats(Y, {{LRow, URow}, {LColumn, LColumn + LColumn1}})
	end.
