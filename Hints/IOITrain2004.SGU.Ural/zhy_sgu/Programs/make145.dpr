{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    OutFile    = 'p145.in';
    N          = 100;
    Limit      = 500;

Var
    i , j      : integer;
begin
    randomize;
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(N , ' ' , N * (N - 1) div 2 , ' ' , Limit);
      for i := 1 to N do
        for j := i + 1 to N do
          writeln(i , ' ' , j , ' ' , random(10000) + 1);
      writeln(1 , ' ' , N);
    Close(OUTPUT);
end.

