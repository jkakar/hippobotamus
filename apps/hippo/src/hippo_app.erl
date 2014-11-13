%%%-------------------------------------------------------------------
%% @doc hippo public API
%% @end
%%%-------------------------------------------------------------------

-module(hippo_app).

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    lager:info("Hello, world!"),
    Dispatch = cowboy_router:compile([
      %% {URIHost, list({URIPath, Handler, Opts})}
      {'_', [{'_', hippo_status_handler, []}]}
    ]),
    Name = hippo_http,
    Acceptors = 100,
    {Port, _} = string:to_integer(os:getenv("PORT")),
    TransportOptions = [{port, Port}],
    ProtocolOptions = [{env, [{dispatch, Dispatch}]},
                       {onresponse, fun log_http_response/4}],
    cowboy:start_http(Name, Acceptors, TransportOptions, ProtocolOptions),

    %% Token = os:getenv("HIPCHAT_TOKEN"),
    %% hippo_hipchat:send_message(Token, "Orchestration", "Hello from Erlang!"),

    hippo_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

log_http_response(Code, _Headers, _Response, Request) ->
    Method = to_string(extract(cowboy_req:method(Request))),
    Host = to_string(extract(cowboy_req:host(Request))),
    Port = port_to_string(extract(cowboy_req:port(Request))),
    Path = to_string(extract(cowboy_req:path(Request))),
    lager:info("method=~s path=~s~s~s status_code=~p",
               [Method, Host, Port, Path, Code]),
    Request.

extract({Value, _Request}) ->
    Value.

port_to_string(Port) -> case to_string(Port) of
                            "80" -> "";
                            OtherPort -> ":" ++ OtherPort
                        end.

to_string(undefined) ->
    "";
to_string(Atom) when is_atom(Atom) ->
    atom_to_list(Atom);
to_string(Binary) when is_binary(Binary) ->
    binary_to_list(Binary);
to_string(Integer) when is_integer(Integer) ->
    integer_to_list(Integer);
to_string([]) ->
    "";
to_string(List) when is_list(List) ->
    to_string(List, "").

to_string(List, Separator) when is_list(List) ->
    string:join(list_to_string(List, []), Separator).

list_to_string([], Result) ->
    lists:reverse(Result);
list_to_string([Head|Rest], Result) ->
    list_to_string(Rest, [to_string(Head)|Result]).
