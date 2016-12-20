{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p213.in';
    OutFile    = 'p213.out';
    Limit      = 400;
    Maximum    = 10000;

Type
    Tdata      = array[1..Limit , 1..Limit] of longint;
    Tvisited   = array[1..Limit] of longint;
    Tqueue     = array[1..Limit] of longint;

Var
    data       : Tdata;
    visited    : Tvisited;
    queue      : Tqueue;
    N , S , T  : longint;

procedure init;
var
    i , M ,
    p1 , p2    : longint;
begin
    fillchar(data , sizeof(data) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M , S , T);
      for i := 1 to M do
        begin
            read(p1 , p2);
            data[p1 , p2] := i;
            data[p2 , p1] := i;
        end;
//    Close(INPUT);
end;

procedure work;
var
    open , closed ,
    i          : longint;
begin
    fillchar(visited , sizeof(visited) , $FF);
    visited[S] := 0; queue[1] := S;
    open := 1; closed := 1;
    while open <= closed do
      begin
          for i := 1 to N do
            if (visited[i] = -1) and (data[queue[open] , i] <> 0) then
              begin
                  inc(closed);
                  visited[i] := visited[queue[open]] + 1;
                  queue[closed] := i;
              end;
          inc(open);
      end;
end;

procedure out;
var
    i , j , k ,
    tot        : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(visited[T]);
      for i := 0 to visited[T] - 1 do
        begin
            tot := 0;
            for j := 1 to N do
              if visited[j] = i then
                for k := 1 to N do
                  if (visited[k] = i + 1) and (data[j , k] <> 0) then
                    inc(tot);
            write(tot);
            for j := 1 to N do
              if visited[j] = i then
                for k := 1 to N do
                  if (visited[k] = i + 1) and (data[j , k] <> 0) then
                    write(' ' , data[j , k]);
            writeln;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
