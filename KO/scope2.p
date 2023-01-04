program
var x : integer;

function f(y : integer) : integer;
var z : integer;
begin
   z := y * 2;
   f := z + 1
end;

procedure g();
begin
   z := f(42)
end;

begin
   g()
end.
