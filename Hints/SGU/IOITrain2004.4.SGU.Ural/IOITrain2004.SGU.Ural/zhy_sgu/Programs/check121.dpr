{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    InFile     = 'p121.in';
    ChkFile    = 'p121.out';
    Limit      = 100;

Type
    Tgraph     = array[1..Limit] of
                   record
                       total  : integer;
                       data   : array[1..Limit] of integer;
                   end;
    Tdata      = array[1..Limit , 1..Limit] of integer;

Var
    graph      : Tgraph;
    data ,
    answer     : Tdata;
    N          : integer;

procedure error;
begin
    writeln('Wrong Answer');
    halt(1);
end;

procedure init;
var
    i , p , j  : integer;
begin
    fillchar(data , sizeof(data) , 0);
    fillchar(answer , sizeof(answer) , 0);
    fillchar(graph , sizeof(graph) , 0);
    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        begin
            read(p);
            while p <> 0 do
              begin
                  inc(graph[i].total);
                  graph[i].data[graph[i].total] := p;
                  data[i , p] := 1;
                  read(p);
              end;
        end;
    Close(INPUT);

    assign(INPUT , ChkFile); ReSet(INPUT);
      for i := 1 to N do
        begin
            for j := 1 to graph[i].total do
              begin
                  read(p);
                  if p = 0 then
                    Error;
                  answer[i , graph[i].data[j]] := p;
              end;
            read(p);
            if p <> 0 then
              error;
        end;
    Close(INPUT);
end;

procedure check;
var
    i , j ,
    sum        : integer;
begin
    for i := 1 to N do
      for j := 1 to N do
        if answer[i , j] <> answer[j , i] then
          error;

    for i := 1 to N do
      begin
          sum := 0;
          for j := 1 to N do
            if answer[i , j] = 1 then
              inc(sum);
          if (graph[i].total > 1) and ((sum = 0) or (sum = graph[i].total)) then
            error;
      end;
end;

Begin
    init;
    check;
    writeln('Accepted');
End.
