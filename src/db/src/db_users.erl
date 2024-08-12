-module(db_users).

-export([
    get_all/0,
    get_user/1,
    get_user_by_mail_password/2,
    add/2
]).

-define(QUERY_ALL_USER, "SELECT * FROM users").

get_all() ->
    db_utils:query(?QUERY_ALL_USER).

get_user(Email) ->
    Q = io_lib:format("SELECT * FROM users WHERE email = '~s'", [
        binary_to_list(Email)
    ]),
    Result = db_utils:query(Q),

    case Result of
        [] ->
            io:format("No user found for email: ~p~n", [Email]),
            {error, not_found};
        [User] ->
            Username = proplists:get_value(<<"username">>, User),
            io:format("User found: ~p~nUsername: ~p~n", [User, Username]),
            {ok, User}
    end.

get_user_by_mail_password(Email, Password) ->
    Q = io_lib:format("SELECT * FROM users WHERE email = '~s' and password = '~s'", [
        binary_to_list(Email), binary_to_list(Password)
    ]),
    Result = db_utils:query(Q),

    case Result of
        [] ->
            io:format("No user found for email: ~p~n", [Email]),
            {error, not_found};
        [User] ->
            Username = proplists:get_value(<<"username">>, User),
            io:format("User found: ~p~nUsername: ~p~n", [User, Username]),
            {ok, User}
    end.

add(Email, Password) ->
    Q = io_lib:format("INSERT INTO users (email, password) VALUES ('~s', '~s')", [
        binary_to_list(Email), binary_to_list(Password)
    ]),
    db_utils:insert(Q).
