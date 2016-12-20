program N9to1_Problem;
var
 i,n:longint;
begin
 readln(n);
 case n of
  1..8: writeln(0);
  9: writeln(8)
  else begin
        write(72);
        for i:=1 to n-10 do write(0);
       end;
 end;
end.