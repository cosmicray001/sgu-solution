{
ID: yuhc(020538)
PROG: Sgu223
}
program Sgu223;
var
  f           :array[0..10,0..100,0..1024] of int64;
  n,m,k,i,j,p :longint;
  ans         :int64;
//
procedure opf;
begin
  assign(input,'s223.in');
  reset(input);
  assign(output,'s223.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure dp(t,x,q :integer);
var tt :integer;
begin
  if t > n then
  begin
    f[i+1,j+q,x] := f[i+1,j+q,x] + f[i,j,p];
    exit;
  end;
  dp(t+1,x,q);
  if (x shr (t - 2)) and 1 = 1 then exit;
  x := 1 shl (t - 1) + x;
  if (p and (x shl 1) = 0) and (p and (x shr 1) = 0) and (p and x = 0) then //and ((x shr 1) and tt = 0) then
  dp(t+1,x,q+1);
end;
//
begin
  opf;
  readln(n,k);
  m := 1 shl n - 1;
  fillchar(f,sizeof(f),0);
  f[0,0,0] := 1;
  for i := 0 to n - 1 do
    for j := 0 to k do
      for p := 0 to m do
        if f[i,j,p] > 0 then dp(1,0,0);
  ans := 0;
  for i := 0 to m do
    ans := ans + f[n,k,i];
  writeln(ans);
  clf;
end.
