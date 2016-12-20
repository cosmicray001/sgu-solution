{$mode dephi}
//Writeln on 2008/12/17
program The_Sum;
var
 a,b,c,i,k,ans:longint;
//
begin
 readln(k);
 a:=0; b:=1; ans:=0;
 for i:=1 to k do
  begin
   ans:=ans+b;
   c:=b; b:=a+b; a:=c;
  end;
 writeln(ans);
end.