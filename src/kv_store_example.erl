-module(kv_store_example).
-behaviour(gen_server).
-include_lib("eunit/include/eunit.hrl").

-export([start_link/0]).

-export([
  init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3
]).

-export([
  store/2,
  retrieve/1,
  retrieve/0
]).

-define(SERVER, ?MODULE).

-record(state, {}).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, {}}.

handle_call({store, K, V}, _From, State) ->
  Status = erlang:put(K, V),
  {reply, Status, State};
handle_call({get, K}, _From, State) ->
  Status = erlang:get(K),
  {reply, Status, State};
handle_call({get}, _From, State) ->
  Status = erlang:get(),
  {reply, Status, State};
handle_call(_Request, _From, State) ->
  {reply, unhandled, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% API
store(K, V) ->
  gen_server:call(?SERVER, {store, K, V}).

retrieve(K) ->
  gen_server:call(?SERVER, {get, K}).

retrieve() ->
  gen_server:call(?SERVER, {get}).

%% Internal functions





%% Unit Tests

storing_test() ->
  {ok, _Pid} = ?MODULE:start_link(),
  ?assert(store(1, 1) == undefined),
  ?assert(retrieve(1) == 1),
  ok = gen_server:stop(?MODULE),
  ok.