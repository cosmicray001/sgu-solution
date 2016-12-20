{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p113.in';
    OutFile    = 'p113.out';

Var
    N          : integer;

procedure main;
var
    i , p , j ,
    times ,
    target     : integer;
begin
    readln(N);
    for i := 1 to N do
      begin
          read(p);
          j := 2; times := 0;
          target := trunc(sqrt(p));
          while (times < 2) and (p <> 1) and (j <= target) do
            if p mod j = 0 then
              begin
                  inc(times);
                  p := p div j;
              end
            else
              inc(j);
          if (times = 2) and (p <> 1) or (times = 0) then
            writeln('No')
          else
            writeln('Yes');
      end;
end;

Begin
//    assign(INPUT , InFile); ReSet(INPUT);
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      main;
//    Close(OUTPUT);
//    Close(INPUT);
End.
