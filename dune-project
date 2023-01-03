(lang dune 3.6)

(name pp)

(generate_opam_files true)

(source
 (github JINZhao2000/analyseur-pseudo-pascal))

(authors "Zhao JIN")

(maintainers "Zhao JIN")

(license "Apache License 2.0")

; (documentation https://url/to/documentation)

(package
 (name pp)
 (synopsis "analyseur pseudo pascal")
 (description "Projet : Analyseur syntaxique et semantique pour Pseudo-Pascal")
 (depends ocaml dune ocamllex ocamlyacc menhir)
 (tags
  ("pascal" "analyser")))

(using menhir 2.1)

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
