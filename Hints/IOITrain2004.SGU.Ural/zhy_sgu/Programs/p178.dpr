{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p178.in';
    OutFile    = 'p178.out';

Var
    N          : extended;
    ans        : longint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
//    Close(INPUT);
end;

procedure work;
var
    tmp        : extended;
    i          : longint;
begin
    ans := -1; tmp := 1;
    repeat
      tmp := tmp * 2;
      inc(ans);
    until tmp * (ans + 1) - 1 >= N;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(ans);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
