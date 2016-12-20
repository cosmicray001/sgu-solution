{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Var
    N , K , i  : longint;
    answer     : comp;
Begin
    read(N , K);
    if K > N
      then writeln(0)
      else begin
               answer := 1;
               for i := N downto N - K + 1 do
                 answer := answer * i;
               for i := 1 to K do
                 answer := answer / i;
               for i := N downto N - K + 1 do
                 answer := answer * i;
               writeln(answer : 0 : 0);
           end;
End.
