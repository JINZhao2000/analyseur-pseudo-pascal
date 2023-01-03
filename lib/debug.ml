open Ast

let print_code flu = 
  match flu with 
  | Parser.PROG -> Printf.fprintf stdout "%s" "\nprogram\n"
  | Parser.BEGIN -> Printf.fprintf stdout "%s" "begin\n"
  | Parser.END -> Printf.fprintf stdout "%s" "\nend"
  | Parser.FUNC -> Printf.fprintf stdout "%s" "function "
  | Parser.PROC -> Printf.fprintf stdout "%s" "procedure "
  | Parser.VAR -> Printf.fprintf stdout "%s " "var"

  | Parser.INTT -> Printf.fprintf stdout "%s" " integer "
  | Parser.BOOLT -> Printf.fprintf stdout "%s" " boolean "
  | Parser.ARR -> Printf.fprintf stdout "%s" " array of "
  | Parser.NEW -> Printf.fprintf stdout "%s" " new "

  | Parser.LPAR -> Printf.fprintf stdout "%s" "("
  | Parser.RPAR -> Printf.fprintf stdout "%s" ")"
  | Parser.SEP -> Printf.fprintf stdout "%s" ";"
  | Parser.SEPL -> Printf.fprintf stdout "%s" ";\n"
  | Parser.COLON -> Printf.fprintf stdout "%s" ":"
  | Parser.COMA -> Printf.fprintf stdout "%s " ","
  | Parser.LCOCH -> Printf.fprintf stdout "%s" "["
  | Parser.RCOCH -> Printf.fprintf stdout "%s" "]"
  | Parser.DOT -> Printf.fprintf stdout "%s" ".\n"
  | Parser.EOF -> Printf.fprintf stdout "%s" "=== LEXER OK ===\n";raise End_of_file

  | Parser.REPT -> Printf.fprintf stdout "%s" "repeat\n"
  | Parser.UNTIL -> Printf.fprintf stdout "%s" "until\n"
  | Parser.IF -> Printf.fprintf stdout "%s" "if "
  | Parser.THEN -> Printf.fprintf stdout "%s" " then\n"
  | Parser.ELSE -> Printf.fprintf stdout "%s" " else\n"
  | Parser.WHILE -> Printf.fprintf stdout "%s" "while "
  | Parser.DO -> Printf.fprintf stdout "%s" "do\n"

  | Parser.EQ -> Printf.fprintf stdout "%s" "="
  | Parser.NE -> Printf.fprintf stdout "%s" " <> "
  | Parser.GE -> Printf.fprintf stdout "%s" " >= "
  | Parser.LE -> Printf.fprintf stdout "%s" " <= "
  | Parser.GT -> Printf.fprintf stdout "%s" " > "
  | Parser.LT -> Printf.fprintf stdout "%s" " < "
  | Parser.AND -> Printf.fprintf stdout "%s" " and "
  | Parser.OR -> Printf.fprintf stdout "%s" " or "
  | Parser.NOT -> Printf.fprintf stdout "%s" " not "
  | Parser.PLUS -> Printf.fprintf stdout "%s" " + "
  | Parser.MINUS -> Printf.fprintf stdout "%s" " - "
  | Parser.TIMES -> Printf.fprintf stdout "%s" " * "
  | Parser.DIV -> Printf.fprintf stdout "%s" " / "
  | Parser.NEG -> Printf.fprintf stdout "%s" " -"

  | Parser.ID s -> Printf.fprintf stdout " %s " s  
  | Parser.BOOL b -> Printf.fprintf stdout " %s " (string_of_bool b)
  | Parser.INT i -> Printf.fprintf stdout " %d " i

let print_token flu = 
  match flu with 
  | Parser.PROG -> Printf.fprintf stdout "%s" "PROG "
  | Parser.BEGIN -> Printf.fprintf stdout "%s" "BEGIN "
  | Parser.END -> Printf.fprintf stdout "%s" "END "
  | Parser.FUNC -> Printf.fprintf stdout "%s" "FUNC "
  | Parser.PROC -> Printf.fprintf stdout "%s" "PROC "
  | Parser.VAR -> Printf.fprintf stdout "%s " "VAR "

  | Parser.INTT -> Printf.fprintf stdout "%s" "INTT "
  | Parser.BOOLT -> Printf.fprintf stdout "%s" "BOOLT "
  | Parser.ARR -> Printf.fprintf stdout "%s" "ARR"
  | Parser.NEW -> Printf.fprintf stdout "%s" "NEW "

  | Parser.LPAR -> Printf.fprintf stdout "%s" "LPAR "
  | Parser.RPAR -> Printf.fprintf stdout "%s" "RPAR "
  | Parser.SEP -> Printf.fprintf stdout "%s" "SEP"
  | Parser.SEPL -> Printf.fprintf stdout "%s" "SEPL\n"
  | Parser.COLON -> Printf.fprintf stdout "%s" "COLON "
  | Parser.COMA -> Printf.fprintf stdout "%s " "COMA "
  | Parser.LCOCH -> Printf.fprintf stdout "%s" "LCOCH "
  | Parser.RCOCH -> Printf.fprintf stdout "%s" "RCOCH "
  | Parser.DOT -> Printf.fprintf stdout "%s" "DOT\n"
  | Parser.EOF -> raise End_of_file

  | Parser.REPT -> Printf.fprintf stdout "%s" "REPT "
  | Parser.UNTIL -> Printf.fprintf stdout "%s" "UNTIL "
  | Parser.IF -> Printf.fprintf stdout "%s" "IF "
  | Parser.THEN -> Printf.fprintf stdout "%s" "THEN "
  | Parser.ELSE -> Printf.fprintf stdout "%s" "ELSE "
  | Parser.WHILE -> Printf.fprintf stdout "%s" "WHILE "
  | Parser.DO -> Printf.fprintf stdout "%s" "DO "

  | Parser.EQ -> Printf.fprintf stdout "%s" "EQ "
  | Parser.NE -> Printf.fprintf stdout "%s" "NE "
  | Parser.GE -> Printf.fprintf stdout "%s" "GE "
  | Parser.LE -> Printf.fprintf stdout "%s" "LE "
  | Parser.GT -> Printf.fprintf stdout "%s" "GT"
  | Parser.LT -> Printf.fprintf stdout "%s" "LT"
  | Parser.AND -> Printf.fprintf stdout "%s" "AND "
  | Parser.OR -> Printf.fprintf stdout "%s" "OR "
  | Parser.NOT -> Printf.fprintf stdout "%s" "NOT "
  | Parser.PLUS -> Printf.fprintf stdout "%s" "PLUS "
  | Parser.MINUS -> Printf.fprintf stdout "%s" "MINUS "
  | Parser.TIMES -> Printf.fprintf stdout "%s" "TIMES "
  | Parser.DIV -> Printf.fprintf stdout "%s" "DIV "
  | Parser.NEG -> Printf.fprintf stdout "%s" "NEG "

  | Parser.ID _ -> Printf.fprintf stdout "%s" "ID "  
  | Parser.BOOL _ -> Printf.fprintf stdout "%s" "BOOL "
  | Parser.INT _ -> Printf.fprintf stdout "%s" "INT "

