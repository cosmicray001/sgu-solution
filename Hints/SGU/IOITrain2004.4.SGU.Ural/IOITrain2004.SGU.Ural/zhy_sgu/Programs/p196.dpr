{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p196.in';
    OutFile    = 'p196.out';
    Limit      = 10000;

Type
    Tdata      = array[1..Limit] of extended;

Var
    data       : Tdata;
    answer     : extended;
    N          : longint;

procedure init;
var
    i , p1 , p2 ,
    M          : longint;
begin
    fillchar(data , sizeof(data) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(p1 , p2);
            data[p1] := data[p1] + 1;
            data[p2] := data[p2] + 1;
        end;
//    Close(INPUT);
end;

procedure work;
var
    i          : longint;
begin
    answer := 0;
    for i := 1 to N do
      answer := answer + data[i] * data[i];
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer : 0 : 0);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
