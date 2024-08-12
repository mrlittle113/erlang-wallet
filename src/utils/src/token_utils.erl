-module(token_utils).

-export([generate_unique_token/0]).

gen_rnd(Length, AllowedChars) ->
    MaxLength = length(AllowedChars),
    lists:foldl(
        fun(_, Acc) -> [lists:nth(crypto:rand_uniform(1, MaxLength), AllowedChars)] ++ Acc end,
        [],
        lists:seq(1, Length)
    ).

generate_unique_token() ->
    gen_rnd(25, "abcdefghijklmnopqrstuvwxyz1234567890").
