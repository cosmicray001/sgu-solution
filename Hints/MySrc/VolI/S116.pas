program Index_Prime;
const m=1229; maxn=10000;
var
 p:array[1..m] of integer;
 bj:array[1..maxn] of boolean;
 f,ans,pre:array[0..maxn] of longint;
 n,i,j,k,t,np,min:integer;
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
 for i:=1 to j do
  begin
   if p[i]>j then break;
   p[i]:=p[p[i]];
  end;
 np:=i-1;
end;
//
procedure work;
var
 i,j:integer;
begin
 fillchar(f,sizeof(f),255);
 f[0]:=0;
 for i:=1 to np do
  for j:=p[i] to n do
   begin
    if (f[j-p[i]]>=0)and((f[j]=-1)or(f[j-p[i]]+1<=f[j])) then
     begin
      f[j]:=f[j-p[i]]+1;
      pre[j]:=p[i];
     end;
   end;
end;
//
begin
 assign(input,'index.in');
 reset(input);
 assign(output,'index.out');
 rewrite(output);
 getPrime;
 readln(n);
 work;
 if f[n]=-1 then writeln(0) else
  begin
   writeln(f[n]);
   t:=n; k:=0;
   while t<>0 do
    begin
     inc(k);
     ans[k]:=pre[t];
     t:=t-pre[t];
    end;
   for i:=1 to f[n]-1 do
    for j:=i+1 to f[n] do
     if ans[i]<ans[j] then
      begin t:=ans[i]; ans[i]:=ans[j]; ans[j]:=t; end;
   for i:=1 to f[n]-1 do write(ans[i],' ');
   writeln(ans[f[n]]);
  end;
 close(input);
 close(output);
end.
