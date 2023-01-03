.DEFAULT_GOAL=build

build:
	@dune build

checkyacc:
	menhir --explain --unused-tokens lib/parser.mly

lexer:
	@dune exec pp print ./OK/*
	@dune exec pp print ./KO/*

token:
	@dune exec pp token ./OK/*
	@dune exec pp token ./KO/*

parse:
	@dune exec pp parse ./OK/*
	@dune exec pp parse ./KO/*

clean:
	@dune clean

conflict: build
	@menhir --explain --unused-tokens ./lib/parser.mly
	@ocamlyacc -v ./lib/parser.mly
	@rm -f ./lib/parser.mli
	@rm -f ./lib/parser.ml

