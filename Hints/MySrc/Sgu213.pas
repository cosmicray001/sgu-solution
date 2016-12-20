{
ID: yuhc(020538)
PROG: Sgu213
}
program Sgu213;
var
  g                   :array[1..400,1..400] of longint;
  bj                  :array[1..400] of boolean;
  hash                :array[1..160000] of boolean;
  ans,dis             :array[1..400] of longint;
  n,m,s,t,i,j,l,x,y,k :longint;
//
procedure opf;
begin
  assign(input,'s213.in');
  reset(input);
  assign(output,'s213.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure dijkstra;
var
  i,j,k,mincost :integer;
begin
  fillchar(bj,sizeof(bj),false);
  for i := 1 to n do
    if g[s,i] > 0 then dis[i] := 1
      else dis[i] := maxint;
  dis[s] := 0;
  bj[s] := true;
  for i := 1 to n - 1 do
  begin
    mincost := maxint;
    for j := 1 to n do
      if (not bj[j]) and (dis[j] < mincost) then
      begin
        mincost := dis[j];
        k := j;
      end;
    bj[k] := true;
    for j := 1 to n do
      if (not bj[j]) and (g[k,j] > 0) and (dis[k] + 1 < dis[j]) then
        dis[j] := dis[k] + 1;
  end;
end;
//
begin
  opf;
  readln(n,m,s,t);
  fillchar(g,sizeof(g),0);
  for i := 1 to m do
  begin
    readln(x,y);
    g[x,y] := i;
    g[y,x] := i;
  end;
  //
  dijkstra;
  writeln(dis[t]);
  //
  fillchar(hash,sizeof(hash),false);
  for k := 0 to dis[t] - 1 do
  begin
    l := 0;
    for i := 1 to n do
      if dis[i] = k then
        for j := 1 to n do
          if (dis[i] + 1 = dis[j]) and (g[j,i] > 0) then
          begin
            inc(l);
            ans[l] := g[i,j];
            hash[g[i,j]] := true;
          end;
    if k = dis[t] - 1 then
      for i := 1 to m do
        if not hash[i] then
        begin inc(l); ans[l] := i; end;
    write(l);
    for i := 1 to l do write(' ',ans[i]);
    writeln;
  end;
  clf;
end.