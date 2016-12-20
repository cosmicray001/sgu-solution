//Written by Yuhc On 2008/12/23
program abba;
type
 cc=array[0..10001] of longint;
var
 a,b,i:integer;
 c1,c2:cc;
//
procedure mul(var m:cc;t:integer);
var
 i,l:integer;
begin
 for i:=1 to m[0] do
  m[i]:=m[i]*t;
 for i:=1 to m[0]-1 do
  if m[i]>9 then
   begin
    m[i+1]:=m[i+1]+m[i] div 10;
    m[i]:=m[i] mod 10;
   end;
 l:=m[0];
 while m[l]>9 do
  begin
   m[l+1]:=m[l+1]+m[l] div 10;
   m[l]:=m[l] mod 10;
   inc(l);
  end;
 m[0]:=l;
end;
//
function getmax:boolean;
var i:integer;
begin
 if c1[0]>c2[0] then exit(true);
 if c2[0]>c1[0] then exit(false);
 for i:=c1[0] downto 1 do
  if c1[i]>c2[i] then exit(true) else
  if c2[i]>c1[i] then exit(false);
 exit(true);
end;
//
procedure minus;
var
 a,b,c:cc;
 i,j:integer;
begin
 if getmax then
  begin a:=c1; b:=c2; end else
  begin a:=c2; b:=c1; write('-'); end;
 fillchar(c,sizeof(c),0);
 for i:=1 to a[0] do
  begin
   c[i]:=c[i]+a[i]-b[i];
   if c[i]<0 then
    begin
     c[i]:=c[i]+10;
     dec(c[i+1]);
    end;
  end;
 while (i>1)and(c[i]=0) do dec(i);
 for j:=i downto 2 do write(c[j]);
 writeln(c[1]);
end;
//
begin
 assign(input,'ab.in');
 reset(input);
 assign(output,'ab.out');
 rewrite(output);
 readln(a,b);
 fillchar(c1,sizeof(c1),0);
 fillchar(c2,sizeof(c2),0);
 c1[1]:=1; c1[0]:=1;
 c2[1]:=1; c2[0]:=1;
 for i:=1 to b do mul(c1,a);
 for i:=1 to a do mul(c2,b);
 minus;
 close(input);
 close(output);
end.