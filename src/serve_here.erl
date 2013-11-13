-module(serve_here).

-export([main/1]).

main(_Args) ->
	% Start up the require applications
	application:start(crypto),
	application:start(ranch),
	application:start(cowlib),
	application:start(cowboy),

	% Start up a static file web server
	Port = 8080,
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/[...]", cowboy_static, {dir, ".",
				[{etag, false}, {mimetypes, cow_mimetypes, all}]}}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, [{port, Port}], [
		{env, [{dispatch, Dispatch}]}
	]),
	io:format("Webserver started on :~p~n", [Port]),
	timer:sleep(infinity).
