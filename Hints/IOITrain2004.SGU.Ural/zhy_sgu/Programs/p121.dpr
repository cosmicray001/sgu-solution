{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    InFile     = 'p121.in';
    OutFile    = 'p121.out';
    Limit      = 100;
    firstcolor = 1;

Type
    Tgraph     = array[1..Limit] of
                   record
                       total  : integer;
                       data   : array[1..Limit] of integer;
                   end;
    Tdata      = array[1..Limit , 1..Limit] of integer;
    Tvisited   = array[1..Limit] of boolean;
    Tfather    = array[1..Limit] of integer;
    Tchild     = array[1..Limit] of integer;

Var
    graph      : Tgraph;
    data ,
    answer     : Tdata;
    visited    : Tvisited;
    father     : Tfather;
    child      : Tchild;
    N          : integer;
    noanswer   : boolean;

procedure init;
var
    i , p      : integer;
begin
    fillchar(graph , sizeof(graph) , 0);
    fillchar(data , sizeof(data) , 0);
    fillchar(answer , sizeof(answer) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
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
//    Close(INPUT);
end;

procedure dfs(treeroot , root , color , fa : integer);
var
    i          : integer;
begin
    visited[root] := true;
    for i := 1 to N do
      if (i <> treeroot) and (i <> fa) then
        if (data[root , i] = 1) then
          if visited[i] then
            begin
                if answer[i , root] = 0 then
                  begin
                      answer[i , root] := color;
                      answer[root , i] := color;
                  end;
                if i = root then
                  inc(child[root]);
            end
          else
            begin
                answer[i , root] := color;
                answer[root , i] := color;
                inc(child[root]);
                father[i] := root;
                dfs(treeroot , i , 3 - color , root);
            end;
            
    if (data[root , treeroot] = 1) and (treeroot <> fa) then
      if child[root] = 0 then
        begin
            answer[root , treeroot] := color;
            answer[treeroot , root] := color;
        end
      else
        begin
            answer[root , treeroot] := 3 - firstcolor;
            answer[treeroot , root] := 3 - firstcolor;
        end;
end;

procedure process(root : integer);
var
    i , color ,
    find , sum : integer;
begin
    fillchar(father , sizeof(father) , 0);
    fillchar(child , sizeof(child) , 0);
    visited[root] := true;
    if data[root , root] = 1 then
      answer[root , root] := 3 - firstcolor;
    color := firstcolor;
    for i := 1 to N do
      if (data[root , i] = 1) and (not visited[i]) then
        begin
            answer[root , i] := color;
            answer[i , root] := color;
            inc(child[root]);
            father[i] := root;
            color := 3 - color;
            dfs(root , i , color , root);
        end;

    find := 0;
    sum := 0;
    for i := 1 to N do
      begin
          inc(sum , data[root , i]);
          if (data[root , i] = 1) and (answer[root , i] <> firstcolor) then
            begin
                find := 1;
                break;
            end;
      end;

    if (sum > 1) and (find = 0) then
      begin
          i := 2;
          while (i <= N) do
            if (data[root , i] = 1) and (answer[root , i] = firstcolor) and (child[i] = 0) then
              break
            else
              inc(i);

          answer[root , i] := 3 - answer[root , i];
          answer[i , root] := 3 - answer[i , root];
          while i <> root do
            begin
                answer[i , father[i]] := 3 - answer[i , father[i]];
                answer[father[i] , i] := 3 - answer[father[i] , i];
                i := father[i];
                if child[i] > 1 then
                  break;
            end;
          if i = root then
            noanswer := true;
      end;
end;

procedure work;
var
    i          : integer;
begin
    fillchar(visited , sizeof(visited) , 0);
    noanswer := false;
    for i := 1 to N do
      if not visited[i] then
        begin
            process(i);
            if noanswer then
              exit;
        end;
end;

procedure out;
var
    i , j      : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln('No solution')
      else
        for i := 1 to N do
          begin
              for j := 1 to graph[i].total do
                write(answer[i , graph[i].data[j]] , ' ');
              writeln(0);
          end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
