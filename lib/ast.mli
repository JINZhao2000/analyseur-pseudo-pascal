type id = string

type t = 
  | INTT
  | BOOLT
  | ARR of t

type var = 
  | VAR1 of (id * t) list
  | VAR2 of id list * t

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

type cond = 
  | C of e
  | NOT of cond
  | OR of cond * cond
  | AND of cond * cond

type instr = 
  | PCALL of id * e list
  | AFF of id * e
  | AFFT of e * e * e
  | IF of cond * instr * instr
  | WHILE of cond * instr
  | BLC of instr

type bloc = 
  | BLOC of instr list

type deff = 
  | FUNC of id * var option * t * var option * bloc
(*
type defp = 
  | PROC of id * env option * env option * bloc *)

type defprog = 
  | DEFV of var
  | DEFF of deff
  (*| DEFP of defp *)
