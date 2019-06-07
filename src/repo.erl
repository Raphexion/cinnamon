-module(repo).
-behaviour(gen_server).
-include_lib("eunit/include/eunit.hrl").

%% API
-export([start_link/0]).
-export([github/3]).

%% Behaviour Callbacks

-export([init/1,
	 handle_call/3,
	 handle_cast/2,
	 handle_info/2,
	 terminate/2,
	 code_change/3]).

%%------------------------------------------------------------------------------
%% API
%%------------------------------------------------------------------------------

start_link() ->
    gen_server:start_link(?MODULE, [], []).

github(Repo, User, Project) ->
    gen_server:call(Repo, {github, User, Project}).

%%-----------------------------------------------------------------------------
%% Behaviour callbacks
%%------------------------------------------------------------------------------

-record(repo, {url :: string}).

%% @hidden
init(_) ->
    {ok, #repo{}}.

%% @hidden
handle_call({github, User, Project}, _From, State) ->
    priv_github(User, Project, State).

%% @hidden
handle_cast(_What, State) ->
    {noreply, State}.

%% @hidden
handle_info(_What, State) ->
    {noreply, State}.

%% @hidden
terminate(_Reason, _State) ->
    ok.

%% @hidden
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%------------------------------------------------------------------------------
%% Private
%%------------------------------------------------------------------------------

priv_github(User, Project, State) ->
    Url = github_url(User, Project),
    {reply, {ok, Url}, State#repo{url=Url}}.

github_url(User, Project) ->
    "git@github.com:" ++ User ++ "/" ++ Project ++ ".git".

%%------------------------------------------------------------------------------
%% Tests
%%------------------------------------------------------------------------------

minimal_github_url_test() ->
    Correct = "git@github.com:Raphexion/cinnamon.git",
    Answer = github_url("Raphexion", "cinnamon"),
    ?assert(Answer =:= Correct).

minimal_repo_test() ->
    Correct = "git@github.com:Raphexion/cinnamon.git",
    {ok, Repo} = start_link(),
    {ok, Url} = github(Repo, "Raphexion", "cinnamon"),
    ?assert(Url =:= Correct).
