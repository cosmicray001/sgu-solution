{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
var
    i          : longint;
Begin
    assign(OUTPUT , 'p237.in'); ReWrite(OUTPUT);
      randomize;
      for i := 1 to 255 do
        case random(5) of
          0    : write('!');
          1    : write('*');
          2    : write('?');
        else
          write(chr(random(26) + 97));
        end;
      writeln;
    Close(OUTPUT);
End.
