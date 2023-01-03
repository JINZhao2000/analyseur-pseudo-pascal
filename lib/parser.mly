%{
  open Ast
    %}

%token PROG BEGIN END FUNC PROC VAR LPAR RPAR SEP SEPL
%token INTT BOOLT ARR NEW
%token COLON COMA LCOCH RCOCH DOT EOF
%token REPT UNTIL IF THEN ELSE WHILE DO
%token EQ LE GE NE LT GT AND NOT OR
%token PLUS MINUS TIMES DIV NEG
%nonassoc NOT NEG
%right TIMES DIV AND 
%left PLUS MINUS OR 
%left EQ LE GE NE LT GT
%token<int> INT
%token<bool> BOOL
%token<string> ID
%start program
%type<Ast.defprog list * Ast.bloc> program
%type<Ast.defprog> defprog
%type<Ast.t> t
%type<Ast.e> e
%type<Ast.cond> cond
%type<Ast.instr> instr
%type<Ast.bloc> bloc
%type<Ast.defprog list> defps
%type<Ast.var> defv
%type<Ast.var> param
%type<(Ast.id * Ast.t) list> var
%type<Ast.e list> exps
%type<string list> ids
%type<Ast.deff> deff
// %type<Ast.defp> defp
%type<Ast.instr list> instrs
%%

program:
  | PROG bloc DOT EOF        { ([], $2) }
  | PROG defps bloc DOT EOF  { ($2, $3) }

// bloc of program function procedure
bloc:
  | BEGIN instrs { BLOC $2 }

// declare variables
defv:
  | VAR param { $2 }

// type
t:
  | INTT   { INTT } // int
  | BOOLT  { BOOLT } // bool
  | ARR t  { ARR($2) } // array of t

param:
  | var { VAR1 $1 }
  | ids COLON t { VAR2 ($1, $3) }

// variables 
// also declare env
var:
  | ID COLON t        { [($1, $3)] } // a : integer
  | ID COLON t SEP var    { ($1, $3)::$5 } // a : integer; b : integer; 

// expression
e:
  | INT                      { INT $1 }
  | BOOL                     { BOOL $1 }
  | ID                       { ID $1 }
  | NEG e                    { NEG $2 }
  | e PLUS e                 { PLUS ($1, $3) }
  | e MINUS e                { MINUS ($1, $3) }
  | e TIMES e                { TIMES ($1, $3) }
  | e DIV e                  { DIV ($1, $3) } 
  | e EQ e                   { EQ ($1, $3) }
  | e NE e                   { NE ($1, $3) }
  | e GE e                   { GE ($1, $3) }
  | e LE e                   { LE ($1, $3) }
  | e GT e                   { GT ($1, $3) }
  | e LT e                   { LT ($1, $3) }
  | ID LPAR RPAR             { FCALL ($1, []) }
  | ID LPAR exps RPAR        { FCALL ($1, $3) }
  | e LCOCH e RCOCH          { Tbl ($1, $3) }
  | NEW ARR t LCOCH e RCOCH  { CTbl ($3, $5) }

// condition
cond:
  | e              { C $1 }
  | NOT cond       { NOT $2 }
  | cond OR cond   { OR ($1, $3) }
  | cond AND cond  { AND ($1, $3) }

// instruction
instr:
  | ID LPAR RPAR                  { PCALL ($1, []) }
  | ID LPAR exps RPAR             { PCALL ($1, $3) }
  | ID COLON EQ e                 { AFF ($1, $4) }
  | e LCOCH e RCOCH COLON EQ e    { AFFT ($1, $3, $7) }
  | IF cond THEN instr ELSE instr     { IF ($2, $4, $6) }
  | WHILE cond DO BEGIN instr END { WHILE ($2, $5) }
  | BEGIN instr END              { BLC $2 }
  | REPT instr SEP UNTIL cond     { WHILE ($5, $2) } 


defprog:
  | defv SEPL  { DEFV $1 }  // declare variables
  | deff  { DEFF $1 }  // declare function
  // | PROC defp SEP { DEFP $2 } // declare procedure

deff:
  | FUNC ID LPAR RPAR COLON t SEPL bloc            { FUNC ($2, None, $6, None, $8) } // function id () : integer; begin end
  | FUNC ID LPAR param RPAR COLON t SEPL bloc     { FUNC ($2, Some($4), $7, None, $9) } // function id (a : integer) : integer; begin end
  | FUNC ID LPAR RPAR COLON t SEPL defv bloc       { FUNC ($2, None, $6, Some($8), $9) } // function id () : integer; var b : integer; begin end
  | FUNC ID LPAR param RPAR COLON t SEPL defv bloc  { FUNC ($2, Some($4), $7, Some($9), $10) } // function id (a : integer) : integer; var b : integer begin end

// defp:
//   | PROC ID LPAR RPAR SEP bloc           { PROC ($1, None, None, $5)} // procedure id(); begin end
//   | PROC ID LPAR RPAR SEP defv bloc      { PROC ($1, None, Some($5), $6)} // procedure id(); var b : integer; begin end
//   | PROC ID LPAR env RPAR SEP bloc      { PROC ($1, Some($3), None, $6)} // procedure id(a : integer); begin end
//   | PROC ID LPAR env RPAR SEP defv bloc { PROC ($1, Some($3), Some($6), $7)} // procedure id(a : integer); var b : integer; begin end

defps:
  | defprog       { [$1] }
  | defprog defps { $1::$2 }

instrs:
  | instr END SEPL      { [$1] }
  | instr END SEP       { [$1] }
  | instr END           { [$1] }
  | instr SEPL instrs { $1::$3 }

ids:
  | ID          { [$1] } // a
  | ID COMA ids { $1::$3 } // a, b

exps:
  | e           { [$1] }
  | e COMA exps { $1::$3 }
%%