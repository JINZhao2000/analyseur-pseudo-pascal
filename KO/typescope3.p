program
var x : integer;
   y  : array of integer;

function x() : array of integer;
begin
   x := 42
end;

begin
   y := x()
end.
