-module(main_router).

-export([handle/1]).

handle({append, Filename_, Data}) ->
    Filename = join(Filename_),
    filelib:ensure_dir(Filename),
    file:write_file(Filename, Data, [append]).

join(List) ->
    join(List, "").

join([], Acc) ->
    Acc;

join([home | Tail], _Acc) ->
    Home = os:getenv("HOME"),
    join(Tail, Home);

join([root | Tail], _Acc) ->
    join(Tail, "/");

join([Head | Tail], "/") ->
    join(Tail, "/" ++ Head);

join([Head | Tail], Acc) ->
    join(Tail, Acc ++ "/" ++ Head).
