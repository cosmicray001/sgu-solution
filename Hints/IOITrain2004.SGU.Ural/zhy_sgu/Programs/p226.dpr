{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p226.in';
    OutFile    = 'p226.out';
    Limit      = 200;

Type
    Tmap       = array[1..Limit , 1..Limit , 1..3] of boolean;
    Tvisited   = array[1..Limit , 1..3] of longint;
    Tqueue     = array[1..Limit * 3] of
                   record
                       p , c                 : longint;
                   end;

Var
    map        : Tmap;
    visited    : Tvisited;
    queue      : Tqueue;
    answer     : longint;
    N          : longint;

procedure init;
var
    M , i ,
    p1 , p2 , c: longint;
begin
    fillchar(map , sizeof(map) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(p1 , p2 , c);
            map[p1 , p2 , c] := true;
        end;
//    Close(INPUT);
end;

procedure work;
var
    open , closed ,
    i , j      : longint;
begin
    fillchar(visited , sizeof(visited) , $FF);
    visited[1 , 1] := 0; visited[1 , 2] := 0; visited[1 , 3] := 0;
    answer := -1;
    open := 1; closed := 3;
    queue[1].p := 1; queue[1].c := 1; queue[2].p := 1; queue[2].c := 2;
    queue[3].p := 1; queue[3].c := 3;
    while open <= closed do
      begin
          for i := 1 to N do
            for j := 1 to 3 do
              if (visited[i , j] = -1) and (j <> queue[open].c) and map[queue[open].p , i , j] then
                begin
                    visited[i , j] := visited[queue[open].p , queue[open].c] + 1;
                    inc(closed);
                    queue[closed].p := i; queue[closed].c := j;
                    if i = N then
                      begin
                          answer := visited[i , j];
                          exit;
                      end;
                end;
          inc(open);
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
