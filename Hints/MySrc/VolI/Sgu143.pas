{
ID: yuhc(020538)
PROG: queen
LANG: PASCAL
}
program queen;
const
  Limit = 16000;
var
  w,index    :array[1..Limit] of longint;
  edge       :array[1..Limit shl 1,1..2] of longint;
  bj         :array[1..Limit] of boolean;
  n,i,m,ans  :longint;
//
procedure opf;
begin
  assign(input,'queen.in');
  reset(input);
  assign(output,'queen.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure qsort(l,r :longint);
var
  i,j,mid,t :longint;
begin
  i := l; j := r;
  mid := edge[(i + j) shr 1][1];
  repeat
    while edge[i][1] < mid do inc(i);
    while edge[j][1] > mid do dec(j);
    if i <= j then
    begin
      t := edge[i][1]; edge[i][1] := edge[j][1]; edge[j][1] := t;
      t := edge[i][2]; edge[i][2] := edge[j][2]; edge[j][2] := t;
      inc(i); dec(j);
    end;
  until i > j;
  if i < r then qsort(i,r);
  if j > l then qsort(l,j);
end;
//
function TreeDp(v :longint) :longint;
var
  sum,i,t :longint;
begin
  bj[v] := true;
  sum := w[v];
  for i := index[v] to index[v+1] - 1 do
    if not bj[edge[i][2]] then
    begin
      t := TreeDp(edge[i][2]);
      if t > ans then ans := t;
      if t > 0 then inc(sum,t);
    end;
  TreeDp := sum;
  if sum > ans then ans := sum;
end;
//
begin
  opf;
  readln(n);
  for i := 1 to n do read(w[i]); readln;
  for i := 1 to n - 1 do
  begin
    readln(edge[i][1],edge[i][2]);
    edge[i+n-1][1] := edge[i][2];
    edge[i+n-1][2] := edge[i][1];
  end;
  m := (n - 1) shl 1;
  qsort(1,m);
  for i := m downto 1 do
    index[edge[i][1]] := i;
  index[n+1] := m + 1;
  fillchar(bj,sizeof(bj),false);
  ans := -maxlongint;
  TreeDp(1);
  writeln(ans);
  clf;
end.