let print_c lbuf = 
  let i = 0 in
  let r = ref(i) in
  while true do
    r := !r + 1;
    try
      let t = Lexer.token lbuf in
      print_code t
    with
      | Failure _ -> Printf.fprintf stderr "Unknown token after token %d\n" (!r) ; exit 0
  done

let print_t lbuf = 
  let i = 0 in
  let r = ref(i) in
  while true do
    r := !r + 1;
    try
      let t = Lexer.token lbuf in
      print_token t
    with
      | Failure _ -> Printf.fprintf stderr "Unknown token after token %d\n" (!r) ; exit 0
  done


let rec str_t t = match t with
| INTT -> " integer "
| BOOLT -> " boolean "
| ARR t -> " array of" ^ str_t t

let str_var v = match v with 
| VAR1 vl -> List.fold_left (fun acc (id, t) -> acc ^ id ^ ":" ^ str_t t ^ ";") "var " vl
| VAR2 (idl, t) -> List.fold_left (fun acc x -> acc ^  x ^ ",") "var " idl ^ " : " ^ str_t t

let str_var2 v = match v with 
| VAR1 vl -> List.fold_left (fun acc (id, t) -> acc ^  id ^ ":" ^ str_t t ^ ";") "" vl
| VAR2 (idl, t) -> List.fold_left (fun acc x -> acc ^ x ^ ",") "" idl ^ " : " ^ str_t t

let rec str_e e = match e with
| INT i -> string_of_int i ^ " "
| BOOL b -> string_of_bool b ^ " "
| NEG v -> " -" ^ str_e v
| PLUS (v1, v2) -> str_e v1 ^ " + " ^ str_e v2
| MINUS (v1, v2) -> str_e v1 ^ " - " ^ str_e v2
| TIMES (v1, v2) -> str_e v1 ^ " * " ^ str_e v2
| DIV (v1, v2) ->str_e v1 ^ " / " ^ str_e v2
| EQ (v1, v2) -> str_e v1 ^ " = " ^ str_e v2
| NE (v1, v2) -> str_e v1 ^ " <> " ^ str_e v2
| GE(v1, v2) -> str_e v1 ^ " >= " ^ str_e v2
| LE (v1, v2) -> str_e v1 ^ " <= " ^ str_e v2
| GT (v1, v2) -> str_e v1 ^ " > " ^ str_e v2
| LT (v1, v2) -> str_e v1 ^ " < " ^ str_e v2
| Tbl (v1, v2) -> str_e v1 ^ "[" ^ str_e v2 ^ "]"
| CTbl (t, v) -> "new array of" ^ str_t t ^ "[" ^ str_e v ^ "]"
| _ -> "not implemented"

let str_instr instr = match instr with 
| AFF (id, e) -> id ^ " := " ^ str_e e
| _ -> "not implemented"

let str_bloc b = match b with BLOC bl ->
  "begin\n" ^ (List.fold_left (fun acc x -> acc ^ str_instr x ^ "\n") "" bl) ^ "\nend"

let str_defps defps = match defps with
| DEFV v -> str_var v
| DEFF (FUNC (id, env, t, defv, bloc)) -> 
  let s = "function " ^ id ^ "(" in
  let s = match env with | None -> s
  | Some (e) -> s ^ str_var2 e in 
  let s = s ^ "):" ^str_t t in
  let s = match defv with | None -> s
  | Some(v) -> s ^ str_var v in
  s ^ str_bloc bloc

let str_program p = match p with (defps, bloc) -> 
  let s = List.fold_left (fun acc x -> acc ^ "\n" ^ str_defps x) "" defps in
  "program\n" ^ s ^ "\n" ^ str_bloc bloc ^ ".\n"