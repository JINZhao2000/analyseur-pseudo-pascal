%{
  open Ast
    %}

%token PROG BEGIN END FUNC PROC VAR
%token INTT BOOLT ARR NEW
%token LPAR RPAR SEP COLON COMA LCOCH RCOCH DOT EOF
%token REPT UNTIL IF THEN ELSE WHILE DO
%token EQ LE GE NE LT GT AND NOT OR
%token PLUS MINUS TIMES DIV NEG
// %nonassoc NOT NEG
// %left PLUS MINUS OR
// %right TIMES DIV AND BEGIN END
%token<int> INT
%token<bool> BOOL
%token<string> ID

%left PLUS
%right TIMES
%start program
%type<Ast.defprog list * Ast.bloc> program
%type<Ast.defprog> defprog
%type<Ast.t> t
%type<Ast.env>env
%type<Ast.singop> singop
%type<Ast.biop> biop
%type<Ast.e> e
// %type<Ast.bicond> bicond
// %type<Ast.cond> cond
%type<Ast.instr> instr
%type<Ast.bloc> bloc
%type<Ast.deff> deff
%type<Ast.defp> defp
%type<Ast.defprog list> defps
// %type<Ast.env list> envs
%type<Ast.env> defv
// %type<Ast.env list> vars
%type<Ast.e list> exps
%type<string list> ids
%type<(string * Ast.t) list> idtype
%type<(string * Ast.t) list> var
%type<Ast.instr list> instrs
%%

program:
  | PROG bloc DOT EOF        { ([], $2) }
  | PROG defps bloc DOT EOF  { ($2, $3) }

bloc:
  | BEGIN instrs END { BLOC $2 }

defprog:
  | defv  { DEFV $1 } // declare variables
  | FUNC deff SEP { DEFF $2 }// declare function
  | PROC defp SEP { DEFP $2 } // declare procedure

deff:
  | ID LPAR RPAR COLON t SEP bloc           { FUNC ($1, None, $5, None, $7) } // function id () : integer; begin end
  | ID LPAR env RPAR COLON t SEP bloc      { FUNC ($1, Some($3), $6, None, $8) } // function id (a : integer) : integer; begin end
  | ID LPAR RPAR COLON t SEP defv bloc      { FUNC ($1, None, $5, Some($7), $8) } // function id () : integer; var b : integer; begin end
  | ID LPAR env RPAR COLON t SEP defv bloc { FUNC ($1, Some($3), $6, Some($8), $9) } // function id (a : integer) : integer; var b : integer begin end

defp:
  | ID LPAR RPAR SEP bloc           { PROC ($1, None, None, $5)} // procedure id(); begin end
  | ID LPAR RPAR SEP defv bloc      { PROC ($1, None, Some($5), $6)} // procedure id(); var b : integer; begin end
  | ID LPAR env RPAR SEP bloc      { PROC ($1, Some($3), None, $6)} // procedure id(a : integer); begin end
  | ID LPAR env RPAR SEP defv bloc { PROC ($1, Some($3), Some($6), $7)} // procedure id(a : integer); var b : integer; begin end

defv:
  | VAR env { $2 }
// type
t:
  | INTT   { INTT } // int
  | BOOLT  { BOOLT } // bool
  | ARR t  { ARR($2) } // array of t

var:
  | ID COLON t SEP        { [($1, $3)] } // a : integer
  | ID COLON t SEP var { ($1, $3)::$5 } // a : integer; b : integer; 

idtype:
  | ID COLON t            { [($1, $3)] } // a : integer
  | ID COLON t SEP idtype { ($1, $3)::$5 } // a : integer; b : integer; 

env:
  | idtype      { VAR1 $1 }        // var a : integer; b : integer; 
  | ID COMA ids COLON t { VAR2 ($1::$3, $5) }  // var a, b : integer ;

// single operation
singop:
  | NEG { NEG } // -

// binary algorithmic operation
biop:
  | PLUS { PLUS }
  | MINUS { MINUS }
  | TIMES { TIMES }
  | DIV { DIV } 
  | EQ { EQ }
  | GE { GE }
  | LE { LE }
  | LT { LT }
  | GT { GT }
  | NE { NE }

// expression
e:
  | INT                      { INT $1 }
  | BOOL                     { BOOL $1 }
  | singop e                 { SIGOP ($1, $2) }
  | e biop e                { BIOP ($1, $2, $3) }
  | ID LPAR RPAR             { FCALL ($1, []) }
  | ID LPAR exps RPAR        { FCALL ($1, $3) }
  | e LCOCH e RCOCH          { Tbl ($1, $3) }
  | NEW ARR t LCOCH e RCOCH  { CTbl ($3, $5) }

// bicond:
//   | OR { OR }
//   | AND { AND }
// // condition
// cond:
//   | e              { C $1 }
//   | NOT cond       { NOT $2 }
//   | cond bicond cond   { BICOND ($1, $2, $3) }



// instruction
instr:
  | ID LPAR RPAR SEP                  { PCALL ($1, []) }
  | ID LPAR exps RPAR SEP             { PCALL ($1, $3) }
  | ID COLON EQ e SEP                 { AFF ($1, $4) }
  // | e LCOCH e RCOCH COLON EQ e SEP    { AFFT ($1, $3, $7) }
  // | IF cond THEN instr ELSE instr     { IF ($2, $4, $6) }
  // | WHILE cond DO BEGIN instr END SEP { WHILE ($2, $5) }
  // | BEGIN instrs END SEP              { BLC $2 }
  // | REPT instr SEP UNTIL cond SEP     { WHILE ($5, $2) } 

defps:
  | defprog       { [$1] }
  | defprog defps { $1::$2 }

instrs:
  | instr        { [$1] }
  | instr instrs { $1::$2 }

ids:
  | ID          { [$1] } // a
  | ID COMA ids { $1::$3 } // a, b

// vars:
//   | var SEP      { [$1] }
//   | var SEP vars {$1::$3}

exps:
  | e           { [$1] }
  | e COMA exps { $1::$3 }
%%