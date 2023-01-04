open Pp

(**
  @author Zhao JIN
  @version 1.0
  @since 1.0
  @description
  entry of program
  <usage> : dune exec pp option <file>
  <usage> : make option FILE=<file>
  option:
    lexer
    token
    parse
    scope *)
let _ = 
  if (Array.length Sys.argv < 3) then
    Printf.fprintf stdout "%s" "<usage> : dune exec pp option <file>\n<usage> : make option FILE=<file>\noption:\n lexer\n token\n parse\n scope\n"
  else
    Printf.fprintf stdout "\n";
    if ("lexer" = Sys.argv.(1)) then
      for i = 2 to Array.length Sys.argv - 1 do
        let f = open_in Sys.argv.(i) in
        try
          let lexbuf= Lexing.from_channel f in
          Debug.print_c lexbuf;
        with
          | End_of_file -> close_in f; exit 0
      done
    else if ("token" = Sys.argv.(1)) then
      for i = 2 to Array.length Sys.argv - 1 do
        let f = open_in Sys.argv.(i) in
        try
          let lexbuf= Lexing.from_channel f in
          Debug.print_t lexbuf;
        with
          | End_of_file -> close_in f; exit 0
      done
    else if ("parse" = Sys.argv.(1)) then
      for i = 2 to Array.length Sys.argv - 1 do
        let f = open_in Sys.argv.(i) in
        try
          let lexbuf= Lexing.from_channel f in
          let _ = Parsing.set_trace true in
          let p = Parser.program Lexer.token lexbuf in
          Printf.fprintf stdout "%s\n" (Debug.str_program p)
        with
          | Parsing.Parse_error -> Printf.fprintf stdout "Parse error\n"; close_in f; exit 1
      done
    else if ("scope" = Sys.argv.(1)) then
      for i = 2 to Array.length Sys.argv - 1 do
        let f = open_in Sys.argv.(i) in
        try
          let lexbuf= Lexing.from_channel f in
          let _ = Parsing.set_trace true in
          let p = Parser.program Lexer.token lexbuf in
          Printf.fprintf stdout "%s\n" @@ string_of_bool (Check.check_scope p)
        with
          | Parsing.Parse_error -> Printf.fprintf stdout "Parse error\n"; close_in f; exit 1
      done
    else
      Printf.fprintf stdout "%s" "<usage> : dune exec pp option <file>\n<usage> : make option FILE=<file>\n option:\n lexer\n token\n parse\n scope\n";
      exit 0