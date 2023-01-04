# Analyseur Pseudo-Pascal
## 1. Environment

`dune 3.6.1` 

`ocaml 4.14.1` (`ocamllex` & `ocamlyacc`)

`menhir 20220210` 

`odoc 2.1.1` 

## 2. Usage

```bash
dune exec pp option <file>
```

or

```bash
make option FILE=<file>
```

where option can be `lexer` , `token` , `parse` , `scope` 

## 3. Documentation

### 3.1 main file

```bash
dune build @doc
```

or

```bash
make doc
```

The doc file can be find in `./_build/default/_doc/_html/index.html`

### 3.2 libs

```bash
dune build @doc-private
```

or

```bash
make libdoc
```

if there is an error like

```
File "../../lib/.pp.objs/byte/pp.odoc":
Warning: Couldn't find the following modules:
  Stdlib
```

It is normal, don't worry

The doc file can be find in `./_build/default/_doc/_html/pp@*/Pp/index.html`
