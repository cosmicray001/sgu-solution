{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
Var
    i          : longint;
    
Begin
    randomize;
    assign(OUTPUT , 'p192.in'); ReWrite(OUTPUT);
      writeln(300);
      for i := 1 to 10 do
        begin
            write(random(10) + 1 , ' ' , random(10) + 1 , ' ' , random(10) + 1 , ' ' , random(10) + 1 , ' ');
            case random(3) of
              0               : writeln('G');
              1               : writeln('R');
              2               : writeln('B');
            end;
        end;
    CLose(OUTPUT);
End.