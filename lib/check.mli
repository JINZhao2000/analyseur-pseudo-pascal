open Ast

(**
    check the scope of variable
    @param p a program type
    @return boolean which mean if the scope is satisfied
    *)
val check_scope : program -> bool