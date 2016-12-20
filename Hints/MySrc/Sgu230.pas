{
ID: yuhc(020538)
PROG: Sgu230
}
program Sgu230;
var
  g           :array[1..100,1..100] of boolean;
  r,ans,p     :array[1..100] of integer;
  n,m,x,y,i,l :integer;
//
procedure opf;
begin
  assign(input,'s230.in');
  reset(input);
  assign(output,'s230.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
function Top :boolean;
var
  i,j,k :integer;
begin
  for i := 1 to n do
  begin
    k := -1;
    for j := 1 to n do
      if r[j] = 0 then
      begin
        k := j;
        break;
      end;
    if k = -1 then
    begin Top := false; exit; end;
    inc(l);
    p[l] := k;
    r[k] := -1;
    for j := 1 to n do
      if g[k,j] then
      begin
        g[k,j] := false;
        dec(r[j]);
      end;
  end;
  Top := true;
end;
//
begin
  opf;
  readln(n,m);
  fillchar(r,sizeof(r),0);
  fillchar(g,sizeof(g),false);
  for i := 1 to m do
  begin
    readln(x,y);
    if not g[x,y] then
    begin
      g[x,y] := true;
      inc(r[y]);
    end;
  end;
  //
  if not Top then writeln('No solution')
  else
  begin
    for i := 1 to n do ans[p[i]] := i;
    for i := 1 to n - 1 do
      write(ans[i],' ');
    writeln(ans[n]);
  end;
  clf;
end.