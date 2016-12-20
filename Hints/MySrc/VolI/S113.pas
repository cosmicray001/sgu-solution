program Nearly_Prime;
const m=3401; maxn=31623;
var
 p:array[1..m] of longint;
 bj:array[1..maxn] of boolean;
 n,t,i:longint;
//
procedure getPrime;
var
 i,j,k:longint;
begin
 fillchar(bj,sizeof(bj),true);
 j:=0;
 for i:=2 to maxn do
  if bj[i] then
   begin
    inc(j); p[j]:=i;
    k:=i+i;
    while k<=maxn do
     begin
      bj[k]:=false;
      k:=k+i;
     end;
   end;
end;
//
function test(t:longint):boolean;
var
 i,tot:longint;
begin
 tot:=0;
 for i:=1 to m do
  begin
   if p[i]>t then break;
   if t mod p[i]=0 then
    begin
     t:=t div p[i]; tot:=1;
     break;
    end;
  end;
 if (tot=1)and(t<>1) then
  for i:=1 to m do
   begin
    if p[i]=t then begin tot:=2; break; end;
    if t mod p[i]=0 then begin tot:=3; break end;
    if i=m then tot:=2;
   end;
 if tot=2 then test:=true else test:=false;
end;
//
begin
 assign(input,'nearly.in');
 reset(input);
 assign(output,'nearly.out');
 rewrite(output);
 getPrime;
 read(n);
 for i:=1 to n do
  begin
   read(t);
   if test(t) then writeln('Yes')
    else writeln('No');
  end;
 close(input);
 close(output);
end.
