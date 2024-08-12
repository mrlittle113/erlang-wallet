-module(db_utils).

-export([query/1,
         insert/1,
         trans/1,
         timestamp/0]).

-include("../include/db.hrl").


query(Q) ->
    {ok, Pid} = mysql:start_link(?DB_OPTIONS),
    try
        {ok, _Cols, Rows} = mysql:query(Pid, Q),
        io:format("Perform query: ~p~nGot: ~p", [Q, Rows]),
        Rows
    after
        mysql:stop(Pid)
    end.

insert(Q) ->
    {ok, Pid} = mysql:start_link(?DB_OPTIONS),
    try
        Result = mysql:query(Pid, Q),
        io:format("Perform insert: ~p~nResult: ~p", [Q, Result])
    after
        mysql:stop(Pid)
    end.

-spec trans(fun((Trans :: pid()) -> term())) -> term().
trans(F) ->
    {ok, Pid} = mysql:start_link(?DB_OPTIONS),

    try
        Result = mysql:transaction(Pid, fun() -> F(Pid) end),
        io:format("Perform trans result: ~p", [Result]),
        Result
    after
        mysql:stop(Pid)
    end.

timestamp() ->
    {A,B,C} = erlang:timestamp(),
    Str = integer_to_list(A) ++ integer_to_list(B) ++ integer_to_list(C),
    list_to_integer(Str).