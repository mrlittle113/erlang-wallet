%%%-------------------------------------------------------------------
%% @doc wallet public API
%% @end
%%%-------------------------------------------------------------------

-module(wallet_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    %% Start Cowboy and listen on port 8080
    _ = wallet_session_db:start(),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/api/login", login_handler, []},
            {"/api/users", users_handler, []}
        ]}
    ]),

    {ok, _} = cowboy:start_clear(http_listener, [{port, 8080}], #{env => #{dispatch => Dispatch}}),
    {ok, self()}.

stop(_State) ->
    ok.

%% internal functions
