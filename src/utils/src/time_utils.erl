-module(time_utils).

-export([create_expire_time/1, is_expired/1]).

% Function to create an expiration time from the current time
create_expire_time(DurationMinutes) ->
    % Get the current time
    Now = calendar:universal_time(),
    % Convert Duration from minutes to seconds
    DurationSeconds = DurationMinutes * 60,
    % Calculate the expiration time
    ExpirationTime = calendar:datetime_to_gregorian_seconds(Now) + DurationSeconds,
    % Convert back to a datetime
    calendar:gregorian_seconds_to_datetime(ExpirationTime).

% Function to check if the given expiration time has passed
is_expired(ExpirationTime) ->
    % Get the current time
    Now = calendar:universal_time(),
    % Convert current time to seconds
    NowSeconds = calendar:datetime_to_gregorian_seconds(Now),
    % Convert expiration time to seconds
    ExpirationSeconds = calendar:datetime_to_gregorian_seconds(ExpirationTime),
    % Check if the current time is greater than the expiration time
    NowSeconds > ExpirationSeconds.
