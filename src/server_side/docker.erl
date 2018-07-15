-module(docker).

-compile(export_all).

ps() ->
    exec:exec("docker ps").

build(Folder, Name) ->
    {ok, Cwd} = file:get_cwd(),
    file:set_cwd(Folder),
    exec:exec("docker build -t " ++ Name ++ " ."),
    file:set_cwd(Cwd).

run(Image, DockerCmd, MaxTime) ->
    Self = self(),
    F = fun() ->
		Cmd = "docker run --rm " ++ Image ++ " " ++ DockerCmd,
		case exec:exec(Cmd) of
		    {0, Res} ->
			Self ! {self(), Res};
		    Bad ->
			Self ! Bad
		end
	end,
    Pid = spawn_link(F),
    receive
	{Pid, Res} ->
	    Res;
	Other ->
	    io:fwrite("Unexpected ~p~n", [Other]),
	    Other
    after MaxTime ->
	    {error, max_time}
    end.
