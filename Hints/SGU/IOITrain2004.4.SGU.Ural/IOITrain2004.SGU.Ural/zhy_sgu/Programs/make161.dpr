{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
Const
    OutFile    = 'p161.in';
    Limit      = 6;
    LimitP     = 10;
    LimitEle   = 5;
    LimitC     = 4;

Type
    Tgraph     = array[1..Limit , 1..Limit] of boolean;
    Tpath      = array[1..LimitP] of
                   record
                       p1 , p2               : integer;
                   end;

Var
    graph      : Tgraph;
    path       : Tpath;

procedure floyd;
var
    i , j , k  : integer;
begin
    for i := 1 to Limit do
      graph[i , i] := true;
    for k := 1 to Limit do
      for i := 1 to Limit do
        for j := 1 to Limit do
          graph[i , j] := graph[i , j] or graph[i , k] and graph[k , j];
end;

procedure make_graph;
var
    i , p1 , p2: integer;
begin
    fillchar(graph , sizeof(graph) , 0);
    floyd;
    for i := 1 to LimitP do
      begin
          repeat
            p1 := random(Limit) + 1; p2 := random(Limit) + 1;
          until not graph[p2 , p1];
          graph[p1 , p2] := true;
          path[i].p1 := p1;
          path[i].p2 := p2;
          floyd;
      end;
end;

procedure out_ele;
begin
    if random(2) = 0 then
      write('~');
    write(chr(random(LimitC) + 65));
end;

procedure out;
var
    i , t , j  : integer;
begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(Limit , ' ' , LimitP);
      for i := 1 to LimitP do
        writeln(path[i].p1 , ' ' , path[i].p2);
      writeln(20);
      for j := 1 to 20 do
        begin
            out_ele;
            for i := 1 to LimitEle do
              begin
                  t := random(4);
                  case t of
                    1               : write('|');
                    2               : write('&');
                    3               : write('=>');
                    0               : write('=');
                  end;
                  out_ele;
              end;
            writeln;
        end;
    Close(OUTPUT);
end;

Begin
    randomize;
    make_graph;
    out;
End.
