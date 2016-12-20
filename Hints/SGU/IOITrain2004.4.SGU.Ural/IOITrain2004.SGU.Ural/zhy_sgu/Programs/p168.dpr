{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p168.in';
    OutFile    = 'p168.out';
    Limit      = 1000;

Type
    Tdata      = array[1..Limit , 1..Limit] of integer;

Var
    data       : Tdata;
    N , M      : integer;

procedure init;
var
    i , j      : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to N do
        for j := 1 to M do
          read(data[i , j]);
//    Close(INPUT);
end;

procedure work;
var
    i , j ,
    t1 , t2 ,
    t3 , t4    : integer;
begin
    for j := M downto 1 do
      for i := N downto 1 do
        begin
            t1 := data[i , j];
            if (j + 1 <= M) and (i - 1 >= 1) then
              t2 := data[i - 1 , j + 1]
            else
              t2 := maxlongint;
            if (i + 1 <= N) then
              t3 := data[i + 1 , j]
            else
              t3 := maxlongint;
            if (j + 1 <= M) then
              t4 := data[i , j + 1]
            else
              t4 := maxlongint;
            if t1 > t2 then
              t1 := t2;
            if t1 > t3 then
              t1 := t3;
            if t1 > t4 then
              t1 := t4;
            data[i , j] := t1;
        end;
end;

procedure out;
var
    i , j      : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N do
        begin
            for j := 1 to M - 1 do
              write(data[i , j] , ' ');
            writeln(data[i , M]);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
