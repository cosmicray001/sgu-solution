{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    InFile     = 'p145.in';
    OutFile    = 'p1451.out';
    Limit      = 100;
    LimitEle   = 600;

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
    data       : Tdata;
    queue      : Tqueue;
    N , K , 
    source ,
    target     : integer;
    Answer     : Tpath;

procedure init;
var
    M , p1 , p2 ,
    c          : integer;
begin
    fillchar(data , sizeof(data) , $FF);
    fillchar(queue , sizeof(queue) , 0);
    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M , K);
      while M > 0 do
        begin
            read(p1 , p2 , c);
            data[p1 , p2] := c;
            data[p2 , p1] := c;
            dec(M);
        end;
      read(source , target);
    Close(INPUT);
end;

procedure Del(p : integer);
begin
    queue.data[p] := queue.data[queue.total];
    dec(queue.total);
end;

procedure ins(path : Tpath; visited : Tvisited);
var
    i , j , min ,
    maxhope    : integer;
    shortest   : Tshortest;
begin
    maxhope := 0;
    for i := 1 to queue.total do
      if (maxhope = 0) or (queue.data[i].hope >= queue.data[maxhope].hope) then
        maxhope := i;

    fillchar(shortest , sizeof(shortest) , $FF);
    shortest[path.data[path.Len]] := 0;
    for i := 1 to N - path.Len + 1 do
      begin
          min := 0;
          for j := 1 to N do
            if not visited[j] and (shortest[j] >= 0) then
              if (min = 0) or (shortest[j] < shortest[min]) then
                min := j;

          if min = 0 then
            exit;

          visited[min] := true;
          if (queue.total = K) and (shortest[min] + path.dist >= queue.data[maxhope].hope) then
            exit;
          if min = target then
            break;

          for j := 1 to N do
            if not visited[j] and (data[min , j] >= 0) then
              if (shortest[j] < 0) or (shortest[j] > shortest[min] + data[min , j]) then
                shortest[j] := shortest[min] + data[min , j];
      end;
    path.hope := path.dist + shortest[target];

    if queue.total = K then
      if queue.data[maxhope].hope > path.hope then
        queue.data[maxhope] := path
      else
    else
      begin
          inc(queue.total);
          queue.data[queue.total] := path;
      end;
end;

procedure work;
var
    visited    : Tvisited;
    path       : Tpath;
    i , last ,
    min        : integer;
begin
    queue.total := 1;
    queue.data[1].Len := 1;
    queue.data[1].dist := 0;
    queue.data[1].data[1] := source;
    while K > 0 do
      begin
          min := 0;
          for i := 1 to queue.total do
            if (min = 0) or (queue.data[min].hope > queue.data[i].hope) then
              min := i;
          path := queue.data[min];
          Del(min);
          if path.data[path.Len] = target then
            begin
                dec(K);
                if K = 0 then
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
                for i := 1 to N do
                  if not visited[i] and (data[last , i] <> -1) then
                    begin
                        path.data[path.Len] := i;
                        inc(path.dist , data[last , i]);
                        ins(path , visited);
                        dec(path.dist , data[last , i]);
                    end;
            end;
      end;
end;

procedure out;
var
    i          : integer;
begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer.dist{ , ' ' , answer.Len});
{      for i := 1 to answer.Len - 1 do
        write(answer.data[i] , ' ');
      writeln(answer.data[answer.Len]);}
    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
