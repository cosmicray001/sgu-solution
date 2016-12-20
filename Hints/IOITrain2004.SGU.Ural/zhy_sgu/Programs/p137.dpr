{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p137.in';
    OutFile    = 'p137.out';
    Limit      = 1000;

Type
    Tdata      = array[1..Limit] of integer;

Var
    N , S      : integer;
    data       : Tdata;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , S);
//    Close(INPUT);
end;

procedure work;
var
    tmpS , k ,
    i          : integer;
begin
    tmpS := S mod N;
    k := 1;
    while tmpS * K mod N <> N - 1 do
      inc(k);
    i := k + 1;
    fillchar(data , sizeof(data) , 0);
    while i <> N do
      begin
          data[i] := 1;
          i := (i + k - 1) mod N + 1;
      end;
    data[N] := 1;
    for i := 1 to N do
      inc(data[i] , S div N);
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N - 1 do
        write(data[i] , ' ');
      writeln(data[N]);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
