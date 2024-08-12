-module(wallet_session_db).

-export([
    start/0, create_table/0, insert_session/4, get_wallet_session/1
]).

% Start Mnesia and create the table if it doesn't exist
start() ->
    %% Check if Mnesia is already started
    application:start(mnesia),
    RE = create_table(),
    io:format("~p~n", [RE]).

-record(wallet_session, {
    email,
    token,
    expiration,
    role
}).

create_table() ->
    TableDef = [
        {attributes, record_info(fields, wallet_session)},
        {type, set},
        {index, [token]}
    ],
    case mnesia:create_table(wallet_session, TableDef) of
        {atomic, ok} -> io:format("Table created successfully~n");
        {aborted, Reason} -> io:format("Table creation failed: ~p~n", [Reason])
    end.

insert_session(Email, Token, Expiration, Role) ->
    mnesia:transaction(fun() ->
        % Define the record
        Record = #wallet_session{
            email = Email,
            token = Token,
            expiration = Expiration,
            role = Role
        },
        mnesia:write(Record)
    end).

get_wallet_session(Token) ->
    mnesia:transaction(fun() ->
        case mnesia:index_read(wallet_session, Token, token) of
            [] -> {error, not_found};
            [#wallet_session{} = Session] -> Session
        end
    end).
