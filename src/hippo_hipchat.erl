-module(hippo_hipchat).

-export([send_message/3]).

send_message(Token, Room, Message) ->
    URL = "https://api.hipchat.com/v2/room/" ++ Room ++ "/notification",
    Headers = [{"Authorization", "Bearer " ++ Token}],
    ContentType = "application/json",
    Body = "{\"color\": \"purple\", \"message\": \"" ++ Message ++ "\"}",
    httpc:request(post, {URL, Headers, ContentType, Body}, [], []).
