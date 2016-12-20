{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    OutFile    = 'p174.in';
    N          = 200000;

Var
    i          : longint;
    
Begin
    randomize;
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(N);
      for i := 1 to N do
        writeln(random(200000) - 100000 , ' ' , random(200000) - 100000); 
    Close(OUTPUT);
End.
