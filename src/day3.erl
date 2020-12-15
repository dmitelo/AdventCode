%%%-------------------------------------------------------------------
%%% @author dylanmitelo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Dec 2020 11:37 AM
%%%-------------------------------------------------------------------
-module(day3).
-author("dylanmitelo").

%% API
-export([solve/0]).

solve() ->
	Filename = "../data/day3",
	{ok, Contents} = file:read_file(Filename),
	ParsedBinary = binary:split(Contents, [<<",">>, <<"\n">>], [global, trim_all]),

	io:format("Input data as int list: ~p~n", [ParsedBinary]),

	Ints = [binary_to_list(X) || X <- ParsedBinary],
	io:format("Input data as int list: ~p~n", [Ints]),

	[_ | T] = Ints,
	[_ | T2] = T,
	Increments = [1, 3, 5, 7],
	Trees = [length(find_trees(T, 1, X, [])) || X <- Increments],
	io:format("NEw trees ~n"),
	Trees2 = length(find_trees2(T2, 1, 1, [])),
	CompoundAmount = lists:foldl(fun(X, Acc) -> X * Acc end, 1, Trees),
	CompoundAmount2 = CompoundAmount * Trees2,
	io:format("Trees: ~p~n Trees2: ~p~n Compound Amount: ~p~n CompoundAmount2: ~p~n", [Trees, Trees2, CompoundAmount, CompoundAmount2]),
	ok.

find_trees([], _Pos, _Inc, Ans) ->
	[X || X <- Ans, "#" =:= X];
find_trees([H | T], PrevPos, Inc, Trees) ->
	io:format("first trees~n"),
	NewPos = PrevPos + Inc,
	TreeLineLength = length(H),
	io:format("Line: ~p, Length: ~p, PrevPos: ~p, NewPos: ~p~n", [H, TreeLineLength, PrevPos, NewPos]),
	case NewPos > TreeLineLength of
		true ->
			PosDiff = NewPos - length(H),
			Pos = [lists:nth(PosDiff, H)],
			find_trees(T, PosDiff, Inc, [Pos | Trees]);
		false ->
			Pos = [lists:nth(NewPos, H)],
			find_trees(T, NewPos, Inc, [Pos | Trees])
	end.

find_trees2([], _Pos, _Inc, Ans) ->
	[X || X <- Ans, "#" =:= X];
find_trees2([H | T], PrevPos, Inc, Trees) ->
	NewPos = PrevPos + Inc,
	TreeLineLength = length(H),
	io:format("Line: ~p, Length: ~p, PrevPos: ~p, NewPos: ~p~n", [H, TreeLineLength, PrevPos, NewPos]),
	case NewPos > TreeLineLength of
		true ->
			PosDiff = NewPos - length(H),
			Pos = [lists:nth(PosDiff, H)],
			[_H1 | T1] = T,
			find_trees2(T1, PosDiff, Inc, [Pos | Trees]);
		false ->
			Pos = [lists:nth(NewPos, H)],
			case T of
				[] ->
					find_trees2([], NewPos, Inc, [Pos | Trees]);
				[_H1 | T1] ->
					find_trees2(T1, NewPos, Inc, [Pos | Trees])
			end


	end.