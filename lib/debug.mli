open Ast

(** 
    print the correspond code
    @param lexbuf a lexing buffer created by lexer
    *)
val print_c : Lexing.lexbuf -> unit

(** 
    print the correspond token
    @param lexbuf a lexing buffer created by lexer
    *)
val print_t : Lexing.lexbuf -> unit

(** 
    print parsed program
    @param prog a program type
    @return a program code parsed by parser
    *)
val str_program : program -> string