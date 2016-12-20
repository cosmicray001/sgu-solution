{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    OutFile    = 'p101.in';
    N          = 100;

Var
    i          : integer;

Begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      randomize;
      writeln(N);
      for i := 1 to N do
        writeln(random(7) , ' ' , random(7));
    Close(OUTPUT);
End.
