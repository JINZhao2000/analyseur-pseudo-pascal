{
    open Parser
    
    let keyword_table = Hashtbl.create 32

    let _ = 
        List.iter (fun (kwd, tok) -> Hashtbl.add keyword_table kwd tok)
        [
            "program", PROG;
            "begin", BEGIN;
            "end", END;
            "function", FUNC;
            "procedure", PROC;
            "boolean", BOOLT;
            "integer", INTT;
            "array of", ARR;
            "var", VAR;
            "not", NOT;
            "and", AND;
            "or", OR;
            "new", NEW;
            "repeat", REPT;
            "until", UNTIL;
            "if", IF;
            "then", THEN;
            "else", ELSE;
            "while", WHILE;
            "do", DO
        ]
    
    let find_token = fun w ->
        try
            Hashtbl.find keyword_table w
        with Not_found ->
            ID w
}

let digit = ['0'-'9']
let alphau = ['a'-'z''A'-'Z''_']
let ivalue = '-'?['0'-'9']+
let comment = '{'[^'{']*'}'

rule token = parse
    | comment                     { token lexbuf }
    | ivalue as s                 { INT (int_of_string s) }
    | alphau(alphau|digit)* as s  { find_token s }
    | '.'     { DOT }
    | ','     { COMA }
    | ';'     { SEP }
    | ";\n"   { SEPL }
    | ':'     { COLON }
    | '('     { LPAR }
    | ')'     { RPAR }
    | '='     { EQ }
    | '<'     { LT }
    | '>'     { GT }
    | ">="    { GE }
    | "<="    { LE }
    | '+'     { PLUS }
    | '-'     { MINUS }
    | '*'     { TIMES }
    | '/'     { DIV }
    | '-'     { NEG }
    | '['     { LCOCH }
    | ']'     { RCOCH }
    | '+'     { PLUS }
    | '-'     { MINUS }
    | '*'     { TIMES }
    | '/'     { DIV }
    | eof     { EOF }
    | [' ''\t''\n']               { token lexbuf }
