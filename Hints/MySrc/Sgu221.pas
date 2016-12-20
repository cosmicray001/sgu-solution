{
ID: yuhc(020538)
PROG: Sgu221
}
program Sgu221;
uses math;
type
  ar = array[0..300] of longint;
var
  f,g          :array[0..1,0..2500] of ar;
  a,b          :array[1..50] of integer;
  n,k,m,i,j,i0 :longint;
  c,tot        :ar;
//
procedure opf;
begin
  assign(input,'s221.in');
  reset(input);
  assign(output,'s221.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
function Mult1(a :ar; b :longint) :ar;
var
  i :integer;
begin
  fillchar(c,sizeof(c),0);
  c[0] := a[0];
  for i := 1 to c[0] do c[i] := a[i] * b;
  for i := 1 to c[0] do
  begin
    c[i+1] := c[i+1] + c[i] div 10;
    c[i] := c[i] mod 10;
  end;
  i := c[0] + 1;
  while c[i] > 0 do
  begin
    c[i+1] := c[i] div 10;
    c[i] := c[i] mod 10;
    inc(i);
  end;
  c[0] := i - 1;
  while (c[0] > 1) and (c[c[0]] = 0) do dec(c[0]);
  Mult1 := c;
end;
//
function Mult2(a,b :ar) :ar;
var
  i,j :integer;
begin
  fillchar(c,sizeof(c),0);
  for i := 1 to a[0] do
    for j := 1 to b[0] do
      c[i+j-1] := c[i+j-1] + a[i] * b[j];
  c[0] := a[0] + b[0] - 1;
  for i := 1 to c[0] do
  begin
    c[i+1] := c[i+1] + c[i] div 10;
    c[i] := c[i] mod 10;
  end;
  if c[c[0]+1] > 0 then inc(c[0]);
  while (c[0] > 1) and (c[c[0]] = 0) do dec(c[0]);
  Mult2 := c;
end;
//
function Plus(a,b :ar) :ar;
var
  i :integer;
begin
  fillchar(c,sizeof(c),0);
  c[0] := max(a[0],b[0]);
  for i := 1 to c[0] do
    c[i] := a[i] + b[i];
  for i := 1 to c[0] do
  begin
    c[i+1] := c[i+1] + c[i] div 10;
    c[i] := c[i] mod 10;
  end;
  if c[c[0]+1] > 0 then inc(c[0]);
  Plus := c;
end;
//
begin
  opf;
  readln(n,k);
  if n = 1 then writeln(1)
  else begin
  //
  k := 110;
  a[1] := 1;
  for i := 2 to n do
    if i and 1 = 1 then a[i] := a[i-1] + 2
      else a[i] := a[i-1];
  f[0,0][0] := 1; f[0,0][1] := 1;
  f[1,0][0] := 1; f[1,0][1] := 1;
  f[1,1][0] := 1; f[1,1][1] := 1;
  for i0 := 2 to n do
  begin
    i := i0 and 1;
    for j := 1 to min(a[i0],k) do
      f[i,j] := Plus(f[1-i,j], Mult1(f[1-i,j-1], a[i0] - j + 1));
  end;
  //
  b[1] := 2;
  for i := 2 to n - 1 do
    if i and 1 = 1 then b[i] := b[i-1] + 2
      else b[i] := b[i-1];
  g[0,0][0] := 1; g[0,0][1] := 1;
  g[1,0][0] := 1; g[1,0][1] := 1;
  g[1,1][0] := 1; g[1,1][1] := 2;
  for i0 := 2 to n - 1 do
  begin
    i := i0 and 1;
    for j := 1 to min(b[i0],k) do
      g[i,j] := Plus(g[1-i,j], Mult1(g[1-i,j-1], b[i0] - j + 1));
  end;
  //
  tot[0] := 1; tot[1] := 0;
  for i := 0 to k do
    tot := Plus(tot, Mult2(f[n and 1,i], g[(n-1) and 1,k-i]));
  for i := tot[0] downto 1 do
    write(tot[i]);
  writeln;
  //
  end;
  clf;
end.