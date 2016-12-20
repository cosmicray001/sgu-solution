//Written by Yuhc On 2008/12/23
program Domino;
var
 g:array[0..6,0..6] of integer;
 e:array[1..100] of record s,t:integer; end;
 r:array[0..6] of integer;
 road:array[1..101] of integer;
 n,i,l,t,even,min:integer;
//
procedure init;
var
 a,b,i:integer;
begin
 assign(input,'domino.in');
 reset(input);
 fillchar(g,sizeof(g),0);
 fillchar(r,sizeof(r),0);
 min:=6;
 readln(n);
 for i:=1 to n do
  begin
   readln(a,b);
   e[i].s:=a;   e[i].t:=b;
   inc(r[a]);   inc(r[b]);
   inc(g[a,b]); inc(g[b,a]);
   if min>a then min:=a;
   if min>b then min:=b;
  end;
 close(input);
end;
//
procedure print(bj:boolean);
var
 i,j,a,b:integer;
 use:array[1..100] of boolean;
begin
 assign(output,'domino.out');
 rewrite(output);
 if not bj then writeln('No solution')
  else
  begin
   fillchar(use,sizeof(use),false);
   for i:=1 to n do
    begin
     a:=road[i];
     b:=road[i+1];
     for j:=1 to n do
      if not use[j] then
        begin
         if (e[j].s=a)and(e[j].t=b) then
          begin
           writeln(j,' +'); use[j]:=true;
           break;
          end else
         if (e[j].s=b)and(e[j].t=a) then
          begin
           writeln(j,' -'); use[j]:=true;
           break;
          end;
        end;
    end;
  end;
 close(output);
 halt;
end;
//
procedure dfs(i:integer);
var
 j:integer;
begin
 for j:=min to 6 do
  if g[i,j]>0 then
   begin
    dec(g[i,j]);
    dec(g[j,i]);
    dfs(j);
   end;
 inc(l);
 road[l]:=i;
end;
//
begin
 init;
 t:=min; even:=0;
 for i:=0 to 6 do
  if odd(r[i]) then
   begin t:=i; inc(even); end;
 if even>2 then print(false);
 l:=0;
 dfs(t);
 if l<n then print(false);
 print(true);
end.