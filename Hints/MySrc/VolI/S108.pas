//Writeln on 2009/01/04
program Self_Num;
var
 s,p,c,ans:array[1..5001] of longint;
 bj:array[0.. 63] of boolean;
 sum:array[0..10000] of integer;
 n,k,i,t,total:longint;
//
procedure qsort(l,r:integer);
var
 i,j,mid:integer;
begin
 i:=l; j:=r; mid:=s[(i+j) div 2];
 repeat
  while s[i]<mid do inc(i);
  while s[j]>mid do dec(j);
  if i<=j then
   begin
    t:=s[i]; s[i]:=s[j]; s[j]:=t;
    t:=c[i]; c[i]:=c[j]; c[j]:=t;
    inc(i); dec(j);
   end;
 until i>j;
 if i<r then qsort(i,r);
 if j>l then qsort(l,j);
end;
//
procedure work;
var
 i,j,digital:longint;
begin
 fillchar(bj,sizeof(bj),false);
 total:=0; j:=1;
 for i:=1 to n do
  begin
   digital:=i+(sum[i mod 10000])+(sum[i div 10000]);
   bj[digital and 63]:=true;
   if not bj[i and 63] then
    begin
     inc(total);
     while total=s[j] do
      begin
       p[j]:=i;
       inc(j);
      end;
    end
   else bj[i and 63]:=false;
  end;
end;
//
procedure preious;
var
 i,t,x:integer;
begin
 for i:=0 to 10000 do
  begin
   x:=0; t:=i;
   while t>0 do
    begin
     x:=x+t mod 10;
     t:=t div 10;
    end;
   sum[i]:=x;
  end;
end;
//
begin
 assign(input,'self.in');
 reset(input);
 assign(output,'self.out');
 rewrite(output);
 read(n,k);
 for i:=1 to k do
  begin read(s[i]); c[i]:=i; end;
 qsort(1,k);
 preious;
 work;
 writeln(total);
 for i:=1 to k do ans[c[i]]:=p[i];
 for i:=1 to k-1 do write(ans[i],' ');
 writeln(ans[k]);
 close(input);
 close(output);
end.
