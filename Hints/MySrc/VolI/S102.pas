{$mode dephi}
program Coprimes;
var
 n,i,tot:integer;
function gcd(a,b:integer):integer;
begin
 if a=0 then gcd:=b
  else gcd:=gcd(b mod a,a);
end;
begin
 readln(n);
 tot:=0;
 for i:=1 to n do
  if gcd(i,n)=1 then inc(tot);
 writeln(tot);
end.