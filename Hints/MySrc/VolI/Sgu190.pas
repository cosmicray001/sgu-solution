{
ID: yuhc(020538)
PROG: Sgu190
}
program Sgu190;
const
  MaxN = 40;
  d    :array[1..4,1..2] of integer = ((1,0),(-1,0),(0,1),(0,-1));
var
  n,p,x,y,i,j :integer;
  map,bj      :array[1..MaxN,1..MaxN] of boolean;
  c           :array[1..MaxN,1..MaxN] of integer;
//
procedure opf;
begin
  assign(input,'s190.in');
  reset(input);
  assign(output,'s190.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
function check(i,j :integer) :boolean;
var
  k,x,y,tx,ty :integer;
begin
  for k := 1 to 4 do
  begin
    x := i + d[k][1]; y := j + d[k][2];
    if (x < 1) or (x > n) or (y < 1) or (y > n) then continue;
    if map[x,y] and (not bj[x,y]) then
    begin
      bj[x,y] := true;
      tx := c[x,y] div n;
      ty := c[x,y] mod n;
      if ty = 0 then ty := n else inc(tx);
      if (c[x,y] = 0) or check(tx,ty) then
      begin
        c[x,y] := (i - 1) * n + j;
        check := true;
        exit;
      end;
    end;
  end;
  check := false;
end;
//
procedure main;
begin
  fillchar(c,sizeof(c),0);
  for i := 1 to n do
    for j := 1 to n do
    begin
      fillchar(bj,sizeof(bj),false);
      if map[i,j] and ((i + j) and 1 = 1) then
        if not check(i,j) then
        begin
          writeln('No');
          clf; halt;
        end;
    end;
end;
//
procedure whole;
begin
  for i := 1 to n do
    for j := 1 to n do
      if map[i,j] and ((i + j) and 1 = 0) and (c[i,j] = 0) then
      begin
        writeln('No');
        clf; halt;
      end;
end;
//
procedure print;
var
  xx,yy     :array[1..MaxN * MaxN shr 1] of integer;
  tot,tx,ty :integer;
begin
  writeln('Yes');
  tot := 0;
  for i := 1 to n do
    for j := 1 to n do
    begin
      if not map[i,j] then continue;
      tx := c[i,j] div n;
      ty := c[i,j] mod n;
      if ty = 0 then ty := n else inc(tx);
      if (c[i,j] <> 0) and (ty = j) then
      begin
        inc(tot);
        if tx = i - 1 then
          begin xx[tot] := tx; yy[tot] := ty; end
        else
          begin xx[tot] := i; yy[tot] := j; end;
      end;
    end;
  writeln(tot);
  for i := 1 to tot do writeln(xx[i],' ',yy[i]);
  tot := 0;
  for i := 1 to n do
    for j := 1 to n do
    begin
      if not map[i,j] then continue;
      tx := c[i,j] div n;
      ty := c[i,j] mod n;
      if ty = 0 then ty := n else inc(tx);
      if (c[i,j] <> 0) and (tx = i) then
      begin
        inc(tot);
        if ty = j + 1 then
          begin xx[tot] := i; yy[tot] := j; end
        else
          begin xx[tot] := tx; yy[tot] := ty; end;
      end;
    end;
  writeln(tot);
  for i := 1 to tot do writeln(xx[i],' ',yy[i]);
end;
//
begin
  opf;
  readln(n,p);
  fillchar(map,sizeof(map),true);
  for i := 1 to p do
  begin
    readln(x,y);
    map[x,y] := false;
  end;
  main;
  whole;
  print;
  clf;
end.