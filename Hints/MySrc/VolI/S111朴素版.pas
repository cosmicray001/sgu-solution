//Writeln on 2009/01/24
program Simple_Prob;
type
 ars=array[1..1001] of integer;
var
 x,n:ars;
 l,k,i,j,t,m,y:longint;
 s:ansistring;
//
begin
 assign(input,'simple.in');
 reset(input);
 assign(output,'simple.out');
 rewrite(output);
 fillchar(x,sizeof(x),0);
 readln(s);
 l:=length(s);
 if odd(l) then
  begin inc(l); s:='0'+s; end;
 for i:=1 to l div 2 do
  val(s[i*2-1]+s[i*2],x[i]);
 //
 k:=1;
 i:=1;
 n[1]:=trunc(sqrt(x[i]));
 y:=n[1];
 t:=x[i]-sqr(n[k]);
 while i<=l div 2 do
  begin
   inc(i);
   j:=t*100+x[i];
   for m:=9 downto 0 do
    if m*(m+y*20)<=j then break;
   inc(k);
   n[k]:=m;
   t:=j-m*(m+y*20);
   y:=y*10+n[k];
  end;
 //
 for i:=1 to k do write(n[i]);
 close(input);
 close(output);
end.
