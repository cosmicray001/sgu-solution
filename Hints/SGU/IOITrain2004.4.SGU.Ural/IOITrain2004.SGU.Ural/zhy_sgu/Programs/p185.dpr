{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p185.in';
    OutFile    = 'p185.out';
    Limit      = 400;
    Maximum    = 40000000;

Type
    Tdata      = array[1..Limit , 1..Limit] of longint;
    Tnums      = array[1..Limit , 1..Limit] of byte;
    Tshortest  = array[1..Limit] of longint;
    Tvisited   = array[1..Limit] of boolean;

Var
    C , F      : Tnums; 
    data       : Tdata;
    shortest   : Tshortest;
    visited    : Tvisited;
    answer     : boolean;
    N          : longint;

procedure init;
var
    M , p1 , p2 ,
    L , i      : longint;
begin
    fillchar(data , sizeof(data) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(p1 , p2 , L);
            data[p1 , p2] := L;
            data[p2 , p1] := L;
        end;
//    Close(INPUT);
end;

procedure Dijkstra;
var
    i , j , min: longint;
begin
    fillchar(visited , sizeof(visited) , 0);
    fillchar(shortest , sizeof(shortest) , $7F);
    shortest[1] := 0;
    for i := 1 to N do
      begin
          min := 0;
          for j := 1 to N do
            if not visited[j] then
              if (min = 0) or (shortest[j] < shortest[min]) then
                min := j;

          if shortest[min] > maximum then exit;
          visited[min] := true;

          for j := 1 to N do
            if not visited[j] and (data[min , j] <> 0) and (shortest[j] > shortest[min] + data[min , j]) then
              shortest[j] := shortest[min] + data[min , j];
      end;
end;

procedure Build_Graph;
var
    i , j      : longint;
begin
    fillchar(C , sizeof(C) , 0);
    for i := 1 to N do
      for j := 1 to N do
        if (i <> j) and (data[i , j] <> 0) and (shortest[i] + data[i , j] = shortest[j]) then
          C[i , j] := 1;
end;

function dfs(root : longint) : boolean;
var
    i          : longint;
begin
    dfs := false;
    if visited[root] then exit;
    visited[root] := true;
    if root = N
      then dfs := true
      else begin
               for i := 1 to N do
                 if (C[root , i] - F[root , i] = 1) or (F[i , root] = 1) then
                   if dfs(i) then
                     begin
                         dfs := true;
                         if F[i , root] = 1
                           then F[i , root] := 0
                           else inc(F[root , i]);
                     end;
           end;
end;

procedure work;
begin
    answer := false;
    Dijkstra;
    if not visited[N] then exit;

    Build_Graph;
    fillchar(F , sizeof(F) , 0);

    fillchar(visited , sizeof(visited) , 0);
    if not dfs(1) then exit;
    fillchar(visited , sizeof(visited) , 0);
    if not dfs(1) then exit;

    answer := true;
end;

procedure print_path(root : longint);
var
    i          : longint;
begin
    if root = N
      then writeln(root)
      else begin
               write(root , ' ');
               for i := 1 to N do
                 if F[root , i] = 1 then
                   begin
                       dec(F[root , i]);
                       print_path(i);
                       exit;
                   end;
           end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer
        then begin
                 print_path(1);
                 print_path(1);
             end
        else writeln('No solution');
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
