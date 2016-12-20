{
ID: yuhc(020538)
PROG: Sgu210
}
program Sgu210;
var
  lx,ly,link,a :array[1..400] of integer;
  g            :array[1..400,1..400] of boolean;
  bj           :array[1..400] of boolean;
  n,i,j,t,k    :integer;
//
procedure opf;
begin
  assign(input,'s210.in');
  reset(input);
  assign(output,'s210.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
function hungary(v :integer) :boolean;
var
  i :integer;
begin
  for i := 1 to n do
    if g[v,i] and (not bj[i]) then
    begin
      bj[i] := true;
      if (ly[i] = 0) or hungary(ly[i]) then
      begin
        ly[i] := v;
        lx[v] := i;
        hungary := true;
        exit;
      end;
    end;
  hungary := false;
end;
//
begin
  opf;
  readln(n);
  for i := 1 to n do read(a[i]); readln;
  fillchar(g,sizeof(g),false);
  for i := 1 to n do
  begin
    read(k);
    for j := 1 to k do
    begin
      read(t);
      g[i,t] := true;
    end;
    readln;
  end;
  //
  for i := 1 to n do link[i] := i;
  for i := 1 to n - 1 do
    for j := i + 1 to n do
      if a[i] < a[j] then
      begin
        t := a[i]; a[i] := a[j]; a[j] := t;
        t := link[i]; link[i] := link[j]; link[j] := t;
      end;
  //
  fillchar(ly[i],sizeof(ly[i]),0);
  for i := 1 to n do
  begin
    fillchar(bj,sizeof(bj),false);
    if hungary(link[i]) then;
  end;
  for i := 1 to n - 1 do write(lx[i],' ');
  writeln(lx[n]);
  clf;
end.