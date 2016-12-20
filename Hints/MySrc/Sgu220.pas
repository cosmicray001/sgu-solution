{
ID: yuhc(020538)
PROG: Sgu220
}
program Sgu220;
uses math;
var
  f,g       :array[1..50,0..2500] of int64;
  a,b       :array[1..50] of integer;
  n,k,m,i,j :longint;
  tot       :int64;
//
procedure opf;
begin
  assign(input,'s220.in');
  reset(input);
  assign(output,'s220.out');
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
  readln(n,k);
  if n = 1 then writeln(1)
  else begin
  //
  a[1] := 1;
  for i := 2 to n do
    if i and 1 = 1 then a[i] := a[i-1] + 2
      else a[i] := a[i-1];
  for i := 1 to n do f[i,0] := 1;
  f[1,1] := 1;
  for i := 2 to n do
    for j := 1 to min(a[i],k) do
      f[i,j] := f[i-1,j] + f[i-1,j-1] * (a[i] - j + 1);
  //
  b[1] := 2;
  for i := 2 to n - 1 do
    if i and 1 = 1 then b[i] := b[i-1] + 2
      else b[i] := b[i-1];
  for i := 1 to n - 1 do g[i,0] := 1;
  g[1,1] := 2;
  for i := 2 to n - 1 do
    for j := 1 to min(b[i],k) do
      g[i,j] := g[i-1,j] + g[i-1,j-1] * (b[i] - j + 1);
  //
  tot := 0;
  for i := 0 to k do
    tot := tot + f[n,i] * g[n-1,k-i];
  writeln(tot);
  //
  end;
  clf;
end.