open Ast

module IDSet = Set.Make(String)

let rec check_exp exp tbl = match exp with
| INT _ -> true
| BOOL _ -> true
| ID id -> begin match IDSet.find_opt id tbl with
          | None -> 
            Printf.fprintf stdout "id %s not found\n" id;
            false 
          | Some (_) -> true 
          end
| NEG e -> check_exp e tbl
| PE e -> check_exp e tbl
| FCALL (id, e) -> (check_exp (ID id) tbl) && (List.fold_left (fun acc x -> if check_exp x tbl then acc else false) true e)
| Tbl (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| CTbl (_, e) -> check_exp e tbl
| PLUS (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| MINUS (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| TIMES (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| DIV (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| EQ (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| NE (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| GE (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| LE (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| GT (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)
| LT (e1, e2) -> (check_exp e1 tbl) && (check_exp e2 tbl)

let rec check_cond c tbl = match c with
| C e -> check_exp e tbl
| PCOND c -> check_cond c tbl
| NOT c -> check_cond c tbl
| OR (c1, c2) -> (check_cond c1 tbl) && (check_cond c2 tbl)
| AND (c1, c2) -> (check_cond c1 tbl) && (check_cond c2 tbl)

let rec check_instr i tbl = match i with
| Nil -> true
| PCALL (id, exps) -> (check_exp (ID id) tbl) && (List.fold_left (fun acc x -> if check_exp x tbl then acc else false) true exps)
| AFF (id, e) -> (check_exp (ID id) tbl) && (check_exp e tbl)
| AFFT (e1, e2, e3) -> (check_exp e1 tbl) && (check_exp e2 tbl) && (check_exp e3 tbl)
| IF (cond, i1, i2) -> (check_cond cond tbl) && (check_instr i1 tbl) && (check_instr i2 tbl)
| WHILE (cond, instr) -> (check_cond cond tbl) && (check_instr instr tbl)
| BLC i -> check_instr i tbl

let check_bloc b tbl = match b with BLOC (instrs) -> 
  List.fold_left (fun acc i -> if check_instr i tbl then acc else false) true instrs

let rec add_dict v tbl = match v with 
| VAR1 idtl -> List.fold_left (fun acc (id, _) -> IDSet.add id acc) tbl idtl
| VAR2 (ids, _) -> List.fold_left (fun acc id -> IDSet.add id acc) tbl ids
| VAR3 (v1, v2) -> add_dict v2 (add_dict v1 tbl)

let check_func f tbl = match f with FUNC(id, v, _, def, body) -> 
  let tbl = match v with 
  | None -> tbl
  | Some v ->  add_dict v tbl in
  let tbl = match def with
  | None -> tbl
  | Some v -> add_dict v tbl in
  let tbl = IDSet.add id tbl in
  (* List.fold_left (fun _ x -> output_string stdout (x ^ ", ")) () @@IDSet.elements tbl;  *)
  let res = check_bloc body tbl in
  Printf.fprintf stdout "check function %s scope : %s\n" id (string_of_bool res);
  res

let check_proc f tbl= match f with PROC(id, v, def, body) -> 
  let tbl = match v with 
  | None -> tbl
  | Some v ->  add_dict v tbl in
  let tbl = match def with
  | None -> tbl
  | Some v -> add_dict v tbl in
  let tbl = IDSet.add id tbl in
  (* List.fold_left (fun _ x -> output_string stdout (x ^ ", ")) () @@IDSet.elements tbl;  *)
  let res = check_bloc body tbl in
  Printf.fprintf stdout "check procedure %s scope : %s\n" id (string_of_bool res);
  res

let check_scope p = 
  let tbl = IDSet.empty |> IDSet.add "write" |> IDSet.add "read" |> IDSet.add "writeln" |> IDSet.add "readln" in
  match p with (defplst, bloc) -> begin
    let res = List.fold_left (
      fun acc x -> match x with
      | DEFV _ -> acc
      | DEFF f -> (check_func f tbl) && acc
      | DEFP p -> (check_proc p tbl) && acc
    ) true defplst in
    if res then
    let tbl = List.fold_left (
      fun acc x -> match x with
      | DEFV v -> add_dict v acc
      | DEFF (FUNC(id, _,_,_,_)) -> IDSet.add id acc
      | DEFP (PROC(id,_,_,_)) -> IDSet.add id acc
    ) tbl defplst in
    let res = check_bloc bloc tbl in
    Printf.fprintf stdout "check program scope : %s\n" (string_of_bool res);
    res
    else
      false
  end

(* module IDMap = Map.Make(String)

let is_type id t tbl = 
  let tt = IDMap.find_opt id tbl in
  match tt with
  | None -> false
  | Some tt -> tt = t *)