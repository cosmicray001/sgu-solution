{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    InFile     = 'p101.in';
    OutFile    = 'p101.std';
    Limit      = 100;

Type
    Tdata      = array[1..Limit] of
                   record
                       p1 , p2               : integer;
                   end;
    Tcount     = array[0..6] of integer;
    Tgraph     = array[0..6 , 0..6] of integer;
    Tpath      = array[1..Limit] of
                   record
                       number , order        : integer;
                   end;
    Tused      = array[1..Limit] of boolean;
    Tvisited   = array[0..6] of boolean;

Var
    data       : Tdata;
    count      : Tcount;
    path       : Tpath;
    graph      : Tgraph;
    used       : Tused;
    visited    : Tvisited;
    N          : integer;
    noanswer   : boolean;

procedure init;
var
    i          : integer;
begin
    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      for i := 1 to N do
        with data[i] do
          readln(p1 , p2);
    Close(INPUT);
end;

procedure dfs(root : integer);
var
    i          : integer;
begin
    visited[root] := true;
    for i := 0 to 6 do
      if (graph[root , i] > 0) and (not visited[i]) then
        dfs(i);
end;

function check : boolean;
var
    i          : integer;
begin
    fillchar(visited , sizeof(visited) , 0);
    for i := 0 to 6 do
      if count[i] > 0 then
        begin
            dfs(i);
            break;
        end;
    for i := 0 to 6 do
      if (count[i] > 0) and not visited[i] then
        begin
            check := false;
            exit;
        end;
    check := true;
end;

procedure work;
var
    i , p , j ,
    k , oddnum : integer;
begin
    noanswer := false;
    fillchar(count , sizeof(count) , 0);
    fillchar(graph , sizeof(graph) , 0);
    for i := 1 to N do
      begin
          inc(count[data[i].p1]);
          inc(count[data[i].p2]);
          inc(graph[data[i].p1 , data[i].p2]);
          inc(graph[data[i].p2 , data[i].p1]);
      end;

    if not check then
      begin
          noanswer := true;
          exit;
      end;
      
    oddnum := 0;
    for i := 0 to 6 do
      if odd(count[i]) then
        inc(oddnum);

    if oddnum > 2 then
      begin
          noanswer := true;
          exit;
      end;
      
    p := 0;
    while (p <= 6) and not odd(count[p]) do
      inc(p);
    if p > 6 then
      begin
          p := 0;
          while (p <= 6) and (count[p] = 0) do
            inc(p);
      end;

    fillchar(used , sizeof(used) , 0);
    for i := 1 to N do
      for j := 0 to 6 do
        if graph[p , j] > 0 then
          begin
              dec(graph[p , j]);
              dec(graph[j , p]);
              dec(count[p]); dec(count[j]);
              if check and ((i = N) or (count[j] <> 0))  then
                begin
                    for k := 1 to N do
                      if not used[k] and ((data[k].p1 = j) and (data[k].p2 = p) or (data[k].p1 = p) and (data[k].p2 = j)) then
                        begin
                            if (data[k].p1 = p) and (data[k].p2 = j) then
                              path[i].order := 1
                            else
                              path[i].order := -1;
                            p := j;
                            used[k] := true;
                            path[i].number := k;
                            break;
                        end;
                    break;
                end
              else
                begin
                    inc(graph[p , j]);
                    inc(graph[j , p]);
                    inc(count[p]); inc(count[j]);
                end;
          end;
end;

procedure out;
var
    i          : integer;
begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln('No solution')
      else
        for i := 1 to N do
          begin
              write(path[i].number , ' ');
              if path[i].order > 0 then
                writeln('+')
              else
                writeln('-');
          end;
    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
