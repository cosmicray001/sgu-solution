{
ID: yuhc(020538)
PROG: Sgu195
}
{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
{$MINSTACKSIZE $04000000}
{$MAXSTACKSIZE $04000000}
program Sgu195;
const
  MaxN   = 500001;
type
  Node   = ^Tpoint;
  Tpoint = record
    v    :longint;
    next :Node;
  end;
var
  f         :array[1..MaxN,0..1] of longint;
  ans,BestV :array[0..MaxN] of longint;
  child     :array[1..MaxN] of Node;
  hash      :array[1..MaxN] of boolean;
  n,i       :longint;
//
procedure opf;
begin
  assign(input,'s195.in');
  reset(input);
  assign(output,'s195.out');
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
  i,t  :longint;
  temp :Node;
begin
  readln(n);
  for i := 1 to n do
  begin
    new(child[i]);
    child[i] := NIL;
  end;
  for i := 2 to n do
  begin
    read(t);
    new(temp);
    temp^.next := child[t];
    temp^.v := i;
    child[t] := temp;
  end;
  ans[0] := 0;
  fillchar(hash,sizeof(hash),false);
end;
//
procedure TreeDp(k :longint);
var
  i          :Node;
  t,max,maxv :longint;
begin
  f[k][1] := 1; f[k][0] := 0;
  i := child[k];
  max := 0; t := 0;
  while i <> NIL do
  begin
    t := i^.v;
    TreeDp(t);
    f[k][1] := f[k][1] + f[t][0];
    f[k][0] := f[k][0]+ f[t][0];
    if f[t][1] - f[t][0] > max then
    begin
      maxv := t;
      max := f[t][1] - f[t][0];
    end;
    i := i^.next;
  end;
  f[k][0] := f[k][0] + max;
  BestV[k] := maxv;
end;
//
procedure get(k,c :longint);
var
  i  :Node;
  t  :longint;
begin
  hash[k] := c = 1;
  i := child[k];
  while i <> NIL do
  begin
    t := i^.v;
    if hash[k] then get(t,0)
     else
      if t = BestV[k] then get(t,1)
        else get(t,0);
    i := i^.next;
  end;
end;
//
begin
  opf;
  init;
  TreeDp(1);
  writeln(f[1][0] * 1000);
  get(1,0);
  for i := 1 to n do
    if hash[i] then
    begin
      inc(ans[0]);
      ans[ans[0]] := i;
    end;
  for i := 1 to ans[0] - 1 do write(ans[i],' ');
  writeln(ans[ans[0]]);
  clf;
end.