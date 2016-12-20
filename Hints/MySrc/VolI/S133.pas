//Writeln on 2009/01/23;
program Border;
var
 a,b:array[1..16001] of longint;
 n,i,k,t,tot:longint;
//
procedure qsort(l,r:integer);
var
 i,j,mid:integer;
begin
 i:=l; j:=r; mid:=a[(i+j) div 2];
 repeat
  while a[i]<mid do inc(i);
  while a[j]>mid do dec(j);
  if i<=j then
   begin
    t:=a[i]; a[i]:=a[j]; a[j]:=t;
    t:=b[i]; b[i]:=b[j]; b[j]:=t;
    inc(i); dec(j);
   end;
 until i>j;
 if i<r then qsort(i,r);
 if j>l then qsort(l,j);
end;
//
begin
 assign(input,'border.in');
 reset(input);
 assign(output,'border.out');
 rewrite(output);
 readln(n);
 for i:=1 to n do readln(a[i],b[i]);
 qsort(1,n);
 i:=1;      tot:=0;
 k:=b[1];
 for i:=2 to n do
  if k<b[i] then k:=b[i] else inc(tot);
 writeln(tot);
 close(input);
 close(output);
end.
