{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    OutFile    = 'p216.in';
    N          = 10;
    M          = 5;

Var
    i          : longint;

Begin
    randomize;
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(N , ' ' , M);
      for i := 2 to N do
        writeln(i , ' ' , random(i - 1) + 1);
    Close(OUTPUT);
End.
