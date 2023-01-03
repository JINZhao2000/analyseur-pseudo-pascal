type id = string

type t = 
  | INTT
  | BOOLT
  | ARR of t

type env = 
  | VAR1 of (id * t) list
  | VAR2 of id list * t

type singop = NEG
type biop = PLUS | MINUS | TIMES | DIV |  EQ | GE | LE | LT | GT | NE

type e = 
  | INT of int 
  | BOOL of bool
  | SIGOP of singop * e
  | BIOP of e * biop * e
  | FCALL of id * e list
  | Tbl of e * e 
  | CTbl of t * e

type bicond = OR | AND

type cond = 
  | C of e
  | NOT of cond
  | BICOND of cond * bicond * cond

type instr = 
  | PCALL of id * e list
  | AFF of id * e
  | AFFT of e * e * e
  | IF of cond * instr * instr
  | WHILE of cond * instr
  | BLC of instr list

type bloc = 
  | BLOC of instr list

type deff = 
  | FUNC of id * env option * t * env option * bloc

type defp = 
  | PROC of id * env option * env option * bloc

type defprog = 
  | DEFV of env
  | DEFF of deff
  | DEFP of defp
