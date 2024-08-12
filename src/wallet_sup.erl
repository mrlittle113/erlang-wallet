%%%-------------------------------------------------------------------
%% @doc wallet top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(wallet_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Dispatch = cowboy_router:compile([
        {'_', [{"/api/users", users_handler, []}]},
        {'_', [{"/api/login", login_handler, []}]}
    ]),
    {ok, _} = cowboy:start_clear(http_listener, [{port, 8080}], #{env => #{dispatch => Dispatch}}),

    {ok, {{one_for_one, 10, 10}, []}}.
