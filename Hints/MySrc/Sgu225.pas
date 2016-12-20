{
ID: yuhc(020538)
PROG: Sgu225
}
program Sgu225;
const
  MaxM = 1 shl 10;
var
  f :array[0..10,0..100,0..MaxM,0..MaxM] of longint;
  num :array[0..MaxM] of integer;
  i,j,k,n,m,t,c,c1,c2 :integer;
  ans :longint;
//
procedure opf;
begin
  assign(input,'s225.in');
  reset(input);
  assign(output,'s225.out');
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
  m := 1 shl n - 1;
  for i := 0 to m do
  begin
    t := i;
    num[i] := 0;
    while t > 0 do
    begin
      if t and 1 = 1 then inc(num[i]);
      t := t shr 1;
    end;
  end;
  //
  i := 1;
  for j := 1 to k do dfs(k,0,0);
  i := 2;
  for j := 1 to k do
    for c1 := 0 to m do
      if num[c1] >= j then dfs(j-num[c1],0,c1);
  for i := 3 to n do
    for j := 1 to k do
      for c := 0 to m do
        if num[c] <= j then
          for c1 := 0 to m do
            for c2 := 0 to m do
              f[i,j,c1,c] := f[i,j,c1,c] + f[i-1,j-num[c],c2,c1];
  for i := 0 to m do
    for j := 0 to m do
      ans := ans + f[n+1,k,i,j];
  writeln(ans);
  clf;
end.
