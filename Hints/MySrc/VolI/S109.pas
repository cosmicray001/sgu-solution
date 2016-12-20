program Magic_David;
var
 n:integer;
//
procedure work;
var
 i,j,k:integer;
begin
 write(n);
 for i:=n+3 to 2*n do
  for j:=1 to i-1 do
   if (j<=n)and(i-j<=n) then
    write(' ',(j-1)*n+i-j);
 writeln;
 //
 if odd(n) then k:=n+2 else k:=n+1;
 for i:=n+2 downto 3 do
  begin
   write(k);
   for j:=1 to i-1 do
    if (j<=n)and(i-j<=n) then
     write(' ',(j-1)*n+i-j);
   writeln;
   inc(k,2);
  end;
end;
//
begin
 assign(input,'magic.in');
 reset(input);
 assign(output,'magic.out');
 rewrite(output);
 readln(n);
 if n=2 then
  begin
   writeln('3 4');
   writeln('5 2 3');
  end
 else work;
 close(input);
 close(output);
end.