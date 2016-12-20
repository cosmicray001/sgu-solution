{
ID: yuhc(020538)
PROG: Sgu231
}
program Sgu231;
const
  MaxAns = 8169;
  MaxP   = 78498;
var
  bj        :array[1..1000000] of boolean;
  prime     :array[1..MaxP] of longint;
  x         :array[1..MaxAns] of longint;
  n,p,i,tot :longint;
//
procedure opf;
begin
  assign(input,'s231.in');
  reset(input);
  assign(output,'s231.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure MakePrime;
var
  i,t :longint;
begin
  fillchar(bj,sizeof(bj),true);
  for i := 2 to n do
    if bj[i] then
    begin
      t := i shl 1;
      while t <= n do
      begin
        bj[t] := false;
        inc(t,i);
      end;
    end;
  p := 0;
  for i := 2 to n do
    if bj[i] then
    begin
      inc(p);
      prime[p] := i;
    end;
end;
//
begin
  opf;
  readln(n);
  MakePrime;
  tot := 0;
  for i := 2 to p do
  begin
    if 2 + prime[i] > n then break;
    if bj[2 + prime[i]] then
    begin
      inc(tot);
      x[tot] := prime[i];
    end;
  end;
  writeln(tot);
  for i := 1 to tot do
    writeln(2,' ',x[i]);
  clf;
end.