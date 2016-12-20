{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p102.in';
    OutFile    = 'p102.out';

Var
    N , answer : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
//    Close(INPUT);
end;

function gcd(a , b : integer) : integer;
begin
    if a = 0 then
      gcd := b
    else
      gcd := gcd(b mod a , a);
end;

procedure work;
var
    i          : integer;
begin
    answer := 0;
    for i := 1 to N do
      if gcd(i , N) = 1 then
        inc(answer);
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
