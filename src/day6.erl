%%%-------------------------------------------------------------------
%%% @author dylanmitelo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Dec 2020 2:51 PM
%%%-------------------------------------------------------------------
-module(day6).
-author("dylanmitelo").

%% API
-export([solve/0]).

solve() ->
	Filename = "../data/day6",
	{ok, Contents} = file:read_file(Filename),
	ParsedBinary = binary:split(Contents, [<<"\n\n">>], [global, trim_all]),

	io:format("Parsed data: ~p~n", [ParsedBinary]),

	Ans = fetch_answers(ParsedBinary, [], 0),

	io:format("Answers: ~p~n", [Ans]).

fetch_answers([], Answers, Compound) ->
	{Answers, Compound};
fetch_answers([H | T], Answers, Compound) ->
	Bin = [binary_to_list(X) || X <- binary:split(H, <<"\n">>, [global])],

	Unique = lists:foldl(fun(X, Acc) ->
		lists:filter(fun(Y) -> lists:member(Y, X) end, Acc)
						 end,
		hd(Bin), Bin),
	fetch_answers(T, [Unique | Answers], length(Unique) + Compound).
