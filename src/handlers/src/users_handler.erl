-module(users_handler).
-behaviour(cowboy_handler).

-export([init/2]).

% -include_lib("cowboy/include/cowboy.hrl").

init(Req0, State) ->
    case cowboy_req:method(Req0) of
        <<"GET">> ->
            case cowboy_req:read_body(Req0) of
                {more, Reason, _} ->
                    io:format("Error reading body: ~p~n", [Reason]),
                    {ok, handler_utils:reply(400, <<"Failed to read body">>, Req0), State};
                {ok, Body, Req1} ->
                    case jsx:decode(Body) of
                        {error, _Reason} ->
                            {ok, handler_utils:reply(400, <<"Invalid JSON">>, Req1), State};
                        UserData ->
                            io:format("Is expired: ~p~n", [UserData]),
                            Token = binary:bin_to_list(
                                proplists:get_value(<<"token">>, UserData, <<"unknown">>)
                            ),
                            {atomic, {wallet_session, _, Token, ExpirationTime, Role}} = wallet_session_db:get_wallet_session(
                                Token
                            ),
                            case binary_to_list(Role) of
                                "admin" ->
                                    EX = time_utils:is_expired(ExpirationTime),
                                    io:format("Is expired: ~p~n", [EX]),

                                    Users = db_users:get_all(),
                                    JUsers = handler_utils:encode_json(Users),
                                    {ok, handler_utils:reply(200, JUsers, Req0), State};
                                _ ->
                                    {ok,
                                        handler_utils:reply(
                                            400, <<"Not authorized">>, Req1
                                        ),
                                        State}
                            end
                    end
            end;
        <<"POST">> ->
            case cowboy_req:read_body(Req0) of
                {more, Reason, _} ->
                    io:format("Error reading body: ~p~n", [Reason]),
                    {ok, handler_utils:reply(400, <<"Failed to read body">>, Req0), State};
                {ok, Body, Req1} ->
                    case jsx:decode(Body) of
                        {error, _Reason} ->
                            {ok, handler_utils:reply(400, <<"Invalid JSON">>, Req1), State};
                        UserData ->
                            Email = proplists:get_value(<<"email">>, UserData, <<"unknown">>),
                            Password = proplists:get_value(<<"password">>, UserData, <<"unknown">>),

                            case db_users:get_user(Email) of
                                {ok, User} ->
                                    io:format("User found: ~p~n", [User]),
                                    {ok, handler_utils:reply(400, <<"Email existed">>, Req1),
                                        State};
                                {error, not_found} ->
                                    io:format("User not found~n"),
                                    db_users:add(Email, Password),
                                    {ok, handler_utils:reply(200, <<"User added">>, Req1), State}
                            end
                    end
            end;
        _ ->
            {ok, handler_utils:reply_405(Req0), State}
    end.
