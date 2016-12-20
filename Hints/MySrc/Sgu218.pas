{
ID: yuhc(020538)
PROG: Sgu218
}
program Sgu218;
const
  oo   = 1000000;
  MaxN = 500;
var
  w             :array[1..MaxN,1..MaxN] of longint;
  n,i,j,l,r,min :longint;
  c             :array[1..MaxN] of boolean;
  lx,ly,ans     :array[1..MaxN] of integer;
//
procedure opf;
begin
  assign(input,'s218.in');
  reset(input);
  assign(output,'s218.out');
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
    if (not c[i]) and (w[v,i] <= min) then
    begin
      c[i] := true;
      if (ly[i] = 0) or (hungary(ly[i])) then
      begin
        lx[v] := i;
        ly[i] := v;
        exit(true);
      end;
  end;
  exit(false);
end;
//
function success :boolean;
var
  i,max :integer;
begin
  max := 0;
  fillchar(ly,sizeof(ly),0);
  for i := 1 to n do
  begin
    fillchar(c,sizeof(c),false);
    if hungary(i) then inc(max)
      else break;
  end;
  if max = n then
  begin
    ans := lx;
    success := true;
  end
  else success := false;
end;
//
begin
  opf;
  readln(n);
  for i := 1 to n do
    for j := 1 to n do
    begin
      read(w[i,j]);
      inc(w[i,j],oo);
    end;
  l := 0; r := oo shl 1; min := (l + r) shr 1;
  while l < r do
  begin
    if success then r := min
      else l := min + 1;
    min := (l + r) shr 1;
  end;
  writeln(min-oo);
  for i := 1 to n do
    writeln(i,' ',ans[i]);
  clf;
end.