-module(tools).

% -export([git_pull/0]).
-compile(export_all).

git_pull() ->
    {ok, Cwd} = file:get_cwd(),
    ProjectFolder = project_folder(),
    file:set_cwd(ProjectFolder),
    exec:exec("git fetch --all -p -t"),
    exec:exec("git pull"),
    file:set_cwd(Cwd).

release() ->
    {ok, Cwd} = file:get_cwd(),
    ProjectFolder = project_folder(),
    file:set_cwd(ProjectFolder),
    exec:exec("rebar3 release"),
    file:set_cwd(Cwd).

load_all() ->
    filelib:fold_files(project_folder(), ".*", true, load_file, []).

load_file(FileName, Acc) ->
    Module = lists:last(string:tokens(FileName, "/")),
    io:fwrite("~p~n", [Module]),
    Acc.

project_folder() ->
    {ok, Cwd} = file:get_cwd(),
    Parts = string:tokens(Cwd, "/"),
    "/" ++ lists:flatten(lists:join("/", dropLastN(Parts, 4))).

dropLastN(List, 0) ->
    List;

dropLastN(List, N) ->
    dropLastN(lists:droplast(List), N - 1).
