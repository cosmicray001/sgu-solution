{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p130.in';
    OutFile    = 'p130.out';
    Limit      = 30;

Type
    Tdata      = array[0..Limit] of extended;

Var
    data       : Tdata;
    N          : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
//    Close(INPUT);
end;

procedure work;
var
    i , j      : integer;
begin
    data[0] := 1;
    data[1] := 1;
    for i := 2 to N do
      begin
          data[i] := 0;
          for j := 0 to i - 1 do
            data[i] := data[i] + data[j] * data[i - 1 - j]; 
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(data[N] : 0 : 0 , ' ' , N + 1);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
