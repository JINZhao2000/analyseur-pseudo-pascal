.DEFAULT_GOAL=build

build:
	@dune build

lexer: build
	@dune exec pp print ./OK/*
	@dune exec pp print ./KO/*

token: build
	@dune exec pp token ./OK/*
	@dune exec pp token ./KO/*

parse: build
	@dune exec pp parse ./OK/*
	@dune exec pp parse ./KO/*

scope: build
	@dune exec pp scope ./OK/*
	@dune exec pp scope ./KO/*

clean:
	@dune clean
	@rm -f ./lib/parser.conflicts
	@rm -f ./lib/parser.output

conflict: build
	@menhir --explain --unused-tokens ./lib/parser.mly
	@ocamlyacc -v ./lib/parser.mly
	@rm -f ./lib/parser.mli
	@rm -f ./lib/parser.ml

sucnum:	build
	@dune exec pp parse ./OK/* 2>/dev/null | grep Parse | wc -l

