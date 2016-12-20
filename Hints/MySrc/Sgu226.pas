{
ID: yuhc(020538)
PROG: Sgu226
}
program Sgu226;
uses math;
const
  oo = 10000;
var
  g               :array[1..200,1..200,1..3] of boolean;
  q               :array[1..100000,1..2] of integer;
  f               :array[1..200,1..3] of integer;
  bj              :array[1..200,1..3] of boolean;
  n,m,i,x,y,z,ans :integer;
//
procedure opf;
begin
  assign(input,'s226.in');
  reset(input);
  assign(output,'s226.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure bfs;
var
  l,r,i,j,v,color :longint;
begin
  fillchar(f,sizeof(f),$7f);
  l := 1; r := 3;
  for i := 1 to 3 do
  begin
    f[1][i] := 0;
    q[i][1] := 1;
    q[i][2] := i;
  end;
  repeat
    v := q[l][1];
    j := q[l][2];
    for i := 1 to n do
      for color := 1 to 3 do
        if g[v,i,color] then
          if (color > 0) and (color <> j) then
            if (f[v,j] + 1 < f[i,color]) and (not bj[i,color]) then
            begin
              f[i,color] := f[v,j] + 1;
              bj[i,color] := true;
              inc(r);
              q[r][1] := i;
              q[r][2] := color;
            end;
    bj[v,j] := false;
    inc(l);
  until l > r;
end;
//
begin
  opf;
  readln(n,m);
  fillchar(g,sizeof(g),false);
  for i := 1 to m do
  begin
    readln(x,y,z);
    g[x,y,z] := true;
  end;
  bfs;
  ans := oo;
  for i := 1 to 3 do
    ans := min(f[n,i],ans);
  if ans = oo then writeln(-1)
    else writeln(ans);
  clf;
end.