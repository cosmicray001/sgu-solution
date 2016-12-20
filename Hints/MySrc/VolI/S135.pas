program Drawing_Lines;
var
 n,ans:longint;
begin
 readln(n);
 if odd(n) then
  begin
   ans:=(n+1) div 2;
   ans:=ans*n;
  end else
  begin
   ans:=n div 2;
   ans:=ans*(n+1);
  end;
 writeln(ans+1);
end.