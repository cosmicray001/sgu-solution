{
Submit 1: WA on #1     Treap的一个等号取反了
Submit 2: CE           评测语言选成了Cpp
Submit 3: TLE on #15   Treap
Submit 4: WA on #1     O(N)笛卡尔树建立算法
Submit 5: WA on #1     忘记恢复原序了
Submit 6: AC
Writeln on 2009/03/15
}
program Cartesian_Tree;
var
  left,right,key,root  :array[0..50000] of longint;
  kk,aa,c,pr,pl,pri    :array[0..50000] of longint;
  n,k,v,t,buttom       :longint;
//
procedure qsort(l,r :longint);
var
  i,j,mid :longint;
begin
  i := l; j := r; mid := kk[random(j-i+1) + i];
  repeat
    while kk[i] < mid do inc(i);
    while kk[j] > mid do dec(j);
    if i <= j then
    begin
      t := kk[i]; kk[i] := kk[j]; kk[j] := t;
      t := aa[i]; aa[i] := aa[j]; aa[j] := t;
      t := c[i]; c[i] :=c[j]; c[j] := t;
      inc(i); dec(j);
    end;
  until i > j;
  if i < r then qsort(i,r);
  if j > l then qsort(l,j);
end;
//
procedure left_rotate(var v :longint);
begin
  k := right[v];
  root[k]:= root[v];
  right[root[v]] := k;
  right[v] := left[k];
  root[left[k]] := v;
  left[k] := v;
  root[v] := k;
  v := root[k];
end;
//
procedure inital;
var
  i,k,a :longint;
begin
  assign(input,'tree.in');
  reset(input);
  fillchar(left,sizeof(left),0);
  fillchar(right,sizeof(right),0);
  v := 0;
  root[1] := 0;
  right[0] := 1;
  readln(n);
  for i := 1 to n do readln(kk[i],aa[i]);
  for i := 1 to n do c[i] := i;
  qsort(1,n);
  buttom := 1;
  for i := 2 to n do
  begin
    while right[buttom] <> 0 do buttom := right[buttom];
    v := buttom;
    right[v] := i;
    root[i] := v;
    while (v <> 0) and (aa[v] > aa[right[v]]) do
      left_rotate(v);
    buttom := v;
  end;
  close(input);
end;
//
procedure print;
var
  i :longint;
begin
  assign(output,'tree.out');
  rewrite(output);
  writeln('YES');
  for i := 1 to n do
  begin
    pr[c[i]] := c[root[i]];
    pl[c[i]] := c[left[i]];
    pri[c[i]] := c[right[i]];
  end;
  for i := 1 to n do
    writeln(pr[i],' ',pl[i],' ',pri[i]);
  close(output);
end;
//
begin
  inital;
  print;
end.