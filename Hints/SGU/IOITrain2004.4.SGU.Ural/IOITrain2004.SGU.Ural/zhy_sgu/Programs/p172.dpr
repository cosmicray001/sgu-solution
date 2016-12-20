{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p172.in';
    OutFile    = 'p172.out';
    Limit      = 200;

Type
    Tdata      = array[1..Limit , 1..Limit] of integer;
    Tvisited   = array[1..Limit] of integer;

Var
    data       : Tdata;
    visited ,
    sort       : Tvisited;
    N          : integer;

procedure init;
var
    i , M ,
    p , q      : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      fillchar(data , sizeof(data) , 0);
      read(N , M);
      for i := 1 to M do
        begin
            read(p , q);
            data[p , q] := 1;
            data[q , p] := 1;
        end;
//    Close(INPUT);
end;

procedure NoAnswer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln('no');
//    Close(OUTPUT);
    halt;
end;

procedure dfs(root , color : integer);
var
    i          : integer;
begin
    if visited[root] = 1 then
      if sort[root] <> color then
        NoAnswer
      else
    else
      begin
          visited[root] := 1;
          sort[root] := color;
          for i := 1 to N do
            if data[root , i] = 1 then
              dfs(i , 3 - color);
      end;
end;

procedure work;
var
    i          : integer;
begin
    fillchar(visited , sizeof(visited) , 0);
    fillchar(sort , sizeof(sort) , 0);
    for i := 1 to N do
      if visited[i] = 0 then
        dfs(i , 1);
end;

procedure out;
var
    i , total  : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      total := 0;
      for i := 1 to N do
        if sort[i] = 1 then
          inc(total);

      writeln('yes');
      writeln(total);
      for i := 1 to N do
        if sort[i] = 1 then
          begin
              write(i);
              if total = 1 then
                writeln
              else
                write(' ');
              dec(total);
          end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
