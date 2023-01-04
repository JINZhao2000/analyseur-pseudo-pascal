.DEFAULT_GOAL=build

FILE =

build:
	@dune build

lexer: build
	@dune exec pp lexer $(FILE)

token: build
	@dune exec pp token $(FILE)

parse: build
	@dune exec pp parse $(FILE)

scope: build
	@dune exec pp scope $(FILE)

doc: 
	@dune build @doc

libdoc:
	@dune build @doc-private

clean:
	@dune clean
	@rm -f ./lib/parser.conflicts
	@rm -f ./lib/parser.output

conflict: build
	@menhir --explain --unused-tokens ./lib/parser.mly
	@ocamlyacc -v ./lib/parser.mly
	@rm -f ./lib/parser.mli
	@rm -f ./lib/parser.ml

