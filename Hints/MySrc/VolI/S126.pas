//Writeln on 2009/01/21
program Boxes;
var
 a,b:longint;
//
function gcd(x,y:longint):longint;
begin
 if y=0 then gcd:=x else
  gcd:=gcd(y,x mod y);
end;
//
procedure swap;
var t:longint;
begin
 t:=a; a:=b; b:=t;
end;
//
function possible:boolean;
var t:longint;
begin
 if a>b then swap;
 t:=a+b;
 while t mod 2=0 do t:=t div 2;
 possible:=gcd(a,b) mod t=0;
end;
//
procedure work;
var
 tot:integer;
begin
 tot:=0;
 while a<>0 do
  begin
   b:=b-a;
   a:=2*a;
   inc(tot);
   if a>b then swap;
  end;
 writeln(tot);
end;
//
begin
 assign(input,'box.in');
 reset(input);
 assign(output,'box.out');
 rewrite(output);
 readln(a,b);
 if not possible then writeln(-1)
  else work;
 close(input);
 close(output);
end.
