-module(hippo_hipchat).

-export([send_message/2]).

send_message(Token, Message) ->
    URL = "https://api.hipchat.com/v2/room/Orchestration/notification",
    Headers = [{"Authorization", "Bearer " ++ Token}],
    ContentType = "application/json",
    Body = "{\"color\": \"purple\", \"message\": \"" ++ Message ++ "\"}",
    httpc:request(post, {URL, Headers, ContentType, Body}, [], []).
