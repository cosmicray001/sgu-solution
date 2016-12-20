{
ID: yuhc(020538)
PROG: Sgu149
}
program Sgu149;
const
  MaxN = 10000;
var
  down1,from1,down2,from2,up,
  father,now,pre,child,cost   :array[1..MaxN] of integer;
  n,i                         :integer;
//
procedure opf;
begin
  assign(input,'s149.in');
  reset(input);
  assign(output,'s149.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure init;
var
  i,t,d :integer;
begin
  readln(n);
  for i := 2 to n do
  begin
    readln(t,d);
    father[i] := t;
    cost[i] := d;
    pre[i-1] := now[t];
    child[i-1] := i;
    now[t] := i - 1;
  end;
end;
//
function max(a,b :integer) :integer;
begin
  if a > b then max := a else max := b;
end;
//
procedure TreeDp1(v :integer);
var
  t :integer;
begin
  t := now[v];
  down1[v] := 0; down2[v] := 0;
  while t <> 0 do
  begin
    TreeDp1(child[t]);
    if down1[child[t]] + cost[child[t]] > down1[v] then
    begin
      down2[v] := down1[v];
      from2[v] := from1[v];
      down1[v] := down1[child[t]] + cost[child[t]];
      from1[v] := child[t];
    end
     else
      if down1[child[t]] + cost[child[t]] > down2[v] then
      begin
        down2[v] := down1[child[t]] + cost[child[t]];
        from2[v] := child[t];
      end;
    t := pre[t];
  end;
end;
//
procedure TreeDp2(v :integer);
var
  t :integer;
begin
  up[v] := 0;
  if father[v] <> 0 then
  begin
    up[v] := up[father[v]] + cost[v];
    if from1[father[v]] = v then
      up[v] := max(up[v], down2[father[v]] + cost[v])
    else up[v] := max(up[v], down1[father[v]] + cost[v]);
  end;
  t := now[v];
  while t <> 0 do
  begin
    TreeDp2(child[t]);
    t := pre[t];
  end;
end;
//
begin
  opf;
  init;
  TreeDp1(1);
  TreeDp2(1);
  for i := 1 to n do
    if up[i] = 0 then writeln(down1[i])
      else if down1[i] = 0 then writeln(up[i])
        else writeln(max(down1[i], up[i]));
  clf;
end.