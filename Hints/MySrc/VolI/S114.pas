program TeleStation;
type
 rec=record
  p,v:longint;
 end;
var
 s,t,n,i:longint;
 a:array[1..15000]of rec;
//
procedure qsort(l, r: longint);
var
 i,j,mid:longint;
 t: rec;
 begin
  i:=l; j:=r; mid:=a[(l+r) div 2].p;
  repeat
   while a[i].p<mid do inc(i);
   while a[j].p>mid do dec(j);
   if i<= j then
    begin
     t:=a[i]; a[i]:=a[j]; a[j]:=t;
     inc(i); dec(j);
    end;
  until i>j;
 if l<j then qsort(l,j);
 if i<r then qsort(i,r);
end;
//
begin
 readln(n);
 s:=0;
 for i:=1 to n do
  begin
   read(a[i].p,a[i].v);
   inc(s,a[i].v);
  end;
 s:=s div 2+1;
 qsort(1,n);
 i:=0; t:=0;
 while t<s do
  begin
   inc(i);
   t:=t+a[i].v;
  end;
 writeln(a[i].p,'.00000');
end.

