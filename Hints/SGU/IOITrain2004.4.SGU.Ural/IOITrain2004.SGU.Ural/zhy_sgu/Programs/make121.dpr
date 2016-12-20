{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    OutFile    = 'p121.in';
    N          = 100;

Type
    Tdata      = array[1..N , 1..N] of integer;

Var
    data       : Tdata;
    M          : integer;

procedure init;
begin
    randomize;
    fillchar(data , sizeof(data) , 0);
end;

procedure work;
var
    i , p1 , p2: integer;
begin
    M := random(N * (N - 1) div 2 + 1);
    for i := 1 to M do
      begin
          p1 := random(N) + 1;
          p2 := random(N) + 1;
          data[p1 , p2] := 1;
          data[p2 , p1] := 1;
      end;
end;

procedure out;
var
    i , j      : integer;
begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(N);
      for i := 1 to N do
        begin
            for j := 1 to N do
              if data[i , j] = 1 then
                write(j , ' ');
            writeln(0);
        end;
    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
