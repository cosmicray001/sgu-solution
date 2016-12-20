//Writeln on 2009/01/24
program Simple_Prob;
type
 ars=array[0..1001] of longint;
var
 x,n,y,t,c,j,temp:ars;
 l,k,i,m:longint;
 s:ansistring;
//
function bigger(a,b:ars):boolean;
var
 i:integer;
begin
 if a[0]>b[0] then exit(true);
 if a[0]<b[0] then exit(false);
 for i:=a[0] downto 1 do
  begin
   if a[i]>b[i] then exit(true);
   if a[i]<b[i] then exit(false);
  end;
 exit(false);
end;
//
function plus(a:ars; b:integer):ars;
var
 i:integer;
begin
 c:=a;
 c[1]:=c[1]+b;
 i:=1;
 while c[i]>9 do
  begin
   c[i+1]:=c[i+1]+c[i] div 10;
   c[i]:=c[i] mod 10;
   inc(i);
  end;
 if c[c[0]+1]<>0 then inc(c[0]);
 plus:=c;
end;
//
function minus(a,b:ars):ars;
var
 i:integer;
begin
 fillchar(c,sizeof(c),0);
 for i:=1 to a[0] do
  begin
   c[i]:=c[i]+a[i]-b[i];
   if c[i]<0 then
    begin
     inc(c[i],10);
     dec(c[i+1]);
    end;
  end;
 c[0]:=a[0];
 i:=c[0];
 while (i>0) and (c[i]=0) do dec(i);
 c[0]:=i;
 minus:=c;
end;
//
function mul(a:ars; b:integer):ars;
var
 i:integer;
begin
 fillchar(c,sizeof(c),0);
 for i:=1 to a[0] do c[i]:=a[i]*b;
 for i:=1 to a[0]-1 do
  if c[i]>9 then
   begin
    c[i+1]:=c[i+1]+c[i] div 10;
    c[i]:=c[i] mod 10;
   end;
 i:=a[0];
 while c[i]>9 do
  begin
   c[i+1]:=c[i+1]+c[i] div 10;
   c[i]:=c[i] mod 10;
   inc(i);
  end;
 c[0]:=i;
 mul:=c;
end;
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
 y[0]:=1; y[1]:=n[1];
 t[0]:=1; t[1]:=x[i]-sqr(n[k]);
 while i<=l div 2 do
  begin
   inc(i);
   j:=plus(mul(t,100),x[i]);
   for m:=9 downto 0 do
    begin
     temp:=mul(plus(mul(y,20),m),m);
     if not bigger(temp,j) then break;
    end;
   inc(k);
   n[k]:=m;
   t:=minus(j,temp);
   y:=plus(mul(y,10),n[k]);
  end;
 //
 for i:=1 to k-2 do write(n[i]);
 writeln(n[k-1]);
 close(input);
 close(output);
end.
