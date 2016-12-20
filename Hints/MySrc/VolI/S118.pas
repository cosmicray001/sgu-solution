program Digital_Root;
var
 a:array[1..1000] of longint;
 k,n,i,j:integer;
//
procedure work;
var
 t,ans,i:integer;
begin
 t:=1;  ans:=0;
 for i:=1 to n do
  begin
   t:=(t*(a[i] mod 9)) mod 9;
   ans:=(ans+t) mod 9;
  end;
 if ans=0 then writeln(9)
  else writeln(ans);
end;
//
begin
 assign(input,'root.in');
 reset(input);
 assign(output,'root.out');
 rewrite(output);
 readln(k);
 for i:=1 to k do
  begin
   read(n);
   for j:=1 to n do read(a[j]);
   work;
   readln;
  end;
 close(input);
 close(output);
end.