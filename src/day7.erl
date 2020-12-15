%%%-------------------------------------------------------------------
%%% @author dylanmitelo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Dec 2020 3:53 PM
%%%-------------------------------------------------------------------
-module(day7).
-author("dylanmitelo").

%% API
-export([solve/0]).

solve() ->
	Filename = "../data/day7",
	{ok, Contents} = file:read_file(Filename),
	ParsedBinary = binary:split(Contents, [<<"\n">>], [global, trim_all]),

	io:format("Input data as int list: ~p~n", [ParsedBinary]),

	MapList =
		[
			list_to_tuple([
				begin
					New = binary:replace(Y, [<<" bags">>, <<".">>], <<"">>, [global]),
					case binary:split(New, [<<", ">>], [global, trim_all]) of
						[H] ->
							H;
						T ->
							[Z || <<_:2/binary, Z/binary>> <- T]
					end
				end	||
				Y <- binary:split(X, [<<" contain ">>], [global, trim_all])
			]) || X <- ParsedBinary],

	io:format("MapList: ~p~n", [MapList]),

	Ans0 = find_bag(MapList, maps:new()),
	Ans1 = find_bag1(MapList, Ans0, 0),
	io:format("Answer: ~p~n", [Ans0]),
	io:format("Answer: ~p~n", [Ans1]),
	ok.

find_bag([], Map) ->
	Map;
find_bag([H | T], GoldMap) ->
	{Key, Val} = H,
	case Val of
		X when is_list(X) ->
			case lists:member(<<"shiny gold">>, Val) of
				true ->
					NewMap = maps:put(Key, Val, GoldMap),
					find_bag(T, NewMap);
				false ->
					find_bag(T, GoldMap)
			end;
		_ ->
			case binary:match(Val, <<"shiny gold">>) of
				nomatch ->
					find_bag(T, GoldMap);
				_ ->
					NewMap = maps:put(Key, Val, GoldMap),
					find_bag(T, NewMap)
			end
	end.

find_bag1([], _Map, Points) ->
	Points;
find_bag1([H | T], GoldMap, Points) ->
	{_Key, Val} = H,
	case Val of
		X when is_list(X) ->
			List = [Y || Y <- X, (maps:is_key(Y, GoldMap) orelse <<"shiny gold">> =:= Y)],
			io:format("List:~p~n", [List]),
			case List of
				[] ->
					find_bag1(T, GoldMap, Points);
				_ ->
					find_bag1(T, GoldMap, Points + 1)
			end;
		_ ->
			case binary:match(Val, <<"shiny gold">>) of
				nomatch ->
					<<_:2/binary, NewVal/binary>> = Val,
					case maps:is_key(NewVal, GoldMap) of
						true ->
							io:format("VAl in map: ~p~n", [Val]),
							find_bag1(T, GoldMap, Points + 1);
						false ->
							find_bag1(T, GoldMap, Points)
					end;
				_ ->
					io:format("Direct Gold: ~p~n", [Val]),
					find_bag1(T, GoldMap, Points + 1)
			end
	end.