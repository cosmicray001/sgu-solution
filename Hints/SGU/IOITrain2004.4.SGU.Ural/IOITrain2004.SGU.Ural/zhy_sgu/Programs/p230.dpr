{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p230.in';
    OutFile    = 'p230.out';
    Limit      = 100;

Type
    Tgraph     = array[1..Limit , 1..Limit] of boolean;
    Tvisited   = array[1..Limit] of boolean;
    Tdegree    = array[1..Limit] of longint;
    Tpath      = record
                     tot      : longint;
                     data     : array[1..Limit] of longint;
                 end;

Var
    graph      : Tgraph;
    visited    : Tvisited;
    degree     : Tdegree;
    path       : Tpath;
    N          : longint;

procedure init;
var
    M , i ,
    p1 , p2    : longint;
begin
    fillchar(visited , sizeof(visited) , 0);
    fillchar(degree , sizeof(degree) , 0);
    fillchar(graph , sizeof(graph) , 0);
    fillchar(path , sizeof(path) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(p1 , p2);
            if not graph[p1 , p2] then
              inc(degree[p2]);
            graph[p1 , p2] := true;
        end;
//    Close(INPUT);
end;

procedure work;
var
    i , j ,
    find       : longint;
begin
    for i := 1 to N do
      begin
          find := 0;
          for j := 1 to N do
            if not visited[j] and (degree[j] = 0) then
              begin
                  find := j;
                  break;
              end;
          if find = 0 then exit;
          visited[find] := true;
          inc(path.tot);
          path.data[path.tot] := find;
          for j := 1 to N do
            if not visited[j] and graph[find , j] then
              dec(degree[j]);
      end;
end;

procedure out;
var
    i          : longint;
    num        : Tdegree;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if path.tot < N
        then writeln('No solution')
        else begin
                 for i := 1 to N do
                   num[path.data[i]] := i;
                 for i := 1 to N do
                   write(num[i] , ' ');
                 writeln;
             end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
