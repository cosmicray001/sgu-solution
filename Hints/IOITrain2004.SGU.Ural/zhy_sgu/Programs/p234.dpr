{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p234.in';
    OutFile    = 'p234.out';
    Limit      = 200;
    dirx       : array[1..4] of longint = (-1 , 1 , 0 , 0);
    diry       : array[1..4] of longint = (0 , 0 , -1 , 1);     

Type
    Tdata      = array[0..Limit + 1 , 0..Limit + 1] of longint;
    Tcover     = array[1..Limit , 1..Limit] of
                   record
                       x , y  : longint;
                   end;
    Tvisited   = array[1..Limit , 1..Limit] of boolean;

Var
    data ,
    ans        : Tdata;
    cover      : Tcover;
    visited    : Tvisited;
    N , M , tot: longint;

procedure init;
var
    i , j      : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      fillchar(data , sizeof(data) , 0);
      readln(N , M);
      tot := 0;
      for i := 1 to N do
        for j := 1 to M do
          begin
              read(data[i , j]);
              inc(tot , data[i , j]);
          end;
//    Close(INPUT);
end;

function dfs(x , y : longint) : boolean;
var
    i , nx , ny: longint;
begin
    visited[x , y] := true;
    if odd(x + y)
      then begin
               dfs := true;
               for i := 1 to 4 do
                 begin
                     nx := x + dirx[i]; ny := y + diry[i];
                     if data[nx , ny] = 1 then
                       if not visited[nx , ny] and dfs(nx , ny) then
                         begin
                             cover[nx , ny].x := x; cover[nx , ny].y := y;
                             cover[x , y].x := nx; cover[x , y].y := ny;
                             exit;
                         end;
                 end;
               dfs := false;
           end
      else if cover[x , y].x = 0
             then dfs := true
             else dfs := dfs(cover[x , y].x , cover[x , y].y);
end;

procedure dfs_color(side , x , y : longint);
var
    i , nx , ny: longint;
begin
    visited[x , y] := true;
    if side = 1
      then begin
               ans[x , y] := 1;
               for i := 1 to 4 do
                 begin
                     nx := x + dirx[i]; ny := y + diry[i];
                     if (data[nx , ny] = 1) and not visited[nx , ny] then
                       dfs_color(1 - side , nx , ny);
                 end;
           end
      else if cover[x , y].x <> 0 then
             dfs_color(1 - side , cover[x , y].x , cover[x , y].y);
end;

procedure work;
var
    i , j      : longint;
begin
    fillchar(cover , sizeof(cover) , 0);
    for i := 1 to N do
      for j := 1 to M do
        if (data[i , j] = 1) and (data[i , j + 1] = 1) and (cover[i , j].x = 0) then
          begin
              cover[i , j].x := i; cover[i , j].y := j + 1;
              cover[i , j + 1].x := i; cover[i , j + 1].y := j;
              dec(tot);
          end;
    for i := 1 to N do
      for j := 1 to M do
        if odd(i + j) and (data[i , j] = 1) and (cover[i , j].x = 0) then
          begin
              fillchar(visited , sizeof(visited) , 0);
              if dfs(i , j) then
                dec(tot);
          end;

    fillchar(ans , sizeof(ans) , 0);
    fillchar(visited , sizeof(visited) , 0);
    for i := 1 to N do
      for j := 1 to M do
        if not visited[i , j] and (data[i , j] = 1) and (cover[i , j].x = 0) then
          dfs_color(1 , i , j);
    for i := 1 to N do
      for j := 1 to M do
        if (data[i , j] = 1) and not visited[i , j] and odd(i + j) then
          ans[i , j] := 1;
end;

procedure out;
var
    i , j      : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(tot);
      for i := 1 to N do
        begin
            for j := 1 to M do
              if data[i , j] = 1
                then if ans[i , j] = 0
                       then write('.')
                       else write('G')
                else write('#');
            writeln;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
