program
var x, y : integer;
begin
   repeat
      x := x + 1;
      while y < x do
	 y := y + 1;
      y := y / 2
   until x = y
end.
	 
