%% Copyright (c) 2018 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(emqx_plugin_wm_status).

-include_lib("emqx/include/emqx.hrl").

-export([load/1, unload/0]).

%% Hooks functions
-export([on_client_connected/4
        , on_client_disconnected/3
        ]).

%% Called when the plugin application start
load(Env) ->
    emqx:hook('client.connected', fun ?MODULE:on_client_connected/4, [Env]),
    emqx:hook('client.disconnected', fun ?MODULE:on_client_disconnected/3, [Env]).
   

on_client_connected(#{client_id := ClientId}, ConnAck, ConnAttrs, _Env) ->
    {ok, Rdscon} = eredis:start_link(), 
    eredis:q(Rdscon, ["SET", string:concat("mqtt:status:",ClientId), "1"]).

on_client_disconnected(#{client_id := ClientId}, ReasonCode, _Env) ->
    {ok, Rdsdis} = eredis:start_link(), 
    eredis:q(Rdsdis, ["SET", string:concat("mqtt:status:",ClientId), "0"]).


%% Called when the plugin application stop
unload() ->
    emqx:unhook('client.connected', fun ?MODULE:on_client_connected/4),
    emqx:unhook('client.disconnected', fun ?MODULE:on_client_disconnected/3).


