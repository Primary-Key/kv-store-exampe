%%%-------------------------------------------------------------------
%% @doc kv_store_example public API
%% @end
%%%-------------------------------------------------------------------

-module(kv_store_example_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  kv_store_example_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
