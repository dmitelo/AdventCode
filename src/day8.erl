%%%-------------------------------------------------------------------
%%% @author dylanmitelo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Dec 2020 9:43 AM
%%%-------------------------------------------------------------------
-module(day8).
-author("dylanmitelo").

%% API
-export([solve/0]).

solve() ->
	Filename = "../data/day8",
	{ok, Contents} = file:read_file(Filename),
	ParsedBinary = binary:split(Contents, [<<"\n">>], [global, trim_all]),
	ZippedList = lists:zip(lists:seq(1, length(ParsedBinary)), ParsedBinary),
	Map = maps:from_list(ZippedList),
	io:format("Parsed data: ~p~n", [ZippedList]),

	Ans = loop_actions(Map, 1, 0, maps:new(), {false, {undefined, 0, undefined}}),

	io:format("Ans: ~p~n", [Ans]).

loop_actions(ActionMap, N, Acc, _KeyMap, {_HasSwapped, {_Nth, _Acc0, _}}) when N =:= map_size(ActionMap) ->
	Acc;
loop_actions(ActionMap, N, Acc, KeyMap, {HasSwapped, {Nth, Acc0, KeyMap0}}) ->
	ActionVal = maps:get(N, ActionMap),
	[Action, Val] = binary:split(ActionVal, [<<" ">>], [global, trim_all]),
	io:format("map_size: ~p Action: ~p, N: ~p, Acc: ~p, Swapped: ~p, Nth: ~p Acc0: ~p~n", [map_size(ActionMap), ActionVal, N, Acc, HasSwapped, Nth, Acc0]),
	case maps:is_key(N, KeyMap) of
		true ->
%%			loop_actions(ActionMap, Nth, Acc0, KeyMap0, {false, {undefined, 0, KeyMap0}}),
			ActionVal0 = maps:get(Nth, ActionMap),
			[Action0, Val0] = binary:split(ActionVal0, [<<" ">>], [global, trim_all]),
			case Action0 of
				<<"nop">> ->
					loop_actions(ActionMap, Nth + 1, Acc0, maps:put(Nth, ActionVal0, KeyMap0), {false, {undefined, 0, undefined}});
				<<"acc">> ->
					loop_actions(ActionMap, Nth + 1, Acc0 + binary_to_integer(Val0), maps:put(Nth, ActionVal0, KeyMap0), {false, {undefined, 0, undefined}});
				<<"jmp">> ->
					loop_actions(ActionMap, Nth + binary_to_integer(Val0), Acc0, maps:put(Nth, ActionVal0, KeyMap0), {false, {undefined, 0, undefined}})
			end;
		false ->
			case HasSwapped of
				true ->
					case Action of
						<<"nop">> ->
							loop_actions(ActionMap, N + 1, Acc, maps:put(N, ActionVal, KeyMap), {HasSwapped, {Nth, Acc0, KeyMap0}});
						<<"acc">> ->
							loop_actions(ActionMap, N + 1, Acc + binary_to_integer(Val), maps:put(N, ActionVal, KeyMap), {HasSwapped, {Nth, Acc0, KeyMap0}});
						<<"jmp">> ->
							loop_actions(ActionMap, N + binary_to_integer(Val), Acc, maps:put(N, ActionVal, KeyMap), {HasSwapped, {Nth, Acc0, KeyMap0}})
					end;
				false ->
					case Action of
						<<"nop">> -> %% Treat as jmp, update N and keep Acc
							loop_actions(ActionMap, N + binary_to_integer(Val), Acc, maps:put(N, ActionVal, KeyMap), {true, {N, Acc, KeyMap}});
						<<"acc">> ->
							loop_actions(ActionMap, N + 1, Acc + binary_to_integer(Val), maps:put(N, ActionVal, KeyMap), {HasSwapped, {Nth, Acc0,KeyMap0}});
						<<"jmp">> -> %% treat as Nop update N and keep Acc
							loop_actions(ActionMap, N + 1, Acc, maps:put(N, ActionVal, KeyMap), {true, {N, Acc, KeyMap}})
					end
			end
	end.