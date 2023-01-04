program
var t : array of array of integer;

function allocate(n : integer) : array of array of integer;
var i : integer;
begin
   allocate := new array of array of integer[n];
   i := 0;
   while i < n do
   begin
      allocate[i] := new array of integer [i+1];
      i := i + 1
   end;
end;

procedure pascal_triangle(t : array of array of integer; n : integer);
var i, j : integer;
begin
   t[0][0] := 1;
   i := 1;
   while i < n do
   begin
      t[i][0] := 1;
      t[i][i] := 1;
      j := 1;
      while j < i do
	 t[i][j] := t[i-1][j-1] + t [i-1][j]
   end;
end;
   
begin
   t := allocate(42);
   pascal_triangle(t, 42);
   writeln(t[41][24])
end.
