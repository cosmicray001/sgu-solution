{$mode dephi}
program Div_3;
var
 n,ans:longint;
begin
 readln(n);
 ans:=(n div 3) shl 1;
 if n mod 3=2 then ans:=ans+1;
 writeln(ans);
end.