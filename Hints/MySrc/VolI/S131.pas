{
ID: yuhc(020538)
PROG: hardwood
LANG: PASCAL
}
program hardwood;
var
  f        :array[0..9,0..511] of int64;
  i,j,N,M  :integer;

//
procedure opf;
begin
  assign(input,'hardwood.in');
  reset(input);
  assign(output,'hardwood.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure dfs(line,step,high,low,highlast,lowlast :integer);
begin
  if step > M then
  begin
    if highlast + lowlast = 0 then
      f[line][low] := f[line][low] + f[line - 1][high];
    exit;
  end;

  // Put A *   B * *   C * *   D * *   E   *   F *
  //       *             *         *     * *     * *

  if (highlast = 0) and (lowlast = 0) then
  begin
    dfs(line , step + 1 , high shl 1 , low shl 1 + 1, 1 , 0);
    dfs(line , step + 1 , high shl 1 , low shl 1 + 1, 0 , 1);
    dfs(line , step + 1 , high shl 1 , low shl 1 + 1, 0 , 0);
  end;

  if lowlast = 0 then
  begin
    dfs(line , step + 1 , high shl 1 + 1 - highlast , low shl 1 + 1, 0 , 1);
    dfs(line , step + 1 , high shl 1 + 1 - highlast , low shl 1 + 1, 1 , 1);
  end;

  if highlast = 0 then
    dfs(line , step + 1 , high shl 1 , low shl 1 + lowlast , 1 , 1);

  dfs(line , step + 1 , high shl 1 + 1 - highlast , low shl 1 + lowlast , 0 , 0);
end;
//
procedure print;
begin
  writeln(f[N,1 shl M - 1]);
end;
//
begin
  opf;
  readln(N,M);
  fillchar(f,sizeof(f),0);
  f[0][1 shl M - 1] := 1;
  for i := 1 to n do
    dfs(i,1,0,0,0,0);
  print;
  clf;
end.
