program
var x : integer;

function f(y : integer) : integer;
var z : integer;
begin
  x := y + z;
  f := x
end;

procedure g(u : integer);
begin
  u := u + x
end;

begin
   x := f(g(x))
end.
