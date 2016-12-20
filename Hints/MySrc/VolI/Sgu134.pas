{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
{
ID: yuhc(020538)
PROG: Sgu134 Centroid
LANG: PASCAL
}
program Centroid;
const
  Limit = 16000;
var
  e                 :array[1..Limit shl 1,1..2] of integer;
  sum,Num,index     :array[1..Limit+1] of integer;
  bj                :array[1..Limit] of boolean;
  n,TotNum,min,m,i  :integer;
//
procedure opf;
begin
  assign(input,'centroid.in');
  reset(input);
  assign(output,'centroid.out');
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
  i :integer;
begin
  readln(n);
  for i := 1 to n - 1 do
  begin
    readln(e[i][1],e[i][2]);
    e[i+n-1][1] := e[i][2];
    e[i+n-1][2] := e[i][1];
  end;
end;
//
procedure qsort(l,r :integer);
var
  i,j,mid,t :integer;
begin
  i := l; j := r;
  mid := e[random(j-i+1) + i][1];
  repeat
    while e[i][1] < mid do inc(i);
    while e[j][1] > mid do dec(j);
    if i <= j then
    begin
      t := e[i][1]; e[i][1] := e[j][1]; e[j][1] := t;
      t := e[i][2]; e[i][2] := e[j][2]; e[j][2] := t;
      inc(i); dec(j);
    end;
  until i > j;
  if i < r then qsort(i,r);
  if j > l then qsort(l,j);
end;
//
procedure qsortNum(l,r :integer);
var
  i,j,mid,t :integer;
begin
  i := l; j := r;
  mid := Num[random(j-i+1) + i];
  repeat
    while Num[i] < mid do inc(i);
    while Num[j] > mid do dec(j);
    if i <= j then
    begin
      t := Num[i]; Num[i] := Num[j]; Num[j] := t;
      inc(i); dec(j);
    end;
  until i > j;
  if i < r then qsort(i,r);
  if j > l then qsort(l,j);
end;
//
procedure dfs(root :integer);
var
  i,t,s :integer;
begin
  t := 0;
  s := 0;
  bj[root] := true;
  for i := index[root] to index[root+1] - 1 do
    if not bj[e[i][2]] then
    begin
      dfs(e[i][2]);
      if sum[e[i][2]] > s then
        s := sum[e[i][2]];
      inc(t,sum[e[i][2]]);
    end;
  sum[root] := t + 1;
  //
  if n - sum[root] > s then
    s := n - sum[root];
  if s < min then
  begin
    min := s;
    TotNum := 1;
    Num[1] := root;
  end else
  if s = min then
  begin
    inc(TotNum);
    Num[TotNum] := root;
  end;
end;
//
procedure print;
var
  i :integer;
begin
  writeln(min,' ',TotNum);
  qsortNum(1,TotNum);
  for i := 1 to TotNum - 1 do
    write(Num[i],' ');
  writeln(Num[TotNum]);
end;
//
begin
  opf;
  init;
  m := (n - 1) shl 1;
  qsort(1,m);
  for i := m downto 1 do
    index[e[i][1]] := i;
  index[n+1] := m + 1;
  fillchar(bj,sizeof(bj),false);
  fillchar(sum,sizeof(sum),0);
  min := maxint;
  dfs(1);
  print;
  clf;
end.
