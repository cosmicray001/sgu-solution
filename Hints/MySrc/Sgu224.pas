{
ID: yuhc(020538)
PROG: Sgu224
}
program Sgu224;
var
  diagon1,diagon2,horiz,vertic :array[1..20] of boolean;
  n,k,tot :longint;
//
procedure opf;
begin
  assign(input,'s224.in');
  reset(input);
  assign(output,'s224.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure dfs(x,y,k :integer);
begin
  if k = 0 then
  begin inc(tot); exit; end;
  if x > n then exit;
  if y > n then
  begin dfs(x+1,1,k); exit; end;
  if (n - x + 1 < k) or (x = n) and (n - y + 1 < k) then exit;
  dfs(x,y+1,k);
  if diagon1[x+y] and diagon2[x-y+n] and horiz[x] and vertic[y] then
  begin
    diagon1[x+y] := false;
    diagon2[x-y+n] := false;
    horiz[x] := false;
    vertic[y] := false;
    dfs(x,y+1,k-1);
    diagon1[x+y] := true;
    diagon2[x-y+n] := true;
    horiz[x] := true;
    vertic[y] := true;
  end;
end;
//
begin
  opf;
  readln(n,k);
  tot := 0;
  fillchar(diagon1,sizeof(diagon1),true);
  fillchar(diagon2,sizeof(diagon2),true);
  fillchar(horiz,sizeof(horiz),true);
  fillchar(vertic,sizeof(vertic),true);
  dfs(1,1,k);
  writeln(tot);
  clf;
end.
