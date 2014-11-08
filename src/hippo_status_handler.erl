-module(hippo_status_handler).
-behavior(cowboy_http_handler).

-export([init/3
        ,handle/2
        ,terminate/3
        ]).

init(_Type, Request, _Opts) ->
    {ok, Request, undefined_state}.

handle(Request, State) ->
    {Method, Request2} = cowboy_req:method(Request),
    handle(Method, Request2, State).

terminate(_Reason, _Request, _State) ->
    ok.

%% Internal functions

handle(<<"GET">>, Request, State) ->
    Headers = [{<<"content-type">>, <<"text/plain">>}],
    Body = <<"OK\n">>,
    {ok, Request2} = cowboy_req:reply(200, Headers, Body, Request),
    {ok, Request2, State};
handle(_, Request, State) ->
    {ok, Request2} = cowboy_req:reply(404, Request),
    {ok, Request2, State}.
