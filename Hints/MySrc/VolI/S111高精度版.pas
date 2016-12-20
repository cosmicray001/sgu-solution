//Writeln on 2009/01/24
program Simple_Prob;
type
 ars=array[0..1001] of longint;
var
 x,n,c:ars;
 ch:char;
 l,k,i,j:integer;
//
function larger:boolean;
var
 i:integer;
begin
 for i:=k*2 downto 1 do
  begin
   if c[i]>x[i] then exit(true);
   if c[i]<x[i] then exit(false);
  end;
 larger:=false;
end;
//
function mul(a:ars):boolean;
var
 i,j:integer;
begin
 fillchar(c,sizeof(c),0);
 for i:=1 to k do
  for j:=1 to k do
   begin
    c[i+j-1]:=c[i+j-1]+a[i]*a[j];
    if c[i+j-1]>9 then
     begin
      c[i+j]:=c[i+j]+c[i+j-1] div 10;
      c[i+j-1]:=c[i+j-1] mod 10;
     end;
   end;
 mul:=larger;
end;
//
begin
 assign(input,'simple.in');
 reset(input);
 assign(output,'simple.out');
 rewrite(output);
 l:=0;
 while not eoln do
  begin
   read(ch);
   inc(l);
   x[l]:=ord(ch)-48;
  end;
 for i:=1 to l div 2 do
  begin k:=x[i]; x[i]:=x[l-i+1]; x[l-i+1]:=k; end;
 k:=(l+1) div 2;
 for i:=k downto 1 do n[i]:=9;
 for i:=k downto 1 do
  begin
   for j:=8 downto 0 do
    begin
     if not mul(n) then break;
     n[i]:=j;
    end;
   if i<>1 then inc(n[i]);
  end;
 while (k>0) and (n[k]=0) do dec(k);
 if k=0 then writeln(0) else
  for i:=k downto 1 do write(n[i]);
 close(input);
 close(output);
end.