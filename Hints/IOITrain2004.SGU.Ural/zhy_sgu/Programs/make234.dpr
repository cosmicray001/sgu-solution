{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
Const
    N          = 200;

Var
    i , j      : longint;
    
Begin
    randomize;
    assign(OUTPUT , 'p234.in'); ReWrite(OUTPUT);
      writeln(n , ' ' , n);
      for i := 1 to N do
        begin
            for j := 1 to N do
              if random(10) <= 4 then
                write(1 , ' ')
              else
                write(0 , ' ');
            writeln;
        end;
    Close(OUTPUT);
End.