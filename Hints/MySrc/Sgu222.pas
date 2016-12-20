{
ID: yuhc(020538)
PROG: Sgu222
}
program Sgu222;
var
  f       :array[1..10,0..100] of longint;
  n,k,i,j :integer;
//
begin
  readln(n,k);
  for i := 1 to n do f[i,0] := 1;
  f[1,1] := n;
  for i := 2 to n do
    for j := 1 to k do
      f[i,j] := f[i-1,j] + f[i-1,j-1] * (n - j + 1);
  writeln(f[n,k]);
end.
