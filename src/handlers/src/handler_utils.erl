-module(handler_utils).

-export([
    encode_json/1,
    reply_405/1,
    reply/3
]).

-define(CONTENT_JSON, #{<<"content-type">> => <<"application/json">>}).

encode_json(Data) ->
    %% Convert Data to JSON
    jsx:encode(Data).

reply_405(Req0) ->
    reply(405, <<"Method not allow">>, Req0).

reply(Code, Msg, Req) when is_list(Msg) ->
    reply(Code, list_to_binary(Msg), Req);
reply(Code, Msg, Req0) ->
    Req = cowboy_req:reply(Code, ?CONTENT_JSON, Msg, Req0),
    Req.
