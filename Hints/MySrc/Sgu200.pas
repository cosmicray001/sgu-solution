{
ID: yuhc(020538)
PROG: Sgu200
}
program Sgu200;
var
  n,m   :integer;
  prime :array[1..100] of integer;
  a     :array[1..100,1..100] of integer;
  ans   :array[0..100] of longint;
//
procedure opf;
begin
  assign(input,'s200.in');
  reset(input);
  assign(output,'s200.out');
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
  p,x,i,j :integer;
  bj      :boolean;
begin
  readln(n,m);
  p := 0;
  for i := 2 to 1000 do
  begin
    x := i;
    bj := false;
    for j := 2 to trunc(sqrt(i)) do
      if i mod j = 0 then
      begin bj := true; break; end;
    if not bj then
    begin
      inc(p);
      prime[p] := i;
    end;
    if p = n then break;
  end;
  //
  fillchar(a,sizeof(a),0);
  for i := 1 to m do
  begin
    read(x);
    for j := 1 to n do
      while x mod prime[j] = 0 do
      begin
        x := x div prime[j];
        a[j,i] := 1 - a[j,i];
      end;
  end;
end;
//
function find(i :integer; var p1,p2 :integer) :boolean;
var
  j,k :integer;
begin
  for j := i to n do
    for k := i to m do
      if a[j,k] = 1 then
      begin
        p1 := j; p2 := k;
        find := true;
        exit;
      end;
  find := false;
end;
//
procedure swap_line(p1,p2 :integer);
var
  i,tmp :integer;
begin
  for i := 1 to m do
  begin
    tmp := a[p1,i]; a[p1,i] := a[p2,i]; a[p2,i] := tmp;
  end;
end;
//
procedure swap_col(p1,p2 :integer);
var
  i,tmp :integer;
begin
  for i := 1 to n do
  begin
    tmp := a[i,p1]; a[i,p1] := a[i,p2]; a[i,p2] := tmp;
  end;
end;
//
function Gauss :integer;
var
  i,j,k,p1,p2 :integer;
begin
  i := 1;
  while (i <= n) and (i <= m) do
  begin
    if not find(i,p1,p2) then break;
    swap_line(i,p1);
    swap_col(i,p2);
    for p1 := i + 1 to n do
      if a[p1,i] = 1 then
        for p2 := i to m do
          a[p1,p2] := a[p1,p2] xor a[i,p2];
    inc(i);
  end;
  Gauss := m - i + 1;
end;
//
procedure Mul;
var
  i :integer;
begin
  for i := 1 to ans[0] do
    ans[i] := ans[i] shl 1;
  for i := 1 to ans[0] do
  begin
    ans[i+1] := ans[i+1] + ans[i] div 10;
    ans[i] := ans[i] mod 10;
  end;
  if ans[ans[0]+1] > 0 then inc(ans[0]);
end;
//
procedure Minus;
var
  i :integer;
begin
  dec(ans[1]);
  for i := 1 to ans[0] do
    if ans[i] < 0 then
    begin
      ans[i] := ans[i] + 10;
      dec(ans[i+1]);
    end;
  if ans[ans[0]] = 0 then dec(ans[0]);
  if ans[0] = 0 then ans[0] := 1;
end;
//
procedure print(x :integer);
var
  i :integer;
begin
  ans[0] := 1; ans[1] := 1;
  for i := 1 to x do Mul;
  Minus;
  for i := ans[0] downto 1 do
    write(ans[i]);
  writeln;
end;
//
begin
  opf;
  init;
  print(Gauss);
  clf;
end.
