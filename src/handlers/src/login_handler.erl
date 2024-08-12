-module(login_handler).

-export([init/2]).

init(Req0, State) ->
    case cowboy_req:method(Req0) of
        <<"POST">> ->
            case cowboy_req:read_body(Req0) of
                {ok, Body, Req1} ->
                    case jsx:decode(Body) of
                        {error, _Reason} ->
                            {ok, handler_utils:reply(400, <<"Invalid JSON">>, Req1), State};
                        UserData ->
                            io:format("UserData ~n~p", [UserData]),
                            Email = proplists:get_value(<<"email">>, UserData, <<"unknown">>),
                            Password = proplists:get_value(<<"password">>, UserData, <<"unknown">>),

                            case db_users:get_user_by_mail_password(Email, Password) of
                                {ok, User} ->
                                    [Email, _, _, Role, _] = User,
                                    ExpirationTime = time_utils:create_expire_time(10),
                                    Token = token_utils:generate_unique_token(),

                                    wallet_session_db:insert_session(
                                        Email, Token, ExpirationTime, Role
                                    ),

                                    {atomic, {wallet_session, Email, Token, ExpirationTime, Role}} = wallet_session_db:get_wallet_session(
                                        Token
                                    ),
                                    io:format("Token ~n~p", [Token]),
                                    {ok, handler_utils:reply(200, Token, Req1), State};
                                {error, not_found} ->
                                    io:format("User not found~n"),
                                    {ok, handler_utils:reply(404, <<"User not found">>, Req1),
                                        State}
                            end
                    end;
                {_, Reason, _} ->
                    %% Handle error reading body
                    io:format("Error reading body: ~p~n", [Reason]),
                    {ok, handler_utils:reply(400, <<"Failed to read body">>, Req0), State}
            end;
        _ ->
            %% Handle unsupported HTTP methods
            {ok, handler_utils:reply_405(Req0), State}
    end.
