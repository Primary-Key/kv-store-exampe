-module(kv_store_example).
-behaviour(gen_server).

-export([start_link/0]).

-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-export([store/0]).

-define(SERVER, ?MODULE).

-record(state, {kv_map = #{}}).

start_link() ->
  io:format("~p~n", [get()]),
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  print(get(default_color), "!> KV Store initialized.~n", []),
  {ok, #state{kv_map = #{}}}.

handle_call(store, _From, State) ->
  print(get(default_color), "!> Storing key value.~n", []),
  {reply, ok, State};
handle_call(_Request, _From, State) ->
  {reply, ignored, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  print(get(default_color), "!> KV Store released.~n", []),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% API

store() ->
  gen_server:call(?SERVER, store).

%% Internal functions

color(no_color) -> "\033[0m";
color(undefined) -> "\033[0m";
color(red) -> "\033[0;31m";
color(black) -> "\033[0;30m".

print(Color, String, Vals) ->
  Joined = color(Color) ++ String ++ color(no_color),
  io:format(Joined, Vals).