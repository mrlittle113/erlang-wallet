-module(time_utils_SUITE).
-compile(export_all).

%% Common Test callbacks
init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.

init_per_testcase(_, Config) -> Config.
end_per_testcase(_TestCase, _Config) -> ok.

all() -> [is_expired_test].

is_expired_test(_Config) ->
    PastExpirationTime = time_utils:create_expire_time(-1),
    true = time_utils:is_expired(PastExpirationTime),

    FutureExpirationTime = time_utils:create_expire_time(1),
    false = time_utils:is_expired(FutureExpirationTime),
    timer:sleep(61000),
    true = time_utils:is_expired(FutureExpirationTime).
