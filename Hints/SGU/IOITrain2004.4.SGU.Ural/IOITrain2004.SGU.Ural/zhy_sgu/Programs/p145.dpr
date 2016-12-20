{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p145.in';
    OutFile    = 'p145.out';
    Limit      = 100;
    LimitEle   = 6000;
    LimitSave  = 400;

Type
    Tdata      = array[1..Limit , 1..Limit] of integer;
    Tpath      = record
                     Len , dist , hope       : integer;
                     data                    : array[1..Limit] of byte;
                 end;
    Tqueue     = record
                     total    : integer;
                     data     : array[1..LimitEle] of Tpath;
                 end;
    Tvisited   = array[1..Limit] of boolean;
    Tshortest  = array[1..Limit] of integer;

Var
    data ,
    Floyd      : Tdata;
    queue      : Tqueue;
    N , K ,
    BackupK ,
    source ,
    target ,
    upper_bound: integer;
    list       : Tshortest;
    Answer     : Tpath;

procedure init;
var
    M , p1 , p2 ,
    c          : integer;
begin
    fillchar(data , sizeof(data) , $FF);
    fillchar(queue , sizeof(queue) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M , K);
      while M > 0 do
        begin
            read(p1 , p2 , c);
            data[p1 , p2] := c;
            data[p2 , p1] := c;
            dec(M);
        end;
      read(source , target);
//    Close(INPUT);
end;

procedure down(p : integer);
var
    key        : Tpath;
    newp       : integer;
begin
    key := queue.data[p];
    while p * 2 <= queue.total do
      begin
          newp := p;
          if queue.data[p * 2].hope < key.hope then
            newp := p * 2;
          if (p * 2 < queue.total) then
            if (queue.data[p * 2 + 1].hope < queue.data[p * 2].hope) and (queue.data[p * 2 + 1].hope < key.hope) then
              newp := p * 2 + 1;
          if newp = p then
            break;
          queue.data[p] := queue.data[newp];
          p := newp;
      end;
    queue.data[p] := key;
end;

procedure Del;
begin
    queue.data[1] := queue.data[queue.total];
    dec(queue.total);
    down(1);
end;

procedure ins(path : Tpath; visited : Tvisited; signal : integer);
var
    i , p ,
    maxhope    : integer;
begin
    if floyd[path.data[path.Len] , target] < 0 then
      exit;
      
    if (signal = 0) and (queue.total = LimitSave) then
      begin
          maxhope := 0;
          for i := queue.total shr 1 + 1 to queue.total do
            if (maxhope = 0) or (queue.data[i].hope >= queue.data[maxhope].hope) then
              maxhope := i;
      end;
      
    if (signal = 0) and (queue.total = LimitSave) and
      (path.dist + floyd[path.data[path.Len] , target] > queue.data[maxhope].hope) then
      exit;

    path.hope := path.dist + floyd[path.data[path.Len] , target];

    if path.hope > upper_bound then
      exit;

    if (signal = 0) and (queue.total = LimitSave) then
      if queue.data[maxhope].hope > path.hope then
        begin
            queue.data[maxhope] := path;
            p := maxhope;
            if (p <> 1) and (queue.data[p shr 1].hope < path.hope) then
              begin
                  down(p);
                  exit;
              end;
        end
      else
        exit
    else
      begin
          inc(queue.total);
          queue.data[queue.total] := path;
          p := queue.total;
      end;

    while (p <> 1) and (queue.data[p shr 1].hope > path.hope) do
      begin
          queue.data[p] := queue.data[p shr 1];
          p := p shr 1;
      end;
    queue.data[p] := path;
end;

procedure bfs(signal : integer);
var
    path       : Tpath;
    visited    : Tvisited;
    i , last ,
    p          : integer;
begin
    fillchar(queue , sizeof(queue) , 0);
    queue.total := 1;
    queue.data[1].Len := 1;
    queue.data[1].dist := 0;
    queue.data[1].data[1] := source;
    while K > 0 do
      begin
          if queue.total = 0 then
            break;
          path := queue.data[1];
          Del;
          if path.data[path.Len] = target then
            begin
                dec(K);
                if K < 2 then
                  answer := path;
            end
          else
            begin
                fillchar(visited , sizeof(visited) , 0);
                for i := 1 to path.Len do
                  begin
                      visited[path.data[i]] := true;
                      if i = path.Len then
                        last := path.data[i];
                  end;
                inc(path.Len);
                for p := 1 to N do
                  begin
                      i := list[p];
                      if not visited[i] and (data[last , i] <> -1) then
                        begin
                            path.data[path.Len] := i;
                            inc(path.dist , data[last , i]);
                            ins(path , visited , signal);
                            dec(path.dist , data[last , i]);
                        end;
                  end;
            end;
      end;
end;

procedure work;
var
    i , tmp ,
    p1 , p2    : integer;
begin
    floyd := data;
    for i := 1 to N do
      for p1 := 1 to N do
        for p2 := 1 to N do
          if p1 = p2 then
            floyd[p1 , p2] := 0
          else
            if (Floyd[p1 , i] >= 0) and (Floyd[i , p2] >= 0) then
              if (floyd[p1 , p2] < 0) or (floyd[p1 , p2] > floyd[p1 , i] + floyd[i , p2]) then
                floyd[p1 , p2] := floyd[p1 , i] + floyd[i , p2];
              
    for i := 1 to N do
      list[i] := i;
    for i := 1 to N * N do
      begin
          p1 := random(N) + 1;
          p2 := random(N) + 1;
          tmp := list[p1]; list[p1] := list[p2]; list[p2] := tmp;
      end;

    answer.dist := maxlongint;
    Upper_bound := maxlongint;
    BackupK := K;
    bfs(0);
    Upper_bound := answer.dist;

    K := BackupK;
    bfs(1);
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer.dist , ' ' , answer.Len);
      for i := 1 to answer.Len - 1 do
        write(answer.data[i] , ' ');
      writeln(answer.data[answer.Len]);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
