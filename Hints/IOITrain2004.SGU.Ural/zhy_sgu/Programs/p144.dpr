{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p144.in';
    OutFile    = 'p144.out';

Var
    X , Y , Z ,
    answer     : extended;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(X , Y , Z);
//    Close(INPUT);
end;

procedure work;
var
    tot        : extended;
begin
    tot := (Y - X) * 60;
    if Z >= tot then
      answer := 1
    else
      answer := (2 * tot - Z) * Z / tot / tot;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer : 0 : 7);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
