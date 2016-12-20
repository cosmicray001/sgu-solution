{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p139.in';
    OutFile    = 'p139.out';
    N          = 4;

Type
    Tdata      = array[1..N , 1..N] of integer;
    Tindex     = array[0..N * N] of
                   record
                       x , y  : integer;
                   end;
    Tvisited   = array[1..N , 1..N] of boolean;

Var
    data ,
    target     : Tdata;
    index_data ,
    index_target
               : Tindex;
    visited    : Tvisited;
    answer     : string[10];

procedure init;
var
    i , j      : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      for i := 1 to N do
        for j := 1 to N do
          begin
              read(data[i , j]);
              target[i , j] := (i - 1) * N + j;
              if target[i , j] = N * N then
                target[i , j] := 0;
              index_data[data[i , j]].x := i;
              index_data[data[i , j]].y := j;
              index_target[target[i , j]].x := i;
              index_target[target[i , j]].y := j;
          end;
//    Close(INPUT);
end;

procedure work;
var
    i , j , sum ,
    x , y ,
    tx , ty ,
    total ,
    len        : integer;
begin
    fillchar(visited , sizeof(visited) , 0);
    total := 0;
    for i := 1 to N do
      for j := 1 to N do
        if not visited[i , j] then
          begin
              sum := 0;
              x := i; y := j;
              repeat
                visited[x , y] := true;
                tx := x; ty := y;
                x := index_target[data[tx , ty]].x;
                y := index_target[data[tx , ty]].y;
                inc(sum);
              until (x = i) and (y = j);
              dec(sum);
              inc(total , sum);
          end;
    len := abs(index_target[0].x - index_data[0].x) + abs(index_target[0].y - index_data[0].y);

    if odd(len) = odd(total) then
      answer := 'YES'
    else
      answer := 'NO';
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
