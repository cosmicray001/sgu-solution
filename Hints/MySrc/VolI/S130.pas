program Circle;
var
 c:array[1..31] of double;
 k,i,j:integer;
//
begin
 assign(input,'circle.in');
 reset(input);
 assign(output,'circle.out');
 rewrite(output);
 readln(k);
 fillchar(c,sizeof(c),0);
 c[1]:=1;
 for i:=2 to k+1 do
  for j:=1 to i-1 do
   c[i]:=c[i]+c[j]*c[i-j];
 writeln(c[k+1]:0:0,' ',k+1);
 close(input);
 close(output);
end.
