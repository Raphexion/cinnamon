-module(client_side_secretes).

-export([copy_ssh/0,
	 copy_ssh/1]).

copy_ssh() ->
    Home = os:getenv("HOME"),
    copy_ssh(Home ++ "/.ssh/id_rsa.pub").

copy_ssh(FileName) ->
    {ok, Data} = file:read_file(FileName),
    {append, [home, ".ssh", "authorized_keys"], Data}.
