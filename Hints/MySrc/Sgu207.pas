{
ID: yuhc(020538)
PROG: Sgu207
}
program Sgu207;
var
  k,x,link    :array[1..1000] of integer;
  d           :array[1..1000] of double;
  n,m,y,t,i,j :integer;
  tt          :double;
//
procedure opf;
begin
  assign(input,'s207.in');
  reset(input);
  assign(output,'s207.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
begin
  opf;
  readln(n,m,y);
  for i := 1 to n do read(x[i]);
  for i := 1 to n do
  begin
    k[i] := trunc(m / y * x[i]);
    t := t + k[i];
    d[i] := x[i] / y * m - k[i];
  end;
  m := m - t;
  //
  for i := 1 to n do link[i] := i;
  for i := 1 to n - 1 do
    for j := i + 1 to n do
      if d[i] < d[j] then
      begin
        tt := d[i]; d[i] := d[j]; d[j] := tt;
        t := link[i]; link[i] := link[j]; link[j] := t;
      end;
  //
  for i := 1 to m do
    inc(k[link[i]]);
  //
  for i := 1 to n - 1 do write(k[i],' ');
  writeln(k[n]);
  clf;
end.