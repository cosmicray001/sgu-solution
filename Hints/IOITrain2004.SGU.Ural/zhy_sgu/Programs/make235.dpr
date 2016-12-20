{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
var
    i , j , t ,
    x , y      : longint;
Begin
    randomize;
    assign(OUTPUT , 'p235.in'); ReWrite(OUTPUT);
    writeln(300);
    writeln(50);
    x := random(300) + 1; y := random(300) + 1;
    for i := 1 to 300 do
      begin
          for j := 1 to 300 do
            begin
                t := random(10);
                if (i = x) and (j = y) then begin write('Q'); continue; end;
                if t <= 7
                  then write('B')
                  else write('W');
            end;
          writeln;
      end;
    Close(OUTPUT);
End.
