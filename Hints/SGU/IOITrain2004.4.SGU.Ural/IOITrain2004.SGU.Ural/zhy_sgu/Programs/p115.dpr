{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p115.in';
    OutFile    = 'p115.out';
    Days       : array[1..12] of integer
               = (31 , 28 , 31 , 30 , 31 , 30 , 31 , 31 , 30 , 31 , 30 , 31);

Var
    N , M ,
    answer     : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , M);
//    Close(INPUT);
end;

procedure work;
var
    i          : integer;
begin
    if (M > 12) or (M < 1) or (N > Days[M]) or (N < 1) then
      answer := -1
    else
      begin
          answer := 0;
          for i := 1 to M - 1 do
            inc(answer , Days[i]);
          inc(answer , N);
          answer := (answer - 1) mod 7 + 1;
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer = -1 then
        writeln('Impossible')
      else
        writeln(answer);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
