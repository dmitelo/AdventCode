%%%-------------------------------------------------------------------
%%% @author dylanmitelo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Dec 2020 10:50 AM
%%%-------------------------------------------------------------------
-module(day4).
-author("dylanmitelo").

%%-record(passport, {
%%	byr,
%%	iyr,
%%	eyr,
%%	hgt,
%%	hcl,
%%	ecl,
%%	pid,
%%	cid
%%}).

%% API
-export([solve/0]).

solve() ->
	Filename = "../data/day4",
	{ok, Contents} = file:read_file(Filename),
	ParsedBinary = binary:split(Contents, [<<"\n\n">>], [global, trim_all]),

	MapList =
		[
			maps:from_list([
				list_to_tuple(binary:split(Y, [<<":">>], [global, trim_all])) ||
				Y <- binary:split(X, [<<"\n">>, <<" ">>], [global, trim_all])
			]) || X <- ParsedBinary],

%%	io:format("Input data as int list: ~p~n", [MapList]),

	Ans = validate_passports(MapList, 0),
	io:format("Ans: ~p~n", [Ans]),

	ok.

validate_passports([], CurrentCount) ->
	CurrentCount;
validate_passports([H | T], CurrentCount) when map_size(H) < 7 orelse map_size(H) > 8 ->
	validate_passports(T, CurrentCount);
validate_passports([H | T], CurrentCount) when map_size(H) =:= 8 ->
	io:format("checking fields~n"),
	case validate_fields(H) of
		false ->
			validate_passports(T, CurrentCount);
		_ ->
			validate_passports(T, CurrentCount + 1)
	end;
validate_passports([H | T], CurrentCount) ->
	case maps:is_key(<<"cid">>, H) of
		true ->
			validate_passports(T, CurrentCount);
		false ->
			io:format("checking fields2~n"),
			case validate_fields(H) of
				false ->
					validate_passports(T, CurrentCount);
				_ ->
					validate_passports(T, CurrentCount + 1)
			end
	end.


validate_fields(#{<<"byr">> := Birth} = Map0) when size(Birth) =:= 4 andalso (<<"1920">> =< Birth andalso Birth =< <<"2002">>) ->
	io:format("Validate check 1: ~p~n", [Birth]),
	{_Val, Map} = maps:take(<<"byr">>, Map0),
	validate_fields(Map);
validate_fields(#{<<"byr">> := _}) ->
	false;
validate_fields(#{<<"iyr">> := Issue} = Map0) when size(Issue) =:= 4 andalso (<<"2010">> =< Issue andalso Issue =< <<"2020">>) ->
	io:format("Validate check 2: ~p~n", [Issue]),

	{_Val, Map} = maps:take(<<"iyr">>, Map0),
	validate_fields(Map);
validate_fields(#{<<"iyr">> := _Issue}) ->
	false;
validate_fields(#{<<"eyr">> := Exp} = Map0) when size(Exp) =:= 4 andalso (<<"2020">> =< Exp andalso Exp =< <<"2030">>)->
	io:format("Validate check 3: ~p~n", [Exp]),

	{_Val, Map} = maps:take(<<"eyr">>, Map0),
	validate_fields(Map);
validate_fields(#{<<"eyr">> := _Exp}) ->
	false;
validate_fields(#{<<"hgt">> := Height} = Map0) when size(Height) >= 2 ->
	io:format("Validate check 4: ~p~n", [Height]),

	L = size(Height) - 2,
	<<Size:L/binary, Units/binary>> = Height,
	case Units of
		<<"cm">> ->
			Check = (<<"150">> =< Size andalso Size =< <<"193">>),
			case Check of
				true ->
					{_, Map} = maps:take(<<"hgt">>, Map0),
					validate_fields(Map);
				false ->
					false
			end;
		<<"in">> ->
			Check = (<<"59">> =< Size andalso Size =< <<"76">>),
			case Check of
				true ->
					{_, Map} = maps:take(<<"hgt">>, Map0),
					validate_fields(Map);
				false ->
					false
			end;
		_ ->
			false
	end;
validate_fields(#{<<"hgt">> := _Height} = _Map0) ->
	false;
validate_fields(#{<<"hcl">> := <<"#", Colour/binary>>} = Map0) when size(Colour) =:= 6 ->
	io:format("Validate check 5: ~p~n", [Colour]),

	Checks = ["a", "b", "c", "d", "e", "f", "A", "B", "C", "D", "E", "F", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
	case lists:all(fun(X) -> lists:member([X], Checks) end, binary_to_list(Colour)) of %% TODO regex
		false ->
			false;
		_ ->
			{_, Map} = maps:take(<<"hcl">>, Map0),
			validate_fields(Map)
	end;
validate_fields(#{<<"hcl">> := _Exp} = _Map0) ->
	false;
validate_fields(#{<<"ecl">> := Colour} = Map0) ->
	io:format("Validate check 6: ~p~n", [Colour]),

	case Colour of
		<<"amb">> ->
			{_, Map} = maps:take(<<"ecl">>, Map0),
			validate_fields(Map);
		<<"blu">> ->
			{_, Map} = maps:take(<<"ecl">>, Map0),
			validate_fields(Map);
		<<"brn">> ->
			{_, Map} = maps:take(<<"ecl">>, Map0),
			validate_fields(Map);
		<<"gry">> ->
			{_, Map} = maps:take(<<"ecl">>, Map0),
			validate_fields(Map);
		<<"grn">> ->
			{_, Map} = maps:take(<<"ecl">>, Map0),
			validate_fields(Map);
		<<"hzl">> ->
			{_, Map} = maps:take(<<"ecl">>, Map0),
			validate_fields(Map);
		<<"oth">> ->
			{_, Map} = maps:take(<<"ecl">>, Map0),
			validate_fields(Map);
		_ ->
			false
	end;
validate_fields(#{<<"pid">> := Pid} = Map0) when size(Pid) =:= 9 ->
	io:format("Last validate check: ~p~n", [Pid]),
	Checks = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
	case lists:all(fun(X) -> lists:member([X], Checks) end, binary_to_list(Pid)) of
		false ->
			false;
		_ ->
			{_, Map} = maps:take(<<"pid">>, Map0),
			validate_fields(Map)
	end;
validate_fields(#{<<"pid">> := _Pid} = _Map0) ->
	io:format("validate check 7 failed~n"),
	false;
validate_fields(#{<<"cid">> := _Cid} = Map0) ->
	io:format("Cid check~n"),
	{_, Map} = maps:take(<<"cid">>, Map0),
	validate_fields(Map);
validate_fields(#{} = Map0) ->
	io:format("check for empty map: ~p~n", [Map0]),
	case maps:size(Map0) of
		0 ->
			true;
		_ ->
			false
	end.
