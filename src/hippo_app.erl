-module(hippo_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
     %% {URIHost, list({URIPath, Handler, Opts})}
     {'_', [{'_', hippo_status_handler, []}]}
    ]),
    Name = hippo_http,
    NumAcceptors = 100,
    {Port, _} = string:to_integer(os:getenv("PORT")),
    TransportOptions = [{port, Port}],
    ProtocolOptions = [{env, [{dispatch, Dispatch}]}],
    cowboy:start_http(Name, NumAcceptors, TransportOptions, ProtocolOptions),

    %% TODO(jkakar) Why doesn't this work anymore?
    %% Token = stillir:get_config(hippo, hipchat_token),

    %% Token = os:getenv("HIPCHAT_TOKEN"),
    %% hippo_hipchat:send_message(Token, "Orchestration", "Hello from Erlang!"),

    hippo_sup:start_link().

stop(_State) ->
    ok.
