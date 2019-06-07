-module(repo_sup).
-behaviour(supervisor).

%% API
-export([start_link/0,
	 add_repo/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

add_repo() ->
    supervisor:start_child(?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

init([]) ->
    SupFlags = #{strategy => simple_one_for_one,
                 intensity => 1,
                 period => 1},

    Repo = #{id => repo,
	     start => {repo, start_link, []},
	     restart => transient},

    Children = [Repo],

    {ok, {SupFlags, Children}}.

%%====================================================================
%% Internal functions
%%====================================================================
