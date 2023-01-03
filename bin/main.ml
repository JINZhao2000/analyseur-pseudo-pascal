open Pp

let _ = 
  if (Array.length Sys.argv < 3) then
    Printf.fprintf stdout "%s\n" "<usage> : dune exec pp print <file>"
  else
    Printf.fprintf stdout "\n";
    if ("print" = Sys.argv.(1)) then
      for i = 2 to Array.length Sys.argv - 1 do
        let f = open_in Sys.argv.(i) in
        try
          let lexbuf= Lexing.from_channel f in
          Debug.print_c lexbuf;
        with
          | End_of_file -> close_in f
      done
    else if ("token" = Sys.argv.(1)) then
      for i = 2 to Array.length Sys.argv - 1 do
        let f = open_in Sys.argv.(i) in
        try
          let lexbuf= Lexing.from_channel f in
          Debug.print_t lexbuf;
        with
          | End_of_file -> close_in f
      done
    else if ("parse" = Sys.argv.(1)) then
      for i = 2 to Array.length Sys.argv - 1 do
        let f = open_in Sys.argv.(i) in
        try
          let lexbuf= Lexing.from_channel f in
          let _ = Parser.program Lexer.token lexbuf in ()
        with
          | Parsing.Parse_error -> Printf.fprintf stderr "Parse error\n"; close_in f
      done
    else
      exit 0