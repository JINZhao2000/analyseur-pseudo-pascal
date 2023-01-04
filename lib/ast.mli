(** type of identifier *)
type id = string

(** type of type in Pseudo-Pascal
  | INTT -> integer
  | BOOLT -> boolean   
  | ARR t -> array of t *)
type t = 
  | INTT
  | BOOLT
  | ARR of t

(** type of variable 
  | VAR1 -> var a:integer; b:integer; c:integer; 
  | VAR2 -> var a, b, c:integer; 
  | VAR3 -> mix of different definitions *)
type var = 
  | VAR1 of (id * t) list
  | VAR2 of id list * t
  | VAR3 of var * var

(** type of expression 
  | INT -> an integer
  | BOOL -> a boolean
  | ID -> an identifier
  | NEG -> negative 
  | PLUS -> +
  | MINUS -> -
  | TIMES -> *
  | DIV -> /
  | EQ -> =
  | GE -> >=
  | LE -> <=
  | GT -> >
  | LT -> <
  | NE -> <>
  | FCALL -> function(param)
  | Tbl -> e[e]
  | CTbl -> new array of t[e]
  | PE -> (e)
  *)
type e = 
  | INT of int 
  | BOOL of bool
  | ID of id
  | NEG of e
  | PLUS of e * e
  | MINUS of e * e
  | TIMES of e * e
  | DIV of e * e
  | EQ of e * e
  | GE of e * e
  | LE of e * e
  | LT of e * e 
  | GT of e * e
  | NE of e * e
  | FCALL of id * e list
  | Tbl of e * e 
  | CTbl of t * e
  | PE of e

(** type of condition 
  | C -> expression
  | PCOND -> (condition)  
  | NOT -> not cond
  | OR -> cond or cond
  | AND -> cond and cond
  *)
type cond = 
  | C of e
  | PCOND of cond
  | NOT of cond
  | OR of cond * cond
  | AND of cond * cond

(** type of instruction 
  | PCALL -> procedure call
  | AFF -> :=
  | AFFT ->  e[e] :=
  | IF ->
    if xxx then
      xxx
    else
      xxx
  | WHILE ->
    while xxx do
      xxx
  | BLC ->
    begin
      xxx
    end;
  | Nil -> 
  *)
type instr = 
  | PCALL of id * e list
  | AFF of id * e
  | AFFT of e * e * e
  | IF of cond * instr * instr
  | WHILE of cond * instr
  | BLC of instr
  | Nil

(** type of block 
  begin
    a list of instructions 
  end
  *)
type bloc = 
  | BLOC of instr list

(** type of function 
  identifier (param) : return;
    local variables
  block;
  *)
type deff = 
  | FUNC of id * var option * t * var option * bloc

(** type of procedure
  identifier (param);
    local variables
  block;
 *)
type defp = 
  | PROC of id * var option * var option * bloc

(** type of definition part of program
  | definition of function/procedure
  | definition of global variables
  *)
type defprog = 
  | DEFV of var
  | DEFF of deff
  | DEFP of defp

(** type of program 
  program
    definition part of program
  block.
  *)
type program = defprog list * bloc