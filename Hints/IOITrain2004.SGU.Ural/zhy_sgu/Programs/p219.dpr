{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p219.in';
    OutFile    = 'p219.out';
    Limit      = 1000;

Type
    Tdata      = array[1..Limit , 1..Limit] of longint;
    Tnum       = array[1..Limit] of longint;
    Tpath      = record
                     total    : longint;
                     data     : array[1..Limit] of longint;
                 end;

Var
    data , map : Tdata;
    visited ,
    color ,
    noenergy ,
    ans        : Tnum;
    path       : Tpath;
    N , C , T  : longint;

procedure init;
var
    M , i ,
    p1 , p2 , V: longint;
begin
    fillchar(data , sizeof(data) , $FF);
    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(p1 , p2 , V);
            if data[p1 , p2] = -1
              then data[p1 , p2] := V
              else if data[p1 , p2] > V
                     then data[p1 , p2] := V;
        end;
    Close(INPUT);
end;

procedure dfs_positive(p : longint);
var
    i          : longint;
begin
    visited[p] := T;
    for i := 1 to N do
      if (data[p , i] <> -1) and (color[i] = 0) and (visited[i] <> T) then
        dfs_positive(i);
    inc(path.total); path.data[path.total] := p;
end;

procedure dfs_negative(p : longint);
var
    i          : longint;
begin
    color[p] := C;
    for i := 1 to N do
      if (data[i , p] <> -1) and (visited[i] = T) and (color[i] = 0) then
        dfs_negative(i);
end;

function dfs_find_circle(p , cl : longint) : boolean;
var
    i          : longint;
begin
    if visited[p] = 0
      then visited[p] := T
      else begin
               dfs_find_circle := true;
               noenergy[cl] := 1;
               exit;
           end;
    dfs_find_circle := false;
    for i := 1 to N do
      if (color[i] = cl) and (data[p , i] = 0) and ((visited[i] = T) or (visited[i] = 0))  then
        if dfs_find_circle(i , cl) then
          begin
              dfs_find_circle := true;
              exit;
          end;
end;

procedure dfs(p : longint);
var
    i          : longint;
begin
    for i := 1 to C do
      if (map[p , i] = 1) and (noenergy[i] = 0) then
        begin
            noenergy[i] := 1;
            dfs(i);
        end;
end;

procedure work;
var
    i , j      : longint;
begin
    fillchar(color , sizeof(color) , 0);
    fillchar(visited , sizeof(visited) , 0);
    C := 0; T := 0;
    for i := 1 to N do
      if color[i] = 0 then
        begin
            inc(T);
            path.total := 0;
            dfs_positive(i);
            for j := path.total downto 1 do
              if color[path.data[j]] = 0 then
                begin
                    inc(C);
                    dfs_negative(path.data[j]);
                end;
        end;

    fillchar(visited , sizeof(visited) , 0);
    fillchar(noenergy , sizeof(noenergy) , 0);
    T := 0;
    for i := 1 to N do
      if visited[i] = 0 then
        begin
            inc(T);
            dfs_find_circle(i , color[i]);
        end;

    fillchar(map , sizeof(map) , 0);
    for i := 1 to N do
      for j := 1 to N do
        if (color[i] <> color[j]) and (data[i , j] <> -1) then
          map[color[i] , color[j]] := 1;

    for i := 1 to C do
      if noenergy[i] = 1 then
        dfs(i);

    fillchar(ans , sizeof(ans) , 0);
    for i := 1 to N do
      ans[i] := 1 - noenergy[color[i]];
end;

procedure out;
var
    i          : longint;              
begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(c);
      for i := 1 to N do
        writeln(ans[i]);
    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
