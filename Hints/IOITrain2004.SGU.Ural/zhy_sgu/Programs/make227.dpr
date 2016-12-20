{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
Const
    N          = 50;

Var
    i          : longint;

Begin
    assign(OUTPUT , 'p227.in'); ReWrite(OUTPUT);
      randomize; 
      writeln(N);
      for i := 1 to N do
        writeln(random(1000) , ' ' , random(1000) , ' ' , random(1000) , ' ' , random(1000) , ' ' , random(1000) , ' ' , random(1000));
    Close(OUTPUT);
End.