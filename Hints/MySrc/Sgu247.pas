{
ID: yuhc(020538)
PROG: Sgu247
Ans = [C(2p,p)/p]+2
}
program Sgu247;
type
  arx   =array[0..1000] of longint;
var
  ct    :array[1..1000] of arx;
  c     :arx;
  n,p,i :integer;
//
procedure opf;
begin
  assign(input,'s247.in');
  reset(input);
  assign(output,'s247.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure relax(i :integer);
begin
  c[i+1] := c[i+1] + c[i] div 10;
  c[i] := c[i] mod 10;
end;
//
procedure Multi(b :integer);
var
  i :integer;
begin
  for i := 1 to c[0] do
    c[i] := c[i] * b;
  for i := 1 to c[0] do relax(i);
  i := c[0] + 1;
  while c[i] > 0 do
  begin
    relax(i);
    inc(i);
  end;
  c[0] := i - 1;
end;
//
procedure Divide(b :integer);
var
  i :integer;
begin
  for i := c[0] downto 2 do
  begin
    c[i-1] := c[i-1] + (c[i] mod b) * 10;
    c[i] := c[i] div b;
  end;
  c[1] := c[1] div b;
  while c[c[0]] = 0 do dec(c[0]);
end;
//
procedure Plus;
var
  i :integer;
begin
  c[1] := c[1] + 2;
  for i := 1 to c[0] do relax(i);
  if c[c[0]+1] > 0 then inc(c[0]);
end;
//
procedure print;
var
  i :integer;
begin
  for i := c[0] downto 2 do write(c[i]);
  writeln(c[1]);
end;
//
procedure prework;
var
  i,j :integer;
begin
  fillchar(c,sizeof(c),0);
  c[0] := 1; c[1] := 1;
  j := 1;
  for i := 1 to 1000 do
  begin
    Multi(i shl 1);
    Multi(i shl 1 - 1);
    Divide(i shl 1 - j);
    Divide(j);
    inc(j);
    ct[i] := c;
  end;
end;
//
begin
  opf;
  prework;
  readln(n);
  repeat
    readln(p);
    c := ct[p];
    Divide(p);
    Plus;
    print;
    dec(n);
  until n = 0;
  clf;
end.