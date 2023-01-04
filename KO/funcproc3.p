program
var x : integer;

function f(y : integer) : integer;
var z : integer;
begin
  x := y + z;
  f := x
end;

function g(u : integer) : integer;
begin
  u := u + x;
  g := u
end;

begin
   f(g(x))
end.